-- +micrate Up
CREATE TABLE devices (
  id BIGSERIAL PRIMARY KEY,
  serial_number VARCHAR UNIQUE,
  family VARCHAR,
  platform VARCHAR,
  kind VARCHAR,
  transition_state VARCHAR,
  transition_state_at TIMESTAMP,
  state JSON,
  remote_credential_id BIGINT,
  remote_created_at TIMESTAMP,
  nest_share_id VARCHAR,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
CREATE INDEX device_remote_credential_id_idx ON devices (remote_credential_id);

-- +micrate Down
DROP TABLE IF EXISTS devices;
