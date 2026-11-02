import { readFile, writeFile, mkdir } from "node:fs/promises";
import { createHash } from "node:crypto";
import ts from "typescript";
const source = await readFile("src/features/terrain-navigation/coordinate-transform.ts", "utf8");
const compiled = ts.transpileModule(source, {
  compilerOptions: { module: ts.ModuleKind.ESNext, target: ts.ScriptTarget.ES2022 },
}).outputText;
const { fitAffineTransform, applyAffineTransform } = await import(
  "data:text/javascript;base64," + Buffer.from(compiled).toString("base64")
);
const cad = JSON.parse(await readFile("cad/villa-paraiso-navigation-candidates.json", "utf8"));
const layers = JSON.parse(await readFile("src/data/villa-paraiso-layers.json", "utf8"));
const controls = [];
for (const [layer, key] of [
  ["A-VIA", "roads"],
  ["A-CALZADA", "calzadas"],
  ["A-SENDEROS", "senderos"],
]) {
  const polygons = cad.polylines.filter((p) => p.layer === layer);
  if (polygons.length !== layers[key].length) throw new Error("CAD and SVG layer counts differ");
  polygons.forEach((polygon, index) => {
    const target = [...layers[key][index].matchAll(/[ML]\s+([-\d.]+)\s+([-\d.]+)/g)].map((m) => ({
      x: Number(m[1]),
      y: Number(m[2]),
    }));
    if (target.length !== polygon.points.length)
      throw new Error("CAD and SVG vertex counts differ");
    polygon.points.forEach(([x, y], i) =>
      controls.push({ label: `${layer}:${index}:${i}`, source: { x, y }, target: target[i] }),
    );
  });
}
const transform = fitAffineTransform(controls);
if (!transform || transform.rmsError > 0.1) throw new Error("CAD/SVG registration failed");
const annotation = cad.annotations.find((a) => a.label === "ACCESO PRINCIPAL");
const reference = {
  source: cad.source,
  status: "cad_reference_requires_field_confirmation",
  gpsReferenceSystem: null,
  cadUnits: "meters",
  matchedVertices: controls.length,
  masterplanVersion: "sha256:" + createHash("sha256").update(JSON.stringify(layers)).digest("hex"),
  transform,
  entranceAnnotation: {
    label: annotation.label,
    cad: { x: annotation.point[0], y: annotation.point[1] },
    svg: applyAffineTransform({ x: annotation.point[0], y: annotation.point[1] }, transform),
  },
  note: "Registro CAD→SVG; no es calibración GPS. La anotación puede estar desplazada respecto al acceso físico.",
};
await writeFile(
  "src/data/villa-paraiso-cad-reference.json",
  JSON.stringify(reference, null, 2) + "\n",
);
await mkdir("docs/navigation", { recursive: true });
await writeFile(
  "docs/navigation/referencia-cad-svg.json",
  JSON.stringify(reference, null, 2) + "\n",
);
console.log(
  JSON.stringify({
    matchedVertices: controls.length,
    rmsSvgUnits: transform.rmsError,
    entranceAnnotation: reference.entranceAnnotation.svg,
    gpsReferenceSystem: null,
  }),
);
