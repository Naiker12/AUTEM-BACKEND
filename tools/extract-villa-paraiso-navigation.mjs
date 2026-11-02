import { mkdir, readFile, writeFile } from "node:fs/promises";
import { dirname, resolve } from "node:path";

const [inputPath, outputPath] = process.argv.slice(2);
if (!inputPath || !outputPath) {
  throw new Error(
    "Uso: node scripts/extract-villa-paraiso-navigation.mjs <entrada.dxf> <salida.json>",
  );
}

const NAVIGATION_LAYERS = new Set(["A-VIA", "A-CALZADA", "A-SENDEROS", "_SENDERO"]);
const lines = (await readFile(resolve(inputPath), "latin1")).split(/\r?\n/);
const pairs = [];
for (let index = 0; index + 1 < lines.length; index += 2) {
  pairs.push([lines[index].trim(), lines[index + 1].trim()]);
}

let isInsideEntities = false;
let current = null;
const polylines = [];
const annotations = [];
const flush = () => {
  if (!current) return;
  if (current.type === "LWPOLYLINE" && NAVIGATION_LAYERS.has(current.layer)) {
    if (current.points.length >= 2) {
      polylines.push({ layer: current.layer, closed: current.closed, points: current.points });
    }
    return;
  }
  if (
    (current.type === "TEXT" || current.type === "MTEXT") &&
    current.x !== null &&
    current.y !== null
  ) {
    const label = current.textParts.join("").replace(/\\P/g, " ").trim();
    if (label) annotations.push({ layer: current.layer, label, point: [current.x, current.y] });
  }
};

for (const [code, value] of pairs) {
  if (code === "0" && value === "SECTION") continue;
  if (code === "2" && value === "ENTITIES" && !isInsideEntities) {
    isInsideEntities = true;
    continue;
  }
  if (!isInsideEntities) continue;
  if (code === "0") {
    flush();
    if (value === "ENDSEC") break;
    current = {
      type: value,
      layer: "",
      closed: false,
      points: [],
      pendingX: null,
      x: null,
      y: null,
      textParts: [],
    };
    continue;
  }
  if (!current) continue;
  if (code === "8") current.layer = value;
  if (code === "70") current.closed = (Number(value) & 1) === 1;
  if (code === "10") current.pendingX = Number(value);
  if (code === "20" && current.pendingX !== null) {
    current.points.push([current.pendingX, Number(value)]);
    current.pendingX = null;
  }
  if (code === "10") current.x = Number(value);
  if (code === "20") current.y = Number(value);
  if (code === "1" || code === "3") current.textParts.push(value);
}

const points = polylines.flatMap((polyline) => polyline.points);
const bounds = points.reduce(
  (result, [x, y]) => ({
    minX: Math.min(result.minX, x),
    minY: Math.min(result.minY, y),
    maxX: Math.max(result.maxX, x),
    maxY: Math.max(result.maxY, y),
  }),
  { minX: Infinity, minY: Infinity, maxX: -Infinity, maxY: -Infinity },
);
const byLayer = Object.fromEntries(
  [...NAVIGATION_LAYERS].map((layer) => [
    layer,
    polylines.filter((polyline) => polyline.layer === layer).length,
  ]),
);

await mkdir(dirname(resolve(outputPath)), { recursive: true });
await writeFile(
  resolve(outputPath),
  `${JSON.stringify(
    {
      source: "VILLA PARAISO_05092026_CAMPO.dxf",
      extractedAt: new Date().toISOString(),
      status: "pending_field_validation",
      coordinateSystem: "CAD drawing coordinates; requires GPS-to-SVG calibration before routing",
      bounds,
      summary: { polylines: polylines.length, byLayer },
      polylines,
      annotations,
    },
    null,
    2,
  )}\n`,
  "utf8",
);

console.log(`Extrajimos ${polylines.length} polilíneas navegables candidatas.`);
console.log(JSON.stringify({ bounds, byLayer }));
