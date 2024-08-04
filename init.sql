CREATE TABLE IF NOT EXISTS "users" (
	"id" bigint GENERATED ALWAYS AS IDENTITY NOT NULL UNIQUE,
	"email" text UNIQUE,
	"username" text NOT NULL UNIQUE,
	"hashedPassword" text NOT NULL,
	"address" text NOT NULL,
	"sessionToken" text NOT NULL,
	"emailOptIn" boolean,
	PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "events" (
	"id" bigint GENERATED ALWAYS AS IDENTITY NOT NULL UNIQUE,
	"isPrivate" boolean NOT NULL,
	"ytLink" text,
	"adminId" bigint NOT NULL,
	"eventName" text NOT NULL,
	"description" text NOT NULL,
	"created_at" timestamp without time zone NOT NULL,
	"address" text NOT NULL,
	"event_date" timestamp without time zone NOT NULL,
	PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "tags" (
	"id" bigint GENERATED ALWAYS AS IDENTITY NOT NULL UNIQUE,
	"name" text NOT NULL,
	"event_id" bigint NOT NULL,
	PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "privateEventMembers" (
	"user_id" bigint NOT NULL UNIQUE,
	"event_id" bigint NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS "eventRegistrants" (
	"event_id" bigint NOT NULL UNIQUE,
	"user_id" bigint NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS "comments" (
	"id" bigint GENERATED ALWAYS AS IDENTITY NOT NULL UNIQUE,
	"body" text NOT NULL,
	"poster_id" bigint NOT NULL,
	"event_id" bigint NOT NULL,
	"created_at" timestamp without time zone NOT NULL,
	PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "directMessage" (
	"id" bigint GENERATED ALWAYS AS IDENTITY NOT NULL UNIQUE,
	"body" text NOT NULL,
	"poster_id" bigint NOT NULL,
	"recepient_id" bigint NOT NULL,
	"sent_at" timestamp without time zone NOT NULL,
	PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "pendingInvitation" (
	"id" bigint GENERATED ALWAYS AS IDENTITY NOT NULL UNIQUE,
	"event_id" bigint NOT NULL,
	"url_hash" text NOT NULL,
	PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "socialMediaShare" (
	"id" bigint GENERATED ALWAYS AS IDENTITY NOT NULL UNIQUE,
	"event_id" bigint NOT NULL,
	"user_id" bigint NOT NULL,
	"platform" text NOT NULL,
	PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "blockedUsers" (
	"blocker_id" bigint NOT NULL,
	"blocked_id" bigint NOT NULL
);

CREATE TABLE IF NOT EXISTS "notifications" (
	"id" bigint GENERATED ALWAYS AS IDENTITY NOT NULL UNIQUE,
	"user_id" bigint NOT NULL,
	"event_id" bigint,
	"body" text NOT NULL,
	"created_at" timestamp without time zone NOT NULL,
	PRIMARY KEY ("id")
);


ALTER TABLE "events" ADD CONSTRAINT "events_fk3" FOREIGN KEY ("adminId") REFERENCES "users"("id");
ALTER TABLE "tags" ADD CONSTRAINT "tags_fk2" FOREIGN KEY ("event_id") REFERENCES "events"("id");
ALTER TABLE "privateEventMembers" ADD CONSTRAINT "privateEventMembers_fk0" FOREIGN KEY ("user_id") REFERENCES "users"("id");

ALTER TABLE "privateEventMembers" ADD CONSTRAINT "privateEventMembers_fk1" FOREIGN KEY ("event_id") REFERENCES "events"("id");
ALTER TABLE "eventRegistrants" ADD CONSTRAINT "eventRegistrants_fk0" FOREIGN KEY ("event_id") REFERENCES "events"("id");

ALTER TABLE "eventRegistrants" ADD CONSTRAINT "eventRegistrants_fk1" FOREIGN KEY ("user_id") REFERENCES "users"("id");
ALTER TABLE "comments" ADD CONSTRAINT "comments_fk2" FOREIGN KEY ("poster_id") REFERENCES "users"("id");

ALTER TABLE "comments" ADD CONSTRAINT "comments_fk3" FOREIGN KEY ("event_id") REFERENCES "events"("id");
ALTER TABLE "directMessage" ADD CONSTRAINT "directMessage_fk2" FOREIGN KEY ("poster_id") REFERENCES "users"("id");

ALTER TABLE "directMessage" ADD CONSTRAINT "directMessage_fk3" FOREIGN KEY ("recepient_id") REFERENCES "users"("id");
ALTER TABLE "pendingInvitation" ADD CONSTRAINT "pendingInvitation_fk1" FOREIGN KEY ("event_id") REFERENCES "events"("id");
ALTER TABLE "socialMediaShare" ADD CONSTRAINT "socialMediaShare_fk1" FOREIGN KEY ("event_id") REFERENCES "events"("id");

ALTER TABLE "socialMediaShare" ADD CONSTRAINT "socialMediaShare_fk2" FOREIGN KEY ("user_id") REFERENCES "users"("id");
ALTER TABLE "blockedUsers" ADD CONSTRAINT "blockedUsers_fk0" FOREIGN KEY ("blocker_id") REFERENCES "users"("id");

ALTER TABLE "blockedUsers" ADD CONSTRAINT "blockedUsers_fk1" FOREIGN KEY ("blocked_id") REFERENCES "users"("id");
ALTER TABLE "notifications" ADD CONSTRAINT "notifications_fk1" FOREIGN KEY ("user_id") REFERENCES "users"("id");

ALTER TABLE "notifications" ADD CONSTRAINT "notifications_fk2" FOREIGN KEY ("event_id") REFERENCES "events"("id");