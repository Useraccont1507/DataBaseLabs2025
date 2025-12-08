-- CreateEnum
CREATE TYPE "ComplaintStatus" AS ENUM ('PENDING', 'REVIEWED', 'REJECTED');

-- CreateTable
CREATE TABLE "comments" (
    "commentid" SERIAL NOT NULL,
    "text" TEXT NOT NULL,
    "createdat" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,
    "postid" INTEGER NOT NULL,
    "userid" INTEGER NOT NULL,
    "parentcommentid" INTEGER,

    CONSTRAINT "comments_pkey" PRIMARY KEY ("commentid")
);

-- CreateTable
CREATE TABLE "likes" (
    "likeid" SERIAL NOT NULL,
    "postid" INTEGER NOT NULL,
    "userid" INTEGER NOT NULL,
    "createdat" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "likes_pkey" PRIMARY KEY ("likeid")
);

-- CreateTable
CREATE TABLE "posts" (
    "postid" SERIAL NOT NULL,
    "userid" INTEGER NOT NULL,
    "title" VARCHAR NOT NULL,
    "text" TEXT,
    "imageurl" VARCHAR,
    "createdat" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "posts_pkey" PRIMARY KEY ("postid")
);

-- CreateTable
CREATE TABLE "posttags" (
    "postid" INTEGER NOT NULL,
    "tagid" INTEGER NOT NULL,

    CONSTRAINT "pk_post_tags" PRIMARY KEY ("postid","tagid")
);

-- CreateTable
CREATE TABLE "tags" (
    "tagid" SERIAL NOT NULL,
    "text" VARCHAR(16) NOT NULL,

    CONSTRAINT "tags_pkey" PRIMARY KEY ("tagid")
);

-- CreateTable
CREATE TABLE "userfollowers" (
    "id" SERIAL NOT NULL,
    "followerid" INTEGER NOT NULL,
    "followingid" INTEGER NOT NULL,

    CONSTRAINT "userfollowers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "users" (
    "userid" SERIAL NOT NULL,
    "email" TEXT NOT NULL,
    "password" VARCHAR NOT NULL,
    "nickname" VARCHAR(16) NOT NULL,
    "avatarimageurl" VARCHAR,
    "createdat" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "users_pkey" PRIMARY KEY ("userid")
);

-- CreateTable
CREATE TABLE "postComplaint" (
    "postComplaintId" SERIAL NOT NULL,
    "userid" INTEGER NOT NULL,
    "postid" INTEGER NOT NULL,
    "status" "ComplaintStatus" NOT NULL DEFAULT 'PENDING',
    "createdat" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "postComplaint_pkey" PRIMARY KEY ("postComplaintId")
);

-- CreateIndex
CREATE UNIQUE INDEX "likes_userid_postid_key" ON "likes"("userid", "postid");

-- CreateIndex
CREATE UNIQUE INDEX "tags_text_key" ON "tags"("text");

-- CreateIndex
CREATE UNIQUE INDEX "userfollowers_followerid_followingid_key" ON "userfollowers"("followerid", "followingid");

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "postComplaint_userid_postid_key" ON "postComplaint"("userid", "postid");

-- AddForeignKey
ALTER TABLE "comments" ADD CONSTRAINT "comments_parentcommentid_fkey" FOREIGN KEY ("parentcommentid") REFERENCES "comments"("commentid") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "comments" ADD CONSTRAINT "comments_postid_fkey" FOREIGN KEY ("postid") REFERENCES "posts"("postid") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "comments" ADD CONSTRAINT "comments_userid_fkey" FOREIGN KEY ("userid") REFERENCES "users"("userid") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "likes" ADD CONSTRAINT "likes_postid_fkey" FOREIGN KEY ("postid") REFERENCES "posts"("postid") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "likes" ADD CONSTRAINT "likes_userid_fkey" FOREIGN KEY ("userid") REFERENCES "users"("userid") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "posts" ADD CONSTRAINT "posts_userid_fkey" FOREIGN KEY ("userid") REFERENCES "users"("userid") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "posttags" ADD CONSTRAINT "posttags_postid_fkey" FOREIGN KEY ("postid") REFERENCES "posts"("postid") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "posttags" ADD CONSTRAINT "posttags_tagid_fkey" FOREIGN KEY ("tagid") REFERENCES "tags"("tagid") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "userfollowers" ADD CONSTRAINT "userfollowers_followerid_fkey" FOREIGN KEY ("followerid") REFERENCES "users"("userid") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "userfollowers" ADD CONSTRAINT "userfollowers_followingid_fkey" FOREIGN KEY ("followingid") REFERENCES "users"("userid") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "postComplaint" ADD CONSTRAINT "postComplaint_userid_fkey" FOREIGN KEY ("userid") REFERENCES "users"("userid") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "postComplaint" ADD CONSTRAINT "postComplaint_postid_fkey" FOREIGN KEY ("postid") REFERENCES "posts"("postid") ON DELETE CASCADE ON UPDATE NO ACTION;
