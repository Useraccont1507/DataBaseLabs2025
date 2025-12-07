-- Знайдемо число користувачів без аватарки


SELECT COUNT(*) AS UsersWithoutAvatar
FROM users
WHERE avatarImageUrl IS null;

-- Знайдемо сумму лайків 

SELECT userId, SUM(1) AS totalLikes
FROM likes
GROUP BY userId;


-- Середня кількість лайків на пост
SELECT AVG(like_count) AS avg_likes_per_post
FROM (
    SELECT postId, COUNT(*) AS like_count
    FROM likes
    GROUP BY postId
) AS counts;

-- Найраніший пост у базі
SELECT MIN(createdAt) AS first_post_date
FROM posts;

-- Кількість підписників у кожного користувача
SELECT followingId, COUNT(*) AS total_followers
FROM userFollowers
GROUP BY followingId;

-- Users + posts

SELECT email, nickname, postId, title, text
FROM users
JOIN posts ON users.userId = posts.userId

-- Users + posts (right join)

SELECT email, nickname, postId, title, text
FROM posts
RIGHT JOIN users ON posts.userId = users.userId

-- Full join (user + likes)

SELECT users.userId, nickname, likes
FROM users
FULL JOIN likes ON users.userId = likes.userId;

-- CROSS join (user + posts)

SELECT users.nickname, posts.text
FROM users
CROSS JOIN posts;

-- Having

SELECT userId, COUNT(*) AS total_posts
FROM posts
GROUP BY userId
HAVING COUNT(*) > 1;