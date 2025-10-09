CREATE EXTENSION IF NOT EXISTS citext;

CREATE TABLE users (
    userId SERIAL PRIMARY KEY,
    email CITEXT NOT NULL,
    CONSTRAINT email_format CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    password VARCHAR NOT NULL,
    nickname VARCHAR(16) NOT NULL,
    avatarImageUrl VARCHAR,
    createdAt TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

INSERT INTO users (email, password, nickname, avatarImageUrl)
VALUES 
('olena@example.com', 'pass123', 'Olena', 'https://example.com/avatar1.png'),
('ivan@example.com', 'pass456', 'Ivan', 'https://example.com/avatar2.png');

CREATE TABLE userFollowers (
    id SERIAL PRIMARY KEY,
    followerId INT NOT NULL,
    followingId INT NOT NULL,
    FOREIGN KEY (followerId) REFERENCES users(userId) ON DELETE CASCADE,
    FOREIGN KEY (followingId) REFERENCES users(userId) ON DELETE CASCADE,
    UNIQUE (followerId, followingId),
    CONSTRAINT no_self_follow CHECK (followerId <> followingId)
);

INSERT INTO userFollowers (followerId, followingId) 
VALUES
(1, 2);

CREATE TABLE posts (
    postId SERIAL PRIMARY KEY,
    userId INT NOT NULL,
    title VARCHAR NOT NULL,
    text TEXT,
    imageUrl VARCHAR,
    createdAt TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    FOREIGN KEY (userId) REFERENCES users(userId) ON DELETE CASCADE
);

INSERT INTO posts (title, text, imageUrl, userId)
VALUES 
('Test post title', 'content test', 'https://example.com/avatar1.png', 1),
('Another post', 'second post content', 'https://example.com/avatar2.png', 2);

CREATE TABLE likes (
    likeId SERIAL PRIMARY KEY,
    postId INT NOT NULL,
    userId INT NOT NULL,
    createdAt TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    FOREIGN KEY (postId) REFERENCES posts(postId) ON DELETE CASCADE,
    FOREIGN KEY (userId) REFERENCES users(userId) ON DELETE CASCADE,
    UNIQUE (userId, postId)
);

INSERT INTO likes (postId, userId)
VALUES 
(1, 1),
(2, 2);

CREATE TABLE comments (
    commentId SERIAL PRIMARY KEY,
    text TEXT NOT NULL,
    createdAt TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    postId INT NOT NULL,
    userId INT NOT NULL,
    parentCommentId INT NULL,
    FOREIGN KEY (postId) REFERENCES posts(postId) ON DELETE CASCADE,
    FOREIGN KEY (userId) REFERENCES users(userId) ON DELETE CASCADE,
    FOREIGN KEY (parentCommentId) REFERENCES comments(commentId) ON DELETE CASCADE
);

INSERT INTO comments (text, postId, userId)
VALUES 
('Test comment', 1, 1),
('Test comment2', 2, 2);

CREATE TABLE tags (
    tagId SERIAL PRIMARY KEY,
    text VARCHAR(16) NOT NULL UNIQUE
);

INSERT INTO tags (text)
VALUES
('TESTTAG');

CREATE TABLE postTags (
    postId INT NOT NULL,
    tagId INT NOT NULL,
    FOREIGN KEY (postId) REFERENCES posts(postId) ON DELETE CASCADE,
    FOREIGN KEY (tagId) REFERENCES tags(tagId) ON DELETE CASCADE
);

INSERT INTO postTags (postId, tagId)
VALUES 
(1, 1);

