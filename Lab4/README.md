# DataBase-Lab4

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

**COUNT:**  

```sql
-- Знайдемо число користувачів без аватарки

SELECT COUNT(*) AS UsersWithoutAvatar
FROM users
WHERE avatarImageUrl IS null;
```

<img src="allUsers.png" alt="Users" width="1000"/>

<img src="allUsersWithoutAvatarCount.png" alt="Users" width="1000"/>

**SUM:**  

```sql
-- Знайдемо сумму лайків 

SELECT userId, SUM(1) AS totalLikes
FROM likes
GROUP BY userId;
```
<img src="likes.png" alt="Users" width="1000"/>

<img src="totalLikesById.png" alt="Users" width="1000"/>

**AVG:**  
```sql
-- Середня кількість лайків на пост
SELECT AVG(like_count) AS avg_likes_per_post
FROM (
    SELECT postId, COUNT(*) AS like_count
    FROM likes
    GROUP BY postId
) AS counts;
```

<img src="allPosts.png" alt="Users" width="1000"/>

<img src="avgLikes.png" alt="Followers" width="1000"/>

**MIN:** 

```sql

-- Найраніший пост у базі
SELECT MIN(createdAt) AS first_post_date
FROM posts;
```

<img src="allPosts.png" alt="Users" width="1000"/>

<img src="firstPostDate.png" alt="Followers" width="1000"/>


**GROUP BY:** 
```sql
-- Кількість підписників у кожного користувача

SELECT followingId, COUNT(*) AS total_followers
FROM userFollowers
GROUP BY followingId;
```

<img src="followingFoolowers.png" alt="Followers" width="1000"/>

**INNER JOIN:** 
```sql
-- Users + posts

SELECT email, nickname, postId, title, text
FROM users
JOIN posts ON users.userId = posts.userId
```

<img src="allUsers.png" alt="Users" width="1000"/>
<img src="allPosts.png" alt="Users" width="1000"/>
<img src="innerJoinUser+Post.png" alt="Users" width="1000"/>

**LEFT JOIN:** 
```sql
-- Users + posts (left join)

SELECT email, nickname, postId, title, text
FROM users
JOIN posts ON users.userId = posts.userId
```

<img src="allUsers.png" alt="Users" width="1000"/>
<img src="allPosts.png" alt="Users" width="1000"/>
<img src="leftJoin.png" alt="Users" width="1000"/>

**RIGHT JOIN:** 
```sql
-- Users + posts (right join)

SELECT email, nickname, postId, title, text
FROM posts
RIGHT JOIN users ON posts.userId = users.userId
```

<img src="allUsers.png" alt="Users" width="1000"/>
<img src="allPosts.png" alt="Users" width="1000"/>
<img src="leftJoin.png" alt="Users" width="1000"/>

**FULL JOIN:** 
```sql
-- Full join (user + likes)

SELECT users.userId, nickname, likes
FROM users
FULL JOIN likes ON users.userId = likes.userId;
```

<img src="allUsers.png" alt="Users" width="1000"/>
<img src="allPosts.png" alt="Users" width="1000"/>
<img src="fullJoin.png" alt="Users" width="1000"/>

**CROSS JOIN:** 
```sql
-- CROSS join (user + posts)

SELECT users.nickname, posts.text
FROM users
CROSS JOIN posts;

```

<img src="allUsers.png" alt="Users" width="1000"/>
<img src="allPosts.png" alt="Users" width="1000"/>
<img src="crossJoin.png" alt="Users" width="1000"/>

**Having:** 

```sql
-- Having

SELECT userId, COUNT(*) AS total_posts
FROM posts
GROUP BY userId
HAVING COUNT(*) > 1;
```
<img src="withoutHaving.png" alt="Users" width="1000"/>
<img src="withHaving.png" alt="Users" width="1000"/>


**Верезей Ілля ІМ - 42**

