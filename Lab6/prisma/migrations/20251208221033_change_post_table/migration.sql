/*
  Warnings:

  - You are about to drop the column `imageurl` on the `posts` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "posts" DROP COLUMN "imageurl",
ADD COLUMN     "imageUrlPath" VARCHAR,
ADD COLUMN     "isPublished" BOOLEAN NOT NULL DEFAULT false;
