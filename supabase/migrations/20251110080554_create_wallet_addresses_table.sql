/*
  # Create wallet_addresses table

  1. New Tables
    - `wallet_addresses`
      - `id` (uuid, primary key) - Unique identifier for each wallet entry
      - `address` (text, not null) - The crypto wallet address
      - `label` (text) - Optional label/name for the wallet
      - `blockchain` (text) - Optional blockchain type (e.g., Bitcoin, Ethereum, Solana)
      - `created_at` (timestamptz) - Timestamp when the wallet was added
      - `user_id` (uuid) - Reference to the user who owns this wallet
  
  2. Security
    - Enable RLS on `wallet_addresses` table
    - Add policy for authenticated users to read their own wallet addresses
    - Add policy for authenticated users to insert their own wallet addresses
    - Add policy for authenticated users to update their own wallet addresses
    - Add policy for authenticated users to delete their own wallet addresses
*/

CREATE TABLE IF NOT EXISTS wallet_addresses (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  address text NOT NULL,
  label text DEFAULT '',
  blockchain text DEFAULT '',
  created_at timestamptz DEFAULT now(),
  user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE
);

ALTER TABLE wallet_addresses ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own wallet addresses"
  ON wallet_addresses FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own wallet addresses"
  ON wallet_addresses FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own wallet addresses"
  ON wallet_addresses FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own wallet addresses"
  ON wallet_addresses FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);