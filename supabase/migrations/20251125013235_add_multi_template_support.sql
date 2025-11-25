/*
  # Add Multi-Template Support to Wedding Projects

  This migration enhances the database to support multiple wedding templates.

  ## Changes Made

  1. **Rename Table** (logical, not physical)
     - Keep `timeless_content` table name for backward compatibility
     - But it now stores data for ALL templates (timeless, elegant, etc.)

  2. **New Columns Added**
     - `slug` (text, unique) - URL-friendly identifier (e.g., "hanson-catherine")
     - `template_name` (text, default 'timeless') - Template identifier ("timeless", "elegant", etc.)
     - `status` (text, default 'draft') - Project status ("draft", "active", "archived")
     - `views_count` (integer, default 0) - Page view counter
     - `password` (text, nullable) - Optional password protection
     - `custom_domain` (text, nullable) - Optional custom domain for premium clients
     - `seo_title` (text, nullable) - Custom SEO title
     - `seo_description` (text, nullable) - Custom SEO description

  3. **Indexes Created**
     - Index on `slug` for fast lookup by URL
     - Index on `template_name` for filtering by template
     - Index on `status` for filtering active/draft projects

  4. **Security**
     - RLS policies remain unchanged (public access)
     - All existing data preserved

  ## Backward Compatibility
  - Existing data automatically gets slug generated from couple_names
  - Default template_name set to 'timeless'
  - Default status set to 'active' for existing records
*/

-- Add new columns for multi-template support
DO $$
BEGIN
  -- Add slug column (unique identifier for URL)
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'timeless_content' AND column_name = 'slug'
  ) THEN
    ALTER TABLE timeless_content ADD COLUMN slug text;
  END IF;

  -- Add template_name column
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'timeless_content' AND column_name = 'template_name'
  ) THEN
    ALTER TABLE timeless_content ADD COLUMN template_name text DEFAULT 'timeless';
  END IF;

  -- Add status column
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'timeless_content' AND column_name = 'status'
  ) THEN
    ALTER TABLE timeless_content ADD COLUMN status text DEFAULT 'draft';
  END IF;

  -- Add views_count column
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'timeless_content' AND column_name = 'views_count'
  ) THEN
    ALTER TABLE timeless_content ADD COLUMN views_count integer DEFAULT 0;
  END IF;

  -- Add password column (for password protection)
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'timeless_content' AND column_name = 'password'
  ) THEN
    ALTER TABLE timeless_content ADD COLUMN password text;
  END IF;

  -- Add custom_domain column (for premium clients)
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'timeless_content' AND column_name = 'custom_domain'
  ) THEN
    ALTER TABLE timeless_content ADD COLUMN custom_domain text;
  END IF;

  -- Add SEO columns
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'timeless_content' AND column_name = 'seo_title'
  ) THEN
    ALTER TABLE timeless_content ADD COLUMN seo_title text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'timeless_content' AND column_name = 'seo_description'
  ) THEN
    ALTER TABLE timeless_content ADD COLUMN seo_description text;
  END IF;
END $$;

-- Generate slugs for existing records (if any)
UPDATE timeless_content
SET slug = lower(regexp_replace(couple_names, '[^a-zA-Z0-9]+', '-', 'g'))
WHERE slug IS NULL AND couple_names IS NOT NULL AND couple_names != '';

-- Set default slug for records without couple_names
UPDATE timeless_content
SET slug = 'wedding-' || substr(id::text, 1, 8)
WHERE slug IS NULL OR slug = '';

-- Set status to 'active' for existing records
UPDATE timeless_content
SET status = 'active'
WHERE status = 'draft' AND couple_names IS NOT NULL AND couple_names != '';

-- Add unique constraint on slug
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'timeless_content_slug_key'
  ) THEN
    ALTER TABLE timeless_content ADD CONSTRAINT timeless_content_slug_key UNIQUE (slug);
  END IF;
END $$;

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_timeless_content_slug ON timeless_content(slug);
CREATE INDEX IF NOT EXISTS idx_timeless_content_template ON timeless_content(template_name);
CREATE INDEX IF NOT EXISTS idx_timeless_content_status ON timeless_content(status);
CREATE INDEX IF NOT EXISTS idx_timeless_content_created_at ON timeless_content(created_at DESC);

-- Create function to auto-generate slug from couple_names
CREATE OR REPLACE FUNCTION generate_slug_from_couple_names()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.slug IS NULL OR NEW.slug = '' THEN
    IF NEW.couple_names IS NOT NULL AND NEW.couple_names != '' THEN
      NEW.slug := lower(regexp_replace(NEW.couple_names, '[^a-zA-Z0-9]+', '-', 'g'));
    ELSE
      NEW.slug := 'wedding-' || substr(NEW.id::text, 1, 8);
    END IF;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to auto-generate slug
DROP TRIGGER IF EXISTS trigger_generate_slug ON timeless_content;
CREATE TRIGGER trigger_generate_slug
  BEFORE INSERT OR UPDATE ON timeless_content
  FOR EACH ROW
  EXECUTE FUNCTION generate_slug_from_couple_names();

-- Create function to increment views
CREATE OR REPLACE FUNCTION increment_views(project_slug text)
RETURNS void AS $$
BEGIN
  UPDATE timeless_content
  SET views_count = views_count + 1
  WHERE slug = project_slug;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Success message
DO $$
BEGIN
  RAISE NOTICE '✅ Multi-template support migration completed successfully!';
  RAISE NOTICE '📊 Existing data preserved and updated with default values.';
END $$;
