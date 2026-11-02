-- 202610310005_populate_excel_lots_villa_paraiso.sql
-- Pobla y sincroniza exactamente los 340 lotes oficiales de VILLA PARAISO Reserva Campestre
-- tomados del Excel oficial 'Cuadro_de_Areas__y_Descripcion_para_Pagina_Web_Corregida.xlsx'

-- Permitir lotes con subdivisiones como 45 y 45A, 133 y 133A
DROP INDEX IF EXISTS public.lots_project_number_unique;
CREATE INDEX IF NOT EXISTS lots_project_number_idx ON public.lots (project_id, lot_number);

DO $$
DECLARE
  v_project_id uuid;
BEGIN
  SELECT id INTO v_project_id FROM public.projects WHERE slug IN ('villa-paraiso', 'lotes-360') LIMIT 1;
  IF v_project_id IS NULL THEN
    v_project_id := '00000000-0000-0000-0000-000000000101'::uuid;
  END IF;

  -- Eliminar lotes residuales/ficticios L-R1..L-R8
  DELETE FROM public.lots WHERE project_id = v_project_id AND external_id LIKE 'L-R%';

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-01',
    1,
    'M 1',
    'available',
    108565100,
    350.21,
    '[1058.2,2048.5]'::jsonb,
    '{"pathD":"M 1108.4 2077.2 L 1082.9 2094.4 L 1009.3 2023.8 L 1030.1 2002.1 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":108565100,"cuota_ini_20":21713020,"cuota_inicial_20":21713020,"cuotas_3_ini":7237673,"cuotas_48":1809418,"precio_preventa":98058800,"cuota_ini_pre_20":19611760,"cuotas_3_ini_pre":6537253,"cuotas_48_pre":1634313,"descripcion_lindero":"LOTE NÚMERO UNO (1): Por el frente linda con Calle Número 1 y mide 10.23 metros; por la derecha entrando, linda con Lote número 2, y mide 36.09 metros, por el fondo, linda con Sendero peatonal y mide 10. metros, por la izquierda, linda con Área de cesión, y mide 33.95 metros. Área del lote: 350.21 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-02',
    2,
    'M 1',
    'available',
    115208400,
    371.64,
    '[1081.1,2029.5]'::jsonb,
    '{"pathD":"M 1133.8 2059.9 L 1108.4 2077.2 L 1030.1 2002.1 L 1050.9 1980.4 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":115208400,"cuota_ini_20":23041680,"cuota_inicial_20":23041680,"cuotas_3_ini":7680560,"cuotas_48":1920140,"precio_preventa":104059200,"cuota_ini_pre_20":20811840,"cuotas_3_ini_pre":6937280,"cuotas_48_pre":1734320,"descripcion_lindero":"LOTE NÚMERO DOS (2): Por el frente, linda con calle número 1, y mide 10.23 por la derecha entrando, linda con Lote Numero 3 y mide 38.24 fondo, linda con Sendero peatonal, y mide 10 metros; por la izquierda, linda con Lote Numero 1, y mide 36.09 metros. Área del lote: 371.64 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-03',
    3,
    'M 1',
    'available',
    134220700,
    432.97,
    '[1104.8,2010.1]'::jsonb,
    '{"pathD":"M 1050.9 1980.4 L 1073.8 1956.5 L 1161.7 2040.9 L 1133.8 2059.9 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":134220700,"cuota_ini_20":26844140,"cuota_inicial_20":26844140,"cuotas_3_ini":8948047,"cuotas_48":2237012,"precio_preventa":121231600,"cuota_ini_pre_20":24246320,"cuotas_3_ini_pre":8082107,"cuotas_48_pre":2020527,"descripcion_lindero":"LOTE NÚMERO TRES (3): Por el frente, linda con calle Numero 1 y mide 11.22 metros; por la derecha entrando, linda con Lote Numero 4 y mide 40.56 metros; por el fondo, linda con Sendero peatonal y mide 11.00 metros; por la izquierda linda con Lote Numero 2 y mide 38.24 metros. Área del lote: 432.97 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-04',
    4,
    'M 1',
    'available',
    146506800,
    443.96,
    '[1127.8,1983.6]'::jsonb,
    '{"pathD":"M 1073.8 1956.5 L 1094.1 1935.3 L 1169 1988.2 L 1163.8 2039.5 L 1161.7 2040.9 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"VERDE","valor_m2":330000,"prem2":300000,"precio_venta":146506800,"cuota_ini_20":29301360,"cuota_inicial_20":29301360,"cuotas_3_ini":9767120,"cuotas_48":2441780,"precio_preventa":133188000,"cuota_ini_pre_20":26637600,"cuotas_3_ini_pre":8879200,"cuotas_48_pre":2219800,"descripcion_lindero":"LOTE NÚMERO CUATRO (4): Por el frente, linda con Acceso vehicular al lote y Calle Numero 1 y mide 17.99 metros; por la derecha entrando, linda con zona común, y mide 30.52 metros; por el fondo, linda con Sendero peatonal y mide 9.79 metros; por la izquierda linda con Lote Numero 3 y mide 40.56 metros. Área del lote: 443.96 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-05',
    5,
    'M 1',
    'sold',
    158353800,
    479.86,
    '[1038.6,1945.8]'::jsonb,
    '{"pathD":"M 990.1 1963.5 L 1051.9 1896.4 L 1087.2 1929 L 1023.8 1995.6 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"VERDE","valor_m2":330000,"prem2":300000,"precio_venta":158353800,"cuota_ini_20":31670760,"cuota_inicial_20":31670760,"cuotas_3_ini":10556920,"cuotas_48":2639230,"precio_preventa":143958000,"cuota_ini_pre_20":28791600,"cuotas_3_ini_pre":9597200,"cuotas_48_pre":2399300,"descripcion_lindero":"LOTE NÚMERO CINCO (5): Por el frente, linda con acceso vehicular al lote carrera 2 y mide 15.98 metros; por la derecha entrando, linda con lote Numero 6 y mide 30.37 metros; por el fondo, linda con lote número 7 y mide 15.49 metros; por la izquierda, linda con sendero peatonal y mide 30.62 metros. Área del lote: 479.86M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-06',
    6,
    'M 1',
    'sold',
    141147600,
    427.72,
    '[1005.2,1915.8]'::jsonb,
    '{"pathD":"M 958.5 1933.5 L 1014.8 1874.8 L 1027.1 1873.5 L 1051.9 1896.4 L 990.1 1963.5 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"VERDE","valor_m2":330000,"prem2":300000,"precio_venta":141147600,"cuota_ini_20":28229520,"cuota_inicial_20":28229520,"cuotas_3_ini":9409840,"cuotas_48":2352460,"precio_preventa":128316000,"cuota_ini_pre_20":25663200,"cuotas_3_ini_pre":8554400,"cuotas_48_pre":2138600,"descripcion_lindero":"LOTE NÚMERO SEIS (6): Por el frente, linda con Carrera 2 y mide 11.25 metros; por la derecha entrando, linda con calle 2 y mide 27.06 metros; por el fondo, linda con lote 7 y mide 14.50 metros; por la izquierda, linda con Lote Numero 5 y mide 30.37 metros. Área del lote: 427.72M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-07',
    7,
    'M 1',
    'available',
    93517700,
    301.67,
    '[980.6,1975.8]'::jsonb,
    '{"pathD":"M 1023.8 1995.6 L 1002.9 2017.6 L 937.7 1955.2 L 958.5 1933.5 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":93517700,"cuota_ini_20":18703540,"cuota_inicial_20":18703540,"cuotas_3_ini":6234513,"cuotas_48":1558628,"precio_preventa":84467600,"cuota_ini_pre_20":16893520,"cuotas_3_ini_pre":5631173,"cuotas_48_pre":1407793,"descripcion_lindero":"LOTE NÚMERO SIETE (7): Por el frente, linda con calle 2 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 8 y mide 30.03 metros, por el fondo, linda con Sendero peatonal y mide 10.10 metros; por la izquierda, linda con Lote Numero 5 y 6 y mide 29.99 metros. Área del lote: 301.67M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-08',
    8,
    'M 1',
    'available',
    93148800,
    300.48,
    '[959.9,1997.1]'::jsonb,
    '{"pathD":"M 982.1 2039.4 L 916.9 1976.8 L 937.7 1955.2 L 1002.9 2017.6 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":93148800,"cuota_ini_20":18629760,"cuota_inicial_20":18629760,"cuotas_3_ini":6209920,"cuotas_48":1552480,"precio_preventa":84134400,"cuota_ini_pre_20":16826880,"cuotas_3_ini_pre":5608960,"cuotas_48_pre":1402240,"descripcion_lindero":"LOTE NÚMERO OCHO (8): Por el frente, linda con Calle Numero 2 y mide 10.00 metros; por la derecha entrando, linda con zona comunal y mide 30.07 metros; por el fondo, linda con Sendero peatonal y mide 10.00 metros; por la izquierda, linda con Lote Numero 7 y mide 30.03 metros. Área del lote: 300.48M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-09',
    9,
    'M 2',
    'available',
    86440300,
    298.07,
    '[877.3,1917.2]'::jsonb,
    '{"pathD":"M 919.8 1939.5 L 905.3 1954.7 L 892.5 1954.9 L 834 1898.8 L 854.8 1877.1 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":86440300,"cuota_ini_20":17288060,"cuota_inicial_20":17288060,"cuotas_3_ini":5762687,"cuotas_48":1440672,"precio_preventa":80478900,"cuota_ini_pre_20":16095780,"cuotas_3_ini_pre":5365260,"cuotas_48_pre":1341315,"descripcion_lindero":"LOTE NÚMERO NUEVE (9): Por el frente, linda con acceso vehicular al lote y Calle Numero 2 y mide 7.00 metros; por la derecha entrando, linda con carrara 1 y mide 27 metros; por el fondo, linda con lote 18 y mide 10.00 metros; por la izquierda, linda con Lote Numero 10 y mide 30.00 metros. Área del lote: 298.07 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-10',
    10,
    'M 2',
    'available',
    93000000,
    300,
    '[898,1896.8]'::jsonb,
    '{"pathD":"M 940.6 1917.8 L 919.8 1939.5 L 854.8 1877.1 L 875.6 1855.4 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":93000000,"cuota_ini_20":18600000,"cuota_inicial_20":18600000,"cuotas_3_ini":6200000,"cuotas_48":1550000,"precio_preventa":84000000,"cuota_ini_pre_20":16800000,"cuotas_3_ini_pre":5600000,"cuotas_48_pre":1400000,"descripcion_lindero":"LOTE NÚMERO DIEZ (10): Por el frente, linda con Calle Numero 2 y mide 10.00 metros; por la derecha entrando, linda con lote 11, lote 12 y lote 13 y mide 29.01 metros; por el fondo, linda con Lote Numero 17, y mide 10.00 metros; por la izquierda, linda con Lote Numero 9 y mide 30 metros. Área del lote: 300.00 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-11',
    11,
    'M 2',
    'sold',
    87842700,
    266.19,
    '[958.4,1878.2]'::jsonb,
    '{"pathD":"M 919.7 1897.7 L 940.6 1917.8 L 992.9 1863.3 L 991.9 1849.9 L 977 1838.3 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"VERDE","valor_m2":330000,"prem2":300000,"precio_venta":87842700,"cuota_ini_20":17568540,"cuota_inicial_20":17568540,"cuotas_3_ini":5856180,"cuotas_48":1464045,"precio_preventa":79857000,"cuota_ini_pre_20":15971400,"cuotas_3_ini_pre":5323800,"cuotas_48_pre":1330950,"descripcion_lindero":"LOTE NÚMERO ONCE (11): Por el frente, linda con acceso vehicular al lote Y Carrera Numero 2 y mide 11.29 metros; por la derecha entrando, linda con Lote Numero 12 y mide 27.47 metros; por el fondo, linda con Lote Numero 10 y mide 9.67 metros; por la izquierda, linda con la Calle 2 y mide 25.13 ml. Área del lote: 266.19M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-12',
    12,
    'M 2',
    'sold',
    86615100,
    262.47,
    '[936.9,1859.6]'::jsonb,
    '{"pathD":"M 898.7 1877.6 L 919.7 1897.7 L 977 1838.3 L 961.4 1826.2 L 956.4 1817.9 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"VERDE","valor_m2":330000,"prem2":300000,"precio_venta":86615100,"cuota_ini_20":17323020,"cuota_inicial_20":17323020,"cuotas_3_ini":5774340,"cuotas_48":1443585,"precio_preventa":78741000,"cuota_ini_pre_20":15748200,"cuotas_3_ini_pre":5249400,"cuotas_48_pre":1312350,"descripcion_lindero":"LOTE NÚMERO DOCE (12): Por el frente, linda con acceso vehicular al lote y Carrera Numero 2 y mide 9.82 metros; por la derecha entrando, linda con Lote Numero 13 y mide 27.63 metros; por el fondo, linda con Lote Numero 10 y mide 9.67 metros; por la izquierda, linda con Lote Numero 11 y mide 27.47 metros. Área del lote: 262.47 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-13',
    13,
    'M 2',
    'sold',
    92287800,
    279.66,
    '[917.7,1837.2]'::jsonb,
    '{"pathD":"M 877.7 1857.5 L 898.7 1877.6 L 956.4 1817.9 L 940.9 1792.1 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"VERDE","valor_m2":330000,"prem2":300000,"precio_venta":92287800,"cuota_ini_20":18457560,"cuota_inicial_20":18457560,"cuotas_3_ini":6152520,"cuotas_48":1538130,"precio_preventa":83898000,"cuota_ini_pre_20":16779600,"cuotas_3_ini_pre":5593200,"cuotas_48_pre":1398300,"descripcion_lindero":"LOTE NÚMERO TRECE (13): Por el frente, linda con acceso vehicular al lote y Carrera Numero 2 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 14 y mide 30.23 metros; por el fondo, linda con Lote Numero 10 y mide 9.67 metros; por la izquierda, linda con Lote Numero 12 y mide 27.63 metros. Área del lote: 279.66 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-14',
    14,
    'M 2',
    'available',
    100768800,
    305.36,
    '[900,1813.3]'::jsonb,
    '{"pathD":"M 856.7 1837.4 L 926.1 1765.7 L 930.3 1774.6 L 940.9 1792.1 L 877.7 1857.5 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"VERDE","valor_m2":330000,"prem2":300000,"precio_venta":100768800,"cuota_ini_20":20153760,"cuota_inicial_20":20153760,"cuotas_3_ini":6717920,"cuotas_48":1679480,"precio_preventa":91608000,"cuota_ini_pre_20":18321600,"cuotas_3_ini_pre":6107200,"cuotas_48_pre":1526800,"descripcion_lindero":"LOTE NÚMERO CATORCE (14): Por el frente, linda con acceso vehicular al lote y Carrera Numero 2 y mide 10.10 metros; por la derecha entrando, linda con Lote Numero 15 y mide 33.17 metros; por el fondo, linda con Lote Numero 17 y mide 8.67 metros; por la izquierda, linda con Lote Numero 13 y mide 30.23 metros. Área del lote: 305.36 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-15',
    15,
    'M 2',
    'available',
    111629100,
    338.27,
    '[882.8,1789.1]'::jsonb,
    '{"pathD":"M 835.8 1817.3 L 912.7 1737.7 L 926.1 1765.7 L 856.7 1837.4 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"VERDE","valor_m2":330000,"prem2":300000,"precio_venta":111629100,"cuota_ini_20":22325820,"cuota_inicial_20":22325820,"cuotas_3_ini":7441940,"cuotas_48":1860485,"precio_preventa":101481000,"cuota_ini_pre_20":20296200,"cuotas_3_ini_pre":6765400,"cuotas_48_pre":1691350,"descripcion_lindero":"LOTE NÚMERO QUINCE (15): Por el frente, linda con acceso vehicular al lote y Carrera Numero 2 y mide 10.32 metros; por la derecha entrando, linda con Lote Numero 16 y mide 36.82 metros; por el fondo linda con Lote Numero 17 y mide 9.67 metros; por la izquierda linda con Lote Numero 14 y mide 33.17 metros. Área del lote 338.27 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-16',
    16,
    'M 2',
    'available',
    121614900,
    368.53,
    '[864.3,1766.8]'::jsonb,
    '{"pathD":"M 835.8 1817.3 L 912.7 1737.7 L 903 1721.5 L 888.8 1720 L 814.8 1797.1 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"VERDE","valor_m2":330000,"prem2":300000,"precio_venta":121614900,"cuota_ini_20":24322980,"cuota_inicial_20":24322980,"cuotas_3_ini":8107660,"cuotas_48":2026915,"precio_preventa":110559000,"cuota_ini_pre_20":22111800,"cuotas_3_ini_pre":7370600,"cuotas_48_pre":1842650,"descripcion_lindero":"LOTE NÚMERO DIECISEIS (16): Por el frente, linda con acceso vehicular al lote y Carrera Numero 2 y mide 11.78 metros; por la derecha entrando, linda con Calle Numero 3 y mide 35.58 metros; por el fondo, linda con Lote Numero 17 y mide 9.67 metros; por la izquierda, linda con Lote Numero 15 y mide 36.82 metros. Área del lote: 368.56 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-17',
    17,
    'M 2',
    'available',
    86800000,
    280,
    '[834.8,1837.1]'::jsonb,
    '{"pathD":"M 794 1818.8 L 814.8 1797.1 L 875.6 1855.4 L 854.8 1877.1 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":86800000,"cuota_ini_20":17360000,"cuota_inicial_20":17360000,"cuotas_3_ini":5786667,"cuotas_48":1446667,"precio_preventa":78400000,"cuota_ini_pre_20":15680000,"cuotas_3_ini_pre":5226667,"cuotas_48_pre":1306667,"descripcion_lindero":"LOTE NÚMERO DIECISIETE (17): Por el frente, linda con acceso vehicular al lote y Calle Numero 3 y mide 10.00 metros, por la derecha entrando, linda con el Lote Numero 18 y mide 28.00 metros; por el fondo, linda con Lote Numero 10 y mide 10.00metros; por la izquierda, linda con Lote Numero 14, Lote Numero 15, Lote Numero 16 y mide 28.01 metros. Área del lote: 280.00 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-18',
    18,
    'M 2',
    'available',
    86201700,
    278.07,
    '[814.2,1859.8]'::jsonb,
    '{"pathD":"M 854.8 1877.1 L 834 1898.8 L 779.7 1846.8 L 779.4 1834 L 794 1818.8 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":86201700,"cuota_ini_20":17240340,"cuota_inicial_20":17240340,"cuotas_3_ini":5746780,"cuotas_48":1436695,"precio_preventa":77859600,"cuota_ini_pre_20":15571920,"cuotas_3_ini_pre":5190640,"cuotas_48_pre":1297660,"descripcion_lindero":"LOTE NÚMERO DIECIOCHO (18): Por el frente, linda con el acceso vehicular al lote y Calle Numero 3 y mide 11.71 metros; por la derecha entrando, linda con Carrera Numero 1 y mide 25.00 metros; por el fondo, linda con Lote Numero 09 y mide 10.00 metros; por la izquierda linda con Lote Numero 17 y mide 28.00 metros. Área del lote: 278.07 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-19',
    19,
    'M 3',
    'available',
    89301700,
    288.07,
    '[733.2,1783.7]'::jsonb,
    '{"pathD":"M 775.3 1803.6 L 760.8 1818.8 L 748 1819.1 L 691.6 1765 L 712.4 1743.3 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":89301700,"cuota_ini_20":17860340,"cuota_inicial_20":17860340,"cuotas_3_ini":5953447,"cuotas_48":1488362,"precio_preventa":80659600,"cuota_ini_pre_20":16131920,"cuotas_3_ini_pre":5377307,"cuotas_48_pre":1344327,"descripcion_lindero":"LOTE NÚMERO DIECINUEVE (19): Por el frente, linda con el acceso vehicular al lote y Calle Numero 3 y mide 11.71 metros; por la derecha entrando, linda con Lote Numero 20 y mide 29.00 metros; por el fondo, linda con Lote Numero 30 y mide 10.00 metros; por la izquierda linda con Carrera Numero 1 y mide 26.00 metros. Área del lote: 288.07 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-20',
    20,
    'M 3',
    'available',
    89900000,
    290,
    '[754.6,1761.9]'::jsonb,
    '{"pathD":"M 796.1 1781.9 L 775.3 1803.6 L 712.4 1743.3 L 733.2 1721.6 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":89900000,"cuota_ini_20":17980000,"cuota_inicial_20":17980000,"cuotas_3_ini":5993333,"cuotas_48":1498333,"precio_preventa":81200000,"cuota_ini_pre_20":16240000,"cuotas_3_ini_pre":5413333,"cuotas_48_pre":1353333,"descripcion_lindero":"LOTE NÚMERO VEINTE (20): Por el frente, linda con el acceso vehicular al lote y Calle Numero 3 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 21 y mide 29.00 metros; por el fondo linda con Lote Numero 29 y mide 10.00 metros; por la izquierda linda con Lote Numero 19 y mide 29.00 metros. Área del lote: 290.00 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-21',
    21,
    'M 3',
    'available',
    89900000,
    290,
    '[775.4,1740.2]'::jsonb,
    '{"pathD":"M 754 1699.9 L 816.9 1760.2 L 796.1 1781.9 L 733.2 1721.6 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":89900000,"cuota_ini_20":17980000,"cuota_inicial_20":17980000,"cuotas_3_ini":5993333,"cuotas_48":1498333,"precio_preventa":81200000,"cuota_ini_pre_20":16240000,"cuotas_3_ini_pre":5413333,"cuotas_48_pre":1353333,"descripcion_lindero":"LOTE NÚMERO VEINTI UNO (21): Por el frente, linda con acceso vehicular al lote y Calle Numero 3 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 22, Lote Numero 23, Lote Numero 24 y mide 29.00 metros; por el fondo linda con Lote Numero 28 y mide 10.00 metros; por la izquierda, linda con Lote Numero 20 y mide 29.00 metros. Área del lote: 290.00 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-22',
    22,
    'M 3',
    'available',
    95706600,
    290.02,
    '[836.8,1717.7]'::jsonb,
    '{"pathD":"M 857.5 1675.2 L 872.2 1689.7 L 872.4 1702.4 L 816.9 1760.2 L 795.6 1739.8 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"VERDE","valor_m2":330000,"prem2":300000,"precio_venta":95706600,"cuota_ini_20":19141320,"cuota_inicial_20":19141320,"cuotas_3_ini":6380440,"cuotas_48":1595110,"precio_preventa":87006000,"cuota_ini_pre_20":17401200,"cuotas_3_ini_pre":5800400,"cuotas_48_pre":1450100,"descripcion_lindero":"LOTE NÚMERO VEINTI DOS (22): Por el frente, linda con acceso vehicular al lote y Carrera Numero 2 y mide 11.54 metros; por la derecha entrando, linda con Lote Numero 23 y mide 29.75 metros; por el fondo linda con Lote Numero 21 y mide 9.83 metros; por la izquierda linda con Calle Numero 3 y mide 26.66 metros. Área del lote: 290.02 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-23',
    23,
    'M 3',
    'available',
    96742800,
    293.16,
    '[816,1697]'::jsonb,
    '{"pathD":"M 836.4 1654.5 L 857.5 1675.2 L 795.6 1739.8 L 774.3 1719.3 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"VERDE","valor_m2":330000,"prem2":300000,"precio_venta":96742800,"cuota_ini_20":19348560,"cuota_inicial_20":19348560,"cuotas_3_ini":6449520,"cuotas_48":1612380,"precio_preventa":87948000,"cuota_ini_pre_20":17589600,"cuotas_3_ini_pre":5863200,"cuotas_48_pre":1465800,"descripcion_lindero":"LOTE NÚMERO VEINTI TRES (23): Por el frente, linda con acceso vehicular al lote y Carrera Numero 2 y mide 9.83 metros, por la derecha entrando, linda con Lote Numero 24 y mide 29.88 metros; por el fondo linda con Lote Numero 21 y mide 9.83 metros; por la izquierda linda con Lote Numero 22 y mide 29.75 metros. Área del lote: 293.16 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-24',
    24,
    'M 3',
    'available',
    97152000,
    294.4,
    '[794.6,1676.8]'::jsonb,
    '{"pathD":"M 815.3 1633.8 L 836.4 1654.5 L 774.3 1719.3 L 752.9 1698.9 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"VERDE","valor_m2":330000,"prem2":300000,"precio_venta":97152000,"cuota_ini_20":19430400,"cuota_inicial_20":19430400,"cuotas_3_ini":6476800,"cuotas_48":1619200,"precio_preventa":88320000,"cuota_ini_pre_20":17664000,"cuotas_3_ini_pre":5888000,"cuotas_48_pre":1472000,"descripcion_lindero":"LOTE NÚMERO VEINTI CUATRO (24): Por el frente, linda con acceso vehicular al lote y Carrera Numero 2 y mide 9.83 metros; por la derecha entrando, linda con lote Numero 25 y mide 30.00 metros; por el fondo, linda con Lote Numero 21 y mide 9.33 metros; por la izquierda, linda con Lote Numero 23 y mide 29.88 metros. Área del Lote: 294.40 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-25',
    25,
    'M 3',
    'available',
    97350000,
    295,
    '[773.8,1655.4]'::jsonb,
    '{"pathD":"M 794 1613.3 L 815.3 1633.8 L 752.9 1698.9 L 731.6 1678.4 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"VERDE","valor_m2":330000,"prem2":300000,"precio_venta":97350000,"cuota_ini_20":19470000,"cuota_inicial_20":19470000,"cuotas_3_ini":6490000,"cuotas_48":1622500,"precio_preventa":88500000,"cuota_ini_pre_20":17700000,"cuotas_3_ini_pre":5900000,"cuotas_48_pre":1475000,"descripcion_lindero":"LOTE NÚMERO VEINTI CINCO (25): Por el frente, linda con acceso vehicular al lote y Carrera Numero 2 y mide 9.83 metros; por la derecha entrando, linda con Lote Numero 26 y mide 30.00 metros; por el fondo, linda con Lote Numero 28 y mide 9.83 metros; por la izquierda, linda con Lote Numero 24 y mide 30.00 metros. Área del Lote: 295.00 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-26',
    26,
    'M 3',
    'available',
    97350000,
    295,
    '[752.1,1635.6]'::jsonb,
    '{"pathD":"M 772.7 1592.9 L 794 1613.3 L 731.6 1678.4 L 710.3 1657.9 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"VERDE","valor_m2":330000,"prem2":300000,"precio_venta":97350000,"cuota_ini_20":19470000,"cuota_inicial_20":19470000,"cuotas_3_ini":6490000,"cuotas_48":1622500,"precio_preventa":88500000,"cuota_ini_pre_20":17700000,"cuotas_3_ini_pre":5900000,"cuotas_48_pre":1475000,"descripcion_lindero":"LOTE NÚMERO VEINTI SEIS (26): Por el frente, linda con acceso vehicular al lote y Carrera Numero 2 y mide 9.83 metros; por la derecha entrando, linda con Lote Numero 27 y mide 30.00 metros; por el fondo, linda con Lote Numero 28 y mide 9.83 metros; por la izquierda, linda con Lote Numero 25 y mide 30.00 metros. Área del Lote: 295.00M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-27',
    27,
    'M 3',
    'available',
    96713100,
    293.07,
    '[730.5,1615.8]'::jsonb,
    '{"pathD":"M 710.3 1657.9 L 688.9 1637.5 L 745.1 1578.9 L 757.9 1578.7 L 772.7 1592.9 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"VERDE","valor_m2":330000,"prem2":300000,"precio_venta":96713100,"cuota_ini_20":19342620,"cuota_inicial_20":19342620,"cuotas_3_ini":6447540,"cuotas_48":1611885,"precio_preventa":87921000,"cuota_ini_pre_20":17584200,"cuotas_3_ini_pre":5861400,"cuotas_48_pre":1465350,"descripcion_lindero":"LOTE NÚMERO VEINTI SIETE (27): Por el frente, linda con acceso vehicular al lote y Carrera Numero 2 y mide 11.54 metros; por la derecha entrando, linda con Calle Numero 4 y mide 27.00 metros; por el fondo, linda con Lote Numero 28 y mide 9.83 metros; por la izquierda, linda con Lote Numero 26 y mide 30.00 metros. Área del Lote: 293.07 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-28',
    28,
    'M 3',
    'available',
    87000000,
    300,
    '[710.7,1680.2]'::jsonb,
    '{"pathD":"M 668.1 1659.2 L 688.9 1637.5 L 754 1699.9 L 733.2 1721.6 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":87000000,"cuota_ini_20":17400000,"cuota_inicial_20":17400000,"cuotas_3_ini":5800000,"cuotas_48":1450000,"precio_preventa":81000000,"cuota_ini_pre_20":16200000,"cuotas_3_ini_pre":5400000,"cuotas_48_pre":1350000,"descripcion_lindero":"LOTE NÚMERO VEINTI OCHO (28): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 29 y mide 30.00 metros; por el fondo, linda con Lote Numero 21 y mide 10.00 metros; por la izquierda linda con Lote Numero 25, Lote Numero 26, Lote Numero 27 y mide 30.00 metros. Área del Lote: 300.00 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-29',
    29,
    'M 3',
    'available',
    87000000,
    300,
    '[690.3,1701.2]'::jsonb,
    '{"pathD":"M 647.3 1680.9 L 668.1 1659.2 L 733.2 1721.6 L 712.4 1743.3 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":87000000,"cuota_ini_20":17400000,"cuota_inicial_20":17400000,"cuotas_3_ini":5800000,"cuotas_48":1450000,"precio_preventa":81000000,"cuota_ini_pre_20":16200000,"cuotas_3_ini_pre":5400000,"cuotas_48_pre":1350000,"descripcion_lindero":"LOTE NÚMERO VEINTI NUEVE (29): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 30 y mide 30.00 metros; por el fondo, linda con Lote Numero 20 y mide 10.00 metros; por la izquierda, linda con Lote Numero 28 y mide 30.00 metros. Área del lote: 300.00 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-30',
    30,
    'M 3',
    'available',
    92401700,
    298.07,
    '[670.1,1723.2]'::jsonb,
    '{"pathD":"M 712.4 1743.3 L 691.6 1765 L 633.1 1708.8 L 632.8 1696.1 L 647.3 1680.9 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":92401700,"cuota_ini_20":18480340,"cuota_inicial_20":18480340,"cuotas_3_ini":6160113,"cuotas_48":1540028,"precio_preventa":83459600,"cuota_ini_pre_20":16691920,"cuotas_3_ini_pre":5563973,"cuotas_48_pre":1390993,"descripcion_lindero":"LOTE NÚMERO TREINTA (30): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 11.71 metros; por la derecha entrando, linda con Carrera Numero 1 y mide 27.00 metros; por el fondo linda con Lote Numero 19 y mide 10.00 metros; por la izquierda linda con Lote Numero 29 y mide 30.00 metros. Área del Lote: 298.07 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-31',
    31,
    'M 4',
    'available',
    87004600,
    280.66,
    '[588.4,1646.8]'::jsonb,
    '{"pathD":"M 630.3 1664 L 615.5 1679.4 L 602.8 1679.7 L 548.7 1627.6 L 569.6 1605.8 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":87004600,"cuota_ini_20":17400920,"cuota_inicial_20":17400920,"cuotas_3_ini":5800307,"cuotas_48":1450077,"precio_preventa":78584800,"cuota_ini_pre_20":15716960,"cuotas_3_ini_pre":5238987,"cuotas_48_pre":1309747,"descripcion_lindero":"LOTE NÚMERO TREINTA Y UNO (31): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 11.84 metros; por la derecha entrando, linda con Lote Numero 32 y mide 28.00 metros; por el fondo, linda con Lote Numero 42 y mide 10.06 metros y por la izquierda, linda con Carrera Numero 1 y mide 24.99 metros. Área del Lote: 280.66 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-32',
    32,
    'M 4',
    'available',
    81200000,
    280,
    '[610.4,1624]'::jsonb,
    '{"pathD":"M 590.4 1584.1 L 651.1 1642.3 L 630.3 1664 L 569.6 1605.8 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":81200000,"cuota_ini_20":16240000,"cuota_inicial_20":16240000,"cuotas_3_ini":5413333,"cuotas_48":1353333,"precio_preventa":75600000,"cuota_ini_pre_20":15120000,"cuotas_3_ini_pre":5040000,"cuotas_48_pre":1260000,"descripcion_lindero":"LOTE NÚMERO TREINTA Y DOS (32): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 10.00 metros, por la derecha entrando, linda con Lote Numero 33 y mide 28.00 metros; por el fondo linda con Lote Numero 41 y mide 10.00 metros; por la izquierda, linda con Lote Numero 31 y mide 28 metros.  Área del Lote: 280.00 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-33',
    33,
    'M 4',
    'available',
    81200000,
    280,
    '[631.2,1602.4]'::jsonb,
    '{"pathD":"M 611.2 1562.4 L 671.9 1620.6 L 651.1 1642.3 L 590.4 1584.1 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":81200000,"cuota_ini_20":16240000,"cuota_inicial_20":16240000,"cuotas_3_ini":5413333,"cuotas_48":1353333,"precio_preventa":75600000,"cuota_ini_pre_20":15120000,"cuotas_3_ini_pre":5040000,"cuotas_48_pre":1260000,"descripcion_lindero":"LOTE NÚMERO TREINTA Y TRES (33): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 10.00 metros, por la derecha entrando, linda con Lote Numero 34 y mide 28.00 metros; por el fondo, linda con Lote Numero 40 y mide 10.00 metros; por la izquierda, linda con Lote Numero 32 y mide 28.00 metros. Área del Lote: 280.00 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-34',
    34,
    'M 4',
    'available',
    81200000,
    280,
    '[651.2,1582.1]'::jsonb,
    '{"pathD":"M 632 1540.7 L 692.7 1598.9 L 671.9 1620.6 L 611.2 1562.4 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":81200000,"cuota_ini_20":16240000,"cuota_inicial_20":16240000,"cuotas_3_ini":5413333,"cuotas_48":1353333,"precio_preventa":75600000,"cuota_ini_pre_20":15120000,"cuotas_3_ini_pre":5040000,"cuotas_48_pre":1260000,"descripcion_lindero":"LOTE NÚMERO TREINTA Y CUATRO (34): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 35 y mide 28.00 metros; por el fondo, linda con Lote Numero 39 y mide 10.00 metros; por la izquierda, linda con Lote Numero 33 y mide 28.00 metros. Área del Lote: 280.00 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-35',
    35,
    'M 4',
    'available',
    86800000,
    280,
    '[672.8,1559]'::jsonb,
    '{"pathD":"M 652.8 1519 L 713.5 1577.2 L 692.7 1598.9 L 632 1540.7 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":86800000,"cuota_ini_20":17360000,"cuota_inicial_20":17360000,"cuotas_3_ini":5786667,"cuotas_48":1446667,"precio_preventa":78400000,"cuota_ini_pre_20":15680000,"cuotas_3_ini_pre":5226667,"cuotas_48_pre":1306667,"descripcion_lindero":"LOTE NÚMERO TREINTA Y CINCO (35): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 36 y mide 28.00 metros; por el fondo, linda con Lote Numero 38 y mide 10.00 metros; por la izquierda, linda con Lote Numero 34 y mide 28.00 metros. Área del Lote: 280.00 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-36',
    36,
    'M 4',
    'available',
    91763100,
    278.07,
    '[692.6,1537.7]'::jsonb,
    '{"pathD":"M 727.8 1549.3 L 728.1 1562 L 713.5 1577.2 L 652.8 1519 L 673.6 1497.3 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"VERDE","valor_m2":330000,"prem2":300000,"precio_venta":91763100,"cuota_ini_20":18352620,"cuota_inicial_20":18352620,"cuotas_3_ini":6117540,"cuotas_48":1529385,"precio_preventa":83421000,"cuota_ini_pre_20":16684200,"cuotas_3_ini_pre":5561400,"cuotas_48_pre":1390350,"descripcion_lindero":"LOTE NÚMERO TREINTA Y SEIS (36): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 11.71 metros; por la derecha entrando, linda con Carrera Numero 2 y mide 25.00 metros; por el fondo linda con Lote Numero 37 y mide 10.00 metros; por la izquierda linda con Lote Numero 35 y mide 28.00 metros. Área del Lote: 278.07 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-37',
    37,
    'M 4',
    'available',
    89373000,
    288.3,
    '[632.6,1477.5]'::jsonb,
    '{"pathD":"M 604.4 1443.4 L 617.1 1443.2 L 673.6 1497.3 L 652.8 1519 L 589.8 1458.6 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":89373000,"cuota_ini_20":17874600,"cuota_inicial_20":17874600,"cuotas_3_ini":5958200,"cuotas_48":1489550,"precio_preventa":80724000,"cuota_ini_pre_20":16144800,"cuotas_3_ini_pre":5381600,"cuotas_48_pre":1345400,"descripcion_lindero":"LOTE NÚMERO TREINTA Y SIETE (37): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 11.71 metros; por la derecha entrando, linda con Lote Numero 38 y mide 29.02 metros; por el fondo linda con Lote Numero 36 y mide 10.00 metros; por la izquierda, linda con Carrera Numero 2 y mide 26.02 metros. Área del Lote: 288.30 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-38',
    38,
    'M 4',
    'available',
    84155100,
    290.19,
    '[610.8,1499.8]'::jsonb,
    '{"pathD":"M 569 1480.3 L 589.8 1458.6 L 652.8 1519 L 632 1540.7 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":84155100,"cuota_ini_20":16831020,"cuota_inicial_20":16831020,"cuotas_3_ini":5610340,"cuotas_48":1402585,"precio_preventa":78351300,"cuota_ini_pre_20":15670260,"cuotas_3_ini_pre":5223420,"cuotas_48_pre":1305855,"descripcion_lindero":"LOTE NÚMERO TREINTA Y OCHO (38): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 39 y mide 29.02 metros; por el fondo, linda con Lote Numero 35 y mide 10.00 metros; por la izquierda; linda con Lote Numero 37 y mide 29.02 metros. Área del Lote: 290.19 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-39',
    39,
    'M 4',
    'available',
    84143500,
    290.15,
    '[590.6,1520.5]'::jsonb,
    '{"pathD":"M 569 1480.3 L 632 1540.7 L 611.2 1562.4 L 548.3 1502 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":84143500,"cuota_ini_20":16828700,"cuota_inicial_20":16828700,"cuotas_3_ini":5609567,"cuotas_48":1402392,"precio_preventa":78340500,"cuota_ini_pre_20":15668100,"cuotas_3_ini_pre":5222700,"cuotas_48_pre":1305675,"descripcion_lindero":"LOTE NÚMERO TREINTA Y NUEVE (39): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 40 y mide 29.01 metros; por el fondo, linda con Lote Numero 34 y mide 10.00 metros; por la izquierda; linda con Lote Numero 30 y mide 29.02 metros. Área del Lote: 290.15 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-40',
    40,
    'M 4',
    'available',
    79780250,
    290.11,
    '[570,1541.8]'::jsonb,
    '{"pathD":"M 611.2 1562.4 L 590.4 1584.1 L 527.5 1523.7 L 548.3 1502 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":79780250,"cuota_ini_20":15956050,"cuota_inicial_20":15956050,"cuotas_3_ini":5318683,"cuotas_48":1329671,"precio_preventa":73978050,"cuota_ini_pre_20":14795610,"cuotas_3_ini_pre":4931870,"cuotas_48_pre":1232968,"descripcion_lindero":"LOTE NÚMERO CUARENTA (40): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 41 y mide 29.01 metros; por el fondo linda con Lote Numero 33 y mide 10.00 metros; por la izquierda; linda con Lote Numero 39 y mide 29.01 metros. Área del Lote: 290.11 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-41',
    41,
    'M 4',
    'available',
    79766500,
    290.06,
    '[548.6,1564.6]'::jsonb,
    '{"pathD":"M 569.6 1605.8 L 506.7 1545.4 L 527.5 1523.7 L 590.4 1584.1 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":79766500,"cuota_ini_20":15953300,"cuota_inicial_20":15953300,"cuotas_3_ini":5317767,"cuotas_48":1329442,"precio_preventa":73965300,"cuota_ini_pre_20":14793060,"cuotas_3_ini_pre":4931020,"cuotas_48_pre":1232755,"descripcion_lindero":"LOTE NÚMERO CUARENTA Y UNO (41): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 42 y mide 29.00 metros; por el fondo, linda con Lote Numero 32 y mide 10.00 metros; por la izquierda; linda con Lote Numero 40 y mide 29.01 metros. Área del Lote: 290.06 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-42',
    42,
    'M 4',
    'available',
    79538250,
    289.23,
    '[528.7,1586.1]'::jsonb,
    '{"pathD":"M 569.6 1605.8 L 548.7 1627.6 L 492.3 1573.4 L 492.1 1560.7 L 506.7 1545.4 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":79538250,"cuota_ini_20":15907650,"cuota_inicial_20":15907650,"cuotas_3_ini":5302550,"cuotas_48":1325638,"precio_preventa":73753650,"cuota_ini_pre_20":14750730,"cuotas_3_ini_pre":4916910,"cuotas_48_pre":1229228,"descripcion_lindero":"LOTE NÚMERO CUARENTA Y DOS (42): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 11.71 metros; por la derecha entrando, linda con Carrera Numero 1 y mide 26.01 metros; por el fondo, linda con Lote Numero 31 y mide 10.06 metros; por la izquierda; linda con Lote Numero 41 y mide 29.00 metros. Área del Lote: 289.23 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-43',
    43,
    'M 5',
    'available',
    129802750,
    472.01,
    '[427.9,1494.1]'::jsonb,
    '{"pathD":"M 489.2 1532.9 L 468.4 1554.6 L 367.6 1458 L 385.2 1433.2 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":129802750,"cuota_ini_20":25960550,"cuota_inicial_20":25960550,"cuotas_3_ini":8653517,"cuotas_48":2163379,"precio_preventa":120362550,"cuota_ini_pre_20":24072510,"cuotas_3_ini_pre":8024170,"cuotas_48_pre":2006043,"descripcion_lindero":"LOTE NÚMERO CUARENTA Y TRES (43): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 44 y mide 47.93 metros; por el fondo, linda con Area verde y mide 10.11 metros; por la izquierda; linda con Area verde y mide 46.47 metros. Área del Lote: 472.01 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-44',
    44,
    'M 5',
    'available',
    133834250,
    486.67,
    '[446.5,1472.1]'::jsonb,
    '{"pathD":"M 510 1511.2 L 510 1511.2 L 489.2 1532.9 L 385.2 1433.2 L 402.8 1408.5 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":133834250,"cuota_ini_20":26766850,"cuota_inicial_20":26766850,"cuotas_3_ini":8922283,"cuotas_48":2230571,"precio_preventa":124100850,"cuota_ini_pre_20":24820170,"cuotas_3_ini_pre":8273390,"cuotas_48_pre":2068348,"descripcion_lindero":"LOTE NÚMERO CUARENTA Y CUATRO (44): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 45 y mide 49.39 metros; por el fondo, linda con Area verde y mide 10.11 metros; por la izquierda; linda con Lote Numero 43 y mide 47.93 metros. Área del Lote: 486.67 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-45',
    45,
    'M 5',
    'available',
    206575700,
    712.33,
    '[475.8,1447.2]'::jsonb,
    '{"pathD":"M 548.2 1471.4 L 510 1511.2 L 402.8 1408.5 L 425.6 1376.4 L 491.4 1446.1 L 518.3 1442.7 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":206575700,"cuota_ini_20":41315140,"cuota_inicial_20":41315140,"cuotas_3_ini":13771713,"cuotas_48":3442928,"precio_preventa":192329100,"cuota_ini_pre_20":38465820,"cuotas_3_ini_pre":12821940,"cuotas_48_pre":3205485,"descripcion_lindero":"LOTE NÚMERO CUARENTA Y CINCO (45): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 18.37 metros; por la derecha entrando, linda con Área verde y Lote 45A y mide 54.67 metros (línea quebrada); por el fondo, linda con Area verde y mide 13.09 metros; por la izquierda; linda con Lote Numero 44 y mide 49.39 metros. Área del Lote: 712.33 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-45-A',
    45,
    'M 5',
    'available',
    80066100,
    276.09,
    '[559.2,1435.4]'::jsonb,
    '{"pathD":"M 548.2 1471.4 L 518.3 1442.7 L 580.3 1400.2 L 599.8 1417.5 Z"}'::jsonb,
    '{"ubicacion":"CALLEJON","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":80066100,"cuota_ini_20":16013220,"cuota_inicial_20":16013220,"cuotas_3_ini":5337740,"cuotas_48":1334435,"precio_preventa":74544300,"cuota_ini_pre_20":14908860,"cuotas_3_ini_pre":4969620,"cuotas_48_pre":1242405,"descripcion_lindero":"LOTE NÚMERO CUARENTA Y CINCO A (45A): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 24.81 metros; por la derecha entrando, linda con Área verde y mide 8.66 metros; por el fondo, linda con Área verde y mide 25.02 metros; por la izquierda; linda con Lote Numero 45 y mide 13.78 metros. Área del Lote: 276.09 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-46',
    46,
    'M 6',
    'available',
    87791700,
    302.73,
    '[622.4,1367.3]'::jsonb,
    '{"pathD":"M 612.9 1355.1 L 619.2 1316.5 L 659.5 1355.1 L 606 1411 L 586.7 1393.8 L 598.3 1382.1 Z"}'::jsonb,
    '{"ubicacion":"CALLEJON","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":87791700,"cuota_ini_20":17558340,"cuota_inicial_20":17558340,"cuotas_3_ini":5852780,"cuotas_48":1463195,"precio_preventa":81737100,"cuota_ini_pre_20":16347420,"cuotas_3_ini_pre":5449140,"cuotas_48_pre":1362285,"descripcion_lindero":"LOTE NÚMERO CUARENTA Y SEIS (46): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 25.74 metros; por la derecha entrando, linda con Lote Numero 47, y mide 18.58 metros; por el fondo, linda con Area verde y mide 28.71 metros (línea quebrada); por la izquierda; linda con Area verde y mide 8.61 metros. Área del Lote: 302.73 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-47',
    47,
    'M 6',
    'available',
    87023200,
    300.08,
    '[650.1,1316]'::jsonb,
    '{"pathD":"M 687.5 1325.9 L 659.5 1355.1 L 619.2 1316.5 L 622.2 1299.8 L 632.9 1273.5 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":87023200,"cuota_ini_20":17404640,"cuota_inicial_20":17404640,"cuotas_3_ini":5801547,"cuotas_48":1450387,"precio_preventa":81021600,"cuota_ini_pre_20":16204320,"cuotas_3_ini_pre":5401440,"cuotas_48_pre":1350360,"descripcion_lindero":"LOTE NÚMERO CUARENTA Y SIETE (47): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 13.46 metros; por la derecha entrando, linda con Lote Numero 48 y mide 25.16 metros; por el fondo, linda con Area verde y mide 15.07 metros (línea quebrada); por la izquierda; linda con Lote Numero 46 y mide 18.58 metros. Área del Lote: 300.08 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-48',
    48,
    'M 6',
    'available',
    86715800,
    299.02,
    '[669,1286]'::jsonb,
    '{"pathD":"M 710.2 1302.2 L 687.5 1325.9 L 632.9 1273.5 L 646.1 1240.7 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":86715800,"cuota_ini_20":17343160,"cuota_inicial_20":17343160,"cuotas_3_ini":5781053,"cuotas_48":1445263,"precio_preventa":80735400,"cuota_ini_pre_20":16147080,"cuotas_3_ini_pre":5382360,"cuotas_48_pre":1345590,"descripcion_lindero":"LOTE NÚMERO CUARENTA Y OCHO (48): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.93 metros; por la derecha entrando, linda con Lote Numero 49 y mide 29.55 metros; por el fondo, linda con Area verde y mide 11.78 metros; por la izquierda; linda con Lote Numero 47 y mide 25.16 metros. Área del Lote: 299.02 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-49',
    49,
    'M 6',
    'available',
    91294900,
    314.81,
    '[687.2,1257.1]'::jsonb,
    '{"pathD":"M 731 1280.5 L 710.2 1302.2 L 646.1 1240.7 L 656.2 1215.7 L 659.9 1212.3 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":91294900,"cuota_ini_20":18258980,"cuota_inicial_20":18258980,"cuotas_3_ini":6086327,"cuotas_48":1521582,"precio_preventa":84998700,"cuota_ini_pre_20":16999740,"cuotas_3_ini_pre":5666580,"cuotas_48_pre":1416645,"descripcion_lindero":"LOTE NÚMERO CUARENTA Y NUEVE (49): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 50 y mide 32.78 metros; por el fondo, linda con Area verde y mide 10.64 metros; por la izquierda; linda con Lote Numero 48 y mide 29.55 metros. Área del Lote: 314.81 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-50',
    50,
    'M 6',
    'available',
    125822800,
    405.88,
    '[713.6,1236.5]'::jsonb,
    '{"pathD":"M 765.7 1244.3 L 731 1280.5 L 659.9 1212.3 L 676.9 1196.4 L 685.5 1201.9 L 712.4 1213 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":125822800,"cuota_ini_20":25164560,"cuota_inicial_20":25164560,"cuotas_3_ini":8388187,"cuotas_48":2097047,"precio_preventa":113646400,"cuota_ini_pre_20":22729280,"cuotas_3_ini_pre":7576427,"cuotas_48_pre":1894107,"descripcion_lindero":"LOTE NÚMERO CINCUENTA (50): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 16.68 metros; por la derecha entrando, linda con Area verde y mide 33.62 metros (línea quebrada); por el fondo, linda con Area verde y mide 7.74 metros; por la izquierda; linda con Lote Numero 49 y mide 32.78 metros. Área del Lote: 405.88 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-51',
    51,
    'M 7',
    'available',
    140461000,
    453.1,
    '[801.4,1300.4]'::jsonb,
    '{"pathD":"M 793.9 1258.6 L 812.8 1277.5 L 848.1 1315.1 L 817 1347.5 L 753.9 1287 L 781 1258.7 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":140461000,"cuota_ini_20":28092200,"cuota_inicial_20":28092200,"cuotas_3_ini":9364067,"cuotas_48":2341017,"precio_preventa":126868000,"cuota_ini_pre_20":25373600,"cuotas_3_ini_pre":8457867,"cuotas_48_pre":2114467,"descripcion_lindero":"LOTE NÚMERO CINCUENTA Y UNO (51): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 17.81 metros; por la derecha entrando, linda con Lote Numero 52 y mide 29.09 metros; por el fondo, linda con Lote Numero 63 y mide14.96 metros; por la izquierda; linda con Transversal Numero 1 y mide 26.05 metros (línea quebrada). Área del Lote: 453.10 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-52',
    52,
    'M 7',
    'available',
    84343600,
    290.84,
    '[775.2,1327.7]'::jsonb,
    '{"pathD":"M 753.9 1287 L 817 1347.5 L 796.2 1369.2 L 733.1 1308.7 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":84343600,"cuota_ini_20":16868720,"cuota_inicial_20":16868720,"cuotas_3_ini":5622907,"cuotas_48":1405727,"precio_preventa":78526800,"cuota_ini_pre_20":15705360,"cuotas_3_ini_pre":5235120,"cuotas_48_pre":1308780,"descripcion_lindero":"LOTE NÚMERO CINCUENTA Y DOS (52): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 53 y mide 29.08 metros; por el fondo, linda con Lote Numero 62, Lote Numero 63 y mide 10.00 metros; por la izquierda; linda con Lote Numero 51 y mide 29.09 metros. Área del Lote: 290.84 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-53',
    53,
    'M 7',
    'available',
    84332000,
    290.8,
    '[753.9,1350.5]'::jsonb,
    '{"pathD":"M 712.3 1330.4 L 733.1 1308.7 L 796.2 1369.2 L 775.4 1390.9 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":84332000,"cuota_ini_20":16866400,"cuota_inicial_20":16866400,"cuotas_3_ini":5622133,"cuotas_48":1405533,"precio_preventa":78516000,"cuota_ini_pre_20":15703200,"cuotas_3_ini_pre":5234400,"cuotas_48_pre":1308600,"descripcion_lindero":"LOTE NÚMERO CINCUENTA Y TRES (53): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 54 y mide 29.08 metros; por el fondo, linda con Lote Numero 62 y mide10.00 metros; por la izquierda; linda con Lote Numero 53 y mide 29.08 metros. Área del Lote: 290.80 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-54',
    54,
    'M 7',
    'available',
    84317500,
    290.75,
    '[734,1370.5]'::jsonb,
    '{"pathD":"M 691.5 1352.1 L 712.3 1330.4 L 775.4 1390.9 L 754.6 1412.6 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":84317500,"cuota_ini_20":16863500,"cuota_inicial_20":16863500,"cuotas_3_ini":5621167,"cuotas_48":1405292,"precio_preventa":78502500,"cuota_ini_pre_20":15700500,"cuotas_3_ini_pre":5233500,"cuotas_48_pre":1308375,"descripcion_lindero":"LOTE NÚMERO CINCUENTA Y CUATRO (54): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 55 y mide 29.07 metros; por el fondo, linda con Lote Numero 61 y mide10.00 metros; por la izquierda; linda con Lote Numero 53 y mide 29.08 metros. Área del Lote: 290.75 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-55',
    55,
    'M 7',
    'available',
    84305900,
    290.71,
    '[712.6,1393.2]'::jsonb,
    '{"pathD":"M 670.7 1373.8 L 691.5 1352.1 L 754.6 1412.6 L 733.8 1434.3 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":84305900,"cuota_ini_20":16861180,"cuota_inicial_20":16861180,"cuotas_3_ini":5620393,"cuotas_48":1405098,"precio_preventa":78491700,"cuota_ini_pre_20":15698340,"cuotas_3_ini_pre":5232780,"cuotas_48_pre":1308195,"descripcion_lindero":"LOTE NÚMERO CINCUENTA Y CINCO (55): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 56 y mide 29.07 metros; por el fondo, linda con Lote Numero 60 y mide10.00 metros; por la izquierda; linda con Lote Numero 54 y mide 29.07 metros. Área del Lote: 290.71 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-56',
    56,
    'M 7',
    'available',
    84294300,
    290.67,
    '[692,1414.6]'::jsonb,
    '{"pathD":"M 670.7 1373.8 L 733.8 1434.3 L 713 1456 L 649.9 1395.6 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":84294300,"cuota_ini_20":16858860,"cuota_inicial_20":16858860,"cuotas_3_ini":5619620,"cuotas_48":1404905,"precio_preventa":78480900,"cuota_ini_pre_20":15696180,"cuotas_3_ini_pre":5232060,"cuotas_48_pre":1308015,"descripcion_lindero":"LOTE NÚMERO CINCUENTA Y SEIS (56): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 57 y mide 29.06 metros; por el fondo, linda con Lote Numero 59 y mide 10.00 metros; por la izquierda; linda con Lote Numero 55 y mide 29.07 metros. Área del Lote: 290.67 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-57',
    57,
    'M 7',
    'available',
    89493900,
    288.69,
    '[671.2,1437.8]'::jsonb,
    '{"pathD":"M 713 1456 L 692.2 1477.7 L 635.6 1423.5 L 635.4 1410.7 L 649.9 1395.6 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":89493900,"cuota_ini_20":17898780,"cuota_inicial_20":17898780,"cuotas_3_ini":5966260,"cuotas_48":1491565,"precio_preventa":80833200,"cuota_ini_pre_20":16166640,"cuotas_3_ini_pre":5388880,"cuotas_48_pre":1347220,"descripcion_lindero":"LOTE NÚMERO CINCUENTA Y SIETE (57): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 11.71 metros; por la derecha entrando, linda con Carrera Numero 2 y mide 26.06 metros; por el fondo, linda con Lote Numero 58 y mide 10.00 metros; por la izquierda; linda con Lote Numero 56 y mide 29.06 metros. Área del Lote: 288.69 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-58',
    58,
    'M 7',
    'available',
    120661200,
    365.64,
    '[741.9,1503.8]'::jsonb,
    '{"pathD":"M 784.7 1544 L 766.1 1548.6 L 692.2 1477.7 L 713 1456 L 788.9 1528.8 L 787.4 1532.2 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"VERDE","valor_m2":330000,"prem2":300000,"precio_venta":120661200,"cuota_ini_20":24132240,"cuota_inicial_20":24132240,"cuotas_3_ini":8044080,"cuotas_48":2011020,"precio_preventa":109692000,"cuota_ini_pre_20":21938400,"cuotas_3_ini_pre":7312800,"cuotas_48_pre":1828200,"descripcion_lindero":"LOTE NÚMERO CINCUENTA Y OCHO (58): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 12.42 metros; por la derecha entrando, linda con Lote Numero 59 y mide 35.00 metros; por el fondo, linda con Lote Numero 57 y mide 10.00 metros; por la izquierda; linda con Carrera Numero 2 y mide 34.07 metros. Área del Lote: 365.64 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-59',
    59,
    'M 7',
    'available',
    109355400,
    331.38,
    '[759.5,1479.2]'::jsonb,
    '{"pathD":"M 788.9 1528.8 L 713 1456 L 733.8 1434.3 L 801.6 1499.4 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"VERDE","valor_m2":330000,"prem2":300000,"precio_venta":109355400,"cuota_ini_20":21871080,"cuota_inicial_20":21871080,"cuotas_3_ini":7290360,"cuotas_48":1822590,"precio_preventa":99414000,"cuota_ini_pre_20":19882800,"cuotas_3_ini_pre":6627600,"cuotas_48_pre":1656900,"descripcion_lindero":"LOTE NÚMERO CINCUENTA Y NUEVE (59): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 10.67 metros; por la derecha entrando, linda con Lote Numero 60 y mide 31.28 metros; por el fondo, linda con Lote Numero 56 y mide 10.00 metros; por la izquierda; linda con Lote Numero 58 y mide 35.00 metros. Área del Lote: 331.38 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-60',
    60,
    'M 7',
    'available',
    99339900,
    301.03,
    '[777,1454.3]'::jsonb,
    '{"pathD":"M 819.4 1474.8 L 806.8 1487.3 L 801.6 1499.4 L 733.8 1434.3 L 754.6 1412.6 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"VERDE","valor_m2":330000,"prem2":300000,"precio_venta":99339900,"cuota_ini_20":19867980,"cuota_inicial_20":19867980,"cuotas_3_ini":6622660,"cuotas_48":1655665,"precio_preventa":90309000,"cuota_ini_pre_20":18061800,"cuotas_3_ini_pre":6020600,"cuotas_48_pre":1505150,"descripcion_lindero":"LOTE NÚMERO SESENTA (60): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 10.28 metros; por la derecha entrando, linda con Lote Numero 61 y mide 29.90 metros; por el fondo, linda con Lote Numero 55 y mide 10.00 metros; por la izquierda; linda con Lote Numero 59 y mide 31.28 metros. Área del Lote: 301.03 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-61',
    61,
    'M 7',
    'available',
    99221100,
    300.67,
    '[797.8,1432.5]'::jsonb,
    '{"pathD":"M 775.4 1390.9 L 841.4 1454.2 L 834.5 1459.9 L 819.4 1474.8 L 754.6 1412.6 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"VERDE","valor_m2":330000,"prem2":300000,"precio_venta":99221100,"cuota_ini_20":19844220,"cuota_inicial_20":19844220,"cuotas_3_ini":6614740,"cuotas_48":1653685,"precio_preventa":90201000,"cuota_ini_pre_20":18040200,"cuotas_3_ini_pre":6013400,"cuotas_48_pre":1503350,"descripcion_lindero":"LOTE NÚMERO SESENTA Y UNO (61): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 62 y mide 30.90 metros; por el fondo, linda con Lote Numero 54 y mide 13.00 metros; por la izquierda; linda con Lote Numero 60 y mide 30.44 metros. Área del Lote: 300.67 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-62',
    62,
    'M 7',
    'available',
    133485000,
    404.5,
    '[822.6,1409.3]'::jsonb,
    '{"pathD":"M 869.4 1427 L 864.7 1435.3 L 841.4 1454.2 L 775.4 1390.9 L 802.4 1362.7 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"VERDE","valor_m2":330000,"prem2":300000,"precio_venta":133485000,"cuota_ini_20":26697000,"cuota_inicial_20":26697000,"cuotas_3_ini":8899000,"cuotas_48":2224750,"precio_preventa":121350000,"cuota_ini_pre_20":24270000,"cuotas_3_ini_pre":8090000,"cuotas_48_pre":2022500,"descripcion_lindero":"LOTE NÚMERO SESENTA Y DOS (62): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 13.18 metros; por la derecha entrando, linda con Lote Numero 63 y mide 28.00 metros; por el fondo, linda con Lote Numero 52, Lote Numero 53 y mide 13.00 metros; por la izquierda; linda con Lote Numero 61 y mide 30.44 metros. Área del Lote: 404.50 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-63',
    63,
    'M 7',
    'available',
    141401700,
    428.49,
    '[844.6,1367.8]'::jsonb,
    '{"pathD":"M 848.1 1315.1 L 802.4 1362.7 L 869.4 1427 L 871.1 1391.3 L 864.5 1345.3 L 848.1 1315.1 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"VERDE","valor_m2":330000,"prem2":300000,"precio_venta":141401700,"cuota_ini_20":28280340,"cuota_inicial_20":28280340,"cuotas_3_ini":9426780,"cuotas_48":2356695,"precio_preventa":128547000,"cuota_ini_pre_20":25709400,"cuotas_3_ini_pre":8569800,"cuotas_48_pre":2142450,"descripcion_lindero":"LOTE NÚMERO SESENTA Y TRES (63): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 38.91 metros (línea quebrada); por el fondo, linda con Lote Numero 51, Lote Numero 52 y mide 21.56 metros; por la izquierda; linda con Lote Numero 62 y mide 30.90 metros. Área del Lote: 428.49 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-64',
    64,
    'M 8',
    'sold',
    176092000,
    503.12,
    '[918.6,1410]'::jsonb,
    '{"pathD":"M 909.4 1338 L 894.8 1366 L 897.8 1386.9 L 894.4 1437.8 L 884.9 1453.8 L 890.2 1461.4 L 892.2 1460.6 L 928 1446.9 L 962.8 1446.4 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"ROJO","valor_m2":350000,"prem2":325000,"precio_venta":176092000,"cuota_ini_20":35218400,"cuota_inicial_20":35218400,"cuotas_3_ini":11739467,"cuotas_48":2934867,"precio_preventa":163514000,"cuota_ini_pre_20":32702800,"cuotas_3_ini_pre":10900933,"cuotas_48_pre":2725233,"descripcion_lindero":"LOTE NÚMERO SESENTA Y CUATRO (64): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 44.65 metros (línea quebrada); por el fondo, linda con Area verde y mide 25.07 metros (línea quebrada); por la izquierda; linda con Lote Numero 65 y mide 40.22 metros. Área del Lote: 503.12 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-65',
    65,
    'M 8',
    'sold',
    218288000,
    623.68,
    '[959.2,1387.5]'::jsonb,
    '{"pathD":"M 909.4 1338 L 921.6 1334.4 L 953.4 1325.2 L 1007.7 1435.4 L 1010.1 1440.4 L 967.7 1446.3 L 962.8 1446.4 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROJO","valor_m2":350000,"prem2":325000,"precio_venta":218288000,"cuota_ini_20":43657600,"cuota_inicial_20":43657600,"cuotas_3_ini":14552533,"cuotas_48":3638133,"precio_preventa":202696000,"cuota_ini_pre_20":40539200,"cuotas_3_ini_pre":13513067,"cuotas_48_pre":3378267,"descripcion_lindero":"LOTE NÚMERO SESENTA Y CINCO (65): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 15.23 metros (línea quebrada); por la derecha entrando, linda con Lote Numero 64, y mide 40.22 metros; por el fondo, linda con Area verde y mide 15.91 metros (línea quebrada); por la izquierda; linda con Lote Numero 66 y mide 40.89 metros. Área del Lote: 623.68 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-66',
    66,
    'M 8',
    'available',
    224427000,
    641.22,
    '[1003.9,1375.9]'::jsonb,
    '{"pathD":"M 991.5 1314.2 L 996.8 1311.4 L 1053 1425.3 L 1041.9 1429.6 L 1025.9 1438.2 L 1010.1 1440.4 L 953.4 1325.2 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROJO","valor_m2":350000,"prem2":325000,"precio_venta":224427000,"cuota_ini_20":44885400,"cuota_inicial_20":44885400,"cuotas_3_ini":14961800,"cuotas_48":3740450,"precio_preventa":208396500,"cuota_ini_pre_20":41679300,"cuotas_3_ini_pre":13893100,"cuotas_48_pre":3473275,"descripcion_lindero":"LOTE NÚMERO SESENTA Y SEIS (66): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 15.20 metros (línea quebrada); por la derecha entrando, linda con Lote Numero 65, y mide 42.73 metros; por el fondo, linda con Area verde y mide 15.28 metros (línea quebrada); por la izquierda; linda con Lote Numero 67 y mide 42.28 metros. Área del Lote: 641.22 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-67',
    67,
    'M 8',
    'available',
    241108000,
    688.88,
    '[1048.2,1362.6]'::jsonb,
    '{"pathD":"M 1053 1425.3 L 996.8 1311.4 L 1036.6 1290.2 L 1070.9 1359.8 L 1106.5 1431.9 L 1068 1419.6 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROJO","valor_m2":350000,"prem2":325000,"precio_venta":241108000,"cuota_ini_20":48221600,"cuota_inicial_20":48221600,"cuotas_3_ini":16073867,"cuotas_48":4018467,"precio_preventa":223886000,"cuota_ini_pre_20":44777200,"cuotas_3_ini_pre":14925733,"cuotas_48_pre":3731433,"descripcion_lindero":"LOTE NÚMERO SESENTA Y SIETE (67): Por el frente, linda con acceso vehicular al lote y Calle Numero 2 y mide 15.01 metros; por la derecha entrando, linda con Lote Numero 66 y mide 42.28 metros; por el fondo, linda con Area verde y mide 18.39 metros (línea quebrada); por la izquierda; linda con Lote Numero 68, Lote Numero 77 y mide 52.58 metros. Área del Lote: 688.88 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-68',
    68,
    'M 8',
    'available',
    177243500,
    506.41,
    '[1114.8,1395.4]'::jsonb,
    '{"pathD":"M 1070.9 1359.8 L 1111.4 1339.9 L 1157.6 1432.5 L 1151.6 1449 L 1121 1436.6 L 1106.5 1431.9 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROJO","valor_m2":350000,"prem2":325000,"precio_venta":177243500,"cuota_ini_20":35448700,"cuota_inicial_20":35448700,"cuotas_3_ini":11816233,"cuotas_48":2954058,"precio_preventa":164583250,"cuota_ini_pre_20":32916650,"cuotas_3_ini_pre":10972217,"cuotas_48_pre":2743054,"descripcion_lindero":"LOTE NÚMERO SESENTA Y OCHO (68): Por el frente, linda con acceso vehicular al lote y Calle Numero 3 más Area verde y mide 21.91 metros (línea quebrada); por la derecha entrando, linda con Lote Numero 69 y mide 34.44 metros; por el fondo, linda con Lote Numero 77 y mide 15.00 metros; por la izquierda; linda con Lote Numero 67 y mide 26.75 metros. Área del Lote: 506.41 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-69',
    69,
    'M 8',
    'available',
    216678000,
    619.08,
    '[1160.5,1385.7]'::jsonb,
    '{"pathD":"M 1157.6 1432.5 L 1111.4 1339.9 L 1151.8 1320 L 1167.7 1352.3 L 1183.7 1384.7 L 1214 1446.1 L 1204 1447.2 L 1184.5 1442.3 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROJO","valor_m2":350000,"prem2":325000,"precio_venta":216678000,"cuota_ini_20":43335600,"cuota_inicial_20":43335600,"cuotas_3_ini":14445200,"cuotas_48":3611300,"precio_preventa":201201000,"cuota_ini_pre_20":40240200,"cuotas_3_ini_pre":13413400,"cuotas_48_pre":3353350,"descripcion_lindero":"LOTE NÚMERO SESENTA Y NUEVE (69): Por el frente, linda con acceso vehicular al lote y Calle Numero 3 y mide 19.75 metros (línea quebrada); por la derecha entrando, linda con Lote Numero 70, Lote Numero 73 y mide 46.80 metros; por el fondo, linda con Lote Numero 76 y mide 15.00 metros; por la izquierda; linda con Lote Numero 68 y mide 34.44 metros. Área del Lote: 619.08 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-70',
    70,
    'M 8',
    'sold',
    153415500,
    438.33,
    '[1208.4,1393.5]'::jsonb,
    '{"pathD":"M 1167.7 1352.3 L 1200.1 1336.4 L 1250.3 1438.4 L 1226.3 1444.7 L 1214 1446.1 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROJO","valor_m2":350000,"prem2":325000,"precio_venta":153415500,"cuota_ini_20":30683100,"cuota_inicial_20":30683100,"cuotas_3_ini":10227700,"cuotas_48":2556925,"precio_preventa":142457250,"cuota_ini_pre_20":28491450,"cuotas_3_ini_pre":9497150,"cuotas_48_pre":2374288,"descripcion_lindero":"LOTE NÚMERO SETENTA (70): Por el frente, linda con acceso vehicular al lote y Calle Numero 3 y mide 12.41 metros (línea quebrada); por la derecha entrando, linda con Lote Numero 71 y mide 37.83 metros; por el fondo, linda con Lote Numero 73 y mide 12.00 metros; por la izquierda; linda con Lote Numero 69 y mide 34.80 metros. Área del Lote: 438.33 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-71',
    71,
    'M 8',
    'sold',
    158564000,
    453.04,
    '[1241.2,1379.3]'::jsonb,
    '{"pathD":"M 1232.4 1320.4 L 1200.1 1336.4 L 1250.3 1438.4 L 1255.1 1437.1 L 1268.9 1429.6 L 1281.3 1419.6 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROJO","valor_m2":350000,"prem2":325000,"precio_venta":158564000,"cuota_ini_20":31712800,"cuota_inicial_20":31712800,"cuotas_3_ini":10570933,"cuotas_48":2642733,"precio_preventa":147238000,"cuota_ini_pre_20":29447600,"cuotas_3_ini_pre":9815867,"cuotas_48_pre":2453967,"descripcion_lindero":"LOTE NÚMERO SETENTA Y UNO (71): Por el frente, linda con acceso vehicular al lote y Calle Numero 3 y mide 12.17 metros (línea quebrada); por la derecha entrando, linda con Lote Numero 72 y mide 36.78 metros; por el fondo, linda con Lote Numero 73 y mide 12.00 metros; por la izquierda; linda con Lote Numero 70 y mide 37.83 metros. Área del Lote: 453.04 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-72',
    72,
    'M 8',
    'sold',
    125758500,
    359.31,
    '[1271.2,1363]'::jsonb,
    '{"pathD":"M 1232.4 1320.4 L 1254.6 1309.5 L 1303 1384.8 L 1304.4 1400.8 L 1281.3 1419.6 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"ROJO","valor_m2":350000,"prem2":325000,"precio_venta":125758500,"cuota_ini_20":25151700,"cuota_inicial_20":25151700,"cuotas_3_ini":8383900,"cuotas_48":2095975,"precio_preventa":116775750,"cuota_ini_pre_20":23355150,"cuotas_3_ini_pre":7785050,"cuotas_48_pre":1946263,"descripcion_lindero":"LOTE NÚMERO SETENTA Y DOS (72): Por el frente, linda con acceso vehicular al lote y Calle Numero 3 y mide 15.5 metros (línea quebrada); por la derecha entrando, linda con Carrera Numero 3 y mide 29.79 metros; por el fondo, linda con Lote Numero 73 y mide 8.24 metros; por la izquierda; linda con Lote Numero 71 y mide 36.78 metros. Área del Lote: 359.31 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-73',
    73,
    'M 8',
    'available',
    117415600,
    378.76,
    '[1202.6,1314.8]'::jsonb,
    '{"pathD":"M 1235.1 1278.9 L 1254.6 1309.5 L 1167.7 1352.3 L 1151.8 1320 L 1192.2 1300 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":117415600,"cuota_ini_20":23483120,"cuota_inicial_20":23483120,"cuotas_3_ini":7827707,"cuotas_48":1956927,"precio_preventa":106052800,"cuota_ini_pre_20":21210560,"cuotas_3_ini_pre":7070187,"cuotas_48_pre":1767547,"descripcion_lindero":"LOTE NÚMERO SETENTA Y TRES (73): Por el frente, linda con acceso vehicular al lote y Carrera Numero 3 y mide 12.08 metros; por la derecha entrando, linda con Lote Numero 74, Lote Numero 75 y mide 30.89 metros; por el fondo, linda con Lote Numero 69 y mide 12.00 metros; por la izquierda; linda con Lote Numero 70, Lote Numero 71, Lote Numero 72 y mide 32.24 metros. Área del Lote: 378.76 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-74',
    74,
    'M 8',
    'available',
    165372600,
    533.46,
    '[1186.5,1242.4]'::jsonb,
    '{"pathD":"M 1192.2 1300 L 1143 1200 L 1154.6 1184 L 1177.5 1189.1 L 1235.1 1278.9 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":165372600,"cuota_ini_20":33074520,"cuota_inicial_20":33074520,"cuotas_3_ini":11024840,"cuotas_48":2756210,"precio_preventa":149368800,"cuota_ini_pre_20":29873760,"cuotas_3_ini_pre":9957920,"cuotas_48_pre":2489480,"descripcion_lindero":"LOTE NÚMERO SETENTA Y CUATRO (74): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 15.26 metros (línea quebrada); por la derecha entrando, linda con Lote Numero 75 y mide 37.09 metros; por el fondo, linda con Lote Numero 73 y mide 15.89 metros; por la izquierda; linda con Carrera Numero 3 y mide 35.49 metros. Área del Lote: 533.46 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-75',
    75,
    'M 8',
    'available',
    157573000,
    508.3,
    '[1150.2,1263.5]'::jsonb,
    '{"pathD":"M 1151.8 1320 L 1110.8 1236.7 L 1111.8 1235.8 L 1140.4 1203.5 L 1143 1200 L 1192.2 1300 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":157573000,"cuota_ini_20":31514600,"cuota_inicial_20":31514600,"cuotas_3_ini":10504867,"cuotas_48":2626217,"precio_preventa":142324000,"cuota_ini_pre_20":28464800,"cuotas_3_ini_pre":9488267,"cuotas_48_pre":2372067,"descripcion_lindero":"LOTE NÚMERO SETENTA Y CINCO (75): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 17.39 metros (línea quebrada); por la derecha entrando, linda con Lote Numero 76 y mide 30.89 metros; por el fondo, linda con Lote Numero 73 y mide 15.00 metros; por la izquierda; linda con Lote Numero 74 y mide 37.09 metros. Área del Lote: 508.30 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-76',
    76,
    'M 8',
    'available',
    134574100,
    434.11,
    '[1112.6,1290.9]'::jsonb,
    '{"pathD":"M 1111.4 1339.9 L 1075.5 1267.1 L 1110.8 1236.7 L 1151.8 1320 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":134574100,"cuota_ini_20":26914820,"cuota_inicial_20":26914820,"cuotas_3_ini":8971607,"cuotas_48":2242902,"precio_preventa":121550800,"cuota_ini_pre_20":24310160,"cuotas_3_ini_pre":8103387,"cuotas_48_pre":2025847,"descripcion_lindero":"LOTE NÚMERO SETENTA Y SEIS (76): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 15.50 metros; por la derecha entrando, linda con Lote Numero 77 y mide 26.99 metros; por el fondo, linda con Lote Numero 69 y mide 15.00 metros; por la izquierda; linda con Lote Numero 75 y mide 30.89 metros. Área del Lote: 434.11 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-77',
    77,
    'M 8',
    'available',
    121507600,
    391.96,
    '[1073.9,1314.6]'::jsonb,
    '{"pathD":"M 1070.9 1359.8 L 1036.6 1290.2 L 1068.3 1273.3 L 1075.5 1267.1 L 1111.4 1339.9 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":121507600,"cuota_ini_20":24301520,"cuota_inicial_20":24301520,"cuotas_3_ini":8100507,"cuotas_48":2025127,"precio_preventa":109748800,"cuota_ini_pre_20":21949760,"cuotas_3_ini_pre":7316587,"cuotas_48_pre":1829147,"descripcion_lindero":"LOTE NÚMERO SETENTA Y SIETE (77): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 15.09 metros (línea quebrada); por la derecha entrando, linda con Lote Numero 67 y mide 25.83 metros; por el fondo, linda con Lote Numero 68 y mide 15.00 metros; por la izquierda; linda con Lote Numero 76 y mide 26.99 metros. Área del Lote: 391.96 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-78',
    78,
    'M 10',
    'available',
    105077600,
    338.96,
    '[1228.8,1193.8]'::jsonb,
    '{"pathD":"M 1233 1236.7 L 1199.1 1183.7 L 1204.3 1158.7 L 1221.7 1147.4 L 1265.7 1215.5 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":105077600,"cuota_ini_20":21015520,"cuota_inicial_20":21015520,"cuotas_3_ini":7005173,"cuotas_48":1751293,"precio_preventa":94908800,"cuota_ini_pre_20":18981760,"cuotas_3_ini_pre":6327253,"cuotas_48_pre":1581813,"descripcion_lindero":"LOTE NÚMERO SETENTA Y OCHO (78): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 16.06 metros; por la derecha entrando, linda con Carrera Numero 3 y mide 20.92 metros; por el fondo, linda con Lote Numero 86 y mide 12.98 metros; por la izquierda; linda con Lote Numero 79 y mide 26.97 metros. Área del Lote: 338.96 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-79',
    79,
    'M 10',
    'available',
    101679800,
    350.62,
    '[1260,1171]'::jsonb,
    '{"pathD":"M 1221.7 1147.4 L 1254.5 1126.1 L 1298.5 1194.3 L 1265.7 1215.5 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":101679800,"cuota_ini_20":20335960,"cuota_inicial_20":20335960,"cuotas_3_ini":6778653,"cuotas_48":1694663,"precio_preventa":94667400,"cuota_ini_pre_20":18933480,"cuotas_3_ini_pre":6311160,"cuotas_48_pre":1577790,"descripcion_lindero":"LOTE NÚMERO SETENTA Y NUEVE (79): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide13.00 metros; por la derecha entrando, linda con Lote Numero 78 y mide 27.00 metros; por el fondo, linda con Lote Numero 86 y mide 13.00 metros; por la izquierda; linda con Lote Numero 80 y mide 27.00 metros. Área del Lote: 350.62 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-80',
    80,
    'M 10',
    'available',
    101827700,
    351.13,
    '[1292.8,1149.7]'::jsonb,
    '{"pathD":"M 1287.3 1104.8 L 1331.4 1173 L 1302.9 1191.4 L 1298.6 1194.2 L 1254.5 1126.1 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":101827700,"cuota_ini_20":20365540,"cuota_inicial_20":20365540,"cuotas_3_ini":6788513,"cuotas_48":1697128,"precio_preventa":94805100,"cuota_ini_pre_20":18961020,"cuotas_3_ini_pre":6320340,"cuotas_48_pre":1580085,"descripcion_lindero":"LOTE NÚMERO OCHENTA (80): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 13.00 metros; por la derecha entrando, linda con Lote Numero 79, y mide 27.00 metros; por el fondo, linda con Lotes Numero 83-86 y mide 13.00 metros; por la izquierda; linda con Lote Numero 81 y mide 27.00 metros. Área del Lote: 351.13 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-81',
    81,
    'M 10',
    'available',
    113295700,
    365.47,
    '[1326.8,1129.1]'::jsonb,
    '{"pathD":"M 1287.3 1104.8 L 1309.2 1090.6 L 1330 1095 L 1366 1150.6 L 1331.4 1173 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":113295700,"cuota_ini_20":22659140,"cuota_inicial_20":22659140,"cuotas_3_ini":7553047,"cuotas_48":1888262,"precio_preventa":102331600,"cuota_ini_pre_20":20466320,"cuotas_3_ini_pre":6822107,"cuotas_48_pre":1705527,"descripcion_lindero":"LOTE NÚMERO OCHENTA Y UNO (81): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 16.57 metros; por la derecha entrando, linda con Lote Numero 80, y mide 27.02 metros; por el fondo, linda con Lote Numero 82, Lote Numero 83 y mide 13.72 metros; por la izquierda; linda con Carrera Numero 4 y mide 22.03 metros. Área del Lote: 365.47 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-82',
    82,
    'M 10',
    'sold',
    108846500,
    310.99,
    '[1371.2,1190.9]'::jsonb,
    '{"pathD":"M 1390.1 1225 L 1376 1233.3 L 1334.3 1171.1 L 1366 1150.6 L 1403.4 1208.4 L 1398.9 1221.8 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"ROJO","valor_m2":350000,"prem2":325000,"precio_venta":108846500,"cuota_ini_20":21769300,"cuota_inicial_20":21769300,"cuotas_3_ini":7256433,"cuotas_48":1814108,"precio_preventa":101071750,"cuota_ini_pre_20":20214350,"cuotas_3_ini_pre":6738117,"cuotas_48_pre":1684529,"descripcion_lindero":"LOTE NÚMERO OCHENTA Y DOS (82): Por el frente, linda con acceso vehicular al lote y Calle Numero 3 y mide 13.97 metros; por la derecha entrando, linda con Carrera Numero 4 y mide 22.90 metros; por el fondo, linda con Lote Numero 81 y mide 12.57 metros; por la izquierda; linda con Lote Numero 83 y mide 24.90 metros. Área del Lote: 310.99 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-83',
    83,
    'M 10',
    'available',
    111891500,
    319.69,
    '[1341.2,1216.2]'::jsonb,
    '{"pathD":"M 1334.3 1171.1 L 1376 1233.3 L 1365.5 1245.9 L 1361 1253.5 L 1353.3 1264.9 L 1305 1190.1 L 1331.4 1173 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROJO","valor_m2":350000,"prem2":325000,"precio_venta":111891500,"cuota_ini_20":22378300,"cuota_inicial_20":22378300,"cuotas_3_ini":7459433,"cuotas_48":1864858,"precio_preventa":103899250,"cuota_ini_pre_20":20779850,"cuotas_3_ini_pre":6926617,"cuotas_48_pre":1731654,"descripcion_lindero":"LOTE NÚMERO OCHENTA Y TRES (83): Por el frente, linda con acceso vehicular al lote y Calle Numero 3 y mide 13.97 metros; por la derecha entrando, linda con Lote Numero 82 y mide 24.90 metros; por el fondo, linda con Lote Numero 80 y mide 11.60 metros; por la izquierda; linda con Lote Numero 84, Lote Numero 86 y Lote 81 y mide 29.64 metros. Área del Lote: 319.69 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-84',
    84,
    'M 10',
    'available',
    103218500,
    294.91,
    '[1322.7,1262.2]'::jsonb,
    '{"pathD":"M 1329.6 1309.6 L 1289.1 1246.9 L 1326.2 1222.9 L 1353.3 1264.9 L 1339 1286.2 L 1331.5 1302.2 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROJO","valor_m2":350000,"prem2":325000,"precio_venta":103218500,"cuota_ini_20":20643700,"cuota_inicial_20":20643700,"cuotas_3_ini":6881233,"cuotas_48":1720308,"precio_preventa":95845750,"cuota_ini_pre_20":19169150,"cuotas_3_ini_pre":6389717,"cuotas_48_pre":1597429,"descripcion_lindero":"LOTE NÚMERO OCHENTA Y CUATRO (84): Por el frente, linda con acceso vehicular al lote y Calle Numero 3 y mide 14.46 metros; por la derecha entrando, linda con Lote Numero 83, y mide 16.64 metros; por el fondo, linda con Lote Numero 86 y mide 14.70 metros; por la izquierda; linda con Lote Numero 85 y mide 24.83 metros. Área del Lote: 294.91 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-85',
    85,
    'M 10',
    'sold',
    149303000,
    426.58,
    '[1295.6,1296.9]'::jsonb,
    '{"pathD":"M 1304.2 1347.9 L 1254.1 1269.6 L 1289.1 1246.9 L 1329.6 1309.6 L 1320.6 1345.1 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"ROJO","valor_m2":350000,"prem2":325000,"precio_venta":149303000,"cuota_ini_20":29860600,"cuota_inicial_20":29860600,"cuotas_3_ini":9953533,"cuotas_48":2488383,"precio_preventa":138638500,"cuota_ini_pre_20":27727700,"cuotas_3_ini_pre":9242567,"cuotas_48_pre":2310642,"descripcion_lindero":"LOTE NÚMERO OCHENTA Y CINCO (85): Por el frente, linda con acceso vehicular al lote y Calle Numero 3 y mide 19.17 metros; por la derecha entrando, linda con Lote Numero 84 y mide 24.83 metros; por el fondo, linda con Lote Numero 86 y mide 13.88 metros; por la izquierda; linda con Carrera Numero 3 y mide 30.94 metros. Área del Lote: 426.58 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-86',
    86,
    'M 10',
    'available',
    115084400,
    371.24,
    '[1279.6,1229.7]'::jsonb,
    '{"pathD":"M 1233 1236.7 L 1305 1190.1 L 1326.2 1222.9 L 1254.1 1269.6 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":115084400,"cuota_ini_20":23016880,"cuota_inicial_20":23016880,"cuotas_3_ini":7672293,"cuotas_48":1918073,"precio_preventa":103947200,"cuota_ini_pre_20":20789440,"cuotas_3_ini_pre":6929813,"cuotas_48_pre":1732453,"descripcion_lindero":"LOTE NÚMERO OCHENTA Y SEIS (86): Por el frente, linda con acceso vehicular al lote y Carrera Numero 3 y mide 13.00 metros; por la derecha entrando, linda con Lote Numero 84, Lote Numero 85, y mide 28.58 metros; por el fondo, linda con Lote Numero 83 y mide 13.00 metros; por la izquierda; linda con Lote Numero 78, Lote Numero 79 y mide 27.69 metros. Área del Lote: 371.24 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-87',
    87,
    'M 11',
    'available',
    114442700,
    369.17,
    '[1380.3,1098]'::jsonb,
    '{"pathD":"M 1386.6 1143.7 L 1347.6 1083.5 L 1352.1 1062.8 L 1372.1 1049.7 L 1419.4 1122.5 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":114442700,"cuota_ini_20":22888540,"cuota_inicial_20":22888540,"cuotas_3_ini":7629513,"cuotas_48":1907378,"precio_preventa":103367600,"cuota_ini_pre_20":20673520,"cuotas_3_ini_pre":6891173,"cuotas_48_pre":1722793,"descripcion_lindero":"LOTE NÚMERO OCHENTA Y SIETE (87): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 15.80 metros; por la derecha entrando, linda con Carrera Numero 4 y mide 23.56 metros; por el fondo, linda con Lote Numero 88 y mide 13.00 metros; por la izquierda; linda con Lote Numero 102 y mide 28.88 metros. Área del Lote: 369.17 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-88',
    88,
    'M 11',
    'available',
    75400000,
    260,
    '[1427.1,1135.9]'::jsonb,
    '{"pathD":"M 1468.5 1126.5 L 1402.9 1169 L 1386.6 1143.7 L 1419.4 1122.5 L 1452.2 1101.3 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":75400000,"cuota_ini_20":15080000,"cuota_inicial_20":15080000,"cuotas_3_ini":5026667,"cuotas_48":1256667,"precio_preventa":70200000,"cuota_ini_pre_20":14040000,"cuotas_3_ini_pre":4680000,"cuotas_48_pre":1170000,"descripcion_lindero":"LOTE NÚMERO OCHENTA Y OCHO (88): Por el frente, linda con acceso vehicular al lote y Carrera Numero 4 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 89 y mide 26.00 metros; por el fondo, linda con Lote Numero 99 y mide 10.00 metros; por la izquierda; linda con Lote Numero 87, Lote Numero 102 y mide 26.00 metros. Área del Lote: 260.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-89',
    89,
    'M 11',
    'available',
    80600000,
    260,
    '[1443.9,1160.4]'::jsonb,
    '{"pathD":"M 1484.8 1151.8 L 1419.2 1194.2 L 1402.9 1169 L 1468.5 1126.5 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":80600000,"cuota_ini_20":16120000,"cuota_inicial_20":16120000,"cuotas_3_ini":5373333,"cuotas_48":1343333,"precio_preventa":72800000,"cuota_ini_pre_20":14560000,"cuotas_3_ini_pre":4853333,"cuotas_48_pre":1213333,"descripcion_lindero":"LOTE NÚMERO OCHENTA Y NUEVE (89): Por el frente, linda con acceso vehicular al lote y Carrera Numero 4 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 90 y mide 26.00 metros; por el fondo, linda con Lote Numero 98 y mide 10.00 metros; por la izquierda; linda con Lote Numero 88 y mide 26.00 metros. Área del Lote: 260.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-90',
    90,
    'M 11',
    'available',
    84922200,
    257.34,
    '[1460.5,1185.2]'::jsonb,
    '{"pathD":"M 1501.2 1177 L 1440.7 1216.1 L 1435.1 1214.4 L 1429.8 1210.5 L 1419.2 1194.2 L 1484.8 1151.8 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"VERDE","valor_m2":330000,"prem2":300000,"precio_venta":84922200,"cuota_ini_20":16984440,"cuota_inicial_20":16984440,"cuotas_3_ini":5661480,"cuotas_48":1415370,"precio_preventa":77202000,"cuota_ini_pre_20":15440400,"cuotas_3_ini_pre":5146800,"cuotas_48_pre":1286700,"descripcion_lindero":"LOTE NÚMERO NOVENTA (90): Por el frente, linda con acceso vehicular al lote y Carrera Numero 4 y mide 8.72 metros (línea quebrada); por la derecha entrando, linda con Lote Numero 91 y mide 23.97 metros; por el fondo, linda con Lote Numero 97 y mide 10.00 metros; por la izquierda; linda con Lote Numero 89 y mide 26.00 metros. Área del Lote: 257.34 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-91',
    91,
    'M 11',
    'available',
    138171000,
    418.7,
    '[1490.3,1218.5]'::jsonb,
    '{"pathD":"M 1484.9 1259.1 L 1460 1229.9 L 1440.7 1216.1 L 1501.2 1177 L 1517.5 1202.2 L 1533.8 1227.5 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"VERDE","valor_m2":330000,"prem2":300000,"precio_venta":138171000,"cuota_ini_20":27634200,"cuota_inicial_20":27634200,"cuotas_3_ini":9211400,"cuotas_48":2302850,"precio_preventa":125610000,"cuota_ini_pre_20":25122000,"cuotas_3_ini_pre":8374000,"cuotas_48_pre":2093500,"descripcion_lindero":"LOTE NÚMERO NOVENTA Y UNO (91): Por el frente, linda con acceso vehicular al lote y Carrera Numero 4 y mide 20.78 metros; por la derecha entrando, linda con Lote Numero 92 y mide 19.22 metros; por el fondo, linda con Lotes Numero 95-96 y mide 20.00 metros; por la izquierda; linda con Lote Numero 90 y mide 23.97 metros. Área del Lote: 418.34 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-92',
    92,
    'M 11',
    'available',
    87232200,
    264.34,
    '[1527.4,1250.9]'::jsonb,
    '{"pathD":"M 1484.9 1259.1 L 1549.8 1217.2 L 1567.9 1245.3 L 1508.1 1281.1 L 1501 1276.2 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"VERDE","valor_m2":330000,"prem2":300000,"precio_venta":87232200,"cuota_ini_20":17446440,"cuota_inicial_20":17446440,"cuotas_3_ini":5815480,"cuotas_48":1453870,"precio_preventa":79302000,"cuota_ini_pre_20":15860400,"cuotas_3_ini_pre":5286800,"cuotas_48_pre":1321700,"descripcion_lindero":"LOTE NÚMERO NOVENTA Y DOS (92): Por el frente, linda con acceso vehicular al lote y Carrera Numero 4 y mide 10.68 metros (línea quebrada); por la derecha entrando, linda con Lote Numero 93 y mide 23.18 metros; por el fondo, linda con Lote Numero 94 y mide 11.14 metros; por la izquierda; linda con Lotes Numero 91 y 95 y mide 25.71 metros Área del Lote: 264.34 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-93',
    93,
    'M 11',
    'available',
    86014500,
    260.65,
    '[1554.7,1274.8]'::jsonb,
    '{"pathD":"M 1526.1 1293.5 L 1508.1 1281.1 L 1567.9 1245.3 L 1595.9 1288.9 L 1573.7 1290.6 L 1534.5 1295.6 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"VERDE","valor_m2":330000,"prem2":300000,"precio_venta":86014500,"cuota_ini_20":17202900,"cuota_inicial_20":17202900,"cuotas_3_ini":5734300,"cuotas_48":1433575,"precio_preventa":78195000,"cuota_ini_pre_20":15639000,"cuotas_3_ini_pre":5213000,"cuotas_48_pre":1303250,"descripcion_lindero":"LOTE NÚMERO NOVENTA Y TRES (93): Por el frente, linda con acceso vehicular al lote y Carrera Numero 4 y mide 30.78 metros; por la derecha entrando, linda con Lote Numero 94 y mide 17.23 metros; por el fondo, linda con Lote Numero 92 y mide 23.18 metros. Área del Lote: 260.65 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-94',
    94,
    'M 11',
    'sold',
    208028700,
    630.39,
    '[1602.1,1243]'::jsonb,
    '{"pathD":"M 1622 1286.8 L 1595.9 1288.9 L 1549.8 1217.2 L 1596.9 1186.7 L 1654 1274.9 L 1645.2 1288.7 L 1631.9 1287 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"VERDE","valor_m2":330000,"prem2":300000,"precio_venta":208028700,"cuota_ini_20":41605740,"cuota_inicial_20":41605740,"cuotas_3_ini":13868580,"cuotas_48":3467145,"precio_preventa":189117000,"cuota_ini_pre_20":37823400,"cuotas_3_ini_pre":12607800,"cuotas_48_pre":3151950,"descripcion_lindero":"LOTE NÚMERO NOVENTA Y CUATRO (94): Por el frente, linda con acceso vehicular al lote y Carrera Numero 4 y mide 23.28 metros (línea quebrada); por la derecha entrando, linda con Carrera Numero 5 y mide 34.95 metros; por el fondo, linda con Lote Numero 95 y mide 18.68 metros; por la izquierda; linda con Lote Numero 93 y Lote Numero 92 y mide 28.37 metros. Área del Lote: 630.28 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-95',
    95,
    'M 11',
    'available',
    77500000,
    250,
    '[1557.2,1194.5]'::jsonb,
    '{"pathD":"M 1533.8 1227.5 L 1517.5 1202.2 L 1580.6 1161.4 L 1596.9 1186.7 L 1566.9 1206.1 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":77500000,"cuota_ini_20":15500000,"cuota_inicial_20":15500000,"cuotas_3_ini":5166667,"cuotas_48":1291667,"precio_preventa":70000000,"cuota_ini_pre_20":14000000,"cuotas_3_ini_pre":4666667,"cuotas_48_pre":1166667,"descripcion_lindero":"LOTE NÚMERO NOVENTA Y CINCO (95): Por el frente, linda con acceso vehicular al lote y Carrera Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 96 y mide 25.00 metros; por el fondo, linda con Lote Numero 91 y mide 10.00 metros; por la izquierda; linda con Lote Numero 93, Lote Numero 94 y mide 25.00 metros. Área del Lote: 250.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-96',
    96,
    'M 11',
    'available',
    72500000,
    250,
    '[1540.4,1170]'::jsonb,
    '{"pathD":"M 1517.5 1202.2 L 1501.2 1177 L 1564.3 1136.2 L 1580.6 1161.4 L 1550.5 1180.9 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":72500000,"cuota_ini_20":14500000,"cuota_inicial_20":14500000,"cuotas_3_ini":4833333,"cuotas_48":1208333,"precio_preventa":67500000,"cuota_ini_pre_20":13500000,"cuotas_3_ini_pre":4500000,"cuotas_48_pre":1125000,"descripcion_lindero":"LOTE NÚMERO NOVENTA Y SEIS (96): Por el frente, linda con acceso vehicular al lote y Carrera Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 97 y mide 25.00 metros; por el fondo, linda con Lote Numero 91 y mide 10.00 metros; por la izquierda; linda Lote Numero 95 y mide 25.00 metros. Área del Lote: 250.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-97',
    97,
    'M 11',
    'available',
    72500000,
    250,
    '[1524.1,1144.8]'::jsonb,
    '{"pathD":"M 1564.3 1136.2 L 1501.2 1177 L 1484.8 1151.8 L 1547.9 1111 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":72500000,"cuota_ini_20":14500000,"cuota_inicial_20":14500000,"cuotas_3_ini":4833333,"cuotas_48":1208333,"precio_preventa":67500000,"cuota_ini_pre_20":13500000,"cuotas_3_ini_pre":4500000,"cuotas_48_pre":1125000,"descripcion_lindero":"LOTE NÚMERO NOVENTA Y SIETE (97): Por el frente, linda con acceso vehicular al lote y Carrera Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 98 y mide 25.00 metros; por el fondo, linda con Lote Numero 90 y mide 10.00 metros; por la izquierda; linda Lote Numero 96 y mide 25.00 metros. Área del Lote: 250.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-98',
    98,
    'M 11',
    'available',
    72500000,
    250,
    '[1508.2,1118.8]'::jsonb,
    '{"pathD":"M 1547.9 1111 L 1484.8 1151.8 L 1468.5 1126.5 L 1531.6 1085.7 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":72500000,"cuota_ini_20":14500000,"cuota_inicial_20":14500000,"cuotas_3_ini":4833333,"cuotas_48":1208333,"precio_preventa":67500000,"cuota_ini_pre_20":13500000,"cuotas_3_ini_pre":4500000,"cuotas_48_pre":1125000,"descripcion_lindero":"LOTE NÚMERO NOVENTA Y OCHO (98): Por el frente, linda con acceso vehicular al lote y Carrera Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 99 y mide 25.00 metros; por el fondo, linda con Lote Numero 89 y mide 10.00 metros; por la izquierda; linda Lote Numero 97 y mide 25.00 metros. Área del Lote: 250.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-99',
    99,
    'M 11',
    'available',
    72500000,
    250,
    '[1492.7,1091.9]'::jsonb,
    '{"pathD":"M 1531.6 1085.7 L 1468.5 1126.5 L 1452.2 1101.3 L 1485 1080.1 L 1515.3 1060.5 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":72500000,"cuota_ini_20":14500000,"cuota_inicial_20":14500000,"cuotas_3_ini":4833333,"cuotas_48":1208333,"precio_preventa":67500000,"cuota_ini_pre_20":13500000,"cuotas_3_ini_pre":4500000,"cuotas_48_pre":1125000,"descripcion_lindero":"LOTE NÚMERO NOVENTA Y NUEVE (99): Por el frente, linda con acceso vehicular al lote y Carrera Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 100, Lote Numero 101 y mide 25.00 metros; por el fondo, linda con Lote Numero 88 y mide 10.00 metros; por la izquierda; Lote Numero 98 y mide 25.00 metros. Área del Lote: 250.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-100',
    100,
    'M 11',
    'available',
    99336600,
    342.54,
    '[1477,1034.9]'::jsonb,
    '{"pathD":"M 1476.2 1000.1 L 1515.3 1060.5 L 1485 1080.1 L 1437.7 1007.2 L 1455.4 995.7 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":99336600,"cuota_ini_20":19867320,"cuota_inicial_20":19867320,"cuotas_3_ini":6622440,"cuotas_48":1655610,"precio_preventa":92485800,"cuota_ini_pre_20":18497160,"cuotas_3_ini_pre":6165720,"cuotas_48_pre":1541430,"descripcion_lindero":"LOTE NUMERO CIEN (100): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 14.90 metros; por la derecha entrando, linda con Lote Numero 101 y mide 28.92 metros; por el fondo, linda con Lote Numero 99 y mide 12.00 metros; por la izquierda; Carrera Numero 5 y mide 23.93 metros. Área del Lote: 342.54 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-101',
    101,
    'M 11',
    'available',
    109005200,
    375.88,
    '[1444.7,1054.8]'::jsonb,
    '{"pathD":"M 1437.7 1007.2 L 1437.7 1007.2 L 1485 1080.1 L 1452.2 1101.3 L 1404.9 1028.5 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":109005200,"cuota_ini_20":21801040,"cuota_inicial_20":21801040,"cuotas_3_ini":7267013,"cuotas_48":1816753,"precio_preventa":101487600,"cuota_ini_pre_20":20297520,"cuotas_3_ini_pre":6765840,"cuotas_48_pre":1691460,"descripcion_lindero":"LOTE NUMERO CIENTO UNO (101): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 13.00 metros; por la derecha entrando, linda con Lote Numero 102 y mide 28.88 metros; por el fondo, linda con Lote Numero 99 y mide 13.00 metros; por la izquierda; Lote Numero 100 y mide 28.88 metros. Área del Lote: 375.56 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-102',
    102,
    'M 11',
    'available',
    108924000,
    375.6,
    '[1412.3,1075.1]'::jsonb,
    '{"pathD":"M 1404.9 1028.4 L 1404.9 1028.5 L 1452.2 1101.3 L 1419.4 1122.5 L 1372.1 1049.7 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":108924000,"cuota_ini_20":21784800,"cuota_inicial_20":21784800,"cuotas_3_ini":7261600,"cuotas_48":1815400,"precio_preventa":101412000,"cuota_ini_pre_20":20282400,"cuotas_3_ini_pre":6760800,"cuotas_48_pre":1690200,"descripcion_lindero":"LOTE NUMERO CIENTO DOS (102): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 13.00 metros; por la derecha entrando, linda con Lote Numero 87 y mide 28.88 metros; por el fondo, linda con Lote Numero 88, y mide 13.00 metros; por la izquierda; Lote Numero 101 y mide 28.88 metros. Área del Lote: 375.56 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-103',
    103,
    'M 12',
    'available',
    104098000,
    335.8,
    '[1200.6,1089.4]'::jsonb,
    '{"pathD":"M 1178.7 1072.3 L 1171.5 1057.8 L 1195.2 1042.8 L 1236.1 1105.8 L 1198 1130.6 L 1184.1 1123.5 L 1181.8 1084.4 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":104098000,"cuota_ini_20":20819600,"cuota_inicial_20":20819600,"cuotas_3_ini":6939867,"cuotas_48":1734967,"precio_preventa":94024000,"cuota_ini_pre_20":18804800,"cuotas_3_ini_pre":6268267,"cuotas_48_pre":1567067,"descripcion_lindero":"LOTE NUMERO CIENTO TRES (103): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 21.40 metros; por la derecha entrando, linda con Lote Numero 104 y mide 25.00 metros; por el fondo, linda con Lote Numero 125 y mide 9.32 metros; por la izquierda; Carrera Numero 3 y mide 22.63 metros (línea quebrada). Área del Lote: 335.80 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-104',
    104,
    'M 12',
    'available',
    72500000,
    250,
    '[1227.8,1066.9]'::jsonb,
    '{"pathD":"M 1261.3 1089.4 L 1236.1 1105.8 L 1195.2 1042.8 L 1220.4 1026.4 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":72500000,"cuota_ini_20":14500000,"cuota_inicial_20":14500000,"cuotas_3_ini":4833333,"cuotas_48":1208333,"precio_preventa":67500000,"cuota_ini_pre_20":13500000,"cuotas_3_ini_pre":4500000,"cuotas_48_pre":1125000,"descripcion_lindero":"LOTE NUMERO CIENTO CUATRO (104): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 105 y mide 25.00 metros; por el fondo, linda con Lote Numero 125 y mide 10.00 metros; por la izquierda; Lote Numero 103 y mide 25.00 metros. Área del Lote: 250.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-105',
    105,
    'M 12',
    'available',
    87000000,
    300,
    '[1256,1048.1]'::jsonb,
    '{"pathD":"M 1291.6 1069.8 L 1261.3 1089.4 L 1220.4 1026.4 L 1245.6 1010.1 L 1250.6 1006.8 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":87000000,"cuota_ini_20":17400000,"cuota_inicial_20":17400000,"cuotas_3_ini":5800000,"cuotas_48":1450000,"precio_preventa":81000000,"cuota_ini_pre_20":16200000,"cuotas_3_ini_pre":5400000,"cuotas_48_pre":1350000,"descripcion_lindero":"LOTE NUMERO CIENTO CINCO (105): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 12.00 metros; por la derecha entrando, linda con Lote Numero 106 y mide 25.00 metros; por el fondo, linda con Lote Numero 123, Lote Numero 124 y mide 12.00 metros; por la izquierda; Linda con Lote Numero 105 y mide 25.00 metros. Área del Lote: 300.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-106',
    106,
    'M 12',
    'available',
    87000000,
    300,
    '[1285.9,1029.1]'::jsonb,
    '{"pathD":"M 1321.8 1050.2 L 1291.6 1069.8 L 1250.6 1006.8 L 1270.8 993.7 L 1280.9 987.1 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":87000000,"cuota_ini_20":17400000,"cuota_inicial_20":17400000,"cuotas_3_ini":5800000,"cuotas_48":1450000,"precio_preventa":81000000,"cuota_ini_pre_20":16200000,"cuotas_3_ini_pre":5400000,"cuotas_48_pre":1350000,"descripcion_lindero":"LOTE NUMERO CIENTO SEIS (106): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 12.00 metros; por la derecha entrando, linda con Lote Numero 107 y mide 25.00 metros; por el fondo, linda con Lote Numero 122, Lote Numero 123 y mide 12.00 metros; por la izquierda; linda con Lote Numero 105 y mide 25.00 metros. Área del Lote: 300.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-107',
    107,
    'M 12',
    'available',
    87000000,
    300,
    '[1316.8,1008.2]'::jsonb,
    '{"pathD":"M 1352.1 1030.5 L 1321.8 1050.2 L 1280.9 987.1 L 1296 977.3 L 1311.1 967.5 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":87000000,"cuota_ini_20":17400000,"cuota_inicial_20":17400000,"cuotas_3_ini":5800000,"cuotas_48":1450000,"precio_preventa":81000000,"cuota_ini_pre_20":16200000,"cuotas_3_ini_pre":5400000,"cuotas_48_pre":1350000,"descripcion_lindero":"LOTE NUMERO CIENTO SIETE (107): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 12.00 metros; por la derecha entrando, linda con Lote Numero 108 y mide 25 metros; por el fondo, linda con Lote Numero 121, Lote Numero 122 y mide 12.00 metros; por la izquierda; linda con Lote Numero 106 y mide 25.00 metros. Área del Lote: 300.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-108',
    108,
    'M 12',
    'available',
    87000000,
    300,
    '[1347.1,988.5]'::jsonb,
    '{"pathD":"M 1382.3 1010.9 L 1352.1 1030.5 L 1311.1 967.5 L 1321.2 961 L 1341.4 947.9 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":87000000,"cuota_ini_20":17400000,"cuota_inicial_20":17400000,"cuotas_3_ini":5800000,"cuotas_48":1450000,"precio_preventa":81000000,"cuota_ini_pre_20":16200000,"cuotas_3_ini_pre":5400000,"cuotas_48_pre":1350000,"descripcion_lindero":"LOTE NUMERO CIENTO OCHO (108): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 12.00 metros; por la derecha entrando, linda con Lote Numero 109 y mide 25.00 metros; por el fondo, linda con Lote Numero 120, Lote Numero 121 y mide 12.00 metros; por la izquierda; linda con Lote Numero 107 y mide 25.00 metros. Área del Lote: 300.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-109',
    109,
    'M 12',
    'available',
    87000000,
    300,
    '[1377,969.5]'::jsonb,
    '{"pathD":"M 1412.5 991.2 L 1382.3 1010.9 L 1341.4 947.9 L 1346.4 944.6 L 1371.6 928.2 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":87000000,"cuota_ini_20":17400000,"cuota_inicial_20":17400000,"cuotas_3_ini":5800000,"cuotas_48":1450000,"precio_preventa":81000000,"cuota_ini_pre_20":16200000,"cuotas_3_ini_pre":5400000,"cuotas_48_pre":1350000,"descripcion_lindero":"LOTE NUMERO CIENTO NUEVE (109): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 12.00 metros; por la derecha entrando, linda con Lote Numero 110 y mide 25.00 metros; por el fondo, linda con Lotes Numero 119, Lote Numero 120 y mide 12.00 metros; por la izquierda; linda con Lote Numero 108 y mide 25.00 metros. Área del Lote: 300.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-110',
    110,
    'M 12',
    'available',
    87000000,
    300,
    '[1407.2,949.9]'::jsonb,
    '{"pathD":"M 1442.8 971.6 L 1412.5 991.2 L 1371.6 928.2 L 1396.8 911.9 L 1401.9 908.6 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":87000000,"cuota_ini_20":17400000,"cuota_inicial_20":17400000,"cuotas_3_ini":5800000,"cuotas_48":1450000,"precio_preventa":81000000,"cuota_ini_pre_20":16200000,"cuotas_3_ini_pre":5400000,"cuotas_48_pre":1350000,"descripcion_lindero":"LOTE NUMERO CIENTO DIEZ (110): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 12.00 metros; por la derecha entrando, linda con Lote Numero 111 y mide 25.00 metros; por el fondo, linda con Lote Numero 117, Lote Numero 118 y mide 12.00 metros; por la izquierda; linda con Lote Numero 109 y mide 25.00 metros. Área del Lote: 300.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-111',
    111,
    'M 12',
    'available',
    87000000,
    300,
    '[1437.1,930.9]'::jsonb,
    '{"pathD":"M 1473 952 L 1442.8 971.6 L 1401.9 908.6 L 1422 895.5 L 1432.1 888.9 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":87000000,"cuota_ini_20":17400000,"cuota_inicial_20":17400000,"cuotas_3_ini":5800000,"cuotas_48":1450000,"precio_preventa":81000000,"cuota_ini_pre_20":16200000,"cuotas_3_ini_pre":5400000,"cuotas_48_pre":1350000,"descripcion_lindero":"LOTE NUMERO CIENTO ONCE (111): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 12.00 metros; por la derecha entrando, linda con Lote Numero 112 y mide 25.00 metros; por el fondo, linda con Lote Numero 116, Lote Numero 117 y mide 12.00 metros; por la izquierda; linda con Lote Numero 110 y mide 25.00 metros. Área del Lote: 300.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-112',
    112,
    'M 12',
    'available',
    87000000,
    300,
    '[1467.7,910.6]'::jsonb,
    '{"pathD":"M 1503.3 932.3 L 1473 952 L 1432.1 888.9 L 1447.2 879.1 L 1462.4 869.3 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":87000000,"cuota_ini_20":17400000,"cuota_inicial_20":17400000,"cuotas_3_ini":5800000,"cuotas_48":1450000,"precio_preventa":81000000,"cuota_ini_pre_20":16200000,"cuotas_3_ini_pre":5400000,"cuotas_48_pre":1350000,"descripcion_lindero":"LOTE NUMERO CIENTO DOCE (112): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 12.00 metros; por la derecha entrando, linda con Lote Numero 113 y mide 25.00 metros; por el fondo, linda con Lote Numero 115, Lote Numero 116 y mide 12.00 metros; por la izquierda; linda con Lote Numero 111 y mide 25.00 metros. Área del Lote: 300.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-113',
    113,
    'M 12',
    'available',
    99575100,
    321.21,
    '[1497.5,884.1]'::jsonb,
    '{"pathD":"M 1514.8 862.5 L 1521.5 895.7 L 1514.3 922.4 L 1510.5 927.6 L 1503.3 932.3 L 1462.4 869.3 L 1472.5 862.7 L 1503.7 842.5 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":99575100,"cuota_ini_20":19915020,"cuota_inicial_20":19915020,"cuotas_3_ini":6638340,"cuotas_48":1659585,"precio_preventa":89938800,"cuota_ini_pre_20":17987760,"cuotas_3_ini_pre":5995920,"cuotas_48_pre":1498980,"descripcion_lindero":"LOTE NUMERO CIENTO TRECE (113): Por el frente, linda con acceso vehicular al lote y Carrera Numero 6 y mide 33.15 metros (línea quebrada); por el fondo, linda con Lote Numero 114, Lote Numero 115 y mide 16.39 metros; por la izquierda; linda con Lote Numero 112 y mide 25.00 metros. Área del Lote: 321.21 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-114',
    114,
    'M 12',
    'available',
    106423000,
    343.3,
    '[1467.5,819.1]'::jsonb,
    '{"pathD":"M 1470.4 782.4 L 1503.7 842.5 L 1472.5 862.7 L 1429.9 797.2 L 1457.6 779.2 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":106423000,"cuota_ini_20":21284600,"cuota_inicial_20":21284600,"cuotas_3_ini":7094867,"cuotas_48":1773717,"precio_preventa":96124000,"cuota_ini_pre_20":19224800,"cuotas_3_ini_pre":6408267,"cuotas_48_pre":1602067,"descripcion_lindero":"LOTE NUMERO CIENTO CATORCE (114): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 15.90 metros; por la derecha entrando, linda con Lote Numero 115 y mide 26.00 metros; por el fondo, linda con Lote Numero 113 y mide 12.39 metros; por la izquierda; linda con Carrera Numero 6 y mide 22.85 metros. Área del Lote: 343.30 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-115',
    115,
    'M 12',
    'available',
    75400000,
    260,
    '[1438.2,838.9]'::jsonb,
    '{"pathD":"M 1472.5 862.7 L 1462.4 869.3 L 1447.2 879.1 L 1404.7 813.6 L 1429.9 797.2 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":75400000,"cuota_ini_20":15080000,"cuota_inicial_20":15080000,"cuotas_3_ini":5026667,"cuotas_48":1256667,"precio_preventa":70200000,"cuota_ini_pre_20":14040000,"cuotas_3_ini_pre":4680000,"cuotas_48_pre":1170000,"descripcion_lindero":"LOTE NUMERO CIENTO QUINCE (115): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 116 y mide 26.00 metros; por el fondo, linda con Lotes Numero 112-113 y mide 10.00 metros; por la izquierda; linda con Lote Numero 114 y mide 26.00 metros. Área del Lote: 260.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-116',
    116,
    'M 12',
    'available',
    75400000,
    260,
    '[1413,855.3]'::jsonb,
    '{"pathD":"M 1422 895.5 L 1379.5 829.9 L 1404.7 813.6 L 1447.2 879.1 L 1432.1 888.9 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":75400000,"cuota_ini_20":15080000,"cuota_inicial_20":15080000,"cuotas_3_ini":5026667,"cuotas_48":1256667,"precio_preventa":70200000,"cuota_ini_pre_20":14040000,"cuotas_3_ini_pre":4680000,"cuotas_48_pre":1170000,"descripcion_lindero":"LOTE NUMERO CIENTO DIECISEIS (116): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 117 y mide 26.00 metros; por el fondo, linda con Lote Numero 111, Lote Numero 112 y mide 10.00 metros; por la izquierda; linda con Lote Numero 115 y mide 26.00 metros. Área del Lote: 260.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-117',
    117,
    'M 12',
    'available',
    75400000,
    260,
    '[1388.6,870.1]'::jsonb,
    '{"pathD":"M 1354.3 846.3 L 1379.5 829.9 L 1422 895.5 L 1401.9 908.6 L 1396.8 911.9 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":75400000,"cuota_ini_20":15080000,"cuota_inicial_20":15080000,"cuotas_3_ini":5026667,"cuotas_48":1256667,"precio_preventa":70200000,"cuota_ini_pre_20":14040000,"cuotas_3_ini_pre":4680000,"cuotas_48_pre":1170000,"descripcion_lindero":"LOTE NUMERO CIENTO DIECISIETE (117): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 118 y mide 26.00 metros; por el fondo, linda con Lote Numero 110, Lote Numero 111 y mide 10.00 metros; por la izquierda; linda con Lote Numero 116 y mide 26.00 metros. Área del Lote: 260.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-118',
    118,
    'M 12',
    'available',
    75400000,
    260,
    '[1363.4,886.5]'::jsonb,
    '{"pathD":"M 1329.1 862.7 L 1354.3 846.3 L 1396.8 911.9 L 1371.6 928.2 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":75400000,"cuota_ini_20":15080000,"cuota_inicial_20":15080000,"cuotas_3_ini":5026667,"cuotas_48":1256667,"precio_preventa":70200000,"cuota_ini_pre_20":14040000,"cuotas_3_ini_pre":4680000,"cuotas_48_pre":1170000,"descripcion_lindero":"LOTE NUMERO CIENTO DIECIOCHO (118): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 119, y mide 26.00 metros; por el fondo, linda con Lote Numero 110 y mide 10.00 metros; por la izquierda; linda con Lote Numero 117 y mide 26.00 metros. Área del Lote: 260.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-119',
    119,
    'M 12',
    'available',
    75400000,
    260,
    '[1337.3,904.4]'::jsonb,
    '{"pathD":"M 1303.9 879 L 1329.1 862.7 L 1371.6 928.2 L 1346.4 944.6 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":75400000,"cuota_ini_20":15080000,"cuota_inicial_20":15080000,"cuotas_3_ini":5026667,"cuotas_48":1256667,"precio_preventa":70200000,"cuota_ini_pre_20":14040000,"cuotas_3_ini_pre":4680000,"cuotas_48_pre":1170000,"descripcion_lindero":"LOTE NUMERO CIENTO DIECINUEVE (119): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 120 y mide 26.00 metros; por el fondo, linda con Lote Numero 109 y mide 10.00 metros; por la izquierda; linda con Lote Numero 118 y mide 26.00 metros. Área del Lote: 260.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-120',
    120,
    'M 12',
    'available',
    75400000,
    260,
    '[1312.1,920.8]'::jsonb,
    '{"pathD":"M 1321.2 961 L 1278.7 895.4 L 1303.9 879 L 1346.4 944.6 L 1341.4 947.9 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":75400000,"cuota_ini_20":15080000,"cuota_inicial_20":15080000,"cuotas_3_ini":5026667,"cuotas_48":1256667,"precio_preventa":70200000,"cuota_ini_pre_20":14040000,"cuotas_3_ini_pre":4680000,"cuotas_48_pre":1170000,"descripcion_lindero":"LOTE NUMERO CIENTO VEINTE (120): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 121 y mide 26.00 metros; por el fondo, linda con Lote Numero 108, Lote Numero 109 y mide 10.00 metros; por la izquierda; linda con Lote Numero 119 y mide 26.00 metros. Área del Lote: 260.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-121',
    121,
    'M 12',
    'available',
    75400000,
    260,
    '[1286.9,937.1]'::jsonb,
    '{"pathD":"M 1311.1 967.5 L 1296 977.3 L 1253.5 911.8 L 1278.7 895.4 L 1321.2 961 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":75400000,"cuota_ini_20":15080000,"cuota_inicial_20":15080000,"cuotas_3_ini":5026667,"cuotas_48":1256667,"precio_preventa":70200000,"cuota_ini_pre_20":14040000,"cuotas_3_ini_pre":4680000,"cuotas_48_pre":1170000,"descripcion_lindero":"LOTE NUMERO CIENTO VEINTI Y UNO (121): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 122 y mide 26.00 metros; por el fondo, linda con Lote Numero 107, Lote Numero 108 y mide 10.00 metros; por la izquierda; linda con Lote Numero 120 y mide 26.00 metros. Área del Lote: 260.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-122',
    122,
    'M 12',
    'available',
    75400000,
    260,
    '[1262.1,952.7]'::jsonb,
    '{"pathD":"M 1280.9 987.1 L 1270.8 993.7 L 1228.2 928.2 L 1253.5 911.8 L 1296 977.3 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":75400000,"cuota_ini_20":15080000,"cuota_inicial_20":15080000,"cuotas_3_ini":5026667,"cuotas_48":1256667,"precio_preventa":70200000,"cuota_ini_pre_20":14040000,"cuotas_3_ini_pre":4680000,"cuotas_48_pre":1170000,"descripcion_lindero":"LOTE NUMERO CIENTO VEINTI Y DOS (122): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 123 y mide 26.00 metros; por el fondo, linda con Lote Numero 106, Lote Numero 107 y mide 10.00 metros; por la izquierda; linda con Lote Numero 121 y mide 26.00 metros. Área del Lote: 260.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-123',
    123,
    'M 12',
    'available',
    75400000,
    260,
    '[1237.3,968.3]'::jsonb,
    '{"pathD":"M 1245.6 1010.1 L 1203 944.5 L 1228.2 928.2 L 1270.8 993.7 L 1250.6 1006.8 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":75400000,"cuota_ini_20":15080000,"cuota_inicial_20":15080000,"cuotas_3_ini":5026667,"cuotas_48":1256667,"precio_preventa":70200000,"cuota_ini_pre_20":14040000,"cuotas_3_ini_pre":4680000,"cuotas_48_pre":1170000,"descripcion_lindero":"LOTE NUMERO CIENTO VEINTI Y TRES (123): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 124 y mide 26.00 metros; por el fondo, linda con Lote Numero 105, Lote Numero 106 y mide 10.00 metros; por la izquierda; linda con Lote Numero 122 y mide 26.00 metros. Área del Lote: 260.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-124',
    124,
    'M 12',
    'available',
    75400000,
    260,
    '[1212.1,984.7]'::jsonb,
    '{"pathD":"M 1177.8 960.9 L 1203 944.5 L 1245.6 1010.1 L 1220.4 1026.4 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":75400000,"cuota_ini_20":15080000,"cuota_inicial_20":15080000,"cuotas_3_ini":5026667,"cuotas_48":1256667,"precio_preventa":70200000,"cuota_ini_pre_20":14040000,"cuotas_3_ini_pre":4680000,"cuotas_48_pre":1170000,"descripcion_lindero":"LOTE NUMERO CIENTO VEINTI Y CUATRO (124): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 125 y mide 26.00 metros; por el fondo, linda con Lote Numero 105 y mide 10.00 metros; por la izquierda; linda con Lote Numero 123 y mide 26.00 metros. Área del Lote: 260.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-125',
    125,
    'M 12',
    'available',
    129871400,
    418.94,
    '[1180.4,1010.1]'::jsonb,
    '{"pathD":"M 1151.4 984.2 L 1155.4 975.4 L 1177.8 960.9 L 1220.4 1026.4 L 1195.2 1042.8 L 1171.5 1057.8 L 1157.8 1030.3 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":129871400,"cuota_ini_20":25974280,"cuota_inicial_20":25974280,"cuotas_3_ini":8658093,"cuotas_48":2164523,"precio_preventa":117303200,"cuota_ini_pre_20":23460640,"cuotas_3_ini_pre":7820213,"cuotas_48_pre":1955053,"descripcion_lindero":"LOTE NUMERO CIENTO VEINTI Y CINCO (125): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 12.28 metros; por la derecha entrando, linda con Carrera Numero 3 y mide 25.68 metros (línea quebrada); por el fondo, linda con Lote Numero 103, Lote Numero 104 y mide 19.32 metros; por la izquierda; linda con Lote Numero 124 y mide 26.00 metros. Área del Lote: 418.94 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-126',
    126,
    'M 13',
    'available',
    94429100,
    304.61,
    '[1128.8,915.1]'::jsonb,
    '{"pathD":"M 1119.3 941.5 L 1103.1 873 L 1108.7 854.4 L 1163.1 938.2 L 1124.9 963 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":94429100,"cuota_ini_20":18885820,"cuota_inicial_20":18885820,"cuotas_3_ini":6295273,"cuotas_48":1573818,"precio_preventa":85290800,"cuota_ini_pre_20":17058160,"cuotas_3_ini_pre":5686053,"cuotas_48_pre":1421513,"descripcion_lindero":"LOTE NUMERO CIENTO VEINTI Y SEIS (126): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 15.16 metros; por la derecha entrando, linda con Lote Numero 127 y mide 33.25 metros; por el fondo, linda con Area verde y mide 6.46 metros; por la izquierda; linda con Area verde y mide 30.82 metros. Área del Lote: 304.61 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-127',
    127,
    'M 13',
    'available',
    108642700,
    374.63,
    '[1145.1,882.8]'::jsonb,
    '{"pathD":"M 1188.3 921.8 L 1163.1 938.2 L 1108.7 854.4 L 1120.1 816.8 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":108642700,"cuota_ini_20":21728540,"cuota_inicial_20":21728540,"cuotas_3_ini":7242847,"cuotas_48":1810712,"precio_preventa":101150100,"cuota_ini_pre_20":20230020,"cuotas_3_ini_pre":6743340,"cuotas_48_pre":1685835,"descripcion_lindero":"LOTE NUMERO CIENTO VEINTI Y SIETE (127): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 128 y mide 41.68 metros; por el fondo, linda con Area verde y mide 13.08 metros; por la izquierda; linda con Lote Numero 126 y mide 33.25 metros. Área del Lote: 374.63 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-128',
    128,
    'M 13',
    'available',
    127170800,
    438.52,
    '[1165.3,857.8]'::jsonb,
    '{"pathD":"M 1120.1 816.8 L 1125.2 799.8 L 1143.7 797.9 L 1213.5 905.5 L 1188.3 921.8 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":127170800,"cuota_ini_20":25434160,"cuota_inicial_20":25434160,"cuotas_3_ini":8478053,"cuotas_48":2119513,"precio_preventa":118400400,"cuota_ini_pre_20":23680080,"cuotas_3_ini_pre":7893360,"cuotas_48_pre":1973340,"descripcion_lindero":"LOTE NUMERO CIENTO VEINTI Y OCHO (128): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 129 y mide 42.67 metros; por el fondo, linda con Area verde y mide 12.06 metros; por la izquierda; linda con Lote Numero 127 y mide 41.68 metros. Área del Lote: 438.52 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-129',
    129,
    'M 13',
    'available',
    116121800,
    400.42,
    '[1192.7,847.5]'::jsonb,
    '{"pathD":"M 1238.7 889.1 L 1213.5 905.5 L 1143.7 797.9 L 1164.8 795.7 L 1177.8 795.3 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":116121800,"cuota_ini_20":23224360,"cuota_inicial_20":23224360,"cuotas_3_ini":7741453,"cuotas_48":1935363,"precio_preventa":108113400,"cuota_ini_pre_20":21622680,"cuotas_3_ini_pre":7207560,"cuotas_48_pre":1801890,"descripcion_lindero":"LOTE NUMERO CIENTO VEINTI Y NUEVE (129): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 130 y mide 37.19 metros; por el fondo, linda con Area verde y mide 11.41 metros (línea quebrada); por la izquierda; linda con Lote Numero 128 y mide 42.67 metros. Área del Lote: 400.42 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-130',
    130,
    'M 13',
    'available',
    99049500,
    341.55,
    '[1222.6,838.6]'::jsonb,
    '{"pathD":"M 1177.8 795.3 L 1213 794.3 L 1263.9 872.7 L 1238.7 889.1 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":99049500,"cuota_ini_20":19809900,"cuota_inicial_20":19809900,"cuotas_3_ini":6603300,"cuotas_48":1650825,"precio_preventa":92218500,"cuota_ini_pre_20":18443700,"cuotas_3_ini_pre":6147900,"cuotas_48_pre":1536975,"descripcion_lindero":"LOTE NUMERO CIENTO TREINTA (130): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 131 y mide 31.12 metros; por el fondo, linda con Area verde y mide 11.70 metros; por la izquierda; linda con Lote Numero 129 y mide 37.19 metros. Área del Lote: 341.55 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-131',
    131,
    'M 13',
    'available',
    81838000,
    282.2,
    '[1253.1,828.9]'::jsonb,
    '{"pathD":"M 1263.9 872.7 L 1213 794.3 L 1247.7 792.5 L 1289.1 856.4 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":81838000,"cuota_ini_20":16367600,"cuota_inicial_20":16367600,"cuotas_3_ini":5455867,"cuotas_48":1363967,"precio_preventa":76194000,"cuota_ini_pre_20":15238800,"cuotas_3_ini_pre":5079600,"cuotas_48_pre":1269900,"descripcion_lindero":"LOTE NUMERO CIENTO TREINTA Y UNO (131): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 132 y mide 25.32 metros; por el fondo, linda con Area verde y mide 11.56 metros; por la izquierda; linda con Lote Numero 130 y mide 31.12 metros. Área del Lote: 282.20 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-132',
    132,
    'M 13',
    'available',
    82362900,
    284.01,
    '[1285.3,816.9]'::jsonb,
    '{"pathD":"M 1289.1 856.4 L 1247.7 792.5 L 1261.7 791.8 L 1282.5 779 L 1319.8 836.4 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":82362900,"cuota_ini_20":16472580,"cuota_inicial_20":16472580,"cuotas_3_ini":5490860,"cuotas_48":1372715,"precio_preventa":76682700,"cuota_ini_pre_20":15336540,"cuotas_3_ini_pre":5112180,"cuotas_48_pre":1278045,"descripcion_lindero":"LOTE NUMERO CIENTO TREINTA Y DOS (132): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 12.18 metros; por la derecha entrando, linda con Lote Numero 133 y mide 22.80 metros; por el fondo, linda con Area verde y mide 12.80 metros; por la izquierda; linda con Lote Numero 131 y mide 25.32 metros. Área del Lote: 284.01 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-133',
    133,
    'M 13',
    'available',
    75687100,
    260.99,
    '[1316.3,797.3]'::jsonb,
    '{"pathD":"M 1312.3 760.7 L 1348.6 817.7 L 1319.8 836.4 L 1282.5 779 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":75687100,"cuota_ini_20":15137420,"cuota_inicial_20":15137420,"cuotas_3_ini":5045807,"cuotas_48":1261452,"precio_preventa":70467300,"cuota_ini_pre_20":14093460,"cuotas_3_ini_pre":4697820,"cuotas_48_pre":1174455,"descripcion_lindero":"LOTE NUMERO CIENTO TREINTA Y TRES (133): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 11.42 metros; por la derecha entrando, linda con Lote 133ª y mide 22.50 metros; por el fondo, linda con Area verde y mide 11.63 metros; por la izquierda; linda con Lote Numero 132 y mide 22.80 metros. Área del Lote: 260.99 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-133-A',
    133,
    'M 13',
    'available',
    83853500,
    289.15,
    '[1343.3,777.7]'::jsonb,
    '{"pathD":"M 1334.3 730.5 L 1312.3 760.7 L 1348.6 817.7 L 1378.4 798.4 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":83853500,"cuota_ini_20":16770700,"cuota_inicial_20":16770700,"cuotas_3_ini":5590233,"cuotas_48":1397558,"precio_preventa":78070500,"cuota_ini_pre_20":15614100,"cuotas_3_ini_pre":5204700,"cuotas_48_pre":1301175,"descripcion_lindero":"LOTE NUMERO CIENTO TREINTA Y TRES A (133A): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 11.80 metros; por la derecha entrando, linda con Lote 134 y mide 26.94 metros; por el fondo, linda con Área verde y mide 12.43 metros; por la izquierda; linda con Lote Numero 133 y mide 22.50 metros. Área del Lote: 289.15 M3","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-134',
    134,
    'M 13',
    'sold',
    97513600,
    314.56,
    '[1368.8,752.3]'::jsonb,
    '{"pathD":"M 1354.8 702.3 L 1334.3 730.5 L 1378.4 798.4 L 1405.7 780.7 Z"}'::jsonb,
    '{"ubicacion":"PARQUE","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":97513600,"cuota_ini_20":19502720,"cuota_inicial_20":19502720,"cuotas_3_ini":6500907,"cuotas_48":1625227,"precio_preventa":88076800,"cuota_ini_pre_20":17615360,"cuotas_3_ini_pre":5871787,"cuotas_48_pre":1467947,"descripcion_lindero":"LOTE NUMERO CIENTO TREINTA Y CUATRO (134): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.84 metros; por la derecha entrando, linda con Parqueadero y zona verde y mide 31.09 metros; por el fondo, linda con Área verde y mide 11.61 metros; por la izquierda; linda con Lote 133A y mide 26.94 metros. Área del Lote: 314.56 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-135',
    135,
    'M 19',
    'sold',
    119579400,
    385.74,
    '[1421.5,701]'::jsonb,
    '{"pathD":"M 1440.4 758.2 L 1378.2 662.5 L 1401.3 642.8 L 1465.2 741.2 L 1455.3 748.5 Z"}'::jsonb,
    '{"ubicacion":"PARQUE","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":119579400,"cuota_ini_20":23915880,"cuota_inicial_20":23915880,"cuotas_3_ini":7971960,"cuotas_48":1992990,"precio_preventa":108007200,"cuota_ini_pre_20":21601440,"cuotas_3_ini_pre":7200480,"cuotas_48_pre":1800120,"descripcion_lindero":"LOTE NUMERO CIENTO TREINTA Y CINCO (135): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.01 metros (línea quebrada); por la derecha entrando, linda con Lote Numero 136 y mide 39.05 metros; por el fondo, linda con Area verde y mide 10.09 metros; por la izquierda; linda con Lote Numero parqueadero y zona verde y mide 37.96 metros. Área del Lote: 385.74 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-136',
    136,
    'M 19',
    'sold',
    119691000,
    386.1,
    '[1444.6,680.7]'::jsonb,
    '{"pathD":"M 1465.2 741.2 L 1401.3 642.8 L 1431.3 629.1 L 1482.4 705.3 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":119691000,"cuota_ini_20":23938200,"cuota_inicial_20":23938200,"cuotas_3_ini":7979400,"cuotas_48":1994850,"precio_preventa":108108000,"cuota_ini_pre_20":21621600,"cuotas_3_ini_pre":7207200,"cuotas_48_pre":1801800,"descripcion_lindero":"LOTE NUMERO CIENTO TREINTA Y SEIS (136): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 13.24 metros; por la derecha entrando, linda con Lote Numero 137 y mide 30.54 metros; por el fondo, linda con Area verde y mide 10.98 metros; por la izquierda; linda con Lote Numero 135 y mide 39.05 metros. Área del Lote: 386.10 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-137',
    137,
    'M 19',
    'reserved',
    162787200,
    525.12,
    '[1480.8,650]'::jsonb,
    '{"pathD":"M 1431.3 629.1 L 1469 616.4 L 1490.1 603.8 L 1527.7 652.6 L 1513.3 663.8 L 1511.2 666 L 1482.4 705.3 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":162787200,"cuota_ini_20":32557440,"cuota_inicial_20":32557440,"cuotas_3_ini":10852480,"cuotas_48":2713120,"precio_preventa":147033600,"cuota_ini_pre_20":29406720,"cuotas_3_ini_pre":9802240,"cuotas_48_pre":2450560,"descripcion_lindero":"LOTE NUMERO CIENTO TREINTA Y SIETE (137): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 23.29 metros (línea quebrada); por la derecha entrando, linda con Lote Numero 138 y mide 20.49 metros; por el fondo, linda con Area verde y mide 21.40 metros; por la izquierda; linda con Lote Numero 136 y mide 30.54 metros. Área del Lote: 525.12 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-138',
    138,
    'M 19',
    'reserved',
    132525000,
    427.5,
    '[1533.8,609.5]'::jsonb,
    '{"pathD":"M 1527.7 652.6 L 1490.1 603.8 L 1513.6 589.8 L 1534.1 565.5 L 1536.2 560.5 L 1577.6 613.5 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":132525000,"cuota_ini_20":26505000,"cuota_inicial_20":26505000,"cuotas_3_ini":8835000,"cuotas_48":2208750,"precio_preventa":119700000,"cuota_ini_pre_20":23940000,"cuotas_3_ini_pre":7980000,"cuotas_48_pre":1995000,"descripcion_lindero":"LOTE NUMERO CIENTO TREINTA Y OCHO (138): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 21.10 metros; por la derecha entrando, linda con Lote Numero 139 y mide 22.39 metros; por el fondo, linda con Area verde y mide 19.68 metros (línea quebrada); por la izquierda; linda con Lote Numero 137 y mide 20.49 metros. Área del Lote: 427.50 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-139',
    139,
    'M 19',
    'reserved',
    115478100,
    372.51,
    '[1570.6,568.7]'::jsonb,
    '{"pathD":"M 1540.8 549.6 L 1555.3 516 L 1611.3 587.2 L 1577.6 613.5 L 1536.2 560.5 Z"}'::jsonb,
    '{"ubicacion":"CALLEJON","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":115478100,"cuota_ini_20":23095620,"cuota_inicial_20":23095620,"cuotas_3_ini":7698540,"cuotas_48":1924635,"precio_preventa":104302800,"cuota_ini_pre_20":20860560,"cuotas_3_ini_pre":6953520,"cuotas_48_pre":1738380,"descripcion_lindero":"LOTE NUMERO CIENTO TREINTA Y NUEVE (139): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 14.21 metros; por la derecha entrando, linda con Sendero Peatonal y mide 30.15 metros; por el fondo, linda con Area verde y mide 16.11 metros; por la izquierda; linda con Lote Numero 138 y mide 22.39 metros. Área del Lote: 372.51 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-140',
    140,
    'M 19',
    'available',
    127270500,
    410.55,
    '[1604.5,533.8]'::jsonb,
    '{"pathD":"M 1577 481.9 L 1656.2 558.2 L 1640.7 564.7 L 1637.9 566.3 L 1618.4 581.7 L 1559.3 506.6 L 1565.2 497.5 Z"}'::jsonb,
    '{"ubicacion":"CALLEJON","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":127270500,"cuota_ini_20":25454100,"cuota_inicial_20":25454100,"cuotas_3_ini":8484700,"cuotas_48":2121175,"precio_preventa":114954000,"cuota_ini_pre_20":22990800,"cuotas_3_ini_pre":7663600,"cuotas_48_pre":1915900,"descripcion_lindero":"LOTE NUMERO CIENTO CUARENTA (140): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 14.94 metros (línea quebrada); por la derecha entrando, linda con Lote Numero 141 y mide 36.61 metros; por el fondo, linda con Area verde y mide 10.11 metros; por la izquierda; linda con Lote Numero 139 y mide 31.80 metros. Área del Lote: 410.55 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-141',
    141,
    'M 19',
    'available',
    123070000,
    397,
    '[1628.7,511.2]'::jsonb,
    '{"pathD":"M 1686.7 545.5 L 1656.2 558.2 L 1577 481.9 L 1582 475.2 L 1594.5 457 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":123070000,"cuota_ini_20":24614000,"cuota_inicial_20":24614000,"cuotas_3_ini":8204667,"cuotas_48":2051167,"precio_preventa":111160000,"cuota_ini_pre_20":22232000,"cuotas_3_ini_pre":7410667,"cuotas_48_pre":1852667,"descripcion_lindero":"LOTE NUMERO CIENTO CUARENTA Y UNO (141): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 11.01 metros; por la derecha entrando, linda con Lote Numero 142 y mide 42.51 metros; por el fondo, linda con Area verde y mide 10.12 metros (línea quebrada); por la izquierda; linda con Lote Numero 140 y mide 36.61 metros. Área del Lote: 397.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-142',
    142,
    'M 19',
    'available',
    137439700,
    473.93,
    '[1654.3,492.5]'::jsonb,
    '{"pathD":"M 1698.3 540.6 L 1686.7 545.5 L 1594.5 457 L 1621.4 437 L 1713.6 525.4 L 1700.3 539.3 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":137439700,"cuota_ini_20":27487940,"cuota_inicial_20":27487940,"cuotas_3_ini":9162647,"cuotas_48":2290662,"precio_preventa":127961100,"cuota_ini_pre_20":25592220,"cuotas_3_ini_pre":8530740,"cuotas_48_pre":2132685,"descripcion_lindero":"LOTE NUMERO CIENTO CUARENTA Y DOS (142): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 11.36 metros (línea quebrada); por la derecha entrando, linda con lote 143 y mide 42.52 metros; por el fondo, linda con Area verde y mide 11.15 metros; por la izquierda; linda con Lote Numero 141 y mide 42.51 metros. Área del Lote: 473.93 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-143',
    143,
    'M 19',
    'available',
    128069800,
    441.62,
    '[1681.2,472]'::jsonb,
    '{"pathD":"M 1654.5 423 L 1736.5 501.6 L 1713.6 525.4 L 1621.4 437 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":128069800,"cuota_ini_20":25613960,"cuota_inicial_20":25613960,"cuotas_3_ini":8537987,"cuotas_48":2134497,"precio_preventa":119237400,"cuota_ini_pre_20":23847480,"cuotas_3_ini_pre":7949160,"cuotas_48_pre":1987290,"descripcion_lindero":"LOTE NUMERO CIENTO CUARENTA Y TRES (143): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 11.00 metros; por la derecha entrando, linda con Lote Numero 144 y mide 37.77 metros; por el fondo, linda con Area verde y mide 11.98 metros; por la izquierda; linda con Lote 142 y mide 42.52 metros. Área del Lote: 441.62 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-144',
    144,
    'M 19',
    'available',
    105745600,
    364.64,
    '[1707.2,452.9]'::jsonb,
    '{"pathD":"M 1681 406.7 L 1757.3 479.9 L 1736.5 501.6 L 1654.5 423 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":105745600,"cuota_ini_20":21149120,"cuota_inicial_20":21149120,"cuotas_3_ini":7049707,"cuotas_48":1762427,"precio_preventa":98452800,"cuota_ini_pre_20":19690560,"cuotas_3_ini_pre":6563520,"cuotas_48_pre":1640880,"descripcion_lindero":"LOTE NUMERO CIENTO CUARENTA Y CUATRO (144): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 145 y mide 35.16 metros; por el fondo, linda con Area verde y mide 10.34 metros; por la izquierda; linda con Lote Numero 143 y mide 37.77 metros. Área del Lote: 364.64 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-145',
    145,
    'M 19',
    'available',
    100708300,
    347.27,
    '[1729.7,433.4]'::jsonb,
    '{"pathD":"M 1778.1 458.2 L 1757.3 479.9 L 1681 406.7 L 1703.7 386.8 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":100708300,"cuota_ini_20":20141660,"cuota_inicial_20":20141660,"cuotas_3_ini":6713887,"cuotas_48":1678472,"precio_preventa":93762900,"cuota_ini_pre_20":18752580,"cuotas_3_ini_pre":6250860,"cuotas_48_pre":1562715,"descripcion_lindero":"LOTE NUMERO CIENTO CUARENTA Y CINCO (145): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 146 y mide 34.30 metros; por el fondo, linda con Area verde y mide 10.04 metros; por la izquierda; linda con Lote Numero 144 y mide 35.16 metros. Área del Lote: 347.27 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-146',
    146,
    'M 19',
    'available',
    97457400,
    336.06,
    '[1751.6,413.1]'::jsonb,
    '{"pathD":"M 1703.7 386.8 L 1727.5 368 L 1798.9 436.5 L 1778.1 458.2 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":97457400,"cuota_ini_20":19491480,"cuota_inicial_20":19491480,"cuotas_3_ini":6497160,"cuotas_48":1624290,"precio_preventa":90736200,"cuota_ini_pre_20":18147240,"cuotas_3_ini_pre":6049080,"cuotas_48_pre":1512270,"descripcion_lindero":"LOTE NUMERO CIENTO CUARENTA Y SEIS (146): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 147 y mide 32.92 metros; por el fondo, linda con Area verde y mide 10.10 metros; por la izquierda; linda con Lote Numero 145 y mide 34.30 metros. Área del Lote: 336.06 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-147',
    147,
    'M 19',
    'available',
    96546800,
    332.92,
    '[1773,391.4]'::jsonb,
    '{"pathD":"M 1819.7 414.8 L 1798.9 436.5 L 1727.5 368 L 1746.6 344.8 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":96546800,"cuota_ini_20":19309360,"cuota_inicial_20":19309360,"cuotas_3_ini":6436453,"cuotas_48":1609113,"precio_preventa":89888400,"cuota_ini_pre_20":17977680,"cuotas_3_ini_pre":5992560,"cuotas_48_pre":1498140,"descripcion_lindero":"LOTE NUMERO CIENTO CUARENTA Y SIETE (147): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 148 y mide 33.67 metros; por el fondo, linda con Area verde y mide 10.03 metros; por la izquierda; linda con Lote Numero 146 y mide 32.92 metros. Área del Lote: 332.92 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-148',
    148,
    'M 19',
    'available',
    98399900,
    339.31,
    '[1793.2,368.7]'::jsonb,
    '{"pathD":"M 1746.6 344.8 L 1766.3 322 L 1840.5 393.1 L 1819.7 414.8 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":98399900,"cuota_ini_20":19679980,"cuota_inicial_20":19679980,"cuotas_3_ini":6559993,"cuotas_48":1639998,"precio_preventa":91613700,"cuota_ini_pre_20":18322740,"cuotas_3_ini_pre":6107580,"cuotas_48_pre":1526895,"descripcion_lindero":"LOTE NUMERO CIENTO CUARENTA Y OCHO (148): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 149 y mide 34.19 metros; por el fondo, linda con Area verde y mide 10.01 metros; por la izquierda; linda con Lote Numero 147 y mide 33.67 metros. Área del Lote: 339.31 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-149',
    149,
    'M 19',
    'available',
    98803000,
    340.7,
    '[1814.2,346.3]'::jsonb,
    '{"pathD":"M 1861.3 371.4 L 1840.5 393.1 L 1766.3 322 L 1787.6 300.8 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":98803000,"cuota_ini_20":19760600,"cuota_inicial_20":19760600,"cuotas_3_ini":6586867,"cuotas_48":1646717,"precio_preventa":91989000,"cuota_ini_pre_20":18397800,"cuotas_3_ini_pre":6132600,"cuotas_48_pre":1533150,"descripcion_lindero":"LOTE NUMERO CIENTO CUARENTA Y NUEVE (149): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 150 y mide 33.94 metros; por el fondo, linda con Area verde y mide 10.00 metros; por la izquierda; linda con Lote Numero 148 y mide 34.19 metros. Área del Lote: 340.70 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-150',
    150,
    'M 19',
    'available',
    94763300,
    326.77,
    '[1835.9,327]'::jsonb,
    '{"pathD":"M 1882.1 349.7 L 1861.3 371.4 L 1787.6 300.8 L 1813.9 284.4 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":94763300,"cuota_ini_20":18952660,"cuota_inicial_20":18952660,"cuotas_3_ini":6317553,"cuotas_48":1579388,"precio_preventa":88227900,"cuota_ini_pre_20":17645580,"cuotas_3_ini_pre":5881860,"cuotas_48_pre":1470465,"descripcion_lindero":"LOTE NUMERO CIENTO CINCUENTA (150): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 151 y mide 31.41 metros; por el fondo, linda con Area verde y mide 10.32 metros; por la izquierda; linda con Lote Numero 149 y mide 33.94 metros. Área del Lote: 326.77 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-151',
    151,
    'M 19',
    'reserved',
    87408900,
    301.41,
    '[1859.4,308]'::jsonb,
    '{"pathD":"M 1813.9 284.4 L 1840.2 267.9 L 1902.9 328 L 1882.1 349.7 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":87408900,"cuota_ini_20":17481780,"cuota_inicial_20":17481780,"cuotas_3_ini":5827260,"cuotas_48":1456815,"precio_preventa":81380700,"cuota_ini_pre_20":16276140,"cuotas_3_ini_pre":5425380,"cuotas_48_pre":1356345,"descripcion_lindero":"LOTE NUMERO CIENTO CINCUENTA Y UNO (151): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 152 y mide 28.87 metros; por el fondo, linda con Area verde y mide 10.32 metros; por la izquierda; linda con Lote Numero 150 y mide 31.41 metros. Área del Lote: 301.41 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-152',
    152,
    'M 19',
    'reserved',
    89560700,
    308.83,
    '[1883.4,287.7]'::jsonb,
    '{"pathD":"M 1925.8 304.1 L 1902.9 328 L 1840.2 267.9 L 1864.2 249.3 L 1866.3 247.1 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":89560700,"cuota_ini_20":17912140,"cuota_inicial_20":17912140,"cuotas_3_ini":5970713,"cuotas_48":1492678,"precio_preventa":83384100,"cuota_ini_pre_20":16676820,"cuotas_3_ini_pre":5558940,"cuotas_48_pre":1389735,"descripcion_lindero":"LOTE NUMERO CIENTO CINCUENTA Y DOS (152): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 11.00 metros; por la derecha entrando, linda con Lote 170 y mide 27.41 metros; por el fondo, linda con Area verde y mide 10.11 metros; por la izquierda; linda con Lote Numero 151 y mide 28.87 metros. Área del Lote: 308.83 M2.","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-153',
    153,
    'M 20',
    'available',
    86440300,
    298.07,
    '[1964.9,364.4]'::jsonb,
    '{"pathD":"M 2007.9 383.5 L 1987.1 405.2 L 1922 342.8 L 1936.6 327.6 L 1949.3 327.3 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":86440300,"cuota_ini_20":17288060,"cuota_inicial_20":17288060,"cuotas_3_ini":5762687,"cuotas_48":1440672,"precio_preventa":80478900,"cuota_ini_pre_20":16095780,"cuotas_3_ini_pre":5365260,"cuotas_48_pre":1341315,"descripcion_lindero":"LOTE NUMERO CIENTO CINCUENTA Y TRES (153): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 11.71 metros; por la derecha entrando, linda con Carrera Numero 9 y mide 30.00 metros; por el fondo, linda con Lote Numero 169 y mide 10.00 metros; por la izquierda; linda con Lote Numero 154 y mide 27.00 metros. Área del Lote: 298.07 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-154',
    154,
    'M 20',
    'available',
    82500000,
    300,
    '[1943.8,385.5]'::jsonb,
    '{"pathD":"M 1966.3 426.9 L 1901.2 364.5 L 1922 342.8 L 1987.1 405.2 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":82500000,"cuota_ini_20":16500000,"cuota_inicial_20":16500000,"cuotas_3_ini":5500000,"cuotas_48":1375000,"precio_preventa":76500000,"cuota_ini_pre_20":15300000,"cuotas_3_ini_pre":5100000,"cuotas_48_pre":1275000,"descripcion_lindero":"LOTE NUMERO CIENTO CINCUENTA Y CUATRO (154): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 155 y mide 30.00 metros; por el fondo, linda con Lote Numero 168 y mide 10.00 metros; por la izquierda; linda con Lote Numero 153 y mide 30.00 metros. Área del Lote: 300.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-155',
    155,
    'M 20',
    'available',
    82500000,
    300,
    '[1923.7,405.9]'::jsonb,
    '{"pathD":"M 1880.4 386.2 L 1901.2 364.5 L 1966.3 426.9 L 1945.5 448.6 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":82500000,"cuota_ini_20":16500000,"cuota_inicial_20":16500000,"cuotas_3_ini":5500000,"cuotas_48":1375000,"precio_preventa":76500000,"cuota_ini_pre_20":15300000,"cuotas_3_ini_pre":5100000,"cuotas_48_pre":1275000,"descripcion_lindero":"LOTE NUMERO CIENTO CINCUENTA Y CINCO (155): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 156 y mide 30.00 metros; por el fondo, linda con Lote Numero 167 y mide 10.00 metros; por la izquierda; linda con Lote Numero 154 y mide 30.00 metros. Área del Lote: 300.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-156',
    156,
    'M 20',
    'available',
    82500000,
    300,
    '[1902.2,428.9]'::jsonb,
    '{"pathD":"M 1945.5 448.6 L 1924.7 470.3 L 1859.6 407.9 L 1880.4 386.2 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":82500000,"cuota_ini_20":16500000,"cuota_inicial_20":16500000,"cuotas_3_ini":5500000,"cuotas_48":1375000,"precio_preventa":76500000,"cuota_ini_pre_20":15300000,"cuotas_3_ini_pre":5100000,"cuotas_48_pre":1275000,"descripcion_lindero":"LOTE NUMERO CIENTO CINCUENTA Y SEIS (156): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 157 y mide 30.00 metros; por el fondo, linda con Lote Numero 166 y mide 10.00 metros; por la izquierda; linda con Lote Numero 155 y mide 30.00 metros. Área del Lote: 300.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-157',
    157,
    'M 20',
    'available',
    82500000,
    300,
    '[1881.8,449.9]'::jsonb,
    '{"pathD":"M 1838.8 429.6 L 1859.6 407.9 L 1924.7 470.3 L 1903.9 492 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":82500000,"cuota_ini_20":16500000,"cuota_inicial_20":16500000,"cuotas_3_ini":5500000,"cuotas_48":1375000,"precio_preventa":76500000,"cuota_ini_pre_20":15300000,"cuotas_3_ini_pre":5100000,"cuotas_48_pre":1275000,"descripcion_lindero":"LOTE NUMERO CIENTO CINCUENTA Y SIETE (157): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 158 y mide 30.00 metros; por el fondo, linda con Lote Numero 165 y mide 10.00 metros; por la izquierda; linda con Lote Numero 156 y mide 30.00 metros. Área del Lote: 300.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-158',
    158,
    'M 20',
    'available',
    82500000,
    300,
    '[1861.3,470.9]'::jsonb,
    '{"pathD":"M 1903.9 492 L 1883.1 513.7 L 1818 451.3 L 1838.8 429.6 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":82500000,"cuota_ini_20":16500000,"cuota_inicial_20":16500000,"cuotas_3_ini":5500000,"cuotas_48":1375000,"precio_preventa":76500000,"cuota_ini_pre_20":15300000,"cuotas_3_ini_pre":5100000,"cuotas_48_pre":1275000,"descripcion_lindero":"LOTE NUMERO CIENTO CINCUENTA Y OCHO (158): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 159 y mide 30.00 metros; por el fondo, linda con Lote Numero 164 y mide 10.00 metros; por la izquierda; linda con Lote Numero 157 y mide 30.00 metros. Área del Lote: 300.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-159',
    159,
    'M 20',
    'available',
    82500000,
    300,
    '[1840.2,493.3]'::jsonb,
    '{"pathD":"M 1797.2 473 L 1818 451.3 L 1883.1 513.7 L 1862.3 535.4 L 1829.8 504.2 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":82500000,"cuota_ini_20":16500000,"cuota_inicial_20":16500000,"cuotas_3_ini":5500000,"cuotas_48":1375000,"precio_preventa":76500000,"cuota_ini_pre_20":15300000,"cuotas_3_ini_pre":5100000,"cuotas_48_pre":1275000,"descripcion_lindero":"LOTE NUMERO CIENTO CINCUENTA Y NUEVE (159): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 160, Lote Numero 161 y mide 30.00 metros; por el fondo, linda con Lote Numero 163 y mide 10.00 metros; por la izquierda; linda con Lote Numero 158 y mide 30.00 metros. Área del Lote: 300.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-160',
    160,
    'M 20',
    'available',
    173088500,
    558.35,
    '[1774.9,528.4]'::jsonb,
    '{"pathD":"M 1829.8 504.2 L 1757.5 579.6 L 1725.3 565.5 L 1722.4 551 L 1797.2 473 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":173088500,"cuota_ini_20":34617700,"cuota_inicial_20":34617700,"cuotas_3_ini":11539233,"cuotas_48":2884808,"precio_preventa":156338000,"cuota_ini_pre_20":31267600,"cuotas_3_ini_pre":10422533,"cuotas_48_pre":2605633,"descripcion_lindero":"LOTE NUMERO CIENTO SESENTA (160): Por el frente, linda con acceso vehicular al lote y Carrera Numero 8 y mide 17.45 metros; por la derecha entrando, linda con Lote Numero 161 y mide 34.77 metros; por el fondo, linda con Lote Numero 159 y mide 15.00 metros; por la izquierda; linda con Calle Numero 9 y mide 35.96 metros. Área del Lote: 558.35 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-161',
    161,
    'M 20',
    'available',
    141018300,
    486.27,
    '[1811.7,555.1]'::jsonb,
    '{"pathD":"M 1862.3 535.4 L 1797.3 602.9 L 1780.1 589.5 L 1757.5 579.6 L 1829.8 504.2 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":141018300,"cuota_ini_20":28203660,"cuota_inicial_20":28203660,"cuotas_3_ini":9401220,"cuotas_48":2350305,"precio_preventa":131292900,"cuota_ini_pre_20":26258580,"cuotas_3_ini_pre":8752860,"cuotas_48_pre":2188215,"descripcion_lindero":"LOTE NUMERO CIENTO SESENTA Y UNO (161): Por el frente, linda con acceso vehicular al lote y Carrera Numero 8 y mide 15.48 metros (línea quebrada); por la derecha entrando, linda con Lote Numero 162 y mide 37.17 metros; por el fondo, linda con Lote Numero 159 y mide 15.00 metros; por la izquierda; linda con Lote Numero 160 y mide 34.76 metros. Área del Lote: 486.27 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-162',
    162,
    'M 20',
    'available',
    202569500,
    653.45,
    '[1863.9,586.5]'::jsonb,
    '{"pathD":"M 1927.4 597.7 L 1911.1 614.8 L 1904 617.5 L 1812.3 612.4 L 1807.2 610.5 L 1797.3 602.9 L 1862.3 535.4 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":202569500,"cuota_ini_20":40513900,"cuota_inicial_20":40513900,"cuotas_3_ini":13504633,"cuotas_48":3376158,"precio_preventa":182966000,"cuota_ini_pre_20":36593200,"cuotas_3_ini_pre":12197733,"cuotas_48_pre":3049433,"descripcion_lindero":"LOTE NUMERO CIENTO SESENTA Y DOS (162): Por el frente, linda con acceso vehicular al lote y Carrera Numero 8 y mide 47.00 metros (línea quebrada); por la derecha entrando, linda con Lote Numero 163 y mide 30.00 metros; por la izquierda; linda con Lote Numero 161 mide 31.17 metros. Área del Lote: 653.45 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-163',
    163,
    'M 20',
    'available',
    82500000,
    300,
    '[1905.6,555]'::jsonb,
    '{"pathD":"M 1948.2 576.1 L 1927.4 597.7 L 1862.3 535.4 L 1883.1 513.7 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":82500000,"cuota_ini_20":16500000,"cuota_inicial_20":16500000,"cuotas_3_ini":5500000,"cuotas_48":1375000,"precio_preventa":76500000,"cuota_ini_pre_20":15300000,"cuotas_3_ini_pre":5100000,"cuotas_48_pre":1275000,"descripcion_lindero":"LOTE NUMERO CIENTO SESENTA Y TRES (163): Por el frente, linda con acceso vehicular al lote y Calle Numero 6 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 164 y mide 30.00 metros; por el fondo, linda con Lote Numero 159 y mide 10.00 metros; por la izquierda; linda con Lote Numero 162 mide 30.00 metros. Área del Lote: 300.00M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-164',
    164,
    'M 20',
    'available',
    82500000,
    300,
    '[1925.7,534.7]'::jsonb,
    '{"pathD":"M 1969 554.4 L 1948.2 576.1 L 1883.1 513.7 L 1903.9 492 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":82500000,"cuota_ini_20":16500000,"cuota_inicial_20":16500000,"cuotas_3_ini":5500000,"cuotas_48":1375000,"precio_preventa":76500000,"cuota_ini_pre_20":15300000,"cuotas_3_ini_pre":5100000,"cuotas_48_pre":1275000,"descripcion_lindero":"LOTE NUMERO CIENTO SESENTA Y CUATRO (164): Por el frente, linda con acceso vehicular al lote y Calle Numero 6 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 165 y mide 30.00 metros; por el fondo, linda con Lote Numero 158 y mide 10.00 metros; por la izquierda; linda con Lote Numero 163 mide 30.00 metros. Área del Lote: 300.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-165',
    165,
    'M 20',
    'available',
    82500000,
    300,
    '[1946.8,512.3]'::jsonb,
    '{"pathD":"M 1989.8 532.7 L 1969 554.4 L 1903.9 492 L 1924.7 470.3 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":82500000,"cuota_ini_20":16500000,"cuota_inicial_20":16500000,"cuotas_3_ini":5500000,"cuotas_48":1375000,"precio_preventa":76500000,"cuota_ini_pre_20":15300000,"cuotas_3_ini_pre":5100000,"cuotas_48_pre":1275000,"descripcion_lindero":"LOTE NUMERO CIENTO SESENTA Y CINCO (165): Por el frente, linda con acceso vehicular al lote y Calle Numero 6 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 166 y mide 30.00 metros; por el fondo, linda con Lote Numero 157 y mide 10.00 metros; por la izquierda; linda con Lote Numero 164 mide 30.00 metros. Área del Lote :300.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-166',
    166,
    'M 20',
    'available',
    82500000,
    300,
    '[1968,489.9]'::jsonb,
    '{"pathD":"M 2010.6 511 L 1989.8 532.7 L 1924.7 470.3 L 1945.5 448.6 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":82500000,"cuota_ini_20":16500000,"cuota_inicial_20":16500000,"cuotas_3_ini":5500000,"cuotas_48":1375000,"precio_preventa":76500000,"cuota_ini_pre_20":15300000,"cuotas_3_ini_pre":5100000,"cuotas_48_pre":1275000,"descripcion_lindero":"LOTE NUMERO CIENTO SESENTA Y SEIS (166): Por el frente, linda con acceso vehicular al lote y Calle Numero 6 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 167 y mide 30.00 metros; por el fondo, linda con Lote Numero 156 y mide 10.00 metros; por la izquierda; linda con Lote Numero 165 mide 30.00 metros. Área del Lote:300.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-167',
    167,
    'M 20',
    'available',
    82500000,
    300,
    '[1988.1,469.6]'::jsonb,
    '{"pathD":"M 1966.3 426.9 L 2031.4 489.3 L 2010.6 511 L 1945.5 448.6 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":82500000,"cuota_ini_20":16500000,"cuota_inicial_20":16500000,"cuotas_3_ini":5500000,"cuotas_48":1375000,"precio_preventa":76500000,"cuota_ini_pre_20":15300000,"cuotas_3_ini_pre":5100000,"cuotas_48_pre":1275000,"descripcion_lindero":"LOTE NUMERO CIENTO SESENTA Y SIETE (167): Por el frente, linda con acceso vehicular al lote y Calle Numero 6 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 168 y mide 30.00 metros; por el fondo, linda con Lote Numero 155 y mide 10.00 metros; por la izquierda; linda con Lote Numero 166 mide 30.00 metros. Área del Lote: 300.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-168',
    168,
    'M 20',
    'available',
    82500000,
    300,
    '[2009.6,446.6]'::jsonb,
    '{"pathD":"M 2052.2 467.6 L 2031.4 489.3 L 1966.3 426.9 L 1987.1 405.2 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":82500000,"cuota_ini_20":16500000,"cuota_inicial_20":16500000,"cuotas_3_ini":5500000,"cuotas_48":1375000,"precio_preventa":76500000,"cuota_ini_pre_20":15300000,"cuotas_3_ini_pre":5100000,"cuotas_48_pre":1275000,"descripcion_lindero":"LOTE NUMERO CIENTO SESENTA Y OCHO (168): Por el frente, linda con acceso vehicular al lote y Calle Numero 16y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 169 y mide 30.00 metros; por el fondo, linda con Lote Numero 154 y mide 10.00 metros; por la izquierda; linda con Lote Numero 167 mide 30.00 metros. Área del Lote: 300.00   M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-169',
    169,
    'M 20',
    'available',
    86440300,
    298.07,
    '[2029.4,425.2]'::jsonb,
    '{"pathD":"M 2066.7 452.4 L 2052.2 467.6 L 1987.1 405.2 L 2007.9 383.5 L 2066.5 439.6 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":86440300,"cuota_ini_20":17288060,"cuota_inicial_20":17288060,"cuotas_3_ini":5762687,"cuotas_48":1440672,"precio_preventa":80478900,"cuota_ini_pre_20":16095780,"cuotas_3_ini_pre":5365260,"cuotas_48_pre":1341315,"descripcion_lindero":"LOTE NUMERO CIENTO SESENTA Y NUEVE (169): Por el frente, linda con acceso vehicular al lote y Calle Numero 6 y mide 11.71 metros; por la derecha entrando, linda con Carrera Numero 9 y mide 27.00 metros; por el fondo, linda con Lote Numero 153 y mide 10.00 metros; por la izquierda; linda con Lote Numero 168 mide 30.00 metros. Área del Lote: 298.07   M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-170',
    170,
    'M 19',
    'reserved',
    87861300,
    302.97,
    '[1907.3,263.7]'::jsonb,
    '{"pathD":"M 1948.6 280.3 L 1925.8 304.1 L 1866.3 247.1 L 1888.6 222.7 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":87861300,"cuota_ini_20":17572260,"cuota_inicial_20":17572260,"cuotas_3_ini":5857420,"cuotas_48":1464355,"precio_preventa":81801900,"cuota_ini_pre_20":16360380,"cuotas_3_ini_pre":5453460,"cuotas_48_pre":1363365,"descripcion_lindero":"LOTE NUMERO CIENTO SETENTA (170): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 11.00 metros; por la derecha entrando, linda con Lote Numero 171 y mide 27.67 metros; por el fondo, linda con Area verde y mide 11.00 metros; por la izquierda; linda con Lote 152 y mide 27.41 metros. Área del Lote: 302.97   M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-171',
    171,
    'M 19',
    'reserved',
    81519000,
    281.1,
    '[1928.4,240.5]'::jsonb,
    '{"pathD":"M 1907.5 199.2 L 1969.4 258.6 L 1948.6 280.3 L 1888.6 222.7 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":81519000,"cuota_ini_20":16303800,"cuota_inicial_20":16303800,"cuotas_3_ini":5434600,"cuotas_48":1358650,"precio_preventa":75897000,"cuota_ini_pre_20":15179400,"cuotas_3_ini_pre":5059800,"cuotas_48_pre":1264950,"descripcion_lindero":"LOTE NUMERO CIENTO SETENTA Y UNO (171): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 172 y mide 28.55 metros; por el fondo, linda con Area verde y mide 10.04 metros; por la izquierda; linda con Lote Numero 170 mide 27.67 metros. Área del Lote: 281.10   M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-172',
    172,
    'M 19',
    'reserved',
    83966600,
    289.54,
    '[1949.1,216.4]'::jsonb,
    '{"pathD":"M 1990.2 236.9 L 1969.4 258.6 L 1907.5 199.2 L 1926.5 175.8 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":83966600,"cuota_ini_20":16793320,"cuota_inicial_20":16793320,"cuotas_3_ini":5597773,"cuotas_48":1399443,"precio_preventa":78175800,"cuota_ini_pre_20":15635160,"cuotas_3_ini_pre":5211720,"cuotas_48_pre":1302930,"descripcion_lindero":"LOTE NUMERO CIENTO SETENTA Y DOS (172): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 173 y mide 29.36 metros; por el fondo, linda con Area verde y mide 10.03 metros; por la izquierda; linda con Lote Numero 171 mide 28.55 metros. Área del Lote: 289.54   M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-173',
    173,
    'M 19',
    'reserved',
    85874800,
    296.12,
    '[1968.3,195.6]'::jsonb,
    '{"pathD":"M 2011 215.2 L 1990.2 236.9 L 1926.5 175.8 L 1946.2 153.1 Z"}'::jsonb,
    '{"ubicacion":"CALLEJON","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":85874800,"cuota_ini_20":17174960,"cuota_inicial_20":17174960,"cuotas_3_ini":5724987,"cuotas_48":1431247,"precio_preventa":79952400,"cuota_ini_pre_20":15990480,"cuotas_3_ini_pre":5330160,"cuotas_48_pre":1332540,"descripcion_lindero":"LOTE NUMERO CIENTO SETENTA Y TRES (173): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 174 y mide 29.86 metros; por el fondo, linda con Area verde y mide 10.01 metros; por la izquierda; linda con Lote Numero 172 mide 29.36 metros. Área del Lote: 296.12   M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-174',
    174,
    'M 19',
    'reserved',
    128011800,
    441.42,
    '[2001.3,161.8]'::jsonb,
    '{"pathD":"M 2017.3 208.7 L 1953.6 147.9 L 1963.6 140.9 L 1999 116.9 L 2009.4 114 L 2041 201 Z"}'::jsonb,
    '{"ubicacion":"CALLEJON","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":128011800,"cuota_ini_20":25602360,"cuota_inicial_20":25602360,"cuotas_3_ini":8534120,"cuotas_48":2133530,"precio_preventa":119183400,"cuota_ini_pre_20":23836680,"cuotas_3_ini_pre":7945560,"cuotas_48_pre":1986390,"descripcion_lindero":"LOTE NUMERO CIENTO SETENTA Y CUATRO (174): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 8.56 metros (línea quebrada); por la derecha entrando, linda con Lote 186 y mide 30.78 metros; por el fondo, linda con Area verde y mide 14.24 metros; por la izquierda; linda con Sendero Peatonal y mide 29.30 metros. Área del Lote: 441.42   M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-175',
    175,
    'M 22',
    'available',
    141465500,
    514.42,
    '[2031.2,285.3]'::jsonb,
    '{"pathD":"M 2070.7 318 L 2049.5 340.1 L 1984.4 277.7 L 2030.7 229.4 L 2035 226.5 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":141465500,"cuota_ini_20":28293100,"cuota_inicial_20":28293100,"cuotas_3_ini":9431033,"cuotas_48":2357758,"precio_preventa":131177100,"cuota_ini_pre_20":26235420,"cuotas_3_ini_pre":8745140,"cuotas_48_pre":2186285,"descripcion_lindero":"LOTE NUMERO CIENTO SETENTA Y CINCO (175): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 24.00 metros; por la derecha entrando, linda con Lote Numero 176 y mide 30.00 metros; por el fondo, linda con Lote Numero 177 y mide 10.20 metros; por la izquierda; linda con Lote Numero 185 y mide 32.66 metros. Área del Lote: 514.42   M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-176',
    176,
    'M 22',
    'available',
    86440300,
    298.07,
    '[2007.1,320.1]'::jsonb,
    '{"pathD":"M 2049.5 340.1 L 2028.7 361.8 L 1970.1 305.6 L 1969.9 292.9 L 1984.4 277.7 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":86440300,"cuota_ini_20":17288060,"cuota_inicial_20":17288060,"cuotas_3_ini":5762687,"cuotas_48":1440672,"precio_preventa":80478900,"cuota_ini_pre_20":16095780,"cuotas_3_ini_pre":5365260,"cuotas_48_pre":1341315,"descripcion_lindero":"LOTE NUMERO CIENTO SETENTA Y SEIS (176): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 11.71 metros; por la derecha entrando, linda con Carrera Numero 9 y mide 27.00 metros; por el fondo, linda con Lote Numero 177 y mide 10.00 metros; por la izquierda; linda con Lote Numero 175 y mide 30.00 metros. Área del Lote: 298.07   M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-177',
    177,
    'M 22',
    'available',
    108315000,
    373.5,
    '[2068.5,370.3]'::jsonb,
    '{"pathD":"M 2083.2 409.1 L 2073.7 404.9 L 2028.7 361.8 L 2049.5 340.1 L 2070.7 318 L 2106.8 410.6 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":108315000,"cuota_ini_20":21663000,"cuota_inicial_20":21663000,"cuotas_3_ini":7221000,"cuotas_48":1805250,"precio_preventa":100845000,"cuota_ini_pre_20":20169000,"cuotas_3_ini_pre":6723000,"cuotas_48_pre":1680750,"descripcion_lindero":"LOTE NUMERO CIENTO SETENTA Y SIETE (177): Por el frente, linda con acceso vehicular al lote y Calle Numero 6 y mide 32.15 metros (línea quebrada); por la derecha entrando, linda con Lote Numero 178 y mide 33.07 metros; por la izquierda; linda con Lote Numero 175, Lote Numero 176 y mide 20.20 metros. Área del Lote: 373.50   M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-178',
    178,
    'M 22',
    'available',
    139900750,
    508.73,
    '[2113.4,359.1]'::jsonb,
    '{"pathD":"M 2112.4 320.6 L 2142.4 322.4 L 2136.8 412.4 L 2106.8 410.6 L 2070.7 318 L 2082.4 318.7 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":139900750,"cuota_ini_20":27980150,"cuota_inicial_20":27980150,"cuotas_3_ini":9326717,"cuotas_48":2331679,"precio_preventa":129726150,"cuota_ini_pre_20":25945230,"cuotas_3_ini_pre":8648410,"cuotas_48_pre":2162103,"descripcion_lindero":"LOTE NUMERO CIENTO SETENTA Y OCHO (178): Por el frente, linda con acceso vehicular al lote y Calle Numero 6 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 179 y mide 30.00 metros; por el fondo, linda con Lote Numero 183, Lote Numero 184, Lote Numero 185 y mide 23.92 metros; por la izquierda; linda con Lote Numero 178 y mide 33.07 metros. Área del Lote: 508.73   M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-179',
    179,
    'M 22',
    'available',
    82500000,
    300,
    '[2113.4,359.1]'::jsonb,
    '{"pathD":"M 2112.4 320.6 L 2142.4 322.4 L 2136.8 412.4 L 2106.8 410.6 L 2070.7 318 L 2082.4 318.7 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":82500000,"cuota_ini_20":16500000,"cuota_inicial_20":16500000,"cuotas_3_ini":5500000,"cuotas_48":1375000,"precio_preventa":76500000,"cuota_ini_pre_20":15300000,"cuotas_3_ini_pre":5100000,"cuotas_48_pre":1275000,"descripcion_lindero":"LOTE NUMERO CIENTO SETENTA Y NUEVE (179): Por el frente, linda con acceso vehicular al lote y Calle Numero 6 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 180 y mide 30.00 metros; por el fondo, linda con Lote Numero 182 y mide 10.00 metros; por la izquierda; linda con Lote Numero 178 y mide 30.00 metros. Área del Lote: 300.00   M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-180',
    180,
    'M 22',
    'available',
    100406700,
    346.23,
    '[2186.7,370]'::jsonb,
    '{"pathD":"M 2172.4 324.3 L 2207.2 326.2 L 2202.2 407.5 L 2192.6 415.9 L 2166.8 414.3 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":100406700,"cuota_ini_20":20081340,"cuota_inicial_20":20081340,"cuotas_3_ini":6693780,"cuotas_48":1673445,"precio_preventa":93482100,"cuota_ini_pre_20":18696420,"cuotas_3_ini_pre":6232140,"cuotas_48_pre":1558035,"descripcion_lindero":"LOTE NUMERO CIENTO OCHENTA (180): Por el frente, linda con acceso vehicular al lote y Calle Numero 6 y mide 13.30 metros; por la derecha entrando, linda con Carrera Numero 10 y mide 27.10 metros; por el fondo, linda con Lote Numero 181 y mide 11.59 metros; por la izquierda; linda con Lote Numero 179 y mide 30.00 metros. Área del Lote: 346.23   M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-181',
    181,
    'M 22',
    'available',
    100070300,
    345.07,
    '[2192.6,280.5]'::jsonb,
    '{"pathD":"M 2212.2 245.5 L 2207.2 326.2 L 2172.4 324.3 L 2178 234.3 L 2203.8 235.9 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":100070300,"cuota_ini_20":20014060,"cuota_inicial_20":20014060,"cuotas_3_ini":6671353,"cuotas_48":1667838,"precio_preventa":93168900,"cuota_ini_pre_20":18633780,"cuotas_3_ini_pre":6211260,"cuotas_48_pre":1552815,"descripcion_lindero":"LOTE NUMERO CIENTO OCHENTA Y UNO (181): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 13.30 metros; por la derecha entrando, linda con Lote Numero 182 y mide 30.00 metros; por el fondo, linda con Lote Numero 180 y mide 11.59 metros; por la izquierda; linda con Carrera Numero 10 y mide 26.90 metros. Área del Lote: 345.07   M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-182',
    182,
    'M 22',
    'available',
    82500000,
    300,
    '[2160.2,278.4]'::jsonb,
    '{"pathD":"M 2172.4 324.3 L 2142.4 322.4 L 2148 232.5 L 2178 234.3 L 2172.4 324.3 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":82500000,"cuota_ini_20":16500000,"cuota_inicial_20":16500000,"cuotas_3_ini":5500000,"cuotas_48":1375000,"precio_preventa":76500000,"cuota_ini_pre_20":15300000,"cuotas_3_ini_pre":5100000,"cuotas_48_pre":1275000,"descripcion_lindero":"LOTE NUMERO CIENTO OCHENTA Y DOS (182): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 183 y mide 30.00 metros; por el fondo, linda con Lote Numero 179 y mide 10.00 metros; por la izquierda; linda con Lote Numero 181 y mide 30.00 metros. Área del Lote: 300.00   M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-183',
    183,
    'M 22',
    'available',
    82500000,
    300,
    '[2129.9,277.2]'::jsonb,
    '{"pathD":"M 2142.4 322.4 L 2112.4 320.6 L 2118 230.6 L 2148 232.5 L 2142.4 322.4 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":82500000,"cuota_ini_20":16500000,"cuota_inicial_20":16500000,"cuotas_3_ini":5500000,"cuotas_48":1375000,"precio_preventa":76500000,"cuota_ini_pre_20":15300000,"cuotas_3_ini_pre":5100000,"cuotas_48_pre":1275000,"descripcion_lindero":"LOTE NUMERO CIENTO OCHENTA Y TRES (183): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 184 y mide 30.00 metros; por el fondo, linda con Lote Numero 178 y mide 10.00 metros; por la izquierda; linda con Lote Numero 182 y mide 30.00 metros. Área del Lote: 300.00   M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-184',
    184,
    'M 22',
    'available',
    82500000,
    300,
    '[2100.2,274.6]'::jsonb,
    '{"pathD":"M 2088 228.7 L 2118 230.6 L 2112.4 320.6 L 2082.4 318.7 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":82500000,"cuota_ini_20":16500000,"cuota_inicial_20":16500000,"cuotas_3_ini":5500000,"cuotas_48":1375000,"precio_preventa":76500000,"cuota_ini_pre_20":15300000,"cuotas_3_ini_pre":5100000,"cuotas_48_pre":1275000,"descripcion_lindero":"LOTE NUMERO CIENTO OCHENTA Y CUATRO (184): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 185 y mide 30.00 metros; por el fondo, linda con Lote Numero 178 y mide 10.00 metros; por la izquierda; linda con Lote Numero 183 y mide 30.00 metros. Área del Lote: 300.00   M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-185',
    185,
    'M 22',
    'available',
    89636250,
    325.95,
    '[2067.5,262.6]'::jsonb,
    '{"pathD":"M 2082.4 318.7 L 2070.7 318 L 2035 226.5 L 2040.1 225.7 L 2088 228.7 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":89636250,"cuota_ini_20":17927250,"cuota_inicial_20":17927250,"cuotas_3_ini":5975750,"cuotas_48":1493938,"precio_preventa":83117250,"cuota_ini_pre_20":16623450,"cuotas_3_ini_pre":5541150,"cuotas_48_pre":1385288,"descripcion_lindero":"LOTE NUMERO CIENTO OCHENTA Y CINCO (185): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 17.71 metros; por la derecha entrando, linda con Lote Numero 175 y mide 32.66 metros; por el fondo, linda con Lote Numero 178 y mide 3.92 metros; por la izquierda; linda con Lote Numero 184 y mide 30.00 metros. Área del Lote: 325.95   M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-186',
    186,
    'M 19',
    'reserved',
    136075500,
    494.82,
    '[2050.6,153.8]'::jsonb,
    '{"pathD":"M 2041 201 L 2009.4 114 L 2066.5 117.7 L 2080.9 109.8 L 2073.8 203.5 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":136075500,"cuota_ini_20":27215100,"cuota_inicial_20":27215100,"cuotas_3_ini":9071700,"cuotas_48":2267925,"precio_preventa":126179100,"cuota_ini_pre_20":25235820,"cuotas_3_ini_pre":8411940,"cuotas_48_pre":2102985,"descripcion_lindero":"LOTE NUMERO CIENTO OCHENTA Y SEIS (186): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.94 metros; por la derecha entrando, linda con Lote Numero 187 y mide 31.27 metros; por el fondo, linda con Area verde y mide 24.53 metros (línea quebrada); por la izquierda; linda con Sendero Peatonal y mide 30.81 metros. Área del Lote: 494.87  M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-187',
    187,
    'M 19',
    'available',
    138971250,
    505.35,
    '[2100.4,154.2]'::jsonb,
    '{"pathD":"M 2073.8 203.5 L 2080.9 109.8 L 2095.4 101.9 L 2125.5 102 L 2119 207 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":138971250,"cuota_ini_20":27794250,"cuota_inicial_20":27794250,"cuotas_3_ini":9264750,"cuotas_48":2316188,"precio_preventa":128864250,"cuota_ini_pre_20":25772850,"cuotas_3_ini_pre":8590950,"cuotas_48_pre":2147738,"descripcion_lindero":"LOTE NUMERO CIENTO OCHENTA Y SIETE (187): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 15.07 metros; por la derecha entrando, linda con Lote Numero 188 y mide 35.01 metros; por el fondo, linda con Area verde y mide 15.52 metros (línea quebrada); por la izquierda; linda con Lote Numero 186 y mide 31.27 metros. Área del Lote: 505.40   M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-188',
    188,
    'M 19',
    'available',
    95144500,
    345.98,
    '[2100.4,154.2]'::jsonb,
    '{"pathD":"M 2073.8 203.5 L 2080.9 109.8 L 2095.4 101.9 L 2125.5 102 L 2119 207 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":95144500,"cuota_ini_20":19028900,"cuota_inicial_20":19028900,"cuotas_3_ini":6342967,"cuotas_48":1585742,"precio_preventa":88224900,"cuota_ini_pre_20":17644980,"cuotas_3_ini_pre":5881660,"cuotas_48_pre":1470415,"descripcion_lindero":"LOTE NUMERO CIENTO OCHENTA Y OCHO (188): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 9.99 metros; por la derecha entrando, linda con Lote Numero 189 y mide 35.59 metros; por el fondo, linda con Area verde y mide 9.62 metros; por la izquierda; linda con Lote Numero 187 y mide 35.01 metros. Área del Lote: 345.98   M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-189',
    189,
    'M 19',
    'available',
    100820500,
    366.62,
    '[2167.1,156.2]'::jsonb,
    '{"pathD":"M 2185.7 102.9 L 2179 211.7 L 2148.9 209.3 L 2154.4 102.5 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":100820500,"cuota_ini_20":20164100,"cuota_inicial_20":20164100,"cuotas_3_ini":6721367,"cuotas_48":1680342,"precio_preventa":93488100,"cuota_ini_pre_20":18697620,"cuotas_3_ini_pre":6232540,"cuotas_48_pre":1558135,"descripcion_lindero":"LOTE NUMERO CIENTO OCHENTA Y NUEVE (189): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.02 metros; por la derecha entrando, linda con Lote Numero 190 y mide 36.27 metros; por el fondo, linda con Area verde y mide 10.40 metros; por la izquierda; linda con Lote Numero 188 y mide 35.59 metros. Área del Lote: 366.62M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-190',
    190,
    'M 19',
    'available',
    100773750,
    366.45,
    '[2167.1,156.2]'::jsonb,
    '{"pathD":"M 2185.7 102.9 L 2179 211.7 L 2148.9 209.3 L 2154.4 102.5 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":100773750,"cuota_ini_20":20154750,"cuota_inicial_20":20154750,"cuotas_3_ini":6718250,"cuotas_48":1679563,"precio_preventa":93444750,"cuota_ini_pre_20":18688950,"cuotas_3_ini_pre":6229650,"cuotas_48_pre":1557413,"descripcion_lindero":"LOTE NUMERO CIENTO NOVENTA (190): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 191 y mide 37.02 metros; por el fondo, linda con Area verde y mide 10.02 metros; por la izquierda; linda con Lote Numero 189 y mide 36.27 metros. Área del Lote: 366.45   M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-191',
    191,
    'M 19',
    'sold',
    103083750,
    374.85,
    '[2227.1,159.6]'::jsonb,
    '{"pathD":"M 2238.9 216.3 L 2208.9 214 L 2215.8 102.9 L 2245.9 102.5 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":103083750,"cuota_ini_20":20616750,"cuota_inicial_20":20616750,"cuotas_3_ini":6872250,"cuotas_48":1718063,"precio_preventa":95586750,"cuota_ini_pre_20":19117350,"cuotas_3_ini_pre":6372450,"cuotas_48_pre":1593113,"descripcion_lindero":"LOTE NUMERO CIENTO NOVENTA Y UNO (191): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 192 y mide 37.95 metros; por el fondo, linda con Area verde y mide 10.03 metros; por la izquierda; linda con Lote Numero 190 y mide 37.02 metros. Área del Lote: 374.85   M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-192',
    192,
    'M 19',
    'reserved',
    106337000,
    386.68,
    '[2227.1,159.6]'::jsonb,
    '{"pathD":"M 2238.9 216.3 L 2208.9 214 L 2215.8 102.9 L 2245.9 102.5 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":106337000,"cuota_ini_20":21267400,"cuota_inicial_20":21267400,"cuotas_3_ini":7089133,"cuotas_48":1772283,"precio_preventa":98603400,"cuota_ini_pre_20":19720680,"cuotas_3_ini_pre":6573560,"cuotas_48_pre":1643390,"descripcion_lindero":"LOTE NUMERO CIENTO NOVENTA Y DOS (192): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 10.02 metros; por la derecha entrando, linda con Lote Numero 193 y mide 39.03 metros; por el fondo, linda con Área verde y mide 10.11 metros; por la izquierda; linda con Lote Numero 191 y mide 37.95 metros. Área del Lote: 386.68 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-193',
    193,
    'M 19',
    'reserved',
    127762250,
    464.59,
    '[2290.1,165.5]'::jsonb,
    '{"pathD":"M 2312.2 222 L 2268.9 218.6 L 2276.3 101.6 L 2303.1 99.6 L 2308.1 166.7 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":127762250,"cuota_ini_20":25552450,"cuota_inicial_20":25552450,"cuotas_3_ini":8517483,"cuotas_48":2129371,"precio_preventa":118470450,"cuota_ini_pre_20":23694090,"cuotas_3_ini_pre":7898030,"cuotas_48_pre":1974508,"descripcion_lindero":"LOTE NUMERO CIENTO NOVENTA Y TRES (193): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 14.46 metros; por la derecha entrando, linda con Sendero Peatonal y mide 40.83 metros (línea quebrada); por el fondo, linda con Area verde y mide 8.93 metros; por la izquierda; linda con Lote Numero 192 y mide 39.03 metros. Área del Lote: 464.59 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-194',
    194,
    'M 23',
    'available',
    124610100,
    429.69,
    '[2275.6,267.9]'::jsonb,
    '{"pathD":"M 2242.6 241.3 L 2314 245.8 L 2317.6 294.2 L 2233.6 289 L 2236.2 247 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":124610100,"cuota_ini_20":24922020,"cuota_inicial_20":24922020,"cuotas_3_ini":8307340,"cuotas_48":2076835,"precio_preventa":116016300,"cuota_ini_pre_20":23203260,"cuotas_3_ini_pre":7734420,"cuotas_48_pre":1933605,"descripcion_lindero":"LOTE NUMERO CIENTO NOVENTA Y CUATRO (194): Por el frente, linda con acceso vehicular al lote y Carrera 10 y mide 18.31 metros; por la derecha entrando, linda con Lote Numero 195 y mide 28.01 metros; por el fondo, linda con Área verde y mide 17.14 metros (línea quebrada); por la izquierda; linda con Calle Numero 5 y mide 23.81 metros. Área del Lote: 429.68   M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-195',
    195,
    'M 23',
    'available',
    78916750,
    286.97,
    '[2275.9,306.4]'::jsonb,
    '{"pathD":"M 2319.9 324.4 L 2231.7 319 L 2233.6 289 L 2317.6 294.2 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":78916750,"cuota_ini_20":15783350,"cuota_inicial_20":15783350,"cuotas_3_ini":5261117,"cuotas_48":1315279,"precio_preventa":73177350,"cuota_ini_pre_20":14635470,"cuotas_3_ini_pre":4878490,"cuotas_48_pre":1219623,"descripcion_lindero":"LOTE NUMERO CIENTO NOVENTA Y CINCO (195): Por el frente, linda con acceso vehicular al lote y Carrera Numero 10 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 196 y mide 29.38 metros; por el fondo, linda con Área verde y mide 10.09 metros; por la izquierda; linda con Lote Numero 194 y mide 29.38 metros. Área del Lote: 286.97   M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-196',
    196,
    'M 23',
    'available',
    82733750,
    300.85,
    '[2276,336.8]'::jsonb,
    '{"pathD":"M 2322.2 354.7 L 2229.9 349 L 2231.7 319 L 2319.9 324.4 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":82733750,"cuota_ini_20":16546750,"cuota_inicial_20":16546750,"cuotas_3_ini":5515583,"cuotas_48":1378896,"precio_preventa":76716750,"cuota_ini_pre_20":15343350,"cuotas_3_ini_pre":5114450,"cuotas_48_pre":1278613,"descripcion_lindero":"LOTE NUMERO CIENTO NOVENTA Y SEIS (196): Por el frente, linda con acceso vehicular al lote y carrera Numero 10 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero197 y mide 30.79 metros; por el fondo, linda zona verde y mide 10.10 metros; por la izquierda, linda con Lote Numero 195 y mide 29.38 metros. Área del Lote: 300.85 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-197',
    197,
    'M 23',
    'available',
    86630500,
    315.02,
    '[2276.1,367.2]'::jsonb,
    '{"pathD":"M 2324.7 385 L 2228 379 L 2229.9 349 L 2322.2 354.7 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":86630500,"cuota_ini_20":17326100,"cuota_inicial_20":17326100,"cuotas_3_ini":5775367,"cuotas_48":1443842,"precio_preventa":80330100,"cuota_ini_pre_20":16066020,"cuotas_3_ini_pre":5355340,"cuotas_48_pre":1338835,"descripcion_lindero":"LOTE NUMERO CIENTO NOVENTA Y SIETE (197): Por el frente, linda con acceso vehicular al lote y carrera Nuero 10 y 10.00 metros; por la derecha entrando, linda con Lote Numero 198 y mide 32.22 metros; por el fondo, linda con zona verde y mide 10.10 metros (línea quebrada); por la izquierda; linda con Lote Numero 196 y mide 30.79 metros. Área del Lote: 315.02 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-198',
    198,
    'M 23',
    'available',
    150170700,
    517.83,
    '[2277.5,408.6]'::jsonb,
    '{"pathD":"M 2229.3 410.4 L 2226.4 404.9 L 2228 379 L 2324.7 385 L 2304.6 456.7 L 2285.1 443.4 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":150170700,"cuota_ini_20":30034140,"cuota_inicial_20":30034140,"cuotas_3_ini":10011380,"cuotas_48":2502845,"precio_preventa":139814100,"cuota_ini_pre_20":27962820,"cuotas_3_ini_pre":9320940,"cuotas_48_pre":2330235,"descripcion_lindero":"LOTE NUMERO CIENTO NOVENTA Y OCHO (198): Por el frente, linda con acceso vehicular al lote y Carrera Numero 10 y mide 10.00 metros; por la derecha linda con Calle Numero 6 y mide 31.57 metros; por el fondo linda con Area verde y mide 25.53 metros; por la izquierda; linda con Lote Numero 197 y mide 30.26 metros. Área del Lote: 517.83 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-199',
    199,
    'M 21',
    'available',
    121510000,
    419,
    '[2218.1,472.7]'::jsonb,
    '{"pathD":"M 2221.9 442.1 L 2265.6 459.4 L 2235.1 500.6 L 2198 513.3 L 2182.2 439.3 L 2220.7 441.7 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":121510000,"cuota_ini_20":24302000,"cuota_inicial_20":24302000,"cuotas_3_ini":8100667,"cuotas_48":2025167,"precio_preventa":113130000,"cuota_ini_pre_20":22626000,"cuotas_3_ini_pre":7542000,"cuotas_48_pre":1885500,"descripcion_lindero":"LOTE NUMERO CIENTO NOVENTA Y NUEVE (199): Por el frente, linda con acceso vehicular al lote y Calle Numero 6 y mide 28.87 metros (línea quebrada); por la derecha entrando, linda con Lote Numero 200 y mide 25.18 metros; por la izquierda; linda con Area verde y mide 30.11 metros (línea quebrada). Área del Lote: 419.00   M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-200',
    200,
    'M 21',
    'available',
    116308500,
    422.94,
    '[2160.6,467.4]'::jsonb,
    '{"pathD":"M 2115.5 436.3 L 2118.2 435.4 L 2182.2 439.3 L 2198 513.3 L 2182.7 516.8 L 2168.2 502.9 L 2107.4 444.7 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":116308500,"cuota_ini_20":23261700,"cuota_inicial_20":23261700,"cuotas_3_ini":7753900,"cuotas_48":1938475,"precio_preventa":107849700,"cuota_ini_pre_20":21569940,"cuotas_3_ini_pre":7189980,"cuotas_48_pre":1797495,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS (200): Por el frente, linda con acceso vehicular al lote y Calle Numero 6 y mide 26.19 metros (línea quebrada); por la derecha entrando, linda con Lote Numero 201 y mide 34.67 metros; por el fondo, linda con Área verde y mide 5.24 metros; por la izquierda; linda con Lote Numero 199 y mide 25.18 metros. Área del Lote: 422.94   M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-201',
    201,
    'M 21',
    'sold',
    91373200,
    315.08,
    '[2131.7,488]'::jsonb,
    '{"pathD":"M 2182.7 516.8 L 2148.1 525.3 L 2136.4 514.1 L 2086.6 466.4 L 2107.4 444.7 L 2168.2 502.9 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":91373200,"cuota_ini_20":18274640,"cuota_inicial_20":18274640,"cuotas_3_ini":6091547,"cuotas_48":1522887,"precio_preventa":85071600,"cuota_ini_pre_20":17014320,"cuotas_3_ini_pre":5671440,"cuotas_48_pre":1417860,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS UNO (201): Por el frente, linda con acceso vehicular al lote y Calle Numero 6 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 202 y mide 28.35 metros; por el fondo, linda con Área verde y mide 11.83 metros; por la izquierda; linda con Lote Numero 200 y mide 34.67 metros. Área del Lote: 315.08   M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-202',
    202,
    'M 21',
    'sold',
    77693900,
    267.91,
    '[2104.9,506]'::jsonb,
    '{"pathD":"M 2148.1 525.3 L 2128.1 534 L 2125.3 545.1 L 2065.8 488.1 L 2086.6 466.4 L 2136.4 514.1 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":77693900,"cuota_ini_20":15538780,"cuota_inicial_20":15538780,"cuotas_3_ini":5179593,"cuotas_48":1294898,"precio_preventa":72335700,"cuota_ini_pre_20":14467140,"cuotas_3_ini_pre":4822380,"cuotas_48_pre":1205595,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS DOS (202): Por el frente, linda con acceso vehicular al lote y Calle Numero 6 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 203 y mide 27.41 metros; por el fondo, linda con Área verde y mide 11.05 metros (línea quebrada); por la izquierda; linda con Lote Numero 201 Y mide 28.35 metros. Área del Lote: 267.91   M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-203',
    203,
    'M 21',
    'sold',
    87991800,
    303.42,
    '[2088,531.2]'::jsonb,
    '{"pathD":"M 2125.3 545.1 L 2118.5 571.5 L 2119.2 580.8 L 2094.8 557.5 L 2045 509.8 L 2065.8 488.1 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":87991800,"cuota_ini_20":17598360,"cuota_inicial_20":17598360,"cuotas_3_ini":5866120,"cuotas_48":1466530,"precio_preventa":81923400,"cuota_ini_pre_20":16384680,"cuotas_3_ini_pre":5461560,"cuotas_48_pre":1365390,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS TRES (203): Por el frente, linda con acceso vehicular al lote y Calle Numero 6 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 204 y mide 34.18 metros; por el fondo, linda con Área verde y mide 12.19 metros (línea quebrada); por la izquierda; linda con Lote Numero 202 Y mide 27.41 metros. Área del Lote: 303.42   M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-204',
    204,
    'M 21',
    'sold',
    114657300,
    395.37,
    '[2077,563.1]'::jsonb,
    '{"pathD":"M 2094.8 557.5 L 2119.2 580.8 L 2121.7 624.9 L 2079.8 584.7 L 2024.2 531.5 L 2045 509.8 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":114657300,"cuota_ini_20":22931460,"cuota_inicial_20":22931460,"cuotas_3_ini":7643820,"cuotas_48":1910955,"precio_preventa":106749900,"cuota_ini_pre_20":21349980,"cuotas_3_ini_pre":7116660,"cuotas_48_pre":1779165,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS CUATRO (204): Por el frente, linda con acceso vehicular al lote y Calle Numero 6 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 205 y mide 44.91 metros; por el fondo, linda con Area verde y mide 14.67 metros; por la izquierda; linda con Lote Numero 203 y mide 34.18 metros. Área del Lote: 395.37   M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-205',
    205,
    'M 21',
    'available',
    139559600,
    481.24,
    '[2066,592.5]'::jsonb,
    '{"pathD":"M 2049 596.9 L 2030.5 579.1 L 2003.4 553.2 L 2024.2 531.5 L 2079.8 584.7 L 2121.7 624.9 L 2121.4 634.3 L 2115.5 652.4 L 2112 657.2 L 2084 630.4 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":139559600,"cuota_ini_20":27911920,"cuota_inicial_20":27911920,"cuotas_3_ini":9303973,"cuotas_48":2325993,"precio_preventa":129934800,"cuota_ini_pre_20":25986960,"cuotas_3_ini_pre":8662320,"cuotas_48_pre":2165580,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS CINCO (205): Por el frente, linda con acceso vehicular al lote y Calle Numero 6 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 206, Lote Numero 208 y mide 50.10 metros; por el fondo, linda con Area verde y mide 11.46 metros (línea quebrada); por la izquierda; linda con Lote Numero 204 y mide 44.91 metros. Área del Lote: 481.24   M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-206',
    206,
    'M 21',
    'available',
    86886250,
    315.95,
    '[2014.3,592.1]'::jsonb,
    '{"pathD":"M 1975.1 582.7 L 2003.4 553.2 L 2053 600.7 L 2025.4 631.5 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":86886250,"cuota_ini_20":17377250,"cuota_inicial_20":17377250,"cuotas_3_ini":5792417,"cuotas_48":1448104,"precio_preventa":80567250,"cuota_ini_pre_20":16113450,"cuotas_3_ini_pre":5371150,"cuotas_48_pre":1342788,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS SEIS (206): Por el frente, linda con acceso vehicular al lote y Calle Numero 6 y mide 13.61 metros; por la derecha entrando, linda con Lote Numero 207 y mide 23.33 metros; por el fondo, linda con Lote Numero 208 y mide 13.77 metros; por la izquierda; linda con Lote Numero 205 y mide 22.84 metros. Área del Lote: 315.95 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-207',
    207,
    'M 21',
    'available',
    104611700,
    360.73,
    '[1984.6,622.6]'::jsonb,
    '{"pathD":"M 2025.4 631.5 L 1997.9 662.4 L 1948 625.7 L 1946.8 612.2 L 1975.1 582.7 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":104611700,"cuota_ini_20":20922340,"cuota_inicial_20":20922340,"cuotas_3_ini":6974113,"cuotas_48":1743528,"precio_preventa":97397100,"cuota_ini_pre_20":19479420,"cuotas_3_ini_pre":6493140,"cuotas_48_pre":1623285,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS SIETE (207): Por el frente, linda con acceso vehicular al lote y Calle Numero 6 y mide 18.71 metros; por la derecha entrando, linda con Carrera Numero 8 y mide 20.61 metros; por el fondo, linda con Lote Numero 208 y mide 13.77 metros; por la izquierda; linda con Lote Numero 206 y mide 23.33 metros. Área del Lote: 360.73  M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-208',
    208,
    'M 21',
    'sold',
    191078250,
    694.83,
    '[2050.8,654.5]'::jsonb,
    '{"pathD":"M 2030.8 679.3 L 1995.6 688.7 L 1978.4 676 L 1993.4 659.2 L 1997.9 662.4 L 2053 600.7 L 2084 630.4 L 2112 657.2 L 2086.6 691.1 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":191078250,"cuota_ini_20":38215650,"cuota_inicial_20":38215650,"cuotas_3_ini":12738550,"cuotas_48":3184638,"precio_preventa":177181650,"cuota_ini_pre_20":35436330,"cuotas_3_ini_pre":11812110,"cuotas_48_pre":2953028,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS OCHO (208): Por el frente, linda con acceso vehicular al lote y Carrera Numero 6 y mide 7.51 metros; por la derecha entrando, linda con Area verde y mide 52.30 metros (línea quebrada); por el fondo, linda con Lote Numero 205 y mide 27.18 metros; por la izquierda; linda con Lote Numero 206 y Lote Numero 207 y mide 27.54 metros. Área del Lote: 694.83 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-209',
    209,
    'M 18',
    'sold',
    171082600,
    589.94,
    '[2299.5,583.3]'::jsonb,
    '{"pathD":"M 2319 629.1 L 2293.2 645.1 L 2255.1 583.9 L 2270.2 574.5 L 2297.6 540 L 2306.3 507.4 L 2313 501.6 L 2322.7 541.9 L 2326.7 615.7 L 2324.7 621.8 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":171082600,"cuota_ini_20":34216520,"cuota_inicial_20":34216520,"cuotas_3_ini":11405507,"cuotas_48":2851377,"precio_preventa":159283800,"cuota_ini_pre_20":31856760,"cuotas_3_ini_pre":10618920,"cuotas_48_pre":2654730,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS NUEVE (209): Por el frente, linda con acceso vehicular al lote y Calle Numero 1 y mide 53.74 metros (línea quebrada); por el fondo, linda con Area verde y mide 34.74 metros (línea quebrada); por la izquierda; linda con Lote Numero 210 y mide 24.00 metros. Área del Lote: 589.94 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-210',
    210,
    'M 18',
    'available',
    141988000,
    516.32,
    '[2243.1,628.6]'::jsonb,
    '{"pathD":"M 2271.6 658.6 L 2266.6 663.3 L 2194.9 646.8 L 2196.2 624.7 L 2204 613.8 L 2240.2 593.2 L 2255.1 583.9 L 2293.2 645.1 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":141988000,"cuota_ini_20":28397600,"cuota_inicial_20":28397600,"cuotas_3_ini":9465867,"cuotas_48":2366467,"precio_preventa":131661600,"cuota_ini_pre_20":26332320,"cuotas_3_ini_pre":8777440,"cuotas_48_pre":2194360,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS DIEZ (210): Por el frente, linda con acceso vehicular al lote y Calle Numero 1 y mide 10.76 metros (línea quebrada); por la derecha entrando, linda con Lote Numero 209 y mide 24.00 metros por el fondo, linda con Area verde y mide 31.52 metros (línea quebrada); por la izquierda; linda con Lote Numero 211 y mide 24.46 metros. Área del Lote: 516.32 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-211',
    211,
    'M 18',
    'available',
    90535100,
    312.19,
    '[2227,673.8]'::jsonb,
    '{"pathD":"M 2254.4 704 L 2188.8 684 L 2194.9 646.8 L 2266.6 663.3 L 2263.7 669.3 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":90535100,"cuota_ini_20":18107020,"cuota_inicial_20":18107020,"cuotas_3_ini":6035673,"cuotas_48":1508918,"precio_preventa":84291300,"cuota_ini_pre_20":16858260,"cuotas_3_ini_pre":5619420,"cuotas_48_pre":1404855,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS ONCE (211): Por el frente, linda con acceso vehicular al lote y Calle Numero 1 y mide 14.19 metros (línea quebrada); por la derecha entrando, linda con Lote Numero 210 y mide 24.46 metros; por el fondo, linda con Area verde y mide 12.55 metros; por la izquierda; linda con Lote 215 y mide 22.82 metros. Área del Lote: 312.19 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-212',
    212,
    'M 14',
    'available',
    84814600,
    326.21,
    '[2323.7,679.2]'::jsonb,
    '{"pathD":"M 2335.2 647.3 L 2345.8 634 L 2353.9 707.2 L 2280.9 697.8 L 2285.4 681.2 L 2289.3 675.9 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"AZUL","valor_m2":260000,"prem2":240000,"precio_venta":84814600,"cuota_ini_20":16962920,"cuota_inicial_20":16962920,"cuotas_3_ini":5654307,"cuotas_48":1413577,"precio_preventa":78290400,"cuota_ini_pre_20":15658080,"cuotas_3_ini_pre":5219360,"cuotas_48_pre":1304840,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS DOCE (212): Por el frente, linda con acceso vehicular al lote y Calle Numero 1 y mide 31.63 metros (línea quebrada); por la derecha entrando, linda con Lote Numero 213 y mide 24.49 metros; por el fondo, linda con Area verde y mide 24.50 metros. Área del Lote: 326.21 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-213',
    213,
    'M 14',
    'available',
    89689600,
    344.96,
    '[2320.9,722.3]'::jsonb,
    '{"pathD":"M 2273.6 724.9 L 2280.9 697.8 L 2353.9 707.2 L 2359 753.1 L 2355.7 756.8 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"AZUL","valor_m2":260000,"prem2":240000,"precio_venta":89689600,"cuota_ini_20":17937920,"cuota_inicial_20":17937920,"cuotas_3_ini":5979307,"cuotas_48":1494827,"precio_preventa":82790400,"cuota_ini_pre_20":16558080,"cuotas_3_ini_pre":5519360,"cuotas_48_pre":1379840,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS TRECE (213): Por el frente, linda con acceso vehicular al lote y Calle Numero 1 y mide 9.34 metros; por la derecha entrando, linda con Lote Numero 214 y mide 29.29 metros; por el fondo, linda con Area verde y mide 17.21 metros; por la izquierda; linda con Lote Numero 212 y mide 24.49 metros. Área del Lote: 344.96 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-214',
    214,
    'M 14',
    'available',
    98774000,
    379.9,
    '[2305.7,760.6]'::jsonb,
    '{"pathD":"M 2318.1 799.4 L 2260 753 L 2263.9 748.3 L 2271.1 734.5 L 2273.6 724.9 L 2355.7 756.8 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"AZUL","valor_m2":260000,"prem2":240000,"precio_venta":98774000,"cuota_ini_20":19754800,"cuota_inicial_20":19754800,"cuotas_3_ini":6584933,"cuotas_48":1646233,"precio_preventa":91176000,"cuota_ini_pre_20":18235200,"cuotas_3_ini_pre":6078400,"cuotas_48_pre":1519600,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS CATORCE (214): Por el frente, linda con acceso vehicular al lote y Calle Numero 1 y mide 8.85 metros (línea quebrada); por la derecha entrando, linda con Lote 223 y mide 24.74 metros; por el fondo, linda con Area verde y mide 18.90 metros (línea quebrada); por la izquierda; linda con Lote Numero 213 y mide 29.29 metros. Área del Lote: 379.90 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-215',
    215,
    'M 18',
    'available',
    87127600,
    300.44,
    '[2217.5,712.8]'::jsonb,
    '{"pathD":"M 2245.5 732.9 L 2232.7 748.1 L 2175.2 706.6 L 2186.6 689.4 L 2188.8 684 L 2254.4 704 L 2247.9 728.2 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":87127600,"cuota_ini_20":17425520,"cuota_inicial_20":17425520,"cuotas_3_ini":5808507,"cuotas_48":1452127,"precio_preventa":81118800,"cuota_ini_pre_20":16223760,"cuotas_3_ini_pre":5407920,"cuotas_48_pre":1351980,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS QUINCE (215): Por el frente, linda con acceso vehicular al lote y Calle Numero 1 y mide 16.67 metros (línea quebrada); por la derecha entrando, linda con Lote 211 y mide 22.82 metros; por el fondo, linda con Area verde y mide 8.81 metros; por la izquierda; linda con Lote Numero 216 y mide 23.59 metros. Área del Lote: 300.44 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-216',
    216,
    'M 18',
    'available',
    79718100,
    274.89,
    '[2194.2,742.4]'::jsonb,
    '{"pathD":"M 2232.7 748.1 L 2206.8 778.9 L 2157.1 732.8 L 2161.5 727 L 2175.2 706.6 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":79718100,"cuota_ini_20":15943620,"cuota_inicial_20":15943620,"cuotas_3_ini":5314540,"cuotas_48":1328635,"precio_preventa":74220300,"cuota_ini_pre_20":14844060,"cuotas_3_ini_pre":4948020,"cuotas_48_pre":1237005,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS DIECISEIS (216): Por el frente, linda con acceso vehicular al lote y Calle Numero 1 y mide 13.38 metros; por la derecha entrando, linda con Lote Numero 215 y mide 23.59 metros; por el fondo, linda con Area verde y mide 10.58 metros; por la izquierda; linda con Lote Numero 217 y mide 22.55 metros. Área del Lote: 274.89 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-217',
    217,
    'M 18',
    'available',
    60404100,
    208.29,
    '[2173.6,767.3]'::jsonb,
    '{"pathD":"M 2206.8 778.9 L 2187.6 801.8 L 2140.2 752.6 L 2144.7 748.9 L 2157.1 732.8 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":60404100,"cuota_ini_20":12080820,"cuota_inicial_20":12080820,"cuotas_3_ini":4026940,"cuotas_48":1006735,"precio_preventa":56238300,"cuota_ini_pre_20":11247660,"cuotas_3_ini_pre":3749220,"cuotas_48_pre":937305,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS DIECISIETE (217): Por el frente, linda con acceso vehicular al lote y Calle Numero 1 y mide 9.94 metros; por la derecha entrando, linda con Lote Numero 216 y mide 22.55 metros; por el fondo, linda con Area verde y mide 8.69 metros (línea quebrada); por la izquierda; linda con Lote Numero 218 y mide 22.72 metros. Área del Lote: 208.29 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-218',
    218,
    'M 18',
    'available',
    75678400,
    260.96,
    '[2154.5,792.1]'::jsonb,
    '{"pathD":"M 2156.2 832 L 2153 834.1 L 2124.9 765 L 2140.2 752.6 L 2187.6 801.8 L 2181.9 808.5 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":75678400,"cuota_ini_20":15135680,"cuota_inicial_20":15135680,"cuotas_3_ini":5045227,"cuotas_48":1261307,"precio_preventa":70459200,"cuota_ini_pre_20":14091840,"cuotas_3_ini_pre":4697280,"cuotas_48_pre":1174320,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS DIECISIOCHO (218): Por el frente, linda con acceso vehicular al lote y Calle Numero 1 y mide 15.80 metros (línea quebrada); por la derecha entrando, linda con Lote Numero 217 y mide 22.72 metros; por el fondo, linda con Area verde y mide 6.57 metros; por la izquierda; linda con Lote Numero 219 y mide 24.84 metros. Área del Lote: 260.96 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-219',
    219,
    'M 18',
    'available',
    72239000,
    249.1,
    '[2124.8,804.9]'::jsonb,
    '{"pathD":"M 2149.2 835.1 L 2111.4 838.7 L 2104.6 766.9 L 2124.9 765 L 2153 834.1 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":72239000,"cuota_ini_20":14447800,"cuota_inicial_20":14447800,"cuotas_3_ini":4815933,"cuotas_48":1203983,"precio_preventa":67257000,"cuota_ini_pre_20":13451400,"cuotas_3_ini_pre":4483800,"cuotas_48_pre":1120950,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS DIECINUEVE (219): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 13.95 metros; por la derecha entrando, linda con Lote Numero 218 y mide 24.84 metros; por el fondo, linda con Area verde y mide 6.77 metros; por la izquierda; linda con Lote Numero 220 y mide 24.00 metros. Área del Lote: 249.10 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-220',
    220,
    'M 18',
    'available',
    75011400,
    258.66,
    '[2091.6,803.8]'::jsonb,
    '{"pathD":"M 2111.4 838.7 L 2081.3 841.5 L 2070.2 770.1 L 2104.6 766.9 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":75011400,"cuota_ini_20":15002280,"cuota_inicial_20":15002280,"cuotas_3_ini":5000760,"cuotas_48":1250190,"precio_preventa":69838200,"cuota_ini_pre_20":13967640,"cuotas_3_ini_pre":4655880,"cuotas_48_pre":1163970,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS VEINTE (220): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 10.06 metros; por la derecha entrando, linda con Lote Numero 219 y mide 24.00 metros; por el fondo, linda con Area verde y mide 11.50 metros; por la izquierda; linda con Lote Numero 221 y mide 24.04 metros. Área del Lote: 258.66 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-221',
    221,
    'M 18',
    'available',
    70667200,
    243.68,
    '[2060.7,807.7]'::jsonb,
    '{"pathD":"M 2075 842.1 L 2051.5 846.1 L 2039.7 774.9 L 2065.6 770.6 L 2070.2 770.1 L 2081.3 841.5 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":70667200,"cuota_ini_20":14133440,"cuota_inicial_20":14133440,"cuotas_3_ini":4711147,"cuotas_48":1177787,"precio_preventa":65793600,"cuota_ini_pre_20":13158720,"cuotas_3_ini_pre":4386240,"cuotas_48_pre":1096560,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS VEINTI Y UNO (221): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 10.02 metros (línea quebrada); por la derecha entrando, linda con Lote Numero 220 y mide 24.04 metros; por el fondo, linda con Area verde y mide 10.29 metros; por la izquierda; linda con Lote Numero 222 y mide 24.00 metros. Área del Lote: 243.68 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-222',
    222,
    'M 18',
    'available',
    111687700,
    385.13,
    '[2022.4,814.5]'::jsonb,
    '{"pathD":"M 2051.5 846.1 L 2020.6 851.2 L 1999 853 L 1996.6 780.9 L 2011.7 779.6 L 2039.7 774.9 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":111687700,"cuota_ini_20":22337540,"cuota_inicial_20":22337540,"cuotas_3_ini":7445847,"cuotas_48":1861462,"precio_preventa":103985100,"cuota_ini_pre_20":20797020,"cuotas_3_ini_pre":6932340,"cuotas_48_pre":1733085,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS VEINTI Y DOS (222): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 17.63 metros; por la derecha entrando, linda con Lote Numero 221 y mide 24.00 metros; por el fondo, linda con Area verde y mide 14.46 metros (línea quebrada); por la izquierda; linda con Lote 236 y mide 24.02 metros. Área del Lote: 385.13 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-223',
    223,
    'M 14',
    'available',
    91982000,
    334.48,
    '[2276,791.8]'::jsonb,
    '{"pathD":"M 2260 753 L 2318.1 799.4 L 2290.9 830.4 L 2234.3 785.1 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":91982000,"cuota_ini_20":18396400,"cuota_inicial_20":18396400,"cuotas_3_ini":6132133,"cuotas_48":1533033,"precio_preventa":85292400,"cuota_ini_pre_20":17058480,"cuotas_3_ini_pre":5686160,"cuotas_48_pre":1421540,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS VEINTI Y TRES (223): Por el frente, linda con acceso vehicular al lote y Calle Numero 1 y mide 13.69 metros; por la derecha entrando, linda con Lote Numero 224 y mide 24.12 metros; por el fondo, linda con Area verde y mide 13.70 metros; por la izquierda; linda con Lote 214 y mide 24.74 metros. Área del Lote: 334.48 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-224',
    224,
    'M 14',
    'available',
    78625250,
    285.91,
    '[2251.2,821.4]'::jsonb,
    '{"pathD":"M 2290.9 830.4 L 2267.1 857.5 L 2211.8 813.3 L 2234.3 785.1 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":78625250,"cuota_ini_20":15725050,"cuota_inicial_20":15725050,"cuotas_3_ini":5241683,"cuotas_48":1310421,"precio_preventa":72907050,"cuota_ini_pre_20":14581410,"cuotas_3_ini_pre":4860470,"cuotas_48_pre":1215118,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS VEINTI Y CUATRO (224): Por el frente, linda con acceso vehicular al lote y Calle Numero 1 y mide 12.00 metros; por la derecha entrando, linda con Lote Numero 225 y mide 23.53 metros; por el fondo, linda con Area verde y mide 12.01 metros; por la izquierda; linda con Lote Numero 223 y mide 24.12 metros. Área del Lote: 285.91 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-225',
    225,
    'M 14',
    'available',
    76714000,
    278.96,
    '[2228.8,847.4]'::jsonb,
    '{"pathD":"M 2267.1 857.5 L 2243.2 884.6 L 2189.3 841.5 L 2211.8 813.3 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":76714000,"cuota_ini_20":15342800,"cuota_inicial_20":15342800,"cuotas_3_ini":5114267,"cuotas_48":1278567,"precio_preventa":71134800,"cuota_ini_pre_20":14226960,"cuotas_3_ini_pre":4742320,"cuotas_48_pre":1185580,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS VEINTI Y CINCO (225): Por el frente, linda con acceso vehicular al lote y Calle Numero 1 y mide 12.00 metros; por la derecha entrando, linda con Lote Numero 226 y mide 22.96 metros; por el fondo, linda con Area verde y mide 12.01 metros; por la izquierda; linda con Lote Numero 224 y mide 23.53 metros. Área del Lote: 278.96 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-226',
    226,
    'M 14',
    'available',
    75465500,
    274.42,
    '[2204.3,878.3]'::jsonb,
    '{"pathD":"M 2243.2 884.6 L 2220.3 912.4 L 2166.8 869.7 L 2189.3 841.5 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":75465500,"cuota_ini_20":15093100,"cuota_inicial_20":15093100,"cuotas_3_ini":5031033,"cuotas_48":1257758,"precio_preventa":69977100,"cuota_ini_pre_20":13995420,"cuotas_3_ini_pre":4665140,"cuotas_48_pre":1166285,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS VEINTI Y SEIS (226): Por el frente, linda con acceso vehicular al lote y Calle Numero 1 y mide 12.00 metros; por la derecha entrando, linda con Lote Numero 227 y mide 22.78 metros; por el fondo, linda con Area verde y mide 12.00 metros; por la izquierda; linda con Lote Numero 225 Y mide 22.96 metros. Área del Lote: 374.42 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-227',
    227,
    'M 14',
    'available',
    77594000,
    282.16,
    '[2182.3,905.1]'::jsonb,
    '{"pathD":"M 2220.3 912.4 L 2195.8 942.1 L 2143.7 897.4 L 2157 882 L 2166.8 869.7 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":77594000,"cuota_ini_20":15518800,"cuota_inicial_20":15518800,"cuotas_3_ini":5172933,"cuotas_48":1293233,"precio_preventa":71950800,"cuota_ini_pre_20":14390160,"cuotas_3_ini_pre":4796720,"cuotas_48_pre":1199180,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS VEINTI Y SIETE (227): Por el frente, linda con acceso vehicular al lote y Calle Numero 1 y mide 12.00 metros; por la derecha entrando, linda con Lote Numero 228 y mide 22.83 metros; por el fondo, linda con Area verde y mide 12.80 metros; por la izquierda; linda con Lote Numero 226 y mide 22.78 metros. Área del Lote: 282.16 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-228',
    228,
    'M 14',
    'available',
    75735000,
    275.4,
    '[2158.3,933.4]'::jsonb,
    '{"pathD":"M 2195.8 942.1 L 2172.9 970 L 2120.3 924.8 L 2143.7 897.4 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":75735000,"cuota_ini_20":15147000,"cuota_inicial_20":15147000,"cuotas_3_ini":5049000,"cuotas_48":1262250,"precio_preventa":70227000,"cuota_ini_pre_20":14045400,"cuotas_3_ini_pre":4681800,"cuotas_48_pre":1170450,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS VEINTI Y OCHO (228): Por el frente, linda con acceso vehicular al lote y Calle Numero 1 y mide 12.00 metros; por la derecha entrando, linda con Lote Numero 229 y mide 23.07 metros; por el fondo, linda con Area verde y mide 12.00 metros; por la izquierda; linda con Lote Numero 227 y mide 22.83 metros. Área del Lote: 275.40 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-229',
    229,
    'M 14',
    'available',
    80695400,
    278.26,
    '[2134.8,961.5]'::jsonb,
    '{"pathD":"M 2172.9 970 L 2150 997.8 L 2096.8 952.2 L 2120.3 924.8 Z"}'::jsonb,
    '{"ubicacion":"CALLEJON","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":80695400,"cuota_ini_20":16139080,"cuota_inicial_20":16139080,"cuotas_3_ini":5379693,"cuotas_48":1344923,"precio_preventa":75130200,"cuota_ini_pre_20":15026040,"cuotas_3_ini_pre":5008680,"cuotas_48_pre":1252170,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS VEINTI Y NUEVE (229): Por el frente, linda con acceso vehicular al lote y Calle Numero 1 y mide 12.00 metros; por la derecha entrando, linda con Sendero Peatonal y mide 23.31 metros; por el fondo, linda con Area verde y mide 12.00 metros; por la izquierda; linda con Lote Numero 228 y mide 23.07 metros. Área del Lote: 278.26 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-230',
    230,
    'M 14',
    'available',
    67935400,
    234.26,
    '[2108,993.6]'::jsonb,
    '{"pathD":"M 2071.5 982 L 2090.9 959.1 L 2144.7 1004.2 L 2125.6 1027.4 Z"}'::jsonb,
    '{"ubicacion":"CALLEJON","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":67935400,"cuota_ini_20":13587080,"cuota_inicial_20":13587080,"cuotas_3_ini":4529027,"cuotas_48":1132257,"precio_preventa":63250200,"cuota_ini_pre_20":12650040,"cuotas_3_ini_pre":4216680,"cuotas_48_pre":1054170,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS TREINTA (230): Por el frente, linda con acceso vehicular al lote y Calle Numero 1 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 231 y mide 23.50 metros; por el fondo, linda con Area verde y mide 10.00 metros; por la izquierda; linda con Sendero Peatonal y mide 23.40 metros. Área del Lote: 234.50 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-231',
    231,
    'M 14',
    'available',
    68283400,
    235.46,
    '[2088.6,1017]'::jsonb,
    '{"pathD":"M 2052.2 1005 L 2071.5 982 L 2125.6 1027.4 L 2106.5 1050.6 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":68283400,"cuota_ini_20":13656680,"cuota_inicial_20":13656680,"cuotas_3_ini":4552227,"cuotas_48":1138057,"precio_preventa":63574200,"cuota_ini_pre_20":12714840,"cuotas_3_ini_pre":4238280,"cuotas_48_pre":1059570,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS TREINTA Y UNO (231): Por el frente, linda con acceso vehicular al lote y Calle Numero 1 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 232 y mide 23.59 metros; por el fondo, linda con Area verde y mide 10.00 metros; por la izquierda; linda con Lote Numero 230 y mide 23.50 metros. Área del Lote: 235.46 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-232',
    232,
    'M 14',
    'available',
    68561800,
    236.42,
    '[2070.6,1037.7]'::jsonb,
    '{"pathD":"M 2032.9 1028 L 2052.2 1005 L 2106.5 1050.6 L 2087.4 1073.8 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":68561800,"cuota_ini_20":13712360,"cuota_inicial_20":13712360,"cuotas_3_ini":4570787,"cuotas_48":1142697,"precio_preventa":63833400,"cuota_ini_pre_20":12766680,"cuotas_3_ini_pre":4255560,"cuotas_48_pre":1063890,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS TREINTA Y DOS (232): Por el frente, linda con acceso vehicular al lote y Calle Numero 1 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 248 y mide 23.69 metros; por el fondo, linda con Area verde y mide 10.00 metros; por la izquierda; linda con Lote Numero 231 y mide 23.59 metros. Área del Lote: 236.42 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-233',
    233,
    'M 17',
    'available',
    84598800,
    291.72,
    '[2028.2,969.1]'::jsonb,
    '{"pathD":"M 2063.2 944.7 L 2062.5 955.4 L 2016.2 1010.4 L 1990.9 971.2 L 2053.9 930.4 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":84598800,"cuota_ini_20":16919760,"cuota_inicial_20":16919760,"cuotas_3_ini":5639920,"cuotas_48":1409980,"precio_preventa":78764400,"cuota_ini_pre_20":15752880,"cuotas_3_ini_pre":5250960,"cuotas_48_pre":1312740,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS TREINTA Y TRES (233): Por el frente, linda con acceso vehicular al lote y Carrera Numero 8 y mide 9.47 metros; por la derecha entrando, linda con Lote Numero 234 y mide 25.00 metros; por el fondo, linda con Lote Numero 247 y mide 15.54 metros; por la izquierda; linda con Calle Numero 1 y mide 23.94 metros. Área del Lote: 291.72 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-234',
    234,
    'M 17',
    'available',
    68750000,
    250,
    '[2014.7,937.4]'::jsonb,
    '{"pathD":"M 2037.6 905.2 L 2053.9 930.4 L 1990.9 971.2 L 1974.5 946 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":68750000,"cuota_ini_20":13750000,"cuota_inicial_20":13750000,"cuotas_3_ini":4583333,"cuotas_48":1145833,"precio_preventa":63750000,"cuota_ini_pre_20":12750000,"cuotas_3_ini_pre":4250000,"cuotas_48_pre":1062500,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS TREINTA Y CUATRO (234): Por el frente, linda con acceso vehicular al lote y Carrera Numero 8 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 235 y mide 25.00 metros; por el fondo, linda con Lote Numero 246 y mide 10.00 metros; por la izquierda; linda con Lote Numero 233 Y mide 25.00 metros. Área del Lote: 250.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-235',
    235,
    'M 17',
    'available',
    119399500,
    434.18,
    '[1988.6,904.8]'::jsonb,
    '{"pathD":"M 1941.9 895.5 L 1967.3 879.1 L 1974.8 879.2 L 2008.7 876.4 L 2023.2 882.9 L 2037.6 905.2 L 1974.5 946 L 1958.2 920.7 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":119399500,"cuota_ini_20":23879900,"cuota_inicial_20":23879900,"cuotas_3_ini":7959967,"cuotas_48":1989992,"precio_preventa":110715900,"cuota_ini_pre_20":22143180,"cuotas_3_ini_pre":7381060,"cuotas_48_pre":1845265,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS TREINTA Y CINCO (235): Por el frente, linda con acceso vehicular al lote y Carrera Numero 8 y mide 28.13 metros (línea quebrada); por la derecha entrando, linda con Lote Numero 243 y mide 10.06 metros; por el fondo, linda con Lote Numero 244, Lote Numero 245 y mide 20.00 metros; por la izquierda; linda con Lote Numero 234 y mide 25.00 metros. Área del Lote: 434.18 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-236',
    236,
    'M 18',
    'available',
    116881600,
    403.04,
    '[1971.9,819.8]'::jsonb,
    '{"pathD":"M 1966 853.8 L 1931.8 835.1 L 1965.8 777.5 L 1976.3 782.7 L 1996.6 780.9 L 1999 853 L 1972.8 855.3 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":116881600,"cuota_ini_20":23376320,"cuota_inicial_20":23376320,"cuotas_3_ini":7792107,"cuotas_48":1948027,"precio_preventa":108820800,"cuota_ini_pre_20":21764160,"cuotas_3_ini_pre":7254720,"cuotas_48_pre":1813680,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS TREINTA Y SEIS (236): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 24.10 metros (línea quebrada); por la derecha entrando, linda con Lote 222 y mide 24.02 metros; por el fondo linda con zona verde y mide 10.69 metros:  por la izquierda; linda con Lote Numero 237 Y mide 22.24 metros. Área del Lote: 403.04 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-237',
    237,
    'M 18',
    'available',
    71667700,
    247.13,
    '[1935.9,797.1]'::jsonb,
    '{"pathD":"M 1931.8 835.1 L 1905.3 820.6 L 1940 757.3 L 1959.7 768.1 L 1965.8 777.5 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":71667700,"cuota_ini_20":14333540,"cuota_inicial_20":14333540,"cuotas_3_ini":4777847,"cuotas_48":1194462,"precio_preventa":66725100,"cuota_ini_pre_20":13345020,"cuotas_3_ini_pre":4448340,"cuotas_48_pre":1112085,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS TREINTA Y SIETE (237): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 10.03 metros; por la derecha entrando, linda con Lote Numero 236 y mide 22.24 metros; por el fondo, linda con Area verde y mide 11.20 metros (línea quebrada); por la izquierda; linda con Lote Numero 238 y mide 24.00 metros. Área del Lote: 247.13 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-238',
    238,
    'M 18',
    'available',
    75632000,
    260.8,
    '[1908.5,780.7]'::jsonb,
    '{"pathD":"M 1905.3 820.6 L 1876.7 804.9 L 1911.4 741.6 L 1940 757.3 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":75632000,"cuota_ini_20":15126400,"cuota_inicial_20":15126400,"cuotas_3_ini":5042133,"cuotas_48":1260533,"precio_preventa":70416000,"cuota_ini_pre_20":14083200,"cuotas_3_ini_pre":4694400,"cuotas_48_pre":1173600,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS TREINTA Y OCHO (238): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 10.86 metros; por la derecha entrando, linda con Lote Numero 237 y mide 24.00 metros; por el fondo, linda con Area verde y mide 10.86 metros; por la izquierda; linda con Lote Numero 239 y mide 24.00 metros. Área del Lote: 260.80 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-239',
    239,
    'M 18',
    'sold',
    127487500,
    411.25,
    '[1871.7,760.6]'::jsonb,
    '{"pathD":"M 1855.2 798 L 1844.5 800.1 L 1847.8 723.8 L 1882 725.5 L 1911.4 741.6 L 1876.7 804.9 L 1867.5 799.8 Z"}'::jsonb,
    '{"ubicacion":"CALLEJON","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":127487500,"cuota_ini_20":25497500,"cuota_inicial_20":25497500,"cuotas_3_ini":8499167,"cuotas_48":2124792,"precio_preventa":115150000,"cuota_ini_pre_20":23030000,"cuotas_3_ini_pre":7676667,"cuotas_48_pre":1919167,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS TREINTA Y NUEVE (239): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 9.02 metros (línea quebrada); por la derecha entrando, linda con Lote Numero 238 y mide 24.00 metros; por el fondo, linda con Area verde y mide 22.54 metros; por la izquierda; linda con Sendero Peatonal y mide 25.42 metros. Área del Lote: 411.25 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-240',
    240,
    'M 18',
    'sold',
    110564600,
    356.66,
    '[1817.1,759]'::jsonb,
    '{"pathD":"M 1835.7 801.9 L 1809.1 807.4 L 1787.7 720.7 L 1838.8 723.4 Z"}'::jsonb,
    '{"ubicacion":"CALLEJON","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":110564600,"cuota_ini_20":22112920,"cuota_inicial_20":22112920,"cuotas_3_ini":7370973,"cuotas_48":1842743,"precio_preventa":99864800,"cuota_ini_pre_20":19972960,"cuotas_3_ini_pre":6657653,"cuotas_48_pre":1664413,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS CUARENTA (240): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 9.02 metros; por la derecha entrando, linda Sendero Peatonal y mide 26.17 metros; por el fondo, linda con Area verde y mide 17.03 metros; por la izquierda; linda con Lote Numero 241 y mide 29.70 metros. Área del Lote: 356.66 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-241',
    241,
    'M 18',
    'available',
    144753500,
    499.15,
    '[1775.3,762.9]'::jsonb,
    '{"pathD":"M 1787.7 720.7 L 1809.1 807.4 L 1788.6 811.5 L 1786.2 812.3 L 1775.9 816.9 L 1735.2 717.4 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":144753500,"cuota_ini_20":28950700,"cuota_inicial_20":28950700,"cuotas_3_ini":9650233,"cuotas_48":2412558,"precio_preventa":134770500,"cuota_ini_pre_20":26954100,"cuotas_3_ini_pre":8984700,"cuotas_48_pre":2246175,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS CUARENTA Y UNO (241): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 11.56 metros; por la derecha entrando, linda Lote Numero 240 y mide 29.70 metros; por el fondo, linda con Area verde y mide 17.51 metros; por la izquierda; linda con Lote 263 y mide 35.76 metros. Área del Lote: 449.15 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-242',
    242,
    'M 17',
    'available',
    172323800,
    594.22,
    '[1870.5,861.8]'::jsonb,
    '{"pathD":"M 1863.4 825 L 1934.8 864.2 L 1862.5 911.1 L 1819.9 845.3 L 1827.5 828.1 L 1851.4 823.3 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":172323800,"cuota_ini_20":34464760,"cuota_inicial_20":34464760,"cuotas_3_ini":11488253,"cuotas_48":2872063,"precio_preventa":160439400,"cuota_ini_pre_20":32087880,"cuotas_3_ini_pre":10695960,"cuotas_48_pre":2673990,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS CUARENTA Y DOS (242): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 19.35 metros (línea quebrada); por la derecha entrando, linda Carrera Numero 7 y mide 26.06 metros; por el fondo, linda con Lote Numero 243 y mide 28.70 metros; por la izquierda; linda con Calle Numero 4 y mide 27.10 metros. Área del Lote: 594.22 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-243',
    243,
    'M 17',
    'available',
    86732250,
    315.39,
    '[1911,897.9]'::jsonb,
    '{"pathD":"M 1878.8 936.3 L 1862.5 911.1 L 1934.8 864.2 L 1954.4 874.9 L 1967.3 879.1 L 1941.9 895.5 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":86732250,"cuota_ini_20":17346450,"cuota_inicial_20":17346450,"cuotas_3_ini":5782150,"cuotas_48":1445538,"precio_preventa":80424450,"cuota_ini_pre_20":16084890,"cuotas_3_ini_pre":5361630,"cuotas_48_pre":1340408,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS CUARENTA Y TRES (243): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 11.95 metros; por la derecha entrando, linda con Lote Numero 242 y mide 28.70 metros; por el fondo, linda con Carrera Numero 7 y mide 10.00 metros; por la izquierda; linda con Lote Numero 235, Lote Numero 244 y mide 35.06 metros. Área del Lote: 315.39 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-244',
    244,
    'M 17',
    'available',
    68750000,
    250,
    '[1918.1,929.3]'::jsonb,
    '{"pathD":"M 1958.2 920.7 L 1895.1 961.5 L 1878.8 936.3 L 1941.9 895.5 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":68750000,"cuota_ini_20":13750000,"cuota_inicial_20":13750000,"cuotas_3_ini":4583333,"cuotas_48":1145833,"precio_preventa":63750000,"cuota_ini_pre_20":12750000,"cuotas_3_ini_pre":4250000,"cuotas_48_pre":1062500,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS CUARENTA Y CUATRO (244): Por el frente, linda con acceso vehicular al lote y Carrera Numero 7 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 245 y mide 25.00 metros; por el fondo, linda con Lote Numero 235 y mide 10.00 metros; por la izquierda; linda con Lote Numero 243 y mide 25.00 metros. Área del Lote: 250.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-245',
    245,
    'M 17',
    'available',
    68750000,
    250,
    '[1934.8,953.8]'::jsonb,
    '{"pathD":"M 1911.4 986.8 L 1895.1 961.5 L 1958.2 920.7 L 1974.5 946 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":68750000,"cuota_ini_20":13750000,"cuota_inicial_20":13750000,"cuotas_3_ini":4583333,"cuotas_48":1145833,"precio_preventa":63750000,"cuota_ini_pre_20":12750000,"cuotas_3_ini_pre":4250000,"cuotas_48_pre":1062500,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS CUARENTA Y CINCO (245): Por el frente, linda con acceso vehicular al lote y Carrera Numero 7 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 246 y mide 25.00 metros; por el fondo, linda con Lote Numero 235 y mide 10.00 metros; por la izquierda; linda con Lote Numero 244 y mide 25.00 metros. Área del Lote: 250.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-246',
    246,
    'M 17',
    'available',
    68750000,
    250,
    '[1951.6,978.2]'::jsonb,
    '{"pathD":"M 1990.9 971.2 L 1927.8 1012 L 1911.4 986.8 L 1974.5 946 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":68750000,"cuota_ini_20":13750000,"cuota_inicial_20":13750000,"cuotas_3_ini":4583333,"cuotas_48":1145833,"precio_preventa":63750000,"cuota_ini_pre_20":12750000,"cuotas_3_ini_pre":4250000,"cuotas_48_pre":1062500,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS CUARENTA Y SEIS (246): Por el frente, linda con acceso vehicular al lote y Carrera Numero 7 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 247 y mide 25.00 metros; por el fondo, linda con Lote Numero 234 y mide 10.00 metros; por la izquierda; linda con Lote Numero 245 y mide 25.00 metros. Área del Lote: 250.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-247',
    247,
    'M 17',
    'available',
    139437800,
    480.82,
    '[1973.5,1016.8]'::jsonb,
    '{"pathD":"M 1959 1060.4 L 1927.8 1012 L 1990.9 971.2 L 2016.2 1010.4 L 1973.5 1061.3 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":139437800,"cuota_ini_20":27887560,"cuota_inicial_20":27887560,"cuotas_3_ini":9295853,"cuotas_48":2323963,"precio_preventa":129821400,"cuota_ini_pre_20":25964280,"cuotas_3_ini_pre":8654760,"cuotas_48_pre":2163690,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS CUARENTA Y SIETE (247): Por el frente, linda con acceso vehicular al lote y Carrera Numero 7 y mide 24.27 metros; por la derecha entrando, linda con Calle Numero 1 y mide 22.09 metros; por el fondo, linda con Lote Numero 233 y mide 15.54 metros; por la izquierda; linda con Lote Numero 246 y mide 25.00 metros. Área del Lote: 480.82 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-248',
    248,
    'M 14',
    'available',
    68724200,
    236.98,
    '[2050.3,1062.7]'::jsonb,
    '{"pathD":"M 2013.5 1051 L 2032.9 1028 L 2087.4 1073.8 L 2068.1 1096.9 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":68724200,"cuota_ini_20":13744840,"cuota_inicial_20":13744840,"cuotas_3_ini":4581613,"cuotas_48":1145403,"precio_preventa":63984600,"cuota_ini_pre_20":12796920,"cuotas_3_ini_pre":4265640,"cuotas_48_pre":1066410,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS CUARENTA Y OCHO (248): Por el frente, linda con acceso vehicular al lote y Calle Numero 1 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 249 y mide 23.71 metros; por el fondo, linda con Area verde y mide 10.00 metros; por la izquierda; linda con Lote Numero 232 y mide 23.69 metros. Área del Lote: 236.98 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-249',
    249,
    'M 14',
    'available',
    68756100,
    237.09,
    '[2031,1085.6]'::jsonb,
    '{"pathD":"M 1994.2 1074.1 L 2013.5 1051 L 2068.1 1096.9 L 2048.8 1119.9 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":68756100,"cuota_ini_20":13751220,"cuota_inicial_20":13751220,"cuotas_3_ini":4583740,"cuotas_48":1145935,"precio_preventa":64014300,"cuota_ini_pre_20":12802860,"cuotas_3_ini_pre":4267620,"cuotas_48_pre":1066905,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS CUARENTA Y NUEVE (249): Por el frente, linda con acceso vehicular al lote y Calle Numero 1 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 250 y mide 23.71 metros; por el fondo, linda con Area verde y mide 10.00 metros; por la izquierda; linda con Lote Numero 249 y mide 23.71 metros. Área del Lote: 237.09 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-250',
    250,
    'M 14',
    'available',
    68770600,
    237.14,
    '[2011.9,1108.2]'::jsonb,
    '{"pathD":"M 1974.9 1097.1 L 1994.2 1074.1 L 2048.8 1119.9 L 2029.4 1142.9 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":68770600,"cuota_ini_20":13754120,"cuota_inicial_20":13754120,"cuotas_3_ini":4584707,"cuotas_48":1146177,"precio_preventa":64027800,"cuota_ini_pre_20":12805560,"cuotas_3_ini_pre":4268520,"cuotas_48_pre":1067130,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS CINCUENTA (250): Por el frente, linda con acceso vehicular al lote y Calle Numero 1 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 251 y mide 23.72 metros; por el fondo, linda con Area verde y mide 10.00 metros; por la izquierda; linda con Lote Numero 249 y mide 23.71 metros. Área del Lote: 237.14 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-251',
    251,
    'M 14',
    'available',
    68785100,
    237.19,
    '[1992.4,1131.7]'::jsonb,
    '{"pathD":"M 1955.5 1120.1 L 1974.9 1097.1 L 2029.4 1142.9 L 2010.1 1165.9 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":68785100,"cuota_ini_20":13757020,"cuota_inicial_20":13757020,"cuotas_3_ini":4585673,"cuotas_48":1146418,"precio_preventa":64041300,"cuota_ini_pre_20":12808260,"cuotas_3_ini_pre":4269420,"cuotas_48_pre":1067355,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS CINCUENTA Y UNO (251): Por el frente, linda con acceso vehicular al lote y Calle Numero 1 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 252 y mide 23.72 metros; por el fondo, linda con Area verde y mide 10.00 metros; por la izquierda; linda con Lote Numero 250 y mide 23.72 metros. Área del Lote: 237.19 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-252',
    252,
    'M 14',
    'available',
    68799600,
    237.24,
    '[1973.2,1154.5]'::jsonb,
    '{"pathD":"M 1936.2 1143.1 L 1955.5 1120.1 L 2010.1 1165.9 L 1990.8 1189 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":68799600,"cuota_ini_20":13759920,"cuota_inicial_20":13759920,"cuotas_3_ini":4586640,"cuotas_48":1146660,"precio_preventa":64054800,"cuota_ini_pre_20":12810960,"cuotas_3_ini_pre":4270320,"cuotas_48_pre":1067580,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS CINCUENTA Y DOS (252): Por el frente, linda con acceso vehicular al lote y Calle Numero 1 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 253 y mide 23.73 metros; por el fondo, linda con Area verde y mide 10.00 metros; por la izquierda; linda con Lote Numero 251 y mide 23.72 metros. Área del Lote: 237.24 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-253',
    253,
    'M 14',
    'available',
    68817000,
    237.3,
    '[1953.8,1177.6]'::jsonb,
    '{"pathD":"M 1916.9 1166.1 L 1936.2 1143.1 L 1990.8 1189 L 1971.5 1212 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":68817000,"cuota_ini_20":13763400,"cuota_inicial_20":13763400,"cuotas_3_ini":4587800,"cuotas_48":1146950,"precio_preventa":64071000,"cuota_ini_pre_20":12814200,"cuotas_3_ini_pre":4271400,"cuotas_48_pre":1067850,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS CINCUENTA Y TRES (253): Por el frente, linda con acceso vehicular al lote y Calle Numero 1 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 279 y mide 23.73 metros; por el fondo, linda con Area verde y mide 10.00 metros; por la izquierda; linda con Lote Numero 252 y mide 23.73 metros. Área del Lote: 237.30 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-254',
    254,
    'M 16',
    'available',
    100064500,
    345.05,
    '[1910.6,1104]'::jsonb,
    '{"pathD":"M 1945.9 1084.3 L 1945.2 1095 L 1898.9 1150.1 L 1870.1 1105.5 L 1933.2 1064.6 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":100064500,"cuota_ini_20":20012900,"cuota_inicial_20":20012900,"cuotas_3_ini":6670967,"cuotas_48":1667742,"precio_preventa":93163500,"cuota_ini_pre_20":18632700,"cuotas_3_ini_pre":6210900,"cuotas_48_pre":1552725,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS CINCUENTA Y CUATRO (254): Por el frente, linda con acceso vehicular al lote y Carrera Numero 7 y mide 11.60 metros; por la derecha entrando, linda con Lote Numero 255 y mide 25.00 metros; por el fondo, linda con Lote Numero 278 y mide 17.68 metros; por la izquierda; linda con Calle Numero 1 y mide 23.94 metros. Área del Lote: 345.05 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-255',
    255,
    'M 16',
    'available',
    68750000,
    250,
    '[1893,1073.2]'::jsonb,
    '{"pathD":"M 1916.9 1039.4 L 1933.2 1064.6 L 1870.1 1105.5 L 1853.8 1080.2 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":68750000,"cuota_ini_20":13750000,"cuota_inicial_20":13750000,"cuotas_3_ini":4583333,"cuotas_48":1145833,"precio_preventa":63750000,"cuota_ini_pre_20":12750000,"cuotas_3_ini_pre":4250000,"cuotas_48_pre":1062500,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS CINCUENTA Y CINCO (255): Por el frente, linda con acceso vehicular al lote y Carrera Numero 7 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 256 y mide 25.00 metros; por el fondo, linda con Lote Numero 277 y mide 10.00 metros; por la izquierda; linda con Lote Numero 254 y mide 25.00 metros. Área del Lote: 250.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-256',
    256,
    'M 16',
    'available',
    68750000,
    250,
    '[1877.1,1047.2]'::jsonb,
    '{"pathD":"M 1900.5 1014.2 L 1916.9 1039.4 L 1853.8 1080.2 L 1837.4 1055 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":68750000,"cuota_ini_20":13750000,"cuota_inicial_20":13750000,"cuotas_3_ini":4583333,"cuotas_48":1145833,"precio_preventa":63750000,"cuota_ini_pre_20":12750000,"cuotas_3_ini_pre":4250000,"cuotas_48_pre":1062500,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS CINCUENTA Y SEIS (256): Por el frente, linda con acceso vehicular al lote y Carrera Numero 7 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 257 y mide 25.00 metros; por el fondo, linda con Lote Numero 276 y mide 10.00 metros; por la izquierda; linda con Lote Numero 255 y mide 25.00 metros. Área del Lote: 250.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-257',
    257,
    'M 16',
    'available',
    68750000,
    250,
    '[1860.8,1022]'::jsonb,
    '{"pathD":"M 1884.2 988.9 L 1900.5 1014.2 L 1837.4 1055 L 1821.1 1029.7 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":68750000,"cuota_ini_20":13750000,"cuota_inicial_20":13750000,"cuotas_3_ini":4583333,"cuotas_48":1145833,"precio_preventa":63750000,"cuota_ini_pre_20":12750000,"cuotas_3_ini_pre":4250000,"cuotas_48_pre":1062500,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS CINCUENTA Y SIETE (257): Por el frente, linda con acceso vehicular al lote y Carrera Numero 7 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 258 y mide 25.00 metros; por el fondo, linda con Lote Numero 275 y mide 10.00 metros; por la izquierda; linda con Lote Numero 256 y mide 25.00 metros. Área del Lote: 250.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-258',
    258,
    'M 16',
    'available',
    68750000,
    250,
    '[1844.1,997.5]'::jsonb,
    '{"pathD":"M 1867.9 963.7 L 1884.2 988.9 L 1821.1 1029.7 L 1804.8 1004.5 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":68750000,"cuota_ini_20":13750000,"cuota_inicial_20":13750000,"cuotas_3_ini":4583333,"cuotas_48":1145833,"precio_preventa":63750000,"cuota_ini_pre_20":12750000,"cuotas_3_ini_pre":4250000,"cuotas_48_pre":1062500,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS CINCUENTA Y OCHO (258): Por el frente, linda con acceso vehicular al lote y Carrera Numero 7 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 259 y mide 25.00 metros; por el fondo, linda con Lote Numero 274 y mide 10.00 metros; por la izquierda; linda con Lote Numero 257 y mide 25.00 metros. Área del Lote: 250.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-259',
    259,
    'M 16',
    'available',
    68750000,
    250,
    '[1828.2,971.5]'::jsonb,
    '{"pathD":"M 1851.6 938.5 L 1867.9 963.7 L 1804.8 1004.5 L 1788.5 979.3 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":68750000,"cuota_ini_20":13750000,"cuota_inicial_20":13750000,"cuotas_3_ini":4583333,"cuotas_48":1145833,"precio_preventa":63750000,"cuota_ini_pre_20":12750000,"cuotas_3_ini_pre":4250000,"cuotas_48_pre":1062500,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS CINCUENTA Y NUEVE (259): Por el frente, linda con acceso vehicular al lote y Carrera Numero 7 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 260 y mide 25.00 metros; por el fondo, linda con Lote Numero 273 y mide 10.00 metros; por la izquierda; linda con Lote Numero 258 y mide 25.00 metros. Área del Lote: 250.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-260',
    260,
    'M 16',
    'available',
    68750000,
    250,
    '[1811.4,947.1]'::jsonb,
    '{"pathD":"M 1835.2 913.2 L 1851.6 938.5 L 1788.5 979.3 L 1772.1 954 L 1803.7 933.6 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":68750000,"cuota_ini_20":13750000,"cuota_inicial_20":13750000,"cuotas_3_ini":4583333,"cuotas_48":1145833,"precio_preventa":63750000,"cuota_ini_pre_20":12750000,"cuotas_3_ini_pre":4250000,"cuotas_48_pre":1062500,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS SESENTA (260): Por el frente, linda con acceso vehicular al lote y Carrera Numero 7 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 261, Lote Numero 260 y mide 25.00 metros; por el fondo, linda con Lote Numero 272 y mide 10.00 metros; por la izquierda entrando, linda con Lote Numero 259 y mide 25.00 metros. Área del Lote: 250.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-261',
    261,
    'M 16',
    'available',
    104337750,
    379.41,
    '[1763.4,905.3]'::jsonb,
    '{"pathD":"M 1803.7 933.6 L 1772.1 954 L 1725.5 881.9 L 1749.1 854.9 L 1752 853.7 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":104337750,"cuota_ini_20":20867550,"cuota_inicial_20":20867550,"cuotas_3_ini":6955850,"cuotas_48":1738963,"precio_preventa":96749550,"cuota_ini_pre_20":19349910,"cuotas_3_ini_pre":6449970,"cuotas_48_pre":1612493,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS SESENTA Y UNO (261): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 12.97 metros (línea quebrada); por la derecha entrando, linda con Lote Numero 271 y mide 28.60 metros; por el fondo, linda con Lote Numero 260 y mide 12.50 metros; por la izquierda; linda con Lote Numero 262 y mide 31.69 metros. Área del Lote: 379.41 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-262',
    262,
    'M 16',
    'available',
    110867000,
    382.3,
    '[1794.4,885]'::jsonb,
    '{"pathD":"M 1803.7 933.6 L 1752 853.7 L 1779.7 841.4 L 1790.9 844.8 L 1835.2 913.2 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":110867000,"cuota_ini_20":22173400,"cuota_inicial_20":22173400,"cuotas_3_ini":7391133,"cuotas_48":1847783,"precio_preventa":103221000,"cuota_ini_pre_20":20644200,"cuotas_3_ini_pre":6881400,"cuotas_48_pre":1720350,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS SESENTA Y DOS (262): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 14.33 metros; por la derecha entrando, linda con Lote Numero 261 y mide 31.69 metros; por el fondo, linda con Lote Numero 260 y mide 12.50 metros; por la izquierda; linda con Carrera Numero 7 y mide 27.13 metros. Área del Lote: 382.30 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-263',
    263,
    'M 18',
    'available',
    154835700,
    499.47,
    '[1735.4,770.6]'::jsonb,
    '{"pathD":"M 1775.9 816.9 L 1741.2 832.1 L 1694.5 722.7 L 1704.2 715.2 L 1735.2 717.4 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":154835700,"cuota_ini_20":30967140,"cuota_inicial_20":30967140,"cuotas_3_ini":10322380,"cuotas_48":2580595,"precio_preventa":139851600,"cuota_ini_pre_20":27970320,"cuotas_3_ini_pre":9323440,"cuotas_48_pre":2330860,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS SESENTA Y TRES (263): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 12.58 metros; por la derecha entrando, linda con Sendero Peatonal y mide 35.71 metros; por el fondo, linda con Area verde y mide 14.37 metros (línea quebrada); por la izquierda; linda con Lote Numero 264 y mide 39.58 metros. Área del Lote: 499.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-264',
    264,
    'M 18',
    'available',
    123469900,
    398.29,
    '[1705,786.1]'::jsonb,
    '{"pathD":"M 1668.3 743 L 1694.5 722.7 L 1741.2 832.1 L 1738.2 833.4 L 1731.9 838 L 1719.2 852.6 L 1686 781 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":123469900,"cuota_ini_20":24693980,"cuota_inicial_20":24693980,"cuotas_3_ini":8231327,"cuotas_48":2057832,"precio_preventa":111521200,"cuota_ini_pre_20":22304240,"cuotas_3_ini_pre":7434747,"cuotas_48_pre":1858687,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS SESENTA Y CUATRO (264): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 10.14 metros (línea quebrada); por la derecha entrando, linda con Lote Numero 263 y mide 39.58 metros; por el fondo, linda con Area verde y mide 11.02 metros; por la izquierda; linda con Lote Numero 265, Area verde y mide 40.20 metros. Área del Lote: 398.29 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-265',
    265,
    'M 18',
    'available',
    79735100,
    257.21,
    '[1691.8,827.6]'::jsonb,
    '{"pathD":"M 1686 781 L 1719.1 852.7 L 1699.2 875.3 L 1663.3 806.8 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":79735100,"cuota_ini_20":15947020,"cuota_inicial_20":15947020,"cuotas_3_ini":5315673,"cuotas_48":1328918,"precio_preventa":72018800,"cuota_ini_pre_20":14403760,"cuotas_3_ini_pre":4801253,"cuotas_48_pre":1200313,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS SESENTA Y CINCO (265): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 10.01 metros; por la derecha entrando, linda con Lote Numero 264 y mide 26.26 metros; por el fondo, linda con Area verde y mide 11.42 metros; por la izquierda; linda con Lote Numero 266 y mide 25.72 metros. Área del Lote: 257.21 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-266',
    266,
    'M 18',
    'available',
    75481900,
    243.49,
    '[1671.2,852.3]'::jsonb,
    '{"pathD":"M 1663.3 806.8 L 1699.2 875.3 L 1679.4 897.9 L 1643 830.1 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":75481900,"cuota_ini_20":15096380,"cuota_inicial_20":15096380,"cuotas_3_ini":5032127,"cuotas_48":1258032,"precio_preventa":68177200,"cuota_ini_pre_20":13635440,"cuotas_3_ini_pre":4545147,"cuotas_48_pre":1136287,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS SESENTA Y SEIS (266): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 10.01 metros; por la derecha entrando, linda con Lote Numero 265 y mide 25.72 metros; por el fondo, linda con Area verde y mide 10.28 metros; por la izquierda; linda con Lote Numero 267 y mide 25.63 metros. Área del Lote: 243.49 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-267',
    267,
    'M 18',
    'available',
    75364100,
    243.11,
    '[1649.5,873.8]'::jsonb,
    '{"pathD":"M 1674.7 902.1 L 1653.6 913.2 L 1619.9 849.5 L 1631.2 843.5 L 1643 830.1 L 1679.4 897.9 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":75364100,"cuota_ini_20":15072820,"cuota_inicial_20":15072820,"cuotas_3_ini":5024273,"cuotas_48":1256068,"precio_preventa":68070800,"cuota_ini_pre_20":13614160,"cuotas_3_ini_pre":4538053,"cuotas_48_pre":1134513,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS SESENTA Y SIETE (267): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 10.05 metros (línea quebrada); por la derecha entrando, linda con Lote Numero 266 y mide 25.63 metros; por el fondo, linda con Area verde y mide 10.20 metros (línea quebrada); por la izquierda; linda con Lote Numero 268 y mide 24.00 metros. Área del Lote: 243.11 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-268',
    268,
    'M 18',
    'available',
    72645400,
    234.34,
    '[1623.5,887.1]'::jsonb,
    '{"pathD":"M 1634.7 921.1 L 1623.3 920.3 L 1593.3 863.5 L 1619.9 849.5 L 1653.6 913.2 L 1641.2 919.8 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":72645400,"cuota_ini_20":14529080,"cuota_inicial_20":14529080,"cuotas_3_ini":4843027,"cuotas_48":1210757,"precio_preventa":65615200,"cuota_ini_pre_20":13123040,"cuotas_3_ini_pre":4374347,"cuotas_48_pre":1093587,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS SESENTA Y OCHO (268): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 10.69 metros (línea quebrada); por la derecha entrando, linda con Lote Numero 267 y mide 24.00 metros; por el fondo, linda con Area verde y mide 10.00 metros; por la izquierda; linda con Lote Numero 269 y mide 21.37 metros. Área del Lote: 234.34 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-269',
    269,
    'M 18',
    'sold',
    84239400,
    271.74,
    '[1584.9,895.2]'::jsonb,
    '{"pathD":"M 1572.1 915.5 L 1542 890.6 L 1593.3 863.5 L 1623.3 920.3 L 1575.5 916.9 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":84239400,"cuota_ini_20":16847880,"cuota_inicial_20":16847880,"cuotas_3_ini":5615960,"cuotas_48":1403990,"precio_preventa":76087200,"cuota_ini_pre_20":15217440,"cuotas_3_ini_pre":5072480,"cuotas_48_pre":1268120,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS SESENTA Y NUEVE (269): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 30.17 metros (línea quebrada); por la derecha entrando, linda con Lote Numero 268 y mide 21.37 metros; por la izquierda; linda con Area verde y mide 19.29 metros. Área del Lote: 271.74 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-270',
    270,
    'M 16',
    'sold',
    87269700,
    300.93,
    '[1705,955.1]'::jsonb,
    '{"pathD":"M 1709.2 994.7 L 1674.3 940.6 L 1677.6 927.7 L 1685.9 923.3 L 1696.2 915.2 L 1699.7 911.2 L 1740.6 974.4 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":87269700,"cuota_ini_20":17453940,"cuota_inicial_20":17453940,"cuotas_3_ini":5817980,"cuotas_48":1454495,"precio_preventa":81251100,"cuota_ini_pre_20":16250220,"cuotas_3_ini_pre":5416740,"cuotas_48_pre":1354185,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS SETENTA (270): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 14.25 metros (línea quebrada); por la derecha entrando, linda con Carrera Numero 6 y mide 21.45 metros; por el fondo, linda con Lote Numero 272 y mide 12.43 metros; por la izquierda; linda con Lote Numero 271 y mide 25.05 metros. Área del Lote: 300.93 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-271',
    271,
    'M 16',
    'available',
    92199250,
    335.27,
    '[1735.1,929.5]'::jsonb,
    '{"pathD":"M 1699.7 911.2 L 1725.5 881.9 L 1772.1 954 L 1740.6 974.4 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":92199250,"cuota_ini_20":18439850,"cuota_inicial_20":18439850,"cuotas_3_ini":6146617,"cuotas_48":1536654,"precio_preventa":85493850,"cuota_ini_pre_20":17098770,"cuotas_3_ini_pre":5699590,"cuotas_48_pre":1424897,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS SETENTA Y UNO (271): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 12.99 metros; por la derecha entrando, linda con Lote Numero 270 y mide 25.05 metros; por el fondo, linda con Lote Numero 272 y mide 12.50 metros; por la izquierda; linda con Lote Numero 261 y mide 28.60 metros. Área del Lote: 335.27 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-272',
    272,
    'M 16',
    'available',
    68750000,
    250,
    '[1749.6,985.5]'::jsonb,
    '{"pathD":"M 1788.5 979.3 L 1725.4 1020.1 L 1709.1 994.9 L 1709.2 994.7 L 1740.6 974.4 L 1772.1 954 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":68750000,"cuota_ini_20":13750000,"cuota_inicial_20":13750000,"cuotas_3_ini":4583333,"cuotas_48":1145833,"precio_preventa":63750000,"cuota_ini_pre_20":12750000,"cuotas_3_ini_pre":4250000,"cuotas_48_pre":1062500,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS SETENTA Y DOS (272): Por el frente, linda con acceso vehicular al lote y Carrera Numero 6 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 273 y mide 25.00 metros; por el fondo, linda con Lote Numero 260 y mide 10.00 metros; por la izquierda; linda con Lote Numero 270, Lote Numero 271 y mide 24.93 metros. Área del Lote: 250.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-273',
    273,
    'M 16',
    'available',
    68750000,
    250,
    '[1765.1,1012.3]'::jsonb,
    '{"pathD":"M 1804.8 1004.5 L 1741.7 1045.3 L 1725.4 1020.1 L 1788.5 979.3 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":68750000,"cuota_ini_20":13750000,"cuota_inicial_20":13750000,"cuotas_3_ini":4583333,"cuotas_48":1145833,"precio_preventa":63750000,"cuota_ini_pre_20":12750000,"cuotas_3_ini_pre":4250000,"cuotas_48_pre":1062500,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS SETENTA Y TRES (273): Por el frente, linda con acceso vehicular al lote y Carrera Numero 6 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 274 y mide 25.00 metros; por el fondo, linda con Lote Numero 259 y mide 10.00 metros; por la izquierda; linda con Lote Numero 272 y mide 25.00 metros. Área del Lote: 250.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-274',
    274,
    'M 16',
    'available',
    68750000,
    250,
    '[1782.3,1035.9]'::jsonb,
    '{"pathD":"M 1821.1 1029.7 L 1758 1070.6 L 1741.7 1045.3 L 1804.8 1004.5 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":68750000,"cuota_ini_20":13750000,"cuota_inicial_20":13750000,"cuotas_3_ini":4583333,"cuotas_48":1145833,"precio_preventa":63750000,"cuota_ini_pre_20":12750000,"cuotas_3_ini_pre":4250000,"cuotas_48_pre":1062500,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS SETENTA Y CUATRO (274): Por el frente, linda con acceso vehicular al lote y Carrera Numero 6 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 275 y mide 25.00 metros; por el fondo, linda con Lote Numero 258 y mide 10.00 metros; por la izquierda; linda con Lote Numero 273 y mide 25.00 metros. Área del Lote: 250.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-275',
    275,
    'M 16',
    'available',
    68750000,
    250,
    '[1797.7,1062.8]'::jsonb,
    '{"pathD":"M 1837.4 1055 L 1774.4 1095.8 L 1758 1070.6 L 1821.1 1029.7 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":68750000,"cuota_ini_20":13750000,"cuota_inicial_20":13750000,"cuotas_3_ini":4583333,"cuotas_48":1145833,"precio_preventa":63750000,"cuota_ini_pre_20":12750000,"cuotas_3_ini_pre":4250000,"cuotas_48_pre":1062500,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS SETENTA Y CINCO (275): Por el frente, linda con acceso vehicular al lote y Carrera Numero 6 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 276 y mide 25.00 metros; por el fondo, linda con Lote Numero 257 y mide 10.00 metros; por la izquierda; linda con Lote Numero 274 y mide 25.00 metros. Área del Lote: 250.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-276',
    276,
    'M 16',
    'available',
    68750000,
    250,
    '[1814.1,1088]'::jsonb,
    '{"pathD":"M 1853.8 1080.2 L 1790.7 1121 L 1774.4 1095.8 L 1837.4 1055 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":68750000,"cuota_ini_20":13750000,"cuota_inicial_20":13750000,"cuotas_3_ini":4583333,"cuotas_48":1145833,"precio_preventa":63750000,"cuota_ini_pre_20":12750000,"cuotas_3_ini_pre":4250000,"cuotas_48_pre":1062500,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS SETENTA Y SEIS (276): Por el frente, linda con acceso vehicular al lote y Carrera Numero 6 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 277 y mide 25.00 metros; por el fondo, linda con Lote Numero 256 y mide 10.00 metros; por la izquierda; linda con Lote Numero 275 y mide 25.00 metros. Área del Lote: 250.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-277',
    277,
    'M 16',
    'available',
    68750000,
    250,
    '[1830.4,1113.2]'::jsonb,
    '{"pathD":"M 1870.1 1105.5 L 1807 1146.3 L 1790.7 1121 L 1853.8 1080.2 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":68750000,"cuota_ini_20":13750000,"cuota_inicial_20":13750000,"cuotas_3_ini":4583333,"cuotas_48":1145833,"precio_preventa":63750000,"cuota_ini_pre_20":12750000,"cuotas_3_ini_pre":4250000,"cuotas_48_pre":1062500,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS SETENTA Y SIETE (277): Por el frente, linda con acceso vehicular al lote y Carrera Numero 6 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 278 y mide 25.00 metros; por el fondo, linda con Lote Numero 255 y mide 10.00 metros; por la izquierda; linda con Lote Numero 276 y mide 25.00 metros. Área del Lote: 250.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-278',
    278,
    'M 16',
    'available',
    154903500,
    534.15,
    '[1854.5,1153.8]'::jsonb,
    '{"pathD":"M 1841.8 1200 L 1807 1146.3 L 1870.1 1105.5 L 1898.9 1150.1 L 1856.2 1200.9 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":154903500,"cuota_ini_20":30980700,"cuota_inicial_20":30980700,"cuotas_3_ini":10326900,"cuotas_48":2581725,"precio_preventa":144220500,"cuota_ini_pre_20":28844100,"cuotas_3_ini_pre":9614700,"cuotas_48_pre":2403675,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS SETENTA Y OCHO (278): Por el frente, linda con acceso vehicular al lote y Carrera Numero 6 y mide 26.91 metros; por la derecha entrando, linda con Calle Numero 1 y mide 22.09 metros; por el fondo, linda con Lote Numero 254 y mide 17.68 metros; por la izquierda; linda con Lote Numero 277 y mide 25.00 metros. Área del Lote: 534.15 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-279',
    279,
    'M 14',
    'available',
    68834400,
    237.36,
    '[1934,1201.6]'::jsonb,
    '{"pathD":"M 1897.5 1189.1 L 1916.9 1166.1 L 1971.5 1212 L 1952.2 1235 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":68834400,"cuota_ini_20":13766880,"cuota_inicial_20":13766880,"cuotas_3_ini":4588960,"cuotas_48":1147240,"precio_preventa":64087200,"cuota_ini_pre_20":12817440,"cuotas_3_ini_pre":4272480,"cuotas_48_pre":1068120,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS SETENTA Y NUEVE (279): Por el frente, linda con acceso vehicular al lote y Calle Numero 1 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 280 y mide 23.74 metros; por el fondo, linda con Area verde y mide 10.00 metros; por la izquierda; linda con Lote Numero 252 y mide 23.73 metros. Área del Lote: 237.36 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-280',
    280,
    'M 14',
    'available',
    68854700,
    237.43,
    '[1915,1224]'::jsonb,
    '{"pathD":"M 1878.2 1212.1 L 1897.5 1189.1 L 1952.2 1235 L 1932.9 1258 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":68854700,"cuota_ini_20":13770940,"cuota_inicial_20":13770940,"cuotas_3_ini":4590313,"cuotas_48":1147578,"precio_preventa":64106100,"cuota_ini_pre_20":12821220,"cuotas_3_ini_pre":4273740,"cuotas_48_pre":1068435,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS OCHENTA (280): Por el frente, linda con acceso vehicular al lote y Calle Numero 1 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 281 y mide 23.75 metros; por el fondo, linda con Area verde y mide 10.00 metros; por la izquierda; linda con Lote Numero 279 y mide 23.74 metros. Área del Lote: 237.43 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-281',
    281,
    'M 14',
    'available',
    79201900,
    273.11,
    '[1894.6,1248]'::jsonb,
    '{"pathD":"M 1856 1238.6 L 1878.2 1212.1 L 1932.9 1258 L 1910.6 1284.5 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":79201900,"cuota_ini_20":15840380,"cuota_inicial_20":15840380,"cuotas_3_ini":5280127,"cuotas_48":1320032,"precio_preventa":73739700,"cuota_ini_pre_20":14747940,"cuotas_3_ini_pre":4915980,"cuotas_48_pre":1228995,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS OCHENTA Y UNO (281): Por el frente, linda con acceso vehicular al lote y Calle Numero 1 y mide 11.50 metros; por la derecha entrando, linda con Lote 282 y mide 23.75 metros; por el fondo, linda con Area verde y mide 11.50 metros; por la izquierda; linda con Lote Numero 280 y mide 23.75 metros. Área del Lote: 273.11 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-282',
    282,
    'M 14',
    'available',
    79228000,
    273.2,
    '[1872.2,1274.8]'::jsonb,
    '{"pathD":"M 1856 1238.6 L 1910.6 1284.5 L 1888.4 1311 L 1833.7 1265.1 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":79228000,"cuota_ini_20":15845600,"cuota_inicial_20":15845600,"cuotas_3_ini":5281867,"cuotas_48":1320467,"precio_preventa":73764000,"cuota_ini_pre_20":14752800,"cuotas_3_ini_pre":4917600,"cuotas_48_pre":1229400,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS OCHENTA Y DOS (282): Por el frente, linda con acceso vehicular al lote y Calle Numero 1 y mide 11.50 metros; por la derecha entrando, linda con Lote Numero 283 y mide 23.76 metros; por el fondo, linda con Area verde y mide 11.50 metros; por la izquierda; linda con Lote 281 y mide 23.75 metros. Área del Lote: 273.20 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-283',
    283,
    'M 14',
    'available',
    75806000,
    261.4,
    '[1850.6,1300.4]'::jsonb,
    '{"pathD":"M 1833.7 1265.1 L 1888.4 1311 L 1867.2 1336.3 L 1812.5 1290.4 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":75806000,"cuota_ini_20":15161200,"cuota_inicial_20":15161200,"cuotas_3_ini":5053733,"cuotas_48":1263433,"precio_preventa":70578000,"cuota_ini_pre_20":14115600,"cuotas_3_ini_pre":4705200,"cuotas_48_pre":1176300,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS OCHENTA Y TRES (283): Por el frente, linda con acceso vehicular al lote y Calle Numero 1 y mide 11.50 metros; por la derecha entrando, linda con Lote Numero 284 y mide 23.77 metros; por el fondo, linda con Area verde y mide 11.50 metros; por la izquierda; linda con Lote Numero 282 y mide 23.76 metros. Área del Lote: 261.40 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-284',
    284,
    'M 14',
    'available',
    82693500,
    285.15,
    '[1828.5,1326.5]'::jsonb,
    '{"pathD":"M 1812.5 1290.4 L 1867.2 1336.3 L 1844 1363.9 L 1789.3 1318 L 1789.3 1318 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":82693500,"cuota_ini_20":16538700,"cuota_inicial_20":16538700,"cuotas_3_ini":5512900,"cuotas_48":1378225,"precio_preventa":76990500,"cuota_ini_pre_20":15398100,"cuotas_3_ini_pre":5132700,"cuotas_48_pre":1283175,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS OCHENTA Y CUATRO (284): Por el frente, linda con acceso vehicular al lote y Calle Numero 1 y mide 12.00 metros; por la derecha entrando, linda con Lote Numero 308 y mide 23.76 metros; por el fondo, linda con Area Verde y mide 12.00 metros; por la izquierda; linda con Lote Numero 283 y mide 23.77 metros.  Área del Lote: 285.15 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-285',
    285,
    'M 15',
    'available',
    85564500,
    295.05,
    '[1793.8,1247.8]'::jsonb,
    '{"pathD":"M 1827.9 1234.6 L 1781.7 1289.7 L 1756.1 1250.1 L 1819.2 1209.3 L 1828.6 1223.9 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":85564500,"cuota_ini_20":17112900,"cuota_inicial_20":17112900,"cuotas_3_ini":5704300,"cuotas_48":1426075,"precio_preventa":79663500,"cuota_ini_pre_20":15932700,"cuotas_3_ini_pre":5310900,"cuotas_48_pre":1327725,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS OCHENTA Y CINCO (285): Por el frente, linda con acceso vehicular al lote y Carrera Numero 6 y mide 9.60 metros; por la derecha entrando, linda con Lote Numero 286 y mide 25.00 metros; por el fondo, linda con Lote Numero 307 y mide 15.68 metro; por la izquierda; linda con Calle Numero 1 y mide 23.94 metros Área del Lote: 295.05 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-286',
    286,
    'M 15',
    'available',
    85250000,
    310,
    '[1777.1,1214.7]'::jsonb,
    '{"pathD":"M 1798.9 1178 L 1819.2 1209.3 L 1756.1 1250.1 L 1735.8 1218.8 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":85250000,"cuota_ini_20":17050000,"cuota_inicial_20":17050000,"cuotas_3_ini":5683333,"cuotas_48":1420833,"precio_preventa":79050000,"cuota_ini_pre_20":15810000,"cuotas_3_ini_pre":5270000,"cuotas_48_pre":1317500,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS OCHENTA Y SEIS (286): Por el frente, linda con acceso vehicular al lote y Carrera Numero 6 y mide 12.40 metros; por la derecha entrando, linda con Lote Numero 287 y mide 25.00 metros; por el fondo, linda con Lote Numero 308 y mide 12.40 metro; por la izquierda; linda con Lote Numero 285 y mide 25.00 metros Área del Lote: 310.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-287',
    287,
    'M 15',
    'available',
    85250000,
    310,
    '[1757.6,1182.1]'::jsonb,
    '{"pathD":"M 1778.7 1146.7 L 1798.9 1178 L 1735.8 1218.8 L 1715.6 1187.5 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":85250000,"cuota_ini_20":17050000,"cuota_inicial_20":17050000,"cuotas_3_ini":5683333,"cuotas_48":1420833,"precio_preventa":79050000,"cuota_ini_pre_20":15810000,"cuotas_3_ini_pre":5270000,"cuotas_48_pre":1317500,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS OCHENTA Y SIETE (287): Por el frente, linda con acceso vehicular al lote y Carrera Numero 6 y mide 12.40 metros; por la derecha entrando, linda con Lote Numero 288 y mide 25.00 metros; por el fondo, linda con Lote Numero 305 y mide 12.40 metro; por la izquierda linda con Lote Numero 286 y mide 25.00 metros Área del Lote: 310.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-288',
    288,
    'M 15',
    'available',
    85250000,
    310,
    '[1736.7,1152.1]'::jsonb,
    '{"pathD":"M 1758.4 1115.4 L 1778.7 1146.7 L 1715.6 1187.5 L 1695.3 1156.3 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":85250000,"cuota_ini_20":17050000,"cuota_inicial_20":17050000,"cuotas_3_ini":5683333,"cuotas_48":1420833,"precio_preventa":79050000,"cuota_ini_pre_20":15810000,"cuotas_3_ini_pre":5270000,"cuotas_48_pre":1317500,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS OCHENTA Y OCHO (288): Por el frente, linda con acceso vehicular al lote y Carrera Numero 6 y mide 12.40 metros; por la derecha entrando, linda con Lote Numero 289 y mide 25.00 metros; por el fondo, linda con Lote Numero 304 y mide 12.40 metro; por la izquierda linda con Lote Numero 287 y mide 25.00 metros Área del Lote: 310.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-289',
    289,
    'M 15',
    'available',
    85250000,
    310,
    '[1716.4,1120.9]'::jsonb,
    '{"pathD":"M 1738.2 1084.2 L 1758.4 1115.4 L 1695.3 1156.3 L 1675.1 1125 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":85250000,"cuota_ini_20":17050000,"cuota_inicial_20":17050000,"cuotas_3_ini":5683333,"cuotas_48":1420833,"precio_preventa":79050000,"cuota_ini_pre_20":15810000,"cuotas_3_ini_pre":5270000,"cuotas_48_pre":1317500,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS OCHENTA Y NUEVE (289): Por el frente, linda con acceso vehicular al lote y Carrera Numero 6 y mide 12.40 metros; por la derecha entrando, linda con Lote Numero 290 y mide 25.00 metros; por el fondo, linda con Lote Numero 303 y mide 12.40 metro; por la izquierda linda con Lote Numero 288 y mide 25.00 metros Área del Lote:310.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-290',
    290,
    'M 15',
    'available',
    85250000,
    310,
    '[1696.9,1088.3]'::jsonb,
    '{"pathD":"M 1717.9 1052.9 L 1738.2 1084.2 L 1675.1 1125 L 1654.9 1093.7 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":85250000,"cuota_ini_20":17050000,"cuota_inicial_20":17050000,"cuotas_3_ini":5683333,"cuotas_48":1420833,"precio_preventa":79050000,"cuota_ini_pre_20":15810000,"cuotas_3_ini_pre":5270000,"cuotas_48_pre":1317500,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS NOVENTA (290): Por el frente, linda con acceso vehicular al lote y Carrera Numero 6 y mide 12.40 metros; por la derecha entrando, linda con Lote Numero 291 y mide 25.00 metros; por el fondo, linda con Lote Numero 302 y mide 12.40 metro; por la izquierda linda con Lote Numero 289 y mide 25.00 metros Área del Lote:310.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-291',
    291,
    'M 15',
    'available',
    68750000,
    250,
    '[1677.8,1061.5]'::jsonb,
    '{"pathD":"M 1701.6 1027.6 L 1717.9 1052.9 L 1654.9 1093.7 L 1638.5 1068.4 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":68750000,"cuota_ini_20":13750000,"cuota_inicial_20":13750000,"cuotas_3_ini":4583333,"cuotas_48":1145833,"precio_preventa":63750000,"cuota_ini_pre_20":12750000,"cuotas_3_ini_pre":4250000,"cuotas_48_pre":1062500,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS NOVENTA Y UNO (291): Por el frente, linda con acceso vehicular al lote y Carrera Numero 6 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 292 y mide 25.00 metros; por el fondo, linda con Lote Numero 301 y mide 10.00 metro; por la izquierda linda con Lote Numero 290 y mide 25.00 metros Área del Lote:250.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-292',
    292,
    'M 15',
    'available',
    68750000,
    250,
    '[1662.3,1034.6]'::jsonb,
    '{"pathD":"M 1685.3 1002.4 L 1701.6 1027.6 L 1638.5 1068.4 L 1622.2 1043.2 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":68750000,"cuota_ini_20":13750000,"cuota_inicial_20":13750000,"cuotas_3_ini":4583333,"cuotas_48":1145833,"precio_preventa":63750000,"cuota_ini_pre_20":12750000,"cuotas_3_ini_pre":4250000,"cuotas_48_pre":1062500,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS NOVENTA Y DOS (292): Por el frente, linda con acceso vehicular al lote y Carrera Numero 6 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 293 y mide 25.00 metros; por el fondo, linda con Lote Numero 300 y mide 10.00 metros; por la izquierda linda con Lote Numero 291 y mide 25.00 metros Área del Lote:250.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-293',
    293,
    'M 15',
    'available',
    68750000,
    250,
    '[1645.6,1010.2]'::jsonb,
    '{"pathD":"M 1669 977.2 L 1685.3 1002.4 L 1622.2 1043.2 L 1605.9 1018 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":68750000,"cuota_ini_20":13750000,"cuota_inicial_20":13750000,"cuotas_3_ini":4583333,"cuotas_48":1145833,"precio_preventa":63750000,"cuota_ini_pre_20":12750000,"cuotas_3_ini_pre":4250000,"cuotas_48_pre":1062500,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS NOVENTA Y TRES (293): Por el frente, linda con acceso vehicular al lote y Carrera Numero 6 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 294 y mide 25.00 metros; por el fondo, linda con Lote Numero 299 y mide 10.00 metros; por la izquierda linda con Lote Numero 292 y mide 25.00 metros Área del Lote:250.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-294',
    294,
    'M 15',
    'available',
    68750000,
    250,
    '[1629.3,984.9]'::jsonb,
    '{"pathD":"M 1589.6 992.7 L 1652.7 951.9 L 1669 977.2 L 1605.9 1018 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":68750000,"cuota_ini_20":13750000,"cuota_inicial_20":13750000,"cuotas_3_ini":4583333,"cuotas_48":1145833,"precio_preventa":63750000,"cuota_ini_pre_20":12750000,"cuotas_3_ini_pre":4250000,"cuotas_48_pre":1062500,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS NOVENTA Y CUATRO (294): Por el frente, linda con acceso vehicular al lote y Carrera Numero 6 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 295 y mide 25.00 metros; por el fondo, linda con Lote Numero 289 y mide 10.00 metros; por la izquierda linda con Lote Numero 293 y mide 25.00 metros Área del Lote:250.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-295',
    295,
    'M 15',
    'available',
    84526300,
    291.47,
    '[1601.3,959.1]'::jsonb,
    '{"pathD":"M 1555.1 939.5 L 1644.5 945.9 L 1651.4 950 L 1652.7 951.9 L 1589.6 992.7 L 1582.3 981.5 L 1573.2 967.5 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":84526300,"cuota_ini_20":16905260,"cuota_inicial_20":16905260,"cuotas_3_ini":5635087,"cuotas_48":1408772,"precio_preventa":78696900,"cuota_ini_pre_20":15739380,"cuotas_3_ini_pre":5246460,"cuotas_48_pre":1311615,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS NOVENTA Y CINCO (295): Por el frente, linda con acceso vehicular al lote y Calle Numero 4 y mide 33.33 metros (línea quebrada); por la derecha entrando, linda con Lote Numero 296, Lote Numero 297 y mide 21.10 metros; por la izquierda linda con Lote Numero 294 y mide 25.00 metros Área del Lote: 291.47 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-296',
    296,
    'M 15',
    'available',
    95021400,
    327.66,
    '[1530.9,971.8]'::jsonb,
    '{"pathD":"M 1510.2 1008.3 L 1494.7 984.4 L 1496.3 969.1 L 1537.4 942.4 L 1551.2 939.2 L 1555.1 939.5 L 1573.2 967.5 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":95021400,"cuota_ini_20":19004280,"cuota_inicial_20":19004280,"cuotas_3_ini":6334760,"cuotas_48":1583690,"precio_preventa":88468200,"cuota_ini_pre_20":17693640,"cuotas_3_ini_pre":5897880,"cuotas_48_pre":1474470,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS NOVENTA Y SEIS (296): Por el frente, linda con acceso vehicular al lote y Carrera Numero 5 y mide 14.82 metros (línea quebrada); por la derecha entrando, linda con Lote Numero 297 y mide 25.00 metros; por el fondo, linda con Lote Numero 295 y mide 11.10 metros; por la izquierda linda con Calle Numero 4 y mide 21.04 metros Área del Lote: 327.66 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-297',
    297,
    'M 15',
    'available',
    72500000,
    250,
    '[1550.7,998.9]'::jsonb,
    '{"pathD":"M 1526.5 1033.5 L 1510.2 1008.3 L 1573.2 967.5 L 1582.3 981.5 L 1589.6 992.7 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":72500000,"cuota_ini_20":14500000,"cuota_inicial_20":14500000,"cuotas_3_ini":4833333,"cuotas_48":1208333,"precio_preventa":67500000,"cuota_ini_pre_20":13500000,"cuotas_3_ini_pre":4500000,"cuotas_48_pre":1125000,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS NOVENTA Y SIETE (297): Por el frente, linda con acceso vehicular al lote y Carrera Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 298 y mide 25.00 metros; por el fondo, linda con Lote Numero 295 y mide 10.00 metros; por la izquierda linda con Lote Numero 296 y mide 25.00 metros Área del Lote: 250.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-298',
    298,
    'M 15',
    'available',
    72500000,
    250,
    '[1565.8,1026.6]'::jsonb,
    '{"pathD":"M 1605.9 1018 L 1542.8 1058.8 L 1526.5 1033.5 L 1589.6 992.7 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":72500000,"cuota_ini_20":14500000,"cuota_inicial_20":14500000,"cuotas_3_ini":4833333,"cuotas_48":1208333,"precio_preventa":67500000,"cuota_ini_pre_20":13500000,"cuotas_3_ini_pre":4500000,"cuotas_48_pre":1125000,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS NOVENTA Y OCHO (298): Por el frente, linda con acceso vehicular al lote y Carrera Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 299 Y mide 25.00 metros; por el fondo, linda con Lote Numero 294 y mide 10.00 metros; por la izquierda linda con Lote Numero 297 y mide 25.00 metros Área del Lote: 250.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-299',
    299,
    'M 15',
    'available',
    72500000,
    250,
    '[1582.9,1050.2]'::jsonb,
    '{"pathD":"M 1622.2 1043.2 L 1559.1 1084 L 1542.8 1058.8 L 1605.9 1018 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":72500000,"cuota_ini_20":14500000,"cuota_inicial_20":14500000,"cuotas_3_ini":4833333,"cuotas_48":1208333,"precio_preventa":67500000,"cuota_ini_pre_20":13500000,"cuotas_3_ini_pre":4500000,"cuotas_48_pre":1125000,"descripcion_lindero":"LOTE NUMERO DOSCIENTOS NOVENTA Y NUEVE (299): Por el frente, linda con acceso vehicular al lote y Carrera Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 300 y mide 25.00 metros; por el fondo, linda con Lote Numero 293 y mide 10.00 metros; por la izquierda linda con Lote Numero 298 y mide 25.00 metros Área del Lote: 250.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-300',
    300,
    'M 15',
    'available',
    72500000,
    250,
    '[1598.4,1077]'::jsonb,
    '{"pathD":"M 1638.5 1068.4 L 1575.4 1109.2 L 1559.1 1084 L 1622.2 1043.2 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":72500000,"cuota_ini_20":14500000,"cuota_inicial_20":14500000,"cuotas_3_ini":4833333,"cuotas_48":1208333,"precio_preventa":67500000,"cuota_ini_pre_20":13500000,"cuotas_3_ini_pre":4500000,"cuotas_48_pre":1125000,"descripcion_lindero":"LOTE NUMERO TRESCIENTOS (300): Por el frente, linda con acceso vehicular al lote y Carrera Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 301 y mide 25.00 metros; por el fondo, linda con Lote Numero 292 y mide 10.00 metros; por la izquierda linda con Lote Numero 299 y mide 25.00 metros Área del Lote: 250.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-301',
    301,
    'M 15',
    'available',
    72500000,
    250,
    '[1615.6,1100.7]'::jsonb,
    '{"pathD":"M 1654.9 1093.7 L 1591.8 1134.5 L 1575.4 1109.2 L 1638.5 1068.4 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":72500000,"cuota_ini_20":14500000,"cuota_inicial_20":14500000,"cuotas_3_ini":4833333,"cuotas_48":1208333,"precio_preventa":67500000,"cuota_ini_pre_20":13500000,"cuotas_3_ini_pre":4500000,"cuotas_48_pre":1125000,"descripcion_lindero":"LOTE NUMERO TRESCIENTOS UNO (301): Por el frente, linda con acceso vehicular al lote y Carrera Numero 5 y mide 10.00 metros; por la derecha entrando, linda con Lote Numero 302 y mide 25.00 metros; por el fondo, linda con Lote Numero 291 y mide 10.00 metros; por la izquierda linda con Lote Numero 300 y mide 25.00 metros Área del Lote: 250.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-302',
    302,
    'M 15',
    'available',
    89900000,
    310,
    '[1633.4,1129.7]'::jsonb,
    '{"pathD":"M 1675.1 1125 L 1612 1165.8 L 1591.8 1134.5 L 1654.9 1093.7 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":89900000,"cuota_ini_20":17980000,"cuota_inicial_20":17980000,"cuotas_3_ini":5993333,"cuotas_48":1498333,"precio_preventa":83700000,"cuota_ini_pre_20":16740000,"cuotas_3_ini_pre":5580000,"cuotas_48_pre":1395000,"descripcion_lindero":"LOTE NUMERO TRESCIENTOS DOS (302): Por el frente, linda con acceso vehicular al lote y Carrera Numero 5 y mide 12.40 metros; por la derecha entrando, linda con Lote Numero 303 y mide 25.00 metros; por el fondo, linda con Lote Numero 290 y mide 12.40 metros; por la izquierda linda con Lote Numero 301 y mide 25.00 metros Área del Lote: 310.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-303',
    303,
    'M 15',
    'available',
    89900000,
    310,
    '[1654,1160.4]'::jsonb,
    '{"pathD":"M 1632.3 1197.1 L 1612 1165.8 L 1675.1 1125 L 1695.3 1156.3 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":89900000,"cuota_ini_20":17980000,"cuota_inicial_20":17980000,"cuotas_3_ini":5993333,"cuotas_48":1498333,"precio_preventa":83700000,"cuota_ini_pre_20":16740000,"cuotas_3_ini_pre":5580000,"cuotas_48_pre":1395000,"descripcion_lindero":"LOTE NUMERO TRESCIENTOS TRES (303): Por el frente, linda con acceso vehicular al lote y Carrera Numero 5 y mide 12.40 metros; por la derecha entrando, linda con Lote Numero 304 y mide 25.00 metros; por el fondo, linda con Lote Numero 289 y mide 12.40 metros; por la izquierda linda con Lote Numero 302 y mide 25.00 metros Área del Lote: 310.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-304',
    304,
    'M 15',
    'available',
    89900000,
    310,
    '[1673.6,1193]'::jsonb,
    '{"pathD":"M 1632.3 1197.1 L 1695.3 1156.3 L 1715.6 1187.5 L 1652.5 1228.4 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":89900000,"cuota_ini_20":17980000,"cuota_inicial_20":17980000,"cuotas_3_ini":5993333,"cuotas_48":1498333,"precio_preventa":83700000,"cuota_ini_pre_20":16740000,"cuotas_3_ini_pre":5580000,"cuotas_48_pre":1395000,"descripcion_lindero":"LOTE NUMERO TRESCIENTOS CUATRO (304): Por el frente, linda con acceso vehicular al lote y Carrera Numero 5 y mide 12.40 metros; por la derecha entrando, linda con Lote Numero 305 y mide 25.00 metros; por el fondo, linda con Lote Numero 288 y mide 12.40 metros; por la izquierda linda con Lote Numero 303 y mide 25.00 metros Área del Lote: 310.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-305',
    305,
    'M 15',
    'available',
    96100000,
    310,
    '[1693.8,1224.3]'::jsonb,
    '{"pathD":"M 1652.5 1228.4 L 1715.6 1187.5 L 1735.8 1218.8 L 1672.7 1259.6 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":96100000,"cuota_ini_20":19220000,"cuota_inicial_20":19220000,"cuotas_3_ini":6406667,"cuotas_48":1601667,"precio_preventa":86800000,"cuota_ini_pre_20":17360000,"cuotas_3_ini_pre":5786667,"cuotas_48_pre":1446667,"descripcion_lindero":"LOTE NUMERO TRESCIENTOS CINCO (305): Por el frente, linda con acceso vehicular al lote y Carrera Numero 5 y mide 12.40 metros; por la derecha entrando, linda con Lote Numero 306 y mide 25.00 metros; por el fondo, linda con Lote Numero 287 y mide 12.40 metros; por la izquierda linda con Lote Numero 304 y mide 25.00 metros Área del Lote: 310.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-306',
    306,
    'M 15',
    'available',
    102300000,
    310,
    '[1715.1,1253.6]'::jsonb,
    '{"pathD":"M 1672.7 1259.6 L 1735.8 1218.8 L 1756.1 1250.1 L 1693 1290.9 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"VERDE","valor_m2":330000,"prem2":300000,"precio_venta":102300000,"cuota_ini_20":20460000,"cuota_inicial_20":20460000,"cuotas_3_ini":6820000,"cuotas_48":1705000,"precio_preventa":93000000,"cuota_ini_pre_20":18600000,"cuotas_3_ini_pre":6200000,"cuotas_48_pre":1550000,"descripcion_lindero":"LOTE NUMERO TRESCIENTOS SEIS (306): Por el frente, linda con acceso vehicular al lote y Carrera Numero 5 y mide 12.40 metros; por la derecha entrando, linda con Lote Numero 307 y mide 25.00 metros; por el fondo, linda con Lote Numero 286 y mide 12.40 metros; por la izquierda linda con Lote Numero 305 y mide 25.00 metros Área del Lote: 310.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-307',
    307,
    'M 15',
    'available',
    149820000,
    454,
    '[1739.4,1291.5]'::jsonb,
    '{"pathD":"M 1754.6 1321.8 L 1711.2 1319.1 L 1693 1290.9 L 1756.1 1250.1 L 1781.7 1289.7 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"VERDE","valor_m2":330000,"prem2":300000,"precio_venta":149820000,"cuota_ini_20":29964000,"cuota_inicial_20":29964000,"cuotas_3_ini":9988000,"cuotas_48":2497000,"precio_preventa":136200000,"cuota_ini_pre_20":27240000,"cuotas_3_ini_pre":9080000,"cuotas_48_pre":2270000,"descripcion_lindero":"LOTE NUMERO TRESCIENTOS SIETE (307): Por el frente, linda con acceso vehicular al lote y Carrera Numero 5 y mide 28.00 metros; por la derecha entrando, linda con Calle Numero 1 y mide 13.97 metros; por el fondo, linda con Lote Numero 285 y mide 15.68 metros; por la izquierda linda con Lote Numero 306 y mide 25.00 metros Área del Lote: 454.00 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-308',
    308,
    'M 14',
    'available',
    82664500,
    285.05,
    '[1805,1354.8]'::jsonb,
    '{"pathD":"M 1844 1363.9 L 1820.7 1391.5 L 1766.1 1345.6 L 1789.3 1318 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":82664500,"cuota_ini_20":16532900,"cuota_inicial_20":16532900,"cuotas_3_ini":5510967,"cuotas_48":1377742,"precio_preventa":76963500,"cuota_ini_pre_20":15392700,"cuotas_3_ini_pre":5130900,"cuotas_48_pre":1282725,"descripcion_lindero":"LOTE NUMERO TRESCIENTOS OCHO (308): Por el frente, linda con acceso vehicular al lote y Calle Numero 1 y mide 12.00 metros; por la derecha entrando, linda con Lote Numero 309 y mide 23.75 metros; por el fondo, linda con Area verde y mide 12.00 metros; por la izquierda linda con Lote Numero 284 y mide 23.76 metros Área del Lote: 285.05 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-309',
    309,
    'M 14',
    'available',
    88331400,
    284.94,
    '[1782,1382]'::jsonb,
    '{"pathD":"M 1766.1 1345.6 L 1820.7 1391.5 L 1797.5 1419.1 L 1742.9 1373.2 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":88331400,"cuota_ini_20":17666280,"cuota_inicial_20":17666280,"cuotas_3_ini":5888760,"cuotas_48":1472190,"precio_preventa":79783200,"cuota_ini_pre_20":15956640,"cuotas_3_ini_pre":5318880,"cuotas_48_pre":1329720,"descripcion_lindero":"LOTE NUMERO TRESCIENTOS NUEVE (309): Por el frente, linda con acceso vehicular al lote y Calle Numero 1 y mide 12.00 metros; por la derecha entrando, linda con Lote Numero 310 y mide 23.74 metros; por el fondo, linda con Area verde y mide 12.00 metros; por la izquierda linda con Lote Numero 308 y mide 23.75 metros Área del Lote: 284.94 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-310',
    310,
    'M 14',
    'sold',
    150400800,
    455.76,
    '[1755,1422.9]'::jsonb,
    '{"pathD":"M 1742.9 1373.2 L 1797.5 1419.1 L 1744.5 1482.2 L 1742.1 1474.5 L 1727.5 1428.7 L 1727 1424.9 L 1727.4 1395.9 L 1730.2 1388.3 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"VERDE","valor_m2":330000,"prem2":300000,"precio_venta":150400800,"cuota_ini_20":30080160,"cuota_inicial_20":30080160,"cuotas_3_ini":10026720,"cuotas_48":2506680,"precio_preventa":136728000,"cuota_ini_pre_20":27345600,"cuotas_3_ini_pre":9115200,"cuotas_48_pre":2278800,"descripcion_lindero":"LOTE NUMERO TRESCIENTOS DIEZ (310): Por el frente, linda con acceso vehicular al lote y Calle Numero 1 y mide 38.87 metros (línea quebrada); por la derecha entrando, linda con Area verde y mide 27.42 metros; por la izquierda linda con Lote Numero 309 y mide 23.74 metros Área del Lote: 455.76 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-311',
    311,
    'M 9',
    'sold',
    146944000,
    419.84,
    '[1581,1614.9]'::jsonb,
    '{"pathD":"M 1617.1 1604.6 L 1635.5 1603.5 L 1637.9 1605.6 L 1594 1657.6 L 1518.1 1589.4 L 1543.8 1586.4 L 1556.6 1587.1 L 1578.3 1593.2 L 1592 1598.8 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"ROJO","valor_m2":350000,"prem2":325000,"precio_venta":146944000,"cuota_ini_20":29388800,"cuota_inicial_20":29388800,"cuotas_3_ini":9796267,"cuotas_48":2449067,"precio_preventa":136448000,"cuota_ini_pre_20":27289600,"cuotas_3_ini_pre":9096533,"cuotas_48_pre":2274133,"descripcion_lindero":"LOTE NUMERO TRESCIENTOS ONCE (311): Por el frente, linda con acceso vehicular al lote y Carrera Numero 3 y mide 41.06 metros (línea quebrada); por la derecha entrando, linda con Lote Numero 312 y mide 33.94 metros; por la izquierda linda con Area verde y mide 22.65 metros Área del Lote: 419.84 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-312',
    312,
    'M 9',
    'available',
    130760000,
    373.6,
    '[1541.7,1631.8]'::jsonb,
    '{"pathD":"M 1499.2 1591.7 L 1518.1 1589.4 L 1594 1657.6 L 1574.5 1680.5 L 1484 1597.8 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROJO","valor_m2":350000,"prem2":325000,"precio_venta":130760000,"cuota_ini_20":26152000,"cuota_inicial_20":26152000,"cuotas_3_ini":8717333,"cuotas_48":2179333,"precio_preventa":121420000,"cuota_ini_pre_20":24284000,"cuotas_3_ini_pre":8094667,"cuotas_48_pre":2023667,"descripcion_lindero":"LOTE NUMERO TRESCIENTOS DOCE (312): Por el frente, linda con acceso vehicular al lote y Carrera Numero 3 y mide 11.85 metros (línea quebrada); por la derecha entrando, linda con Lote Numero 313 y mide 40.82 metros; por el fondo, linda con Area verde y mide 10.00 metros; por la izquierda linda con Lote Numero 311 y mide 33.94 metros Área del Lote: 373.60 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-313',
    313,
    'M 9',
    'sold',
    146608000,
    418.88,
    '[1519.6,1650.8]'::jsonb,
    '{"pathD":"M 1555 1703.5 L 1468.3 1627.2 L 1472.3 1613.9 L 1484 1597.8 L 1574.5 1680.5 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROJO","valor_m2":350000,"prem2":325000,"precio_venta":146608000,"cuota_ini_20":29321600,"cuota_inicial_20":29321600,"cuotas_3_ini":9773867,"cuotas_48":2443467,"precio_preventa":136136000,"cuota_ini_pre_20":27227200,"cuotas_3_ini_pre":9075733,"cuotas_48_pre":2268933,"descripcion_lindero":"LOTE NUMERO TRESCIENTOS TRECE (313): Por el frente, linda con acceso vehicular al lote y Calle Numero 1 y mide 11.34 metros (línea quebrada); por la derecha entrando, linda con Lote Numero 314 y mide 38.44 metros; por el fondo, linda con Area verde y mide 10.00 metros; por la izquierda linda con Lote Numero 312 y mide 40.82 metros Área del Lote: 418.88 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-314',
    314,
    'M 9',
    'sold',
    133931000,
    382.66,
    '[1503.4,1679.1]'::jsonb,
    '{"pathD":"M 1535.6 1726.4 L 1457.8 1662.7 L 1468.3 1627.2 L 1555 1703.5 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROJO","valor_m2":350000,"prem2":325000,"precio_venta":133931000,"cuota_ini_20":26786200,"cuota_inicial_20":26786200,"cuotas_3_ini":8928733,"cuotas_48":2232183,"precio_preventa":124364500,"cuota_ini_pre_20":24872900,"cuotas_3_ini_pre":8290967,"cuotas_48_pre":2072742,"descripcion_lindero":"LOTE NUMERO TRESCIENTOS CATORCE (314): Por el frente, linda con acceso vehicular al lote y Calle Numero 1 y mide 12.35 metros; por la derecha entrando, linda con Lote Numero 315 y mide 33.45 metros; por el fondo, linda con Area verde y mide 10.00 metros; por la izquierda linda con Lote Numero 313 y mide 38.44 metros Área del Lote: 382.67 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-315',
    315,
    'M 9',
    'available',
    113449000,
    324.14,
    '[1488.3,1706.2]'::jsonb,
    '{"pathD":"M 1515.6 1748.9 L 1442.2 1689 L 1456.2 1667.3 L 1457.8 1662.7 L 1535.6 1726.4 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROJO","valor_m2":350000,"prem2":325000,"precio_venta":113449000,"cuota_ini_20":22689800,"cuota_inicial_20":22689800,"cuotas_3_ini":7563267,"cuotas_48":1890817,"precio_preventa":105345500,"cuota_ini_pre_20":21069100,"cuotas_3_ini_pre":7023033,"cuotas_48_pre":1755758,"descripcion_lindero":"LOTE NUMERO TRESCIENTOS QUINCE (315): Por el frente, linda con acceso vehicular al lote y Calle Numero 1 y mide 10.21 metros (línea quebrada); por la derecha entrando, linda con Lote Numero 316 y mide 31.52 metros; por el fondo, linda con Área verde y mide 10.00 metros; por la izquierda linda con Lote Numero 314 y mide 33.45 metros Área del Lote: 324.14 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-316',
    316,
    'M 9',
    'sold',
    109354000,
    312.44,
    '[1468.1,1731.6]'::jsonb,
    '{"pathD":"M 1495.7 1771.5 L 1421.7 1711.1 L 1438 1695.5 L 1442.2 1689 L 1515.6 1748.9 L 1505.6 1758.5 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROJO","valor_m2":350000,"prem2":325000,"precio_venta":109354000,"cuota_ini_20":21870800,"cuota_inicial_20":21870800,"cuotas_3_ini":7290267,"cuotas_48":1822567,"precio_preventa":101543000,"cuota_ini_pre_20":20308600,"cuotas_3_ini_pre":6769533,"cuotas_48_pre":1692383,"descripcion_lindero":"LOTE NUMERO TRESCIENTOS DIEZ Y SEIS (316): Por el frente, linda con acceso vehicular al lote y Calle Numero 1 y mide 10.08 metros (línea quebrada); por la derecha entrando, linda con Lote Numero 317 y mide 31.78 metros; por el fondo, linda con Área verde y mide 10.00 metros; por la izquierda linda con Lote Numero 315 y mide 31.52 metros Área del Lote: 312.44 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-317',
    317,
    'M 9',
    'sold',
    430738000,
    1230.68,
    '[1421.1,1771.4]'::jsonb,
    '{"pathD":"M 1436.5 1848.5 L 1344.2 1760.1 L 1407.6 1699.6 L 1421.7 1711.1 L 1495.7 1771.5 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"ROJO","valor_m2":350000,"prem2":325000,"precio_venta":430738000,"cuota_ini_20":86147600,"cuota_inicial_20":86147600,"cuotas_3_ini":28715867,"cuotas_48":7178967,"precio_preventa":399971000,"cuota_ini_pre_20":79994200,"cuotas_3_ini_pre":26664733,"cuotas_48_pre":6666183,"descripcion_lindero":"LOTE NUMERO TRESCIENTOS DIEZ Y ISIETE (317): Por el frente, linda con acceso vehicular al lote y Calle Numero 1 y Area verde, y mide 35.21 metros (línea quebrada); por la derecha entrando, linda con Área verde y mide 42.23 metros; por el fondo, linda con Area verde y mide 32.35 metros; por la izquierda linda con Lote Numero 316 y mide 31.78 metros Área del Lote: 1230.68 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-318',
    318,
    'M 28',
    'reserved',
    289348500,
    826.71,
    '[1420,1370]'::jsonb,
    NULL,
    '{"ubicacion":"ISLA","color":"ROJO","valor_m2":350000,"prem2":325000,"precio_venta":289348500,"cuota_ini_20":57869700,"cuota_inicial_20":57869700,"cuotas_3_ini":19289900,"cuotas_48":4822475,"precio_preventa":268680750,"cuota_ini_pre_20":53736150,"cuotas_3_ini_pre":17912050,"cuotas_48_pre":4478013,"descripcion_lindero":"LOTE NUMERO TRESCIENTOS DIEZ Y OCHO (318): Lote rodeado por espejo de agua en su perímetro, conocido como isla de los Patos, ubicado en la Manzana 28 de proyecto. Área del Lote: 826.71 M2","isReserve":true}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-319',
    319,
    'M 29',
    'reserved',
    381556000,
    1090.16,
    '[1600,1450]'::jsonb,
    NULL,
    '{"ubicacion":"ISLA","color":"ROJO","valor_m2":350000,"prem2":325000,"precio_venta":381556000,"cuota_ini_20":76311200,"cuota_inicial_20":76311200,"cuotas_3_ini":25437067,"cuotas_48":6359267,"precio_preventa":354302000,"cuota_ini_pre_20":70860400,"cuotas_3_ini_pre":23620133,"cuotas_48_pre":5905033,"descripcion_lindero":"LOTE NUMERO TRESCIENTOS DIEZ Y NUEVE (319): Lote rodeado por espejo de agua en su perímetro, conocido como isla de las flores, ubicado en la Manzana 29 de proyecto.  Área del Lote: 1090.16 M2","isReserve":true}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-320',
    320,
    'M 24',
    'sold',
    122162700,
    370.19,
    '[805.6,1016.6]'::jsonb,
    '{"pathD":"M 817.9 958.7 L 830.9 1055.9 L 825.5 1057.4 L 812.3 1057.6 L 792 1052.3 L 783.7 1046.5 L 780.4 990.7 L 801.5 979.4 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"VERDE","valor_m2":330000,"prem2":300000,"precio_venta":122162700,"cuota_ini_20":24432540,"cuota_inicial_20":24432540,"cuotas_3_ini":8144180,"cuotas_48":2036045,"precio_preventa":111057000,"cuota_ini_pre_20":22211400,"cuotas_3_ini_pre":7403800,"cuotas_48_pre":1850950,"descripcion_lindero":"LOTE NUMERO TRESCIENTOS VEINTE (320): Por el frente, linda con acceso vehicular al lote y Calle Numero 7 y mide 16.92 metros (línea quebrada); por la derecha entrando, linda con Area verde y mide 18.61 metros; por el fondo, linda con Área verde y mide 16.61 metros (línea quebrada); por la izquierda linda con Lote Numero 321, Lote Numero 322, Lote Numero 323, y mide 32.63 metros Área del Lote: 370.19 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-321',
    321,
    'M 24',
    'sold',
    93567300,
    301.83,
    '[851.9,955.1]'::jsonb,
    '{"pathD":"M 817.9 958.7 L 840.7 930 L 850.4 925.6 L 868.8 926.1 L 880.4 936.5 L 885 971.3 L 820.7 979.9 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":93567300,"cuota_ini_20":18713460,"cuota_inicial_20":18713460,"cuotas_3_ini":6237820,"cuotas_48":1559455,"precio_preventa":84512400,"cuota_ini_pre_20":16902480,"cuotas_3_ini_pre":5634160,"cuotas_48_pre":1408540,"descripcion_lindero":"LOTE NUMERO TRESCIENTOS VEINTI Y UNO (321): Por el frente, linda con acceso vehicular al lote y Calle Numero 7 y mide 27.66 metros (línea quebrada); por la derecha entrando, linda con Lote Numero 320 y mide 7.09 metros; por el fondo, linda con Lote Numero 322 y mide 21.59 metros; por la izquierda linda con Carrera Numero 11 y mide 11.68 metros Área del Lote: 301.83 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-322',
    322,
    'M 24',
    'sold',
    84890400,
    273.84,
    '[855.6,994.2]'::jsonb,
    '{"pathD":"M 820.7 979.9 L 885 971.3 L 890.1 1009 L 825.8 1017.7 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"AMARILLO","valor_m2":310000,"prem2":280000,"precio_venta":84890400,"cuota_ini_20":16978080,"cuota_inicial_20":16978080,"cuotas_3_ini":5659360,"cuotas_48":1414840,"precio_preventa":76675200,"cuota_ini_pre_20":15335040,"cuotas_3_ini_pre":5111680,"cuotas_48_pre":1277920,"descripcion_lindero":"LOTE NUMERO TRESCIENTOS VEINTI Y DOS (322): Por el frente, linda con acceso vehicular al lote y Carrera Numero 11 y mide 12.67 metros; por la derecha entrando, linda con Lote Numero 321 y mide 21.59 metros; por el fondo, linda con Lote Numero 320 y mide 12.70 metros; por la izquierda linda con Lote Numero 323 y mide 21.58 metros Área del Lote: 273.84 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-323',
    323,
    'M 24',
    'sold',
    89251800,
    270.46,
    '[861.3,1031.5]'::jsonb,
    '{"pathD":"M 890.1 1009 L 895.6 1050.4 L 858.5 1048.5 L 830.9 1055.9 L 825.8 1017.7 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"VERDE","valor_m2":330000,"prem2":300000,"precio_venta":89251800,"cuota_ini_20":17850360,"cuota_inicial_20":17850360,"cuotas_3_ini":5950120,"cuotas_48":1487530,"precio_preventa":81138000,"cuota_ini_pre_20":16227600,"cuotas_3_ini_pre":5409200,"cuotas_48_pre":1352300,"descripcion_lindero":"LOTE NUMERO TRESCIENTOS VEINT Y IRES (323): Por el frente, linda con acceso vehicular al lote y Carrera Numero 11 y mide 13.90 metros; por la derecha entrando, linda con Lote Numero 322 y mide 21.58 metros; por el fondo, linda con Lote Numero 320 y mide 12.84 metros; por la izquierda linda con Area verde y mide 21.87 metros (línea quebrada). Área del Lote: 270.46 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-324',
    324,
    'M 25',
    'reserved',
    103811400,
    314.58,
    '[959.9,1022.2]'::jsonb,
    '{"pathD":"M 914.9 1013.7 L 919.5 1048.1 L 960.6 1042.6 L 1006.7 1022.3 L 1010 1000.9 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"VERDE","valor_m2":330000,"prem2":300000,"precio_venta":103811400,"cuota_ini_20":20762280,"cuota_inicial_20":20762280,"cuotas_3_ini":6920760,"cuotas_48":1730190,"precio_preventa":94374000,"cuota_ini_pre_20":18874800,"cuotas_3_ini_pre":6291600,"cuotas_48_pre":1572900,"descripcion_lindero":"LOTE NUMERO TRESCIENTOS VEINTI Y CUATRO (324): Por el frente, linda con acceso vehicular al lote y Carrera Numero 11 y mide 11.53 metros; por la derecha entrando, linda con Area verde y mide 30.52 metros; por el fondo, linda con Area verde y mide 7.23 metros; por la izquierda linda con Lote Numero 325 y mide 31.91 metros Área del Lote: 314.58 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-325',
    325,
    'M 25',
    'reserved',
    110794200,
    335.74,
    '[962.4,991.5]'::jsonb,
    '{"pathD":"M 910.9 983.5 L 915 1013.7 L 1010 1000.9 L 1013.6 978.4 L 1008.7 970.4 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"VERDE","valor_m2":330000,"prem2":300000,"precio_venta":110794200,"cuota_ini_20":22158840,"cuota_inicial_20":22158840,"cuotas_3_ini":7386280,"cuotas_48":1846570,"precio_preventa":100722000,"cuota_ini_pre_20":20144400,"cuotas_3_ini_pre":6714800,"cuotas_48_pre":1678700,"descripcion_lindero":"LOTE NUMERO TRESCIENTOS VEINTI Y CINCO (325): Por el frente, linda con acceso vehicular al lote y Carrera Numero 11 y mide 10.15 metros; por la derecha entrando, linda con Lote Numero 324 y mide 31.92 metros; por el fondo, linda con Área verde y mide 10.69 metros; por la izquierda linda con Lote Numero 326 y mide 32.83 metros Área del Lote: 335.74 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-326',
    326,
    'M 25',
    'reserved',
    102247200,
    309.84,
    '[954.3,963.2]'::jsonb,
    '{"pathD":"M 991.7 942 L 906.9 953.3 L 910.9 983.5 L 1008.7 970.4 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"VERDE","valor_m2":330000,"prem2":300000,"precio_venta":102247200,"cuota_ini_20":20449440,"cuota_inicial_20":20449440,"cuotas_3_ini":6816480,"cuotas_48":1704120,"precio_preventa":92952000,"cuota_ini_pre_20":18590400,"cuotas_3_ini_pre":6196800,"cuotas_48_pre":1549200,"descripcion_lindero":"LOTE NUMERO TRESCIENTOS VEINTI Y SEIS (326): Por el frente, linda con acceso vehicular al lote y Carrera Numero 11 y mide 10.13 metros; por la derecha entrando, linda con Lote Numero 325 y mide 32.83 metros; por el fondo, linda con Área verde y mide 11.00 metros; por la izquierda linda con Lote Numero 327 y mide 28.47 metros Área del Lote: 309.84 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-327',
    327,
    'M 25',
    'reserved',
    87176100,
    264.17,
    '[954.3,963.2]'::jsonb,
    '{"pathD":"M 991.7 942 L 906.9 953.3 L 910.9 983.5 L 1008.7 970.4 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"VERDE","valor_m2":330000,"prem2":300000,"precio_venta":87176100,"cuota_ini_20":17435220,"cuota_inicial_20":17435220,"cuotas_3_ini":5811740,"cuotas_48":1452935,"precio_preventa":79251000,"cuota_ini_pre_20":15850200,"cuotas_3_ini_pre":5283400,"cuotas_48_pre":1320850,"descripcion_lindero":"LOTE NUMERO TRESCIENTOS VEINTI Y SIETE (327): Por el frente, linda con acceso vehicular al lote y Carrera Numero 11 y mide 10.39 metros (línea quebrada); por la derecha entrando, linda con Lote Numero 326 y mide 28.47 metros; por el fondo, linda con Area verde y mide 11.04 metros; por la izquierda linda con Lote Numero 328 y mide 22.69 metros Área del Lote: 263.93 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-328',
    328,
    'M 25',
    'reserved',
    105171000,
    318.7,
    '[941.5,892.1]'::jsonb,
    '{"pathD":"M 966.4 859.7 L 913.6 867.2 L 918 882.4 L 911.9 914.9 L 907 922.6 L 974.6 913.6 L 971.8 908.9 L 966.4 872.8 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"VERDE","valor_m2":330000,"prem2":300000,"precio_venta":105171000,"cuota_ini_20":21034200,"cuota_inicial_20":21034200,"cuotas_3_ini":7011400,"cuotas_48":1752850,"precio_preventa":95610000,"cuota_ini_pre_20":19122000,"cuotas_3_ini_pre":6374000,"cuotas_48_pre":1593500,"descripcion_lindero":"LOTE NUMERO TRESCIENTOS VEINTI Y OCHO (328): Por el frente, linda con acceso vehicular al lote y Carrera Numero 11 y mide 19.82 metros (línea quebrada); por la derecha entrando, linda con Lote Numero 327 y mide 22.69 metros; por el fondo, linda con Area verde y mide 18.32 metros (línea quebrada); por la izquierda linda con Lote Numero 329 y mide 17.76 metros Área del Lote: 318.70 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-329',
    329,
    'M 25',
    'reserved',
    115348200,
    349.54,
    '[941.5,892.1]'::jsonb,
    '{"pathD":"M 966.4 859.7 L 913.6 867.2 L 918 882.4 L 911.9 914.9 L 907 922.6 L 974.6 913.6 L 971.8 908.9 L 966.4 872.8 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"VERDE","valor_m2":330000,"prem2":300000,"precio_venta":115348200,"cuota_ini_20":23069640,"cuota_inicial_20":23069640,"cuotas_3_ini":7689880,"cuotas_48":1922470,"precio_preventa":104862000,"cuota_ini_pre_20":20972400,"cuotas_3_ini_pre":6990800,"cuotas_48_pre":1747700,"descripcion_lindero":"LOTE NUMERO TRESCIENTOS VEINTI Y NUEVE (329): Por el frente, linda con acceso vehicular al lote y Carrera Numero 11 y mide 9.07 metros; por la derecha entrando, linda con Lote Numero 328 y mide 17.76 metros; por el fondo, linda con Area verde y mide 25.73 metros (línea quebrada); por la izquierda linda con Calle Numero 7 y mide 29.38 metros (línea quebrada). Área del Lote: 349.54 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-330',
    330,
    'M 26',
    'reserved',
    109272000,
    376.8,
    '[1358.4,484.5]'::jsonb,
    '{"pathD":"M 1333.9 462.6 L 1421.4 462.6 L 1372.6 504.6 L 1345.1 509.7 L 1305 509.7 L 1320 488.8 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":109272000,"cuota_ini_20":21854400,"cuota_inicial_20":21854400,"cuotas_3_ini":7284800,"cuotas_48":1821200,"precio_preventa":101736000,"cuota_ini_pre_20":20347200,"cuotas_3_ini_pre":6782400,"cuotas_48_pre":1695600,"descripcion_lindero":"LOTE NUMERO TRESCIENTOS TREINTA (330): Por el frente, linda con acceso vehicular al lote y Calle Numero 7 y mide 18.40 metros (línea quebrada); por la derecha entrando, linda con Area verde y mide 22.62 metros; por el fondo, linda con Área verde y mide 21.42 metros; por la izquierda linda con Lote Numero 331 y mide 29.12 metros Área del Lote: 376.80 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-331',
    331,
    'M 26',
    'reserved',
    100963500,
    348.15,
    '[1379.7,441.3]'::jsonb,
    '{"pathD":"M 1333.9 462.6 L 1365.5 411.5 L 1401 411.5 L 1421.4 462.6 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":100963500,"cuota_ini_20":20192700,"cuota_inicial_20":20192700,"cuotas_3_ini":6730900,"cuotas_48":1682725,"precio_preventa":94000500,"cuota_ini_pre_20":18800100,"cuotas_3_ini_pre":6266700,"cuotas_48_pre":1566675,"descripcion_lindero":"LOTE NUMERO TRESCIENTOS TREINTA Y UNO (331): Por el frente, linda con acceso vehicular al lote y Calle Numero 7 y mide 20.01 metros; por la derecha entrando, linda con Lote Numero 330 y mide 29.12 metros; por el fondo, linda con Área verde y mide 18.32 metros; por la izquierda linda con Lote Numero 332 y mide 11.80 metros Área del Lote: 348.15 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-332',
    332,
    'M 26',
    'reserved',
    106859200,
    368.48,
    '[1410.3,369.1]'::jsonb,
    '{"pathD":"M 1365.5 411.5 L 1404.6 335 L 1474.4 335 L 1425 367.5 L 1401 411.5 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"ROSADO","valor_m2":290000,"prem2":270000,"precio_venta":106859200,"cuota_ini_20":21371840,"cuota_inicial_20":21371840,"cuotas_3_ini":7123947,"cuotas_48":1780987,"precio_preventa":99489600,"cuota_ini_pre_20":19897920,"cuotas_3_ini_pre":6632640,"cuotas_48_pre":1658160,"descripcion_lindero":"LOTE NUMERO TRESCIENTOS TREINTA Y DOS (332): Por el frente, linda con acceso vehicular al lote y Calle Numero 7 y mide 28.58 metros; por la derecha entrando, linda con Lote Numero 331 y mide 11.80 metros; por el fondo, linda con Area verde y mide 36.36 metros (línea quebrada); por la izquierda linda con Lote Numero 333 y mide 23.23 metros Área del Lote: 368.48 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-333',
    333,
    'M 26',
    'reserved',
    90183500,
    327.94,
    '[1457.9,316.5]'::jsonb,
    '{"pathD":"M 1404.6 335 L 1423 300.5 L 1524.8 300.5 L 1474.4 335 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":90183500,"cuota_ini_20":18036700,"cuota_inicial_20":18036700,"cuotas_3_ini":6012233,"cuotas_48":1503058,"precio_preventa":83624700,"cuota_ini_pre_20":16724940,"cuotas_3_ini_pre":5574980,"cuotas_48_pre":1393745,"descripcion_lindero":"LOTE NUMERO TRESCIENTOS TREINTA Y TRES (333): Por el frente, linda con acceso vehicular al lote y Calle Numero 7 y mide 13.00 metros; por la derecha entrando, linda con Lote Numero 332 y mide 23.23 metros; por el fondo, linda con Area verde y mide 20.32 metros; por la izquierda linda con Lote Numero 334 y mide 33.89 metros Área del Lote: 327.94 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-334',
    334,
    'M 26',
    'reserved',
    116399250,
    423.27,
    '[1487.5,283.5]'::jsonb,
    '{"pathD":"M 1545.7 286.1 L 1524.8 300.5 L 1423 300.5 L 1441.3 266 L 1551.4 266.1 Z"}'::jsonb,
    '{"ubicacion":"CENTRAL","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":116399250,"cuota_ini_20":23279850,"cuota_inicial_20":23279850,"cuotas_3_ini":7759950,"cuotas_48":1939988,"precio_preventa":107933850,"cuota_ini_pre_20":21586770,"cuotas_3_ini_pre":7195590,"cuotas_48_pre":1798898,"descripcion_lindero":"LOTE NUMERO TRESCIENTOS TREINTA Y CUATRO (334): Por el frente, linda con acceso vehicular al lote y Calle Numero 7 y mide 13.00 metros; por la derecha entrando, linda con Lote Numero 333 y mide 33.89 metros; por el fondo, linda con Area verde y mide 15.37 metros (línea quebrada); por la izquierda linda con Lote Numero 335 y mide 36.62 metros Área del Lote: 423.27 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-335',
    335,
    'M 26',
    'reserved',
    129079500,
    469.38,
    '[1505.6,246.5]'::jsonb,
    '{"pathD":"M 1567 226.2 L 1554.6 254.4 L 1551.4 266.1 L 1441.3 266 L 1458.6 234.1 L 1471.8 226.2 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"NARANJA","valor_m2":275000,"prem2":255000,"precio_venta":129079500,"cuota_ini_20":25815900,"cuota_inicial_20":25815900,"cuotas_3_ini":8605300,"cuotas_48":2151325,"precio_preventa":119691900,"cuota_ini_pre_20":23938380,"cuotas_3_ini_pre":7979460,"cuotas_48_pre":1994865,"descripcion_lindero":"LOTE NUMERO TRESCIENTOS TREINTA Y CINCO (335): Por el frente, linda con acceso vehicular al lote y Calle Numero 7 y mide 15.07 metros; por la derecha entrando, linda con Lote Numero 334 y mide 36.62 metros; por el fondo, linda con Área verde y mide 13.81 metros (línea quebrada); por la izquierda linda con Carrera Numero 12 y mide 34.64 metros Área del Lote: 468.77 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-336',
    336,
    'M 27',
    'reserved',
    55164200,
    212.17,
    '[1491.2,176.3]'::jsonb,
    '{"pathD":"M 1498.2 202.2 L 1458.6 202.2 L 1485.3 151.9 L 1521.5 150.3 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"AZUL","valor_m2":260000,"prem2":240000,"precio_venta":55164200,"cuota_ini_20":11032840,"cuota_inicial_20":11032840,"cuotas_3_ini":3677613,"cuotas_48":919403,"precio_preventa":50920800,"cuota_ini_pre_20":10184160,"cuotas_3_ini_pre":3394720,"cuotas_48_pre":848680,"descripcion_lindero":"LOTE NUMERO TRESCIENTOS TREINTA Y SEIS (336): Por el frente, linda con ac LOTE NUMERO CIENTO TREINTA Y TRES (133): Por el frente, linda con acceso vehicular al lote y Calle Numero 5 y mide 11.42 metros; por la derecha entrando, linda con Área verde y mide 22.50 metros; por el fondo, linda con Área verde y mide 11.63 metros; por la izquierda; linda con Lote Numero 132 y mide 22.80 metros. Área del Lote: 260.99 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-337',
    337,
    'M 27',
    'reserved',
    90352600,
    347.51,
    '[1539.1,175.1]'::jsonb,
    '{"pathD":"M 1521.5 150.3 L 1560 148.6 L 1582.1 144.9 L 1567.1 183.1 L 1539.1 202.2 L 1498.2 202.2 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"AZUL","valor_m2":260000,"prem2":240000,"precio_venta":90352600,"cuota_ini_20":18070520,"cuota_inicial_20":18070520,"cuotas_3_ini":6023507,"cuotas_48":1505877,"precio_preventa":83402400,"cuota_ini_pre_20":16680480,"cuotas_3_ini_pre":5560160,"cuotas_48_pre":1390040,"descripcion_lindero":"LOTE NUMERO TRESCIENTOS TREINTA Y SIETE (337): Por el frente, linda con acceso vehicular al lote y Carrera Numero 12 y mide 25.59 metros; por la derecha entrando, linda con Carrera Numero 12 y mide 13.64 metros; por el fondo, linda con Area verde y mide 20.27 metros (línea quebrada); por la izquierda linda con Lote Numero 336 y mide 18.92 metros Área del Lote: 347.51 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

  INSERT INTO public.lots (
    project_id, external_id, lot_number, manzana, status, price_cop, area_m2, centroid, geometry, metadata
  ) VALUES (
    v_project_id,
    'L-338',
    338,
    'M 27',
    'reserved',
    153927800,
    592.03,
    '[1637.3,174.6]'::jsonb,
    '{"pathD":"M 1585.5 201.9 L 1608.7 142.8 L 1661.5 142.7 L 1697.7 148.2 L 1692.8 162.6 L 1670.2 187.2 L 1642.4 208.8 L 1605.2 213 Z"}'::jsonb,
    '{"ubicacion":"ESQUINA","color":"AZUL","valor_m2":260000,"prem2":240000,"precio_venta":153927800,"cuota_ini_20":30785560,"cuota_inicial_20":30785560,"cuotas_3_ini":10261853,"cuotas_48":2565463,"precio_preventa":142087200,"cuota_ini_pre_20":28417440,"cuotas_3_ini_pre":9472480,"cuotas_48_pre":2368120,"descripcion_lindero":"LOTE NUMERO TRESCIENTOS TREINTA Y OCHO (338): Por el frente, linda con acceso vehicular al lote y Carrera Numero 12 y mide 21.13 metros; por la derecha entrando, linda con Area verde y mide 19.97 metros (línea quebrada); por el fondo, linda con Area verde y mide 27.89 metros (línea quebrada); por la izquierda linda con Area verde y mide 29.75 metros (línea quebrada). Área del Lote: 592.03 M2","isReserve":false}'::jsonb
  )
  ON CONFLICT (project_id, external_id) DO UPDATE SET
    lot_number = EXCLUDED.lot_number,
    manzana = EXCLUDED.manzana,
    status = EXCLUDED.status,
    price_cop = EXCLUDED.price_cop,
    area_m2 = EXCLUDED.area_m2,
    centroid = COALESCE(public.lots.centroid, EXCLUDED.centroid),
    geometry = COALESCE(public.lots.geometry, EXCLUDED.geometry),
    metadata = public.lots.metadata || EXCLUDED.metadata,
    updated_at = now();

END $$;
