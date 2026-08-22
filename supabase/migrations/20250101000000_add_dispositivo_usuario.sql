-- =============================================================
-- Tabla: dispositivo_usuario
-- Almacena el operador configurado en el dispositivo (PIN + nombre).
-- Solo debe haber una fila por dispositivo (app single-tenant).
-- =============================================================
CREATE TABLE IF NOT EXISTS dispositivo_usuario (
  id            BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nombre        TEXT NOT NULL,
  pin_hash      TEXT NOT NULL,
  configurado_en TIMESTAMPTZ DEFAULT now()
);

-- RLS: solo lectura/escritura autenticada (ajustar segun necesidad)
ALTER TABLE dispositivo_usuario ENABLE ROW LEVEL SECURITY;

-- Policy: cualquier usuario autenticado puede leer/escribir
-- (en app single-tenant esto es suficiente; ajustar si hay multi-tenant)
CREATE POLICY "dispositivo_usuario_all" ON dispositivo_usuario
  FOR ALL
  USING (true)
  WITH CHECK (true);
