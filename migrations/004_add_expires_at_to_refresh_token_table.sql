ALTER TABLE refresh_tokens
ADD COLUMN expires_at TIMESTAMP NOT NULL AFTER token;