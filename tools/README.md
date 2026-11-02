# Herramientas de procesamiento CAD y 3D (AUTEM-BACKEND)

Este directorio contiene las herramientas de backend para procesar planos CAD (DXF/DWG), modelos 3D (GLB/glTF), y georreferenciación de desarrollos inmobiliarios.

El frontend de AUTEM **no** debe procesar archivos CAD pesados ni calcular transformaciones geométricas complejas en el cliente; consume únicamente los derivados optimizados (JSON vectorial, SVG limpio, GeoJSON o GLB reparado).

---

## 1. `extract-masterplan.mjs`
Extrae capas, polilíneas, textos de lotes y linderos desde un archivo CAD `.dxf` a formato estructurado (SVG y JSON) usando algoritmos de *Ray Casting* y *Shoelace formula* para cómputo de métricas y centroides.

```bash
node tools/extract-masterplan.mjs <ruta-al-archivo.dxf> [ruta-salida.json]
```

## 2. `extract-villa-paraiso-navigation.mjs`
Extrae las redes de navegación (vías `A-VIA`, calzadas `A-CALZADA`, senderos `A-SENDEROS`) y anotaciones de acceso desde un DXF para alimentar el grafo de rutas de navegación interna del terreno.

```bash
node tools/extract-villa-paraiso-navigation.mjs <entrada.dxf> <salida.json>
```

## 3. `register-navigation-cad.mjs`
Registra los pares de puntos de control entre entidades CAD y el plano SVG vectorizado mediante regresión afín de mínimos cuadrados, garantizando un error RMS por debajo del umbral de tolerancia (< 0.1) antes de persistir o publicar.

```bash
node tools/register-navigation-cad.mjs
```

## 4. `repair-glb.mjs`
Repara modelos GLB/glTF exportados por herramientas CAD o de visualización (por ejemplo *trimesh* o Revit) que carecen de vectores normales o materiales PBR estándar.
- Calcula normales por vértice ponderadas por área.
- Asigna materiales PBR PBR Metallic-Roughness consistentes (ej. acabado nórdico *"Mármol blanco"* `#E5E4E2`).

```bash
node tools/repair-glb.mjs <archivo.glb> [archivo2.glb ...]
```

