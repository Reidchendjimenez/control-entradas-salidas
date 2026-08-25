-- =============================================================
-- Tabla: pos_temporales — políticas RLS
-- La tabla se crea en schema.sql pero sin políticas; si RLS está
-- activado, todo insert/select/update/delete falla con 42501.
-- App single-tenant: policy permisiva para anon/authenticated.
-- =============================================================
ALTER TABLE pos_temporales ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "pos_temporales_all" ON pos_temporales;

CREATE POLICY "pos_temporales_all" ON pos_temporales
  FOR ALL
  USING (true)
  WITH CHECK (true);
