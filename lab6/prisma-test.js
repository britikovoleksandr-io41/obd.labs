require("dotenv/config");

const { Pool } = require("pg");
const { PrismaPg } = require("@prisma/adapter-pg");
const { PrismaClient } = require("@prisma/client");

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

const adapter = new PrismaPg(pool);
const prisma = new PrismaClient({ adapter });

async function main() {
  const category = await prisma.categories.upsert({
    where: { category_name: "Наукова фантастика" },
    update: {},
    create: {
      category_name: "Наукова фантастика",
    },
  });

  const memberByPhone = await prisma.members.findUnique({
    where: { phone: "+380671112233" },
  });

  const member = memberByPhone
    ? await prisma.members.update({
        where: { member_id: memberByPhone.member_id },
        data: {
          email: "reader.test@example.com",
        },
      })
    : await prisma.members.create({
        data: {
          full_name: "Тестовий Читач",
          phone: "+380671112233",
          email: "reader.test@example.com",
        },
      });

  let book = await prisma.books.findFirst({
    where: {
      title: "Дюна",
      author: "Frank Herbert",
    },
  });

  if (!book) {
    book = await prisma.books.create({
      data: {
        title: "Дюна",
        author: "Frank Herbert",
        category_id: category.category_id,
        is_available: true,
      },
    });
  }

  const existingReview = await prisma.reviews.findFirst({
    where: {
      book_id: book.book_id,
      member_id: member.member_id,
    },
  });

  if (!existingReview) {
    await prisma.reviews.create({
      data: {
        book_id: book.book_id,
        member_id: member.member_id,
        rating: 5,
        comment: "Книга сподобалась, сюжет цікавий.",
      },
    });
  }

  const result = await prisma.books.findFirst({
    where: {
      book_id: book.book_id,
    },
    include: {
      categories: true,
      reviews: {
        include: {
          members: true,
        },
      },
    },
  });

  console.log(JSON.stringify(result, null, 2));
}

main()
  .catch((error) => {
    console.error(error);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
    await pool.end();
  });
