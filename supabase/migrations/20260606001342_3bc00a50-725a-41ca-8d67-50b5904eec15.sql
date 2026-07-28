
CREATE TABLE IF NOT EXISTS public.carousels (
  id TEXT NOT NULL,
  space_id TEXT NOT NULL,
  name TEXT NOT NULL,
  slides JSONB NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (space_id, id)
);

CREATE INDEX IF NOT EXISTS idx_carousels_space_updated ON public.carousels (space_id, updated_at DESC);

GRANT SELECT, INSERT, UPDATE, DELETE ON public.carousels TO anon, authenticated;
GRANT ALL ON public.carousels TO service_role;

ALTER TABLE public.carousels ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Anyone can read carousels" ON public.carousels;
CREATE POLICY "Anyone can read carousels" ON public.carousels FOR SELECT USING (true);

DROP POLICY IF EXISTS "Anyone can insert carousels" ON public.carousels;
CREATE POLICY "Anyone can insert carousels" ON public.carousels FOR INSERT WITH CHECK (true);

DROP POLICY IF EXISTS "Anyone can update carousels" ON public.carousels;
CREATE POLICY "Anyone can update carousels" ON public.carousels FOR UPDATE USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Anyone can delete carousels" ON public.carousels;
CREATE POLICY "Anyone can delete carousels" ON public.carousels FOR DELETE USING (true);

CREATE OR REPLACE FUNCTION public.set_updated_at() RETURNS TRIGGER AS $$
BEGIN NEW.updated_at = now(); RETURN NEW; END;
$$ LANGUAGE plpgsql SET search_path = public;

DROP TRIGGER IF EXISTS carousels_set_updated_at ON public.carousels;
CREATE TRIGGER carousels_set_updated_at BEFORE UPDATE ON public.carousels
FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
