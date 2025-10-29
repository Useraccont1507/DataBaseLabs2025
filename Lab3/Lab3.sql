-- INSERT

INSERT INTO users (email, password, nickname, avatarImageUrl)
VALUES 
('andry@example.com', 'pass123', 'Andry', 'https://example.com/avatar1.png'),
('kate@example.com', 'pass12346', 'Kate', 'https://example.com/avatar1.png'),
('illia@example.com', 'pass456', 'Illia', 'https://example.com/avatar2.png');

-- Follow members

INSERT INTO userFollowers (followerI d, followingId) 
VALUES
(1, 2),
(2, 1),
(3, 1);

-- Create posts

INSERT INTO posts (title, text, imageUrl, userId)
VALUES 
('First Andry post', 'Hello world', 'https://example.com/avatar1.png', 1),
('Illia joined', 'Hello world', 'https://example.com/avatar1.png', 3),
('Second Andry post', 'Hello world', 'https://example.com/avatar1.png', 1),
('Kate post', 'Test Content', 'https://example.com/avatar2.png', 2);

-- Create new tag

INSERT INTO tags (text)
VALUES
('TESTTAG');

-- Use tag for post

INSERT INTO postTags (postId, tagId)
VALUES 
(1, 1);

-- Like posts

INSERT INTO likes (postId, userId)
VALUES 
(1, 2),
(4, 3);

-- Make comments for posts

INSERT INTO comments (text, postId, userId)
VALUES 
('Test comment', 1, 2),
('Test comment2', 2, 3);


-- SELECT

SELECT email, userId FROM users
SELECT * FROM public.posts WHERE userId = 1
SELECT userId, COUNT(postId) AS post_count
FROM posts
GROUP BY userId;
SELECT p.postId, p.title
FROM posts p
JOIN postTags pt ON p.postId = pt.postId
JOIN tags t ON pt.tagId = t.tagId
WHERE t.text = 'TESTTAG';
SELECT u.nickname
FROM users u
JOIN userFollowers uf ON u.userId = uf.followerId
WHERE uf.followingId = 1;

-- UPDATE
UPDATE users
SET password = 'newPass'
WHERE userId = 1;
UPDATE posts
SET text = 'NEw Text'
WHERE postId = 1;
UPDATE comments
SET text = 'New Comment'
WHERE commentId = 1;

-- DELETE 
DELETE FROM users
WHERE userId = 3;
DELETE FROM likes
WHERE likeId = 1;
DELETE FROM comments
WHERE commentId = 2;
DELETE FROM postTags
WHERE postId = 1 AND tagId = 1;