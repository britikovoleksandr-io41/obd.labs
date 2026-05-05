-- Видалення старих таблиць , щоб оновити схему
DROP TABLE IF EXISTS loans CASCADE;
DROP TABLE IF EXISTS books CASCADE;
DROP TABLE IF EXISTS members CASCADE;
DROP TABLE IF EXISTS categories CASCADE;

-- СХЕМА В 3NF

-- 1. Таблиця категорій (Без транзитивних залежностей)
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

-- 2. Таблиця читачів (Без часткових залежностей)
CREATE TABLE members (
    member_id SERIAL PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    phone VARCHAR(20) UNIQUE
);

-- 3. Таблиця книг (Категорія винесена за зовнішнім ключем)
CREATE TABLE books (
    book_id SERIAL PRIMARY KEY,
    category_id INTEGER REFERENCES categories(category_id),
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL
);

-- 4. Таблиця позик (Залишилися лише залежності від повного ключа)
CREATE TABLE loans (
    loan_id SERIAL PRIMARY KEY,
    member_id INTEGER REFERENCES members(member_id),
    book_id INTEGER REFERENCES books(book_id),
    loan_date DATE NOT NULL DEFAULT CURRENT_DATE,
    return_date DATE CHECK (return_date > loan_date)
);