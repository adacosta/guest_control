-- +micrate Up
CREATE TABLE requests (
  id BIGSERIAL PRIMARY KEY,
  kind VARCHAR,
  response TEXT,
  response_code INT,
  remote_credential_id BIGINT,
  created_at TIMESTAMP
);


-- +micrate Down
DROP TABLE IF EXISTS requests;
