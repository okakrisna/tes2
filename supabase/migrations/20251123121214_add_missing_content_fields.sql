/*
  # Add missing fields to timeless_content table

  1. Changes
    - Add columns for all content fields from JSON
    - Add background section fields (1-5) with size and position
    - Add gallery images array field
    - Add hero and streaming fields
    - Add journey, countdown, and other text fields
  
  2. Security
    - Maintain existing RLS policies
*/

-- Add new columns to timeless_content table
DO $$ 
BEGIN
  -- Hero section fields
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'timeless_content' AND column_name = 'hero_title') THEN
    ALTER TABLE timeless_content ADD COLUMN hero_title text DEFAULT ''::text;
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'timeless_content' AND column_name = 'hero_image') THEN
    ALTER TABLE timeless_content ADD COLUMN hero_image text DEFAULT ''::text;
  END IF;
  
  -- Background sections
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'timeless_content' AND column_name = 'background_section_1') THEN
    ALTER TABLE timeless_content ADD COLUMN background_section_1 text DEFAULT ''::text;
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'timeless_content' AND column_name = 'background_section_1_size') THEN
    ALTER TABLE timeless_content ADD COLUMN background_section_1_size text DEFAULT 'cover'::text;
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'timeless_content' AND column_name = 'background_section_1_position') THEN
    ALTER TABLE timeless_content ADD COLUMN background_section_1_position text DEFAULT 'center center'::text;
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'timeless_content' AND column_name = 'background_section_2') THEN
    ALTER TABLE timeless_content ADD COLUMN background_section_2 text DEFAULT ''::text;
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'timeless_content' AND column_name = 'background_section_2_size') THEN
    ALTER TABLE timeless_content ADD COLUMN background_section_2_size text DEFAULT 'cover'::text;
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'timeless_content' AND column_name = 'background_section_2_position') THEN
    ALTER TABLE timeless_content ADD COLUMN background_section_2_position text DEFAULT 'center center'::text;
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'timeless_content' AND column_name = 'background_section_3') THEN
    ALTER TABLE timeless_content ADD COLUMN background_section_3 text DEFAULT ''::text;
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'timeless_content' AND column_name = 'background_section_3_size') THEN
    ALTER TABLE timeless_content ADD COLUMN background_section_3_size text DEFAULT 'cover'::text;
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'timeless_content' AND column_name = 'background_section_3_position') THEN
    ALTER TABLE timeless_content ADD COLUMN background_section_3_position text DEFAULT 'center center'::text;
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'timeless_content' AND column_name = 'background_section_4') THEN
    ALTER TABLE timeless_content ADD COLUMN background_section_4 text DEFAULT ''::text;
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'timeless_content' AND column_name = 'background_section_4_size') THEN
    ALTER TABLE timeless_content ADD COLUMN background_section_4_size text DEFAULT 'cover'::text;
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'timeless_content' AND column_name = 'background_section_4_position') THEN
    ALTER TABLE timeless_content ADD COLUMN background_section_4_position text DEFAULT 'center center'::text;
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'timeless_content' AND column_name = 'background_section_5') THEN
    ALTER TABLE timeless_content ADD COLUMN background_section_5 text DEFAULT ''::text;
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'timeless_content' AND column_name = 'background_section_5_size') THEN
    ALTER TABLE timeless_content ADD COLUMN background_section_5_size text DEFAULT 'cover'::text;
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'timeless_content' AND column_name = 'background_section_5_position') THEN
    ALTER TABLE timeless_content ADD COLUMN background_section_5_position text DEFAULT 'center center'::text;
  END IF;
  
  -- Gallery images as JSON array
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'timeless_content' AND column_name = 'gallery_images') THEN
    ALTER TABLE timeless_content ADD COLUMN gallery_images jsonb DEFAULT '[]'::jsonb;
  END IF;
END $$;
