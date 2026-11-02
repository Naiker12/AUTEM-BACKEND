/**
 * Repair GLB files produced by naive exporters (e.g. trimesh).
 *
 * Problems fixed:
 *   1. Missing NORMAL attribute -> geometry renders black under any PBR lighting.
 *   2. Missing material -> finish customizer / model-viewer have nothing to tint.
 *
 * The script computes per-vertex normals (area-weighted average of the
 * incident face normals) and appends a new NORMAL accessor + bufferView to
 * the GLB's BIN chunk, then inserts a default metallic-roughness material and
 * assigns it to every primitive that has none.
 *
 * Usage: node scripts/repair-glb.mjs <file.glb> [file2.glb ...]
 */

import { readFileSync, writeFileSync } from "node:fs";

const GLB_MAGIC = 0x46546c67; // "glTF"
const CHUNK_JSON = 0x4e4f534a; // "JSON"
const CHUNK_BIN = 0x004e4942; // "BIN\0"

const COMP_BYTES = { 5120: 1, 5121: 1, 5122: 2, 5123: 2, 5125: 4, 5126: 4 };
const TYPE_COMPONENTS = { SCALAR: 1, VEC2: 2, VEC3: 3, VEC4: 4, MAT4: 16 };

// AUTEM nordic "Mármol blanco" default finish (#E5E4E2).
const BASE_COLOR = [0.898, 0.894, 0.886, 1.0];

function parseGlb(buf) {
  const view = new DataView(buf.buffer, buf.byteOffset, buf.byteLength);
  if (view.getUint32(0, true) !== GLB_MAGIC) throw new Error("Not a GLB file");

  let offset = 12;
  let json = null;
  let bin = null;

  while (offset < buf.length) {
    const chunkLen = view.getUint32(offset, true);
    const chunkType = view.getUint32(offset + 4, true);
    const start = offset + 8;
    if (chunkType === CHUNK_JSON) {
      json = JSON.parse(buf.toString("utf8", start, start + chunkLen));
    } else if (chunkType === CHUNK_BIN) {
      bin = buf.subarray(start, start + chunkLen);
    }
    offset = start + chunkLen;
  }

  if (!json) throw new Error("GLB has no JSON chunk");
  return { json, bin };
}

function serializeGlb(json, bin) {
  const jsonBuf = Buffer.from(JSON.stringify(json), "utf8");
  const paddedJsonLen = Math.ceil(jsonBuf.length / 4) * 4;
  const jsonPadded = Buffer.alloc(paddedJsonLen);
  jsonBuf.copy(jsonPadded);
  jsonPadded.fill(0x20, jsonBuf.length); // pad with spaces per glTF spec

  const paddedBinLen = Math.ceil(bin.length / 4) * 4;
  const binPadded = Buffer.alloc(paddedBinLen);
  binPadded.set(bin, 0);

  const total = 12 + 8 + paddedJsonLen + 8 + paddedBinLen;
  const out = Buffer.alloc(total);
  out.writeUInt32LE(GLB_MAGIC, 0);
  out.writeUInt32LE(2, 4);
  out.writeUInt32LE(total, 8);
  out.writeUInt32LE(paddedJsonLen, 12);
  out.writeUInt32LE(CHUNK_JSON, 16);
  jsonPadded.copy(out, 20);
  out.writeUInt32LE(paddedBinLen, 20 + paddedJsonLen);
  out.writeUInt32LE(CHUNK_BIN, 24 + paddedJsonLen);
  binPadded.copy(out, 28 + paddedJsonLen);
  return out;
}

function readAccessor(json, bin, accIdx) {
  const acc = json.accessors[accIdx];
  const bv = json.bufferViews[acc.bufferView];
  const compBytes = COMP_BYTES[acc.componentType] ?? 4;
  const components = TYPE_COMPONENTS[acc.type] ?? 1;
  const start = (bv.byteOffset ?? 0) + (acc.byteOffset ?? 0);
  const byteLength = compBytes * components * acc.count;
  const data = bin.subarray(start, start + byteLength);
  return { acc, data, compBytes, components };
}

function repair(json, bin) {
  const binLen = json.buffers[0].byteLength ?? bin.length;
  let additions = [];

  for (const mesh of json.meshes ?? []) {
    for (const prim of mesh.primitives ?? []) {
      const attrs = prim.attributes ?? {};
      if (!("POSITION" in attrs)) continue;
      if ("NORMAL" in attrs) continue; // already has normals

      const posAccIdx = attrs.POSITION;
      const posInfo = readAccessor(json, bin, posAccIdx);
      if (posInfo.acc.type !== "VEC3") throw new Error("POSITION must be VEC3");

      const N = posInfo.acc.count;
      const posF32 = new Float32Array(posInfo.data.buffer, posInfo.data.byteOffset, N * 3);

      let idx = null;
      if ("indices" in prim) {
        const idxInfo = readAccessor(json, bin, prim.indices);
        const arr =
          idxInfo.compBytes === 2
            ? new Uint16Array(idxInfo.data.buffer, idxInfo.data.byteOffset, idxInfo.acc.count)
            : new Uint32Array(idxInfo.data.buffer, idxInfo.data.byteOffset, idxInfo.acc.count);
        idx = arr;
      }

      const normals = new Float32Array(N * 3);

      const addFaceNormal = (a, b, c) => {
        const ax = posF32[a * 3],
          ay = posF32[a * 3 + 1],
          az = posF32[a * 3 + 2];
        const bx = posF32[b * 3],
          by = posF32[b * 3 + 1],
          bz = posF32[b * 3 + 2];
        const cx = posF32[c * 3],
          cy = posF32[c * 3 + 1],
          cz = posF32[c * 3 + 2];
        const ux = bx - ax,
          uy = by - ay,
          uz = bz - az;
        const vx = cx - ax,
          vy = cy - ay,
          vz = cz - az;
        normals[a * 3] += uy * vz - uz * vy;
        normals[a * 3 + 1] += uz * vx - ux * vz;
        normals[a * 3 + 2] += ux * vy - uy * vx;
        normals[b * 3] += uy * vz - uz * vy;
        normals[b * 3 + 1] += uz * vx - ux * vz;
        normals[b * 3 + 2] += ux * vy - uy * vx;
        normals[c * 3] += uy * vz - uz * vy;
        normals[c * 3 + 1] += uz * vx - ux * vz;
        normals[c * 3 + 2] += ux * vy - uy * vx;
      };

      if (idx) {
        for (let i = 0; i + 2 < idx.length; i += 3) {
          addFaceNormal(idx[i], idx[i + 1], idx[i + 2]);
        }
      } else {
        for (let i = 0; i + 2 < N; i += 3) {
          addFaceNormal(i, i + 1, i + 2);
        }
      }

      for (let i = 0; i < N; i++) {
        let x = normals[i * 3],
          y = normals[i * 3 + 1],
          z = normals[i * 3 + 2];
        const len = Math.hypot(x, y, z);
        if (len < 1e-8) {
          x = 0;
          y = 1;
          z = 0;
        } else {
          x /= len;
          y /= len;
          z /= len;
        }
        normals[i * 3] = x;
        normals[i * 3 + 1] = y;
        normals[i * 3 + 2] = z;
      }

      const normalBytes = Buffer.from(normals.buffer, normals.byteOffset, normals.byteLength);
      const normalBvIdx = json.bufferViews.length;
      const normalAccIdx = json.accessors.length;

      json.bufferViews.push({
        buffer: 0,
        byteOffset: binLen + additions.reduce((s, a) => s + a.byteLength, 0),
        byteLength: normalBytes.length,
      });
      json.accessors.push({
        bufferView: normalBvIdx,
        componentType: 5126,
        count: N,
        type: "VEC3",
      });

      prim.attributes.NORMAL = normalAccIdx;

      if (!("material" in prim) && (!json.materials || json.materials.length === 0)) {
        json.materials = [
          {
            name: "Acabado",
            pbrMetallicRoughness: {
              baseColorFactor: BASE_COLOR,
              metallicFactor: 0.0,
              roughnessFactor: 0.9,
            },
          },
        ];
      }
      if (!("material" in prim)) prim.material = 0;

      additions.push({ byteLength: normalBytes.length, data: normalBytes });
    }
  }

  const outBin = Buffer.concat([bin, ...additions.map((a) => a.data)]);
  if (outBin.length !== binLen) {
    json.buffers[0].byteLength = outBin.length;
  }
  if (additions.length === 0 && outBin.length === binLen) return null;
  return { outBin };
}

for (const file of process.argv.slice(2)) {
  const original = readFileSync(file);
  const { json, bin } = parseGlb(original);
  const result = repair(json, bin);
  if (!result) {
    console.log(`SKIP  ${file} (nothing to repair)`);
    continue;
  }
  const out = serializeGlb(json, result.outBin);
  writeFileSync(file, out);
  console.log(
    `FIXED ${file} (${(original.length / 1024).toFixed(1)}KB -> ${(out.length / 1024).toFixed(1)}KB, normals + material added)`,
  );
}
