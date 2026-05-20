-- CreateTable
CREATE TABLE "reviews" (
    "review_id" SERIAL NOT NULL,
    "book_id" INTEGER NOT NULL,
    "member_id" INTEGER NOT NULL,
    "rating" INTEGER NOT NULL,
    "comment" TEXT,
    "created_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "reviews_pkey" PRIMARY KEY ("review_id")
);

-- AddForeignKey
ALTER TABLE "reviews" ADD CONSTRAINT "reviews_book_id_fkey" FOREIGN KEY ("book_id") REFERENCES "books"("book_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "reviews" ADD CONSTRAINT "reviews_member_id_fkey" FOREIGN KEY ("member_id") REFERENCES "members"("member_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
