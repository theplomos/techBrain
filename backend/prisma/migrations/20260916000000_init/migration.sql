CREATE TYPE "Role" AS ENUM ('user', 'admin');

CREATE TABLE "users" (
    "id" UUID NOT NULL,
    "email" VARCHAR(254) NOT NULL,
    "full_name" VARCHAR(150) NOT NULL,
    "password_hash" VARCHAR(100),
    "discord_id" VARCHAR(32),
    "avatar_url" TEXT,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "roles" "Role"[] DEFAULT ARRAY['user']::"Role"[],
    "last_login_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,
    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "refresh_sessions" (
    "id" UUID NOT NULL,
    "token_hash" VARCHAR(64) NOT NULL,
    "expires_at" TIMESTAMPTZ NOT NULL,
    "revoked_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "user_id" UUID NOT NULL,
    CONSTRAINT "refresh_sessions_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "oauth_codes" (
    "id" UUID NOT NULL,
    "code_hash" VARCHAR(64) NOT NULL,
    "expires_at" TIMESTAMPTZ NOT NULL,
    "used_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "user_id" UUID NOT NULL,
    CONSTRAINT "oauth_codes_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "UQ_users_email" ON "users"("email");
CREATE UNIQUE INDEX "UQ_users_discord_id" ON "users"("discord_id");
CREATE UNIQUE INDEX "UQ_refresh_sessions_token_hash" ON "refresh_sessions"("token_hash");
CREATE INDEX "IDX_refresh_sessions_user_id" ON "refresh_sessions"("user_id");
CREATE UNIQUE INDEX "UQ_oauth_codes_code_hash" ON "oauth_codes"("code_hash");

ALTER TABLE "refresh_sessions" ADD CONSTRAINT "refresh_sessions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "oauth_codes" ADD CONSTRAINT "oauth_codes_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
