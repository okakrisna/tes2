/*
  # Add Orders Management Table

  1. New Tables
    - `orders`: tracking wedding invitation orders
      - `id` (uuid, primary key)
      - `order_number` (text, unique) - auto-generated order number
      - `client_name` (text) - nama client/pasangan
      - `client_phone` (text) - nomor telepon client
      - `client_email` (text) - email client
      - `template_name` (text) - template yang dipilih (timeless/elegant)
      - `wedding_date` (date) - tanggal pernikahan
      - `order_date` (date) - tanggal order masuk
      - `deadline` (date) - deadline pengerjaan
      - `status` (text) - pending, in_progress, completed, cancelled
      - `priority` (text) - low, medium, high, urgent
      - `price` (numeric) - harga yang disepakati
      - `payment_status` (text) - unpaid, partial, paid
      - `notes` (text) - catatan tambahan
      - `project_url` (text) - URL project jika sudah dibuat
      - `created_at` (timestamptz)
      - `updated_at` (timestamptz)

  2. Security
    - Enable RLS on `orders` table
    - Add policies for authenticated users to manage orders
    - Anyone can view orders (for public board access if needed)

  3. Indexes
    - Index on status for fast filtering
    - Index on deadline for sorting
    - Index on order_date
*/

CREATE TABLE IF NOT EXISTS orders (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  order_number text UNIQUE NOT NULL,
  client_name text NOT NULL,
  client_phone text,
  client_email text,
  template_name text CHECK (template_name IN ('timeless', 'elegant')),
  wedding_date date,
  order_date date NOT NULL DEFAULT CURRENT_DATE,
  deadline date,
  status text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'in_progress', 'completed', 'cancelled')),
  priority text NOT NULL DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high', 'urgent')),
  price numeric(10, 2) DEFAULT 0,
  payment_status text NOT NULL DEFAULT 'unpaid' CHECK (payment_status IN ('unpaid', 'partial', 'paid')),
  notes text,
  project_url text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view orders"
  ON orders
  FOR SELECT
  USING (true);

CREATE POLICY "Authenticated users can insert orders"
  ON orders
  FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Authenticated users can update orders"
  ON orders
  FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Authenticated users can delete orders"
  ON orders
  FOR DELETE
  TO authenticated
  USING (true);

CREATE INDEX IF NOT EXISTS idx_orders_status ON orders(status);
CREATE INDEX IF NOT EXISTS idx_orders_deadline ON orders(deadline);
CREATE INDEX IF NOT EXISTS idx_orders_order_date ON orders(order_date DESC);
CREATE INDEX IF NOT EXISTS idx_orders_priority ON orders(priority);

-- Function to auto-update updated_at timestamp
CREATE OR REPLACE FUNCTION update_orders_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to auto-update updated_at
DROP TRIGGER IF EXISTS orders_updated_at_trigger ON orders;
CREATE TRIGGER orders_updated_at_trigger
  BEFORE UPDATE ON orders
  FOR EACH ROW
  EXECUTE FUNCTION update_orders_updated_at();
