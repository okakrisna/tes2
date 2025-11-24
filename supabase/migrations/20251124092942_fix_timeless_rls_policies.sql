/*
  # Fix RLS policies for timeless_content table
  
  This migration fixes the RLS policies to ensure they work correctly with REST API.
*/

-- Drop existing policies
DROP POLICY IF EXISTS "Anyone can read timeless content" ON timeless_content;
DROP POLICY IF EXISTS "Anyone can insert timeless content" ON timeless_content;
DROP POLICY IF EXISTS "Anyone can update timeless content" ON timeless_content;
DROP POLICY IF EXISTS "Anyone can delete timeless content" ON timeless_content;

-- Create new policies with proper configuration
CREATE POLICY "Enable read access for all"
  ON timeless_content
  FOR SELECT
  USING (true);

CREATE POLICY "Enable insert access for all"
  ON timeless_content
  FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Enable update access for all"
  ON timeless_content
  FOR UPDATE
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Enable delete access for all"
  ON timeless_content
  FOR DELETE
  USING (true);
