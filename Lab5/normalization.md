# DatabaseLab 5

Верезей Ілля ІМ-42

---

## 1. Функціональні залежності (FD)


### Таблиця `users`
*   `userId` -> `email`, `password`, `nickname`, `avatarImageUrl`, `createdAt`

### Таблиця `userFollowers`
*   `id` (Surrogate PK) -> `followerId`, `followingId`
*   `{followerId, followingId}` -> `id` (Забезпечується обмеженням `UNIQUE`, що запобігає дублюванню підписок)

### Таблиця `posts`
*   `postId` -> `userId`, `title`, `text`, `imageUrl`, `createdAt`
*   `userId` -> `users.userId`

### Таблиця `likes`
*   `likeId` (Surrogate PK) -> `postId`, `userId`, `createdAt`
*   `{userId, postId}` -> `likeId` (Забезпечується обмеженням `UNIQUE`, один лайк на пост від юзера)

### Таблиця `comments`
*   `commentId` -> `text`, `createdAt`, `postId`, `userId`, `parentCommentId`

### Таблиця `tags`
*   `tagId` -> `text`

### Таблиця `postTags`
*   `{postId, tagId}` -> *existence* (Комбінація визначає наявність зв'язку)

---

## 2. Аналіз нормальних форм (NF)

### 2.1. Перша нормальна форма (1NF)
**Вимога:** Атомарність атрибутів
**Аналіз:** Усі таблиці (`users`, `userFollowers`, `posts`, `likes`, `comments`, `tags`, `postTags`) містять лише скалярні типи даних (`INT`, `VARCHAR`, `TEXT`, `TIMESTAMP`). Жодне поле не містить масивів (наприклад, теги не записані як "tag1, tag2" в одному рядку).
**Висновок:** Схема відповідає **1NF**.

### 2.2. Друга нормальна форма (2NF)
**Вимога:** Відсутність часткових функціональних залежностей (неключовий атрибут залежить від частини складеного ключа).

*   **Таблиці з простим ключем:** `users`, `posts`, `comments`, `tags` мають простий PK (`userId`, `postId` тощо), тому автоматично відповідають 2NF.
*   **Таблиці з сурогатним ключем та UNIQUE:** `likes` та `userFollowers` мають власний `id`, тому часткова залежність неможлива.
*   **Таблиця `postTags` (Проблема та Рішення):**
    *   *До нормалізації:* Якщо таблиця не має PK, можливе дублювання пар `(postId, tagId)`.
    *   *Рішення:* Створення **композитного первинного ключа** `(postId, tagId)`. Оскільки в цій таблиці немає неключових атрибутів, умова 2NF виконується автоматично.

### 2.3. Третя нормальна форма (3NF)
**Вимога:** Відсутність транзитивних залежностей (неключовий атрибут залежить від іншого неключового).

*   **Аналіз:**
    *   У `posts`: заголовок і текст залежать від `postId`. Хоча є `userId`, атрибути поста не змінюються при зміні атрибутів юзера.
    *   У `comments`: текст коментаря залежить від `commentId`.
    *   У `users`: всі поля залежать прямо від `userId`.
*   **Висновок:** Транзитивні залежності відсутні. Схема знаходиться в **3NF**.

---

## 3. Процес нормалізації `postTags`

Таблиця зв'язку `postTags` була модифікована для забезпечення цілісності даних та уникнення аномалій вставки (дублікатів).

### Проблема (Оригінальний дизайн)
Без обмежень можна було додати один і той самий тег до поста декілька разів.

```sql
INSERT INTO postTags (postId, tagId) VALUES (1, 5);
INSERT INTO postTags (postId, tagId) VALUES (1, 5); -- Дублювання
```

### Рішення (Нормалізований дизайн)

Використання пари `(postId, tagId)` як **Composite Primary Key** гарантує унікальність зв'язку.

```sql
CREATE TABLE postTags (
    postId INT NOT NULL,
    tagId INT NOT NULL,
    
    CONSTRAINT fk_post FOREIGN KEY (postId) REFERENCES posts(postId) ON DELETE CASCADE,
    CONSTRAINT fk_tag FOREIGN KEY (tagId) REFERENCES tags(tagId) ON DELETE CASCADE,
    
);

ALTER TABLE postTags
ADD CONSTRAINT pk_post_tags PRIMARY KEY (postId, tagId);
```

## 4. Процес нормалізації `users`


### Проблема (Оригінальний дизайн)
Поле email не мало обмеження UNIQUE, що порушувало логіку автентифікації.

```sql
INSERT INTO users (email, password, nickname, avatarImageUrl)
VALUES 
('user@example.com', 'pass123', 'Olena', 'https://example.com/avatar1.png'),
('user@example.com', 'pass456', 'Ivan', 'https://example.com/avatar2.png');
```

### Рішення (Нормалізований дизайн)

Використання CONSTRAINT

```sql
CREATE TABLE users (
    userId SERIAL PRIMARY KEY,
    email CITEXT NOT NULL,
    CONSTRAINT email_format CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    password VARCHAR NOT NULL,
    nickname VARCHAR(16) NOT NULL,
    avatarImageUrl VARCHAR,
    createdAt TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE users
ADD CONSTRAINT uq_users_email UNIQUE (email);
```

---

