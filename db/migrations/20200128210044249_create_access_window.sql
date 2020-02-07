-- +micrate Up
CREATE TABLE access_windows (
  id BIGSERIAL PRIMARY KEY,
  guest_id BIGINT,
  device_id BIGINT,
  start_at TIMESTAMP,
  end_at TIMESTAMP,
  slug VARCHAR,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
CREATE INDEX access_window_guest_id_idx ON access_windows (guest_id);
CREATE INDEX access_window_device_id_idx ON access_windows (device_id);

-- +micrate Down
DROP TABLE IF EXISTS access_windows;
