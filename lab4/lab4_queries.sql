-- ==========================================
-- 1: Агрегатні функції, GROUP BY та HAVING 
-- ==========================================

-- 1. Базова агрегація (COUNT): Загальна кількість книг у бібліотеці
SELECT COUNT(*) AS total_books 
FROM books;

-- 2. Агрегація (MIN, MAX): Найперша та остання дата видачі книги
SELECT MIN(loan_date) AS first_loan_date, MAX(loan_date) AS last_loan_date 
FROM loans;

-- 3. Групування (GROUP BY): Кількість книг у кожній категорії
SELECT category_id, COUNT(*) AS books_in_category 
FROM books 
GROUP BY category_id;

-- 4. Групування з фільтрацією (HAVING): Читачі, які брали більше ніж 1 книгу
SELECT member_id, COUNT(*) AS total_loans 
FROM loans 
GROUP BY member_id 
HAVING COUNT(*) > 1;


-- ==========================================
-- 2: Об'єднання таблиць JOIN 
-- ==========================================

-- 5. INNER JOIN: Вивести імена читачів, назви книг та дати їх позик
SELECT m.full_name, b.title, l.loan_date
FROM loans l
INNER JOIN members m ON l.member_id = m.member_id
INNER JOIN books b ON l.book_id = b.book_id;

-- 6. LEFT JOIN: Вивести всі книги та історію їх позик (навіть якщо книгу ще ніхто не брав)
SELECT b.title, l.loan_date, l.return_date
FROM books b
LEFT JOIN loans l ON b.book_id = l.book_id;

-- 7. RIGHT JOIN: Вивести всі категорії та книги, що до них належать (навіть якщо категорія порожня)
SELECT c.category_name, b.title
FROM books b
RIGHT JOIN categories c ON b.category_id = c.category_id;


-- ==========================================
--  3: Підзапити - Subqueries 
-- ==========================================

-- 8. Підзапит у WHERE: Знайти імена читачів, які коли-небудь брали книгу "Дюна"
SELECT full_name 
FROM members 
WHERE member_id IN (
    SELECT member_id 
    FROM loans 
    WHERE book_id = (SELECT book_id FROM books WHERE title = 'Дюна')
);

-- 9. Підзапит у SELECT: Вивести назви всіх книг та поруч загальну кількість разів, скільки їх брали
SELECT title, 
       (SELECT COUNT(*) FROM loans l WHERE l.book_id = b.book_id) AS times_borrowed 
FROM books b;

-- 10. Підзапит з HAVING: Знайти назви категорій, у яких є більше однієї книги
SELECT category_name 
FROM categories 
WHERE category_id IN (
    SELECT category_id 
    FROM books 
    GROUP BY category_id 
    HAVING COUNT(*) > 1
);