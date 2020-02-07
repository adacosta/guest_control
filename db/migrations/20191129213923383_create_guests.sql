-- +micrate Up
CREATE TABLE guests (
  id BIGSERIAL PRIMARY KEY,
  name VARCHAR,
  note TEXT,
  user_id BIGINT,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
CREATE INDEX guest_user_id_idx ON guests (user_id);

-- +micrate Down
DROP TABLE IF EXISTS guests;