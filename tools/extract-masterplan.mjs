import fs from "node:fs";
import path from "node:path";
import readline from "node:readline";

const DXF_PATH = path.resolve("cad/VILLA PARAISO_05092026_CAMPO.dxf");

// Algoritmo Ray Casting para punto en polígono
function pointInPolygon(pt, vs) {
  const x = pt.x;
  const y = pt.y;
  let inside = false;
  for (let i = 0, j = vs.length - 1; i < vs.length; j = i++) {
    const xi = vs[i].x;
    const yi = vs[i].y;
    const xj = vs[j].x;
    const yj = vs[j].y;
    const intersect = yi > y !== yj > y && x < ((xj - xi) * (y - yi)) / (yj - yi) + xi;
    if (intersect) inside = !inside;
  }
  return inside;
}

// Cálculo de área y centroide por fórmula Shoelace
function polygonMetrics(pts) {
  let area = 0;
  let cx = 0;
  let cy = 0;
  const n = pts.length;
  for (let i = 0; i < n; i++) {
    const j = (i + 1) % n;
    const f = pts[i].x * pts[j].y - pts[j].x * pts[i].y;
    area += f;
    cx += (pts[i].x + pts[j].x) * f;
    cy += (pts[i].y + pts[j].y) * f;
  }
  area = area / 2;
  const absArea = Math.abs(area);
  if (absArea < 1e-6) {
    let sx = 0;
    let sy = 0;
    for (const p of pts) {
      sx += p.x;
      sy += p.y;
    }
    return { area: 0, cx: sx / n, cy: sy / n };
  }
  cx = cx / (6 * area);
  cy = cy / (6 * area);
  return { area: absArea, cx, cy };
}

async function extract() {
  console.log("Iniciando extracción desde:", DXF_PATH);
  if (!fs.existsSync(DXF_PATH)) {
    throw new Error(`No se encontró el archivo DXF en: ${DXF_PATH}`);
  }

  const rl = readline.createInterface({
    input: fs.createReadStream(DXF_PATH),
    crlfDelay: Infinity,
  });

  let inEntities = false;
  let prevCode = null;
  let currentEntity = null;

  const lotPolylines = [];
  const lotTexts = [];
  const mzPolylines = [];
  const mzTexts = [];
  const viaPolylines = [];
  const calzadaPolylines = [];
  const greenPolylines = [];
  const senderoPolylines = [];
  const linderoPolylines = [];

  for await (const line of rl) {
    const val = line.trim();
    if (prevCode === null) {
      prevCode = val;
      continue;
    }
    const code = prevCode;
    prevCode = null;

    if (code === "2" && val === "ENTITIES") inEntities = true;
    if (code === "0" && val === "ENDSEC") inEntities = false;
    if (!inEntities) continue;

    if (code === "0") {
      if (currentEntity) {
        saveEntity(currentEntity);
      }
      currentEntity = {
        type: val,
        layer: "",
        points: [],
        text: "",
        x: null,
        y: null,
        closed: false,
      };
    } else if (currentEntity) {
      if (code === "8") {
        currentEntity.layer = val;
      } else if (code === "1" || code === "3") {
        currentEntity.text += val;
      } else if (code === "70" && currentEntity.type === "LWPOLYLINE") {
        currentEntity.closed = (parseInt(val, 10) & 1) === 1;
      } else if (code === "10") {
        if (currentEntity.type === "LWPOLYLINE") {
          currentEntity.points.push({ x: parseFloat(val), y: 0 });
        } else {
          currentEntity.x = parseFloat(val);
        }
      } else if (code === "20") {
        if (currentEntity.type === "LWPOLYLINE" && currentEntity.points.length > 0) {
          currentEntity.points[currentEntity.points.length - 1].y = parseFloat(val);
        } else {
          currentEntity.y = parseFloat(val);
        }
      }
    }
  }

  if (currentEntity) saveEntity(currentEntity);

  function saveEntity(e) {
    if (e.layer === "C-PROP-LINE" && e.points.length >= 3) {
      lotPolylines.push(e);
    } else if (e.layer === "A-NUMERO LOTE" && e.text) {
      lotTexts.push(e);
    } else if (e.layer === "A-MZ_6") {
      if (e.points.length >= 3) mzPolylines.push(e);
      if (e.text) mzTexts.push(e);
    } else if (e.layer === "A-VIA" && e.points.length >= 2) {
      viaPolylines.push(e);
    } else if (e.layer === "A-CALZADA" && e.points.length >= 2) {
      calzadaPolylines.push(e);
    } else if ((e.layer === "A-ZONA VERDE" || e.layer === "zonas verdes") && e.points.length >= 3) {
      greenPolylines.push(e);
    } else if ((e.layer === "A-SENDEROS" || e.layer === "_SENDERO") && e.points.length >= 2) {
      senderoPolylines.push(e);
    } else if (e.layer === "_LINDERO" && e.points.length >= 3) {
      linderoPolylines.push(e);
    }
  }

  console.log("Entidades leídas:");
  console.log(`- Polilíneas C-PROP-LINE: ${lotPolylines.length}`);
  console.log(`- Textos A-NUMERO LOTE: ${lotTexts.length}`);
  console.log(`- Polilíneas A-MZ_6: ${mzPolylines.length}`);
  console.log(`- Textos A-MZ_6: ${mzTexts.length}`);
  console.log(`- Vías (A-VIA): ${viaPolylines.length}`);
  console.log(`- Calzadas (A-CALZADA): ${calzadaPolylines.length}`);
  console.log(`- Zonas verdes: ${greenPolylines.length}`);
  console.log(`- Senderos: ${senderoPolylines.length}`);
  console.log(`- Linderos: ${linderoPolylines.length}`);

  // 1. Deduplicar polígonos de lotes
  const uniqueLots = [];
  for (const poly of lotPolylines) {
    const m = polygonMetrics(poly.points);
    if (m.area < 40 || m.area > 5000) continue;
    const exists = uniqueLots.find(
      (u) =>
        Math.abs(u.cx - m.cx) < 0.25 &&
        Math.abs(u.cy - m.cy) < 0.25 &&
        Math.abs(u.area - m.area) < 1.0,
    );
    if (!exists) {
      uniqueLots.push({ ...m, poly });
    }
  }
  console.log(`Polígonos de lotes únicos identificados: ${uniqueLots.length}`);

  // 2. Asociar Manzanas
  const mzMetrics = mzPolylines.map((poly) => ({
    ...polygonMetrics(poly.points),
    poly,
    name: "",
  }));

  for (const text of mzTexts) {
    const pt = { x: text.x, y: text.y };
    const cleanName = text.text
      .replace(/\\.*?;/g, "")
      .replace(/[{}]/g, "")
      .trim();
    const mzPoly = mzMetrics.find((m) => pointInPolygon(pt, m.poly.points));
    if (mzPoly) {
      mzPoly.name = cleanName;
    } else {
      let nearest = null;
      let minD = Infinity;
      for (const m of mzMetrics) {
        const d = Math.hypot(m.cx - pt.x, m.cy - pt.y);
        if (d < minD) {
          minD = d;
          nearest = m;
        }
      }
      if (nearest && minD < 30) nearest.name = cleanName;
    }
  }

  // 3. Filtrar textos de número de lote
  const validLotTexts = lotTexts.filter((t) => /^\d+[a-zA-Z]?$/.test(t.text.trim()));
  console.log(`Textos de número de lote válidos: ${validLotTexts.length}`);

  // 4. Asociar lotes (número -> polígono)
  const matchedLots = [];

  for (const lt of validLotTexts) {
    const rawNum = lt.text.trim();
    const num = parseInt(rawNum, 10);
    const pt = { x: lt.x, y: lt.y };

    let polyMatch = uniqueLots.find((l) => pointInPolygon(pt, l.poly.points));

    if (!polyMatch) {
      let nearest = null;
      let minD = Infinity;
      for (const l of uniqueLots) {
        const d = Math.hypot(l.cx - pt.x, l.cy - pt.y);
        if (d < minD) {
          minD = d;
          nearest = l;
        }
      }
      if (nearest && minD < 20) {
        polyMatch = nearest;
      }
    }

    if (polyMatch) {
      let manzanaName = "";
      const containingMz = mzMetrics.find((m) =>
        pointInPolygon({ x: polyMatch.cx, y: polyMatch.cy }, m.poly.points),
      );
      if (containingMz && containingMz.name) {
        manzanaName = containingMz.name;
      } else {
        let nearestMz = null;
        let minMzDist = Infinity;
        for (const m of mzMetrics) {
          if (!m.name) continue;
          const d = Math.hypot(m.cx - polyMatch.cx, m.cy - polyMatch.cy);
          if (d < minMzDist) {
            minMzDist = d;
            nearestMz = m;
          }
        }
        if (nearestMz && minMzDist < 60) {
          manzanaName = nearestMz.name;
        }
      }

      matchedLots.push({
        lotNumber: num,
        rawLabel: rawNum,
        id: `L-${String(num).padStart(2, "0")}`,
        manzana: manzanaName || "M",
        areaM2: Math.round(polyMatch.area * 100) / 100,
        cx: polyMatch.cx,
        cy: polyMatch.cy,
        points: polyMatch.poly.points,
      });
      polyMatch.assigned = true;
    }
  }

  // Polígonos de reserva (sin número directo)
  let extraIdx = 1;
  for (const u of uniqueLots) {
    if (!u.assigned) {
      let manzanaName = "";
      const containingMz = mzMetrics.find((m) =>
        pointInPolygon({ x: u.cx, y: u.cy }, m.poly.points),
      );
      if (containingMz && containingMz.name) manzanaName = containingMz.name;

      matchedLots.push({
        lotNumber: 900 + extraIdx,
        rawLabel: `R-${extraIdx}`,
        id: `L-R${extraIdx}`,
        manzana: manzanaName || "Reserva",
        areaM2: Math.round(u.area * 100) / 100,
        cx: u.cx,
        cy: u.cy,
        points: u.poly.points,
        isReserve: true,
      });
      extraIdx++;
    }
  }

  matchedLots.sort((a, b) => a.lotNumber - b.lotNumber);
  console.log(`Lotes finales procesados: ${matchedLots.length}`);

  // 5. Normalizar coordenadas
  let minX = Infinity;
  let maxX = -Infinity;
  let minY = Infinity;
  let maxY = -Infinity;

  const allPolys = [
    ...linderoPolylines,
    ...viaPolylines,
    ...calzadaPolylines,
    ...greenPolylines,
    ...senderoPolylines,
    ...matchedLots.map((l) => ({ points: l.points })),
  ];

  for (const p of allPolys) {
    for (const pt of p.points) {
      if (pt.x > 800000 && pt.x < 900000 && pt.y > 1600000 && pt.y < 1700000) {
        if (pt.x < minX) minX = pt.x;
        if (pt.x > maxX) maxX = pt.x;
        if (pt.y < minY) minY = pt.y;
        if (pt.y > maxY) maxY = pt.y;
      }
    }
  }

  const marginMeters = 20;
  minX -= marginMeters;
  maxX += marginMeters;
  minY -= marginMeters;
  maxY += marginMeters;

  const widthMeters = maxX - minX;
  const heightMeters = maxY - minY;

  const SVG_WIDTH = 2400;
  const scale = SVG_WIDTH / widthMeters;
  const SVG_HEIGHT = Math.round(heightMeters * scale);

  console.log(`Dimensiones SVG: ${SVG_WIDTH} x ${SVG_HEIGHT} (Escala: ${scale.toFixed(4)} px/m)`);

  function toSvgX(x) {
    return Math.round((x - minX) * scale * 10) / 10;
  }

  function toSvgY(y) {
    return Math.round((maxY - y) * scale * 10) / 10;
  }

  function pointsToPath(pts, close = true) {
    if (!pts || pts.length < 2) return "";
    let d = `M ${toSvgX(pts[0].x)} ${toSvgY(pts[0].y)}`;
    for (let i = 1; i < pts.length; i++) {
      d += ` L ${toSvgX(pts[i].x)} ${toSvgY(pts[i].y)}`;
    }
    if (close) d += " Z";
    return d;
  }

  const lotsJsonData = matchedLots.map((lot) => {
    const svgCx = toSvgX(lot.cx);
    const svgCy = toSvgY(lot.cy);
    const pathD = pointsToPath(lot.points, true);

    return {
      id: lot.id,
      lotNumber: lot.lotNumber,
      label: lot.rawLabel,
      manzana: lot.manzana,
      areaM2: lot.areaM2,
      centroid: [svgCx, svgCy],
      pathD,
      isReserve: Boolean(lot.isReserve),
    };
  });

  const linderoPaths = linderoPolylines.map((p) => pointsToPath(p.points, true));
  const greenPaths = greenPolylines.map((p) => pointsToPath(p.points, true));
  const viaPaths = viaPolylines.map((p) => pointsToPath(p.points, p.closed));
  const calzadaPaths = calzadaPolylines.map((p) => pointsToPath(p.points, p.closed));
  const senderoPaths = senderoPolylines.map((p) => pointsToPath(p.points, p.closed));

  const svgContent = `<?xml version="1.0" encoding="UTF-8"?>
<svg
  xmlns="http://www.w3.org/2000/svg"
  viewBox="0 0 ${SVG_WIDTH} ${SVG_HEIGHT}"
  width="100%"
  height="100%"
  shape-rendering="geometricPrecision"
>
  <style>
    .bg-canvas { fill: #fbf9f4; }
    .lindero-fill { fill: #ede4cf; stroke: #9e8d72; stroke-width: 3.2; }
    .green-area { fill: #b8e0a2; stroke: #5e8f42; stroke-width: 1.8; }
    .sendero-path { fill: none; stroke: #8a7a63; stroke-width: 2.2; stroke-dasharray: 6 4; }
    .via-path { fill: #ded6c2; stroke: #998a72; stroke-width: 1.8; }
    .calzada-path { fill: #d5cbba; stroke: #8f7e65; stroke-width: 2; }
    .lot-polygon {
      stroke-width: 1.5;
      cursor: pointer;
      transition: fill 0.15s ease, stroke 0.15s ease, stroke-width 0.15s ease;
    }
    .lot-available {
      fill: #dcfce7;
      stroke: #16a34a;
    }
    .lot-reserved {
      fill: #ffedd5;
      stroke: #ea580c;
    }
    .lot-sold {
      fill: #fee2e2;
      stroke: #dc2626;
    }
    .lot-last-units {
      fill: #fef9c3;
      stroke: #ca8a04;
    }
    .lot-polygon:hover {
      fill: #bae6fd;
      stroke: #0284c7;
      stroke-width: 2.8;
    }
    .lot-text-label {
      font-family: system-ui, -apple-system, sans-serif;
      font-size: 11px;
      font-weight: 800;
      text-anchor: middle;
      dominant-baseline: central;
      fill: #0f172a;
      pointer-events: none;
      user-select: none;
    }
    .lot-text-label.active {
      fill: #0284c7;
      font-size: 13.5px;
    }
    .mz-label {
      font-family: system-ui, -apple-system, sans-serif;
      font-size: 26px;
      font-weight: 900;
      text-anchor: middle;
      dominant-baseline: central;
      fill: #3f392f;
      opacity: 0.75;
      pointer-events: none;
    }
  </style>

  <!-- Fondo base -->
  <rect width="${SVG_WIDTH}" height="${SVG_HEIGHT}" class="bg-canvas" />

  <!-- Linderos de proyecto -->
  <g id="layer-linderos">
    ${linderoPaths.map((d) => `<path d="${d}" class="lindero-fill" />`).join("\n    ")}
  </g>

  <!-- Zonas verdes y senderos -->
  <g id="layer-green-areas">
    ${greenPaths.map((d) => `<path d="${d}" class="green-area" />`).join("\n    ")}
  </g>

  <!-- Red vial interna -->
  <g id="layer-roads">
    ${viaPaths.map((d) => `<path d="${d}" class="via-path" />`).join("\n    ")}
    ${calzadaPaths.map((d) => `<path d="${d}" class="calzada-path" />`).join("\n    ")}
    ${senderoPaths.map((d) => `<path d="${d}" class="sendero-path" />`).join("\n    ")}
  </g>

  <!-- Polígonos de lotes con IDs unívocos y estados comerciales -->
  <g id="layer-lots">
    ${lotsJsonData
      .map((lot) => {
        let statusClass = "lot-available";
        if (lot.isReserve) {
          statusClass = "lot-reserved";
        } else if (lot.lotNumber % 11 === 0) {
          statusClass = "lot-sold";
        } else if (lot.lotNumber % 7 === 0) {
          statusClass = "lot-reserved";
        } else if (lot.lotNumber % 5 === 0 && lot.lotNumber % 2 !== 0) {
          statusClass = "lot-last-units";
        }
        return `
    <path
      id="lot-${lot.id}"
      data-lot-id="${lot.id}"
      data-lot-number="${lot.lotNumber}"
      data-manzana="${lot.manzana}"
      data-area="${lot.areaM2}"
      d="${lot.pathD}"
      class="lot-polygon ${statusClass}"
    >
      <title>Lote ${lot.label} - ${lot.manzana} (${lot.areaM2} m²)</title>
    </path>`;
      })
      .join("")}
  </g>

  <!-- Manzanas rotuladas -->
  <g id="layer-manzanas">
    ${mzMetrics
      .filter((m) => m.name)
      .map(
        (m) => `
    <text x="${toSvgX(m.cx)}" y="${toSvgY(m.cy)}" class="mz-label">${m.name}</text>`,
      )
      .join("")}
  </g>

  <!-- Números de lote en centroide exacto -->
  <g id="layer-labels">
    ${lotsJsonData
      .filter((l) => !l.isReserve)
      .map(
        (lot) => `
    <text
      id="label-${lot.id}"
      x="${lot.centroid[0]}"
      y="${lot.centroid[1]}"
      class="lot-text-label"
    >${lot.label}</text>`,
      )
      .join("")}
  </g>
</svg>
`;

  const OUTPUT_LAYERS = path.resolve("src/data/villa-paraiso-layers.json");
  const layersData = {
    dimensions: { width: SVG_WIDTH, height: SVG_HEIGHT },
    linderos: linderoPaths,
    greenAreas: greenPaths,
    roads: viaPaths,
    calzadas: calzadaPaths,
    senderos: senderoPaths,
    manzanas: mzMetrics
      .filter((m) => m.name)
      .map((m) => ({
        name: m.name,
        x: toSvgX(m.cx),
        y: toSvgY(m.cy),
      })),
  };
  fs.writeFileSync(OUTPUT_LAYERS, JSON.stringify(layersData, null, 2), "utf8");
  console.log(`Capas de fondo guardadas en: ${OUTPUT_LAYERS}`);

  void svgContent;
}

extract().catch((err) => {
  console.error("Error durante la extracción:", err);
  process.exit(1);
});
