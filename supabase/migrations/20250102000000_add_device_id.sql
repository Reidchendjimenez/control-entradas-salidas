-- Agregar columna device_id para identificar unívocamente cada dispositivo.
-- Cada dispositivo genera un UUID único localmente y lo envía al registrar/verificar.
ALTER TABLE dispositivo_usuario
  ADD COLUMN IF NOT EXISTS device_id TEXT UNIQUE;
