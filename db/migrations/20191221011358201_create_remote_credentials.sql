-- +micrate Up
CREATE TABLE remote_credentials (
  id BIGSERIAL PRIMARY KEY,
  user_id BIGINT,
  username VARCHAR,
  encrypted_password VARCHAR,
  chamberlain_account_id VARCHAR,
  chamberlain_security_token VARCHAR,
  time_zone VARCHAR,
  last_auth_request_at TIMESTAMP,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
CREATE INDEX remote_credentials_user_id_idx ON remote_credentials (user_id);

-- +micrate Down
DROP TABLE IF EXISTS remote_credentials;