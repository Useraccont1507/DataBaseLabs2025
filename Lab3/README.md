# DataBase-Lab3

## Схема бази даних

### Таблиця Users (Користувачі)
| Поле | Тип/Примітка |
| :--- | :--- |
| **userId** |  PK (первинний ключ) |
| **email** | email користувача |
| **password** | пароль користувача |
| **nickname** | нікнейм користувача |
| **avatarImageUrl** | URL аватара користувача |
| **createdAt** | Дата створення облікового запису |

*Примітки*: Основна таблиця. Кожен користувач має унікальний `userId`.

### Таблиця Posts (Пости)
| Поле | Тип/Примітка |
| :--- | :--- |
| **postId** |  PK (первинний ключ) |
| **title** | заголовок посту |
| **text** | текст посту |
| **imageUrl** | URL зображення |
| **createdAt** | дата створення посту |
| **userId** |  FK → Users.userId |

*Примітки*: Кожен пост належить **одному користувачу**.

### Таблиця Comments (Коментарі)
| Поле | Тип/Примітка |
| :--- | :--- |
| **commentId** |  PK (первинний ключ) |
| **text** | текст коментаря |
| **createdAt** | дата створення коментаря |
| **postId** |  FK → Posts.postId |
| **userId** |  FK → Users.userId |
| **parentCommentId** |  FK → Comments.commentId (**NULLable**) |

*Примітки*: Підтримує **ієрархічні коментарі** (відповіді на коментарі). `parentCommentId = NULL` для кореневих коментарів.

### Таблиця Likes (Лайки)
| Поле | Тип/Примітка |
| :--- | :--- |
| **likeId** |  PK (первинний ключ) |
| **postId** |  FK → Posts.postId |
| **userId** |  FK → Users.userId |
| **createdAt** | дата створення лайка |

*Примітки*: Реєструє лайки на постах. **Унікальна комбінація** (`userId`, `postId`).

### Таблиця Tags (Теги)
| Поле | Тип/Примітка |
| :--- | :--- |
| **tagId** |  PK (первинний ключ) |
| **text** | назва тегу |

*Примітки*: Зберігає список доступних тегів. Зв'язок із постами через таблицю `PostTags`.

### Таблиця PostTags (Зв'язок пост-тег)
| Поле | Тип/Примітка |
| :--- | :--- |
| **postId** |  FK → Posts.postId |
| **tagId** |  FK → Tags.tagId |

*Примітки*: **Проміжна таблиця** для зв'язку **багато-до-багатьох** (**M:N**) між постами та тегами.

### Таблиця UserFollowers (Підписки)
| Поле | Тип/Примітка |
| :--- | :--- |
| **id** | PK (первинний ключ) |
| **followerId** | FK → Users.userId (той, хто підписаний) |
| **followingId** | FK → Users.userId (той, на кого підписались) |

*Примітки*: Відображає зв'язки **M:N** між користувачами (**система підписок**).

---

## 🔗 Відносини між таблицями

| Відношення | Тип | Реалізація |
| :--- | :--- | :--- |
| **Users → Posts** | **1:N** | `Posts.userId` (FK, NOT NULL) |
| **Users → Comments** | **1:N** | `Comments.userId` (FK, NOT NULL) |
| **Posts → Comments** | **1:N** | `Comments.postId` (FK, NOT NULL) |
| **Comments → Comments** | **1:N** | `Comments.parentCommentId` (FK, NULLable) |
| **Posts ↔ Tags** | **M:N** | Проміжна таблиця `PostTags` |
| **Users ↔ Users** | **M:N** | Таблиця `UserFollowers` |
| **Posts ↔ Users** (через Likes) | **M:N** | Таблиця `Likes` |

---

## 📊 Діаграма відносин (текстова)
```text
Users (1) ←→ (N) Posts
  ↑                  ↑
  │                  │
 (N)                (N)
  │                  │
  ↓                  ↓
Comments ←------ Likes
  ↑
  │
 (N) (self-reference, NULLable)
  │
  ↓
Comments (child comments)

```

## Команди та фото

**INSERT:**  

```sql
INSERT INTO users (email, password, nickname, avatarImageUrl)
VALUES 
('andry@example.com', 'pass123', 'Andry', 'https://example.com/avatar1.png'),
('kate@example.com', 'pass12346', 'Kate', 'https://example.com/avatar1.png'),
('illia@example.com', 'pass456', 'Illia', 'https://example.com/avatar2.png');
```

<img src="usersInsert.png" alt="Users" width="1000"/>


```sql
INSERT INTO userFollowers (followerI d, followingId) 
VALUES
(1, 2),
(2, 1),
(3, 1);
```

<img src="folowersInsert.png" alt="Followers" width="1000"/>

```sql
INSERT INTO tags (text)
VALUES
('TESTTAG');
```

<img src="tagInsert.png" alt="Followers" width="1000"/>

```sql
INSERT INTO posts (title, text, imageUrl, userId)
VALUES 
('First Andry post', 'Hello world', 'https://example.com/avatar1.png', 1),
('Illia joined', 'Hello world', 'https://example.com/avatar1.png', 3),
('Second Andry post', 'Hello world', 'https://example.com/avatar1.png', 1),
('Kate post', 'Test Content', 'https://example.com/avatar2.png', 2);
```

<img src="postInsert.png" alt="Followers" width="1000"/>


**SELECT:** 
```sql
SELECT email, userId FROM users
```

<img src="userIdEmailSelect.png" alt="Followers" width="1000"/>

```sql
SELECT * FROM public.posts WHERE userId = 1
```


<img src="postByUserSelect.png" alt="Followers" width="1000"/>

```sql
SELECT userId, COUNT(postId) AS post_count
FROM posts
GROUP BY userId;
```

<img src="userPostCountSelect.png" alt="Followers" width="1000"/>

```sql
SELECT p.postId, p.title
FROM posts p
JOIN postTags pt ON p.postId = pt.postId
JOIN tags t ON pt.tagId = t.tagId
WHERE t.text = 'TESTTAG';
```

<img src="postByTag.png" alt="Followers" width="1000"/>

**UPDATE:** 

```sql
UPDATE users
SET password = 'newPass'
WHERE userId = 1;
```
<img src="passwordUpdate.png" alt="Followers" width="1000"/>

```sql
UPDATE posts
SET text = 'NEw Text'
WHERE postId = 1;
```
<img src="postUpdate.png" alt="Followers" width="1000"/>

```sql
UPDATE comments
SET text = 'New Comment'
WHERE commentId = 1;
```
<img src="commentUpdate.png" alt="Followers" width="1000"/>

**DELETE:** 

```sql
DELETE FROM users
WHERE userId = 3;
```

<img src="userDelete.png" alt="Followers" width="1000"/>

```sql
DELETE FROM likes
WHERE likeId = 1;
DELETE FROM comments
WHERE commentId = 2;
DELETE FROM postTags
WHERE postId = 1 AND tagId = 1;
```

**Верезей Ілля ІМ - 42**

