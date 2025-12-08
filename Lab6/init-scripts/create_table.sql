

CREATE TABLE users (
    userId SERIAL PRIMARY KEY,
    email TEXT NOT NULL,
    CONSTRAINT email_format CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    password VARCHAR NOT NULL,
    nickname VARCHAR(16) NOT NULL,
    avatarImageUrl VARCHAR,
    createdAt TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE users
ADD CONSTRAINT uq_users_email UNIQUE (email);


CREATE TABLE userFollowers (
    id SERIAL PRIMARY KEY,
    followerId INT NOT NULL,
    followingId INT NOT NULL,
    FOREIGN KEY (followerId) REFERENCES users(userId) ON DELETE CASCADE,
    FOREIGN KEY (followingId) REFERENCES users(userId) ON DELETE CASCADE,
    UNIQUE (followerId, followingId),
    CONSTRAINT no_self_follow CHECK (followerId <> followingId)
);


CREATE TABLE posts (
    postId SERIAL PRIMARY KEY,
    userId INT NOT NULL,
    title VARCHAR NOT NULL,
    text TEXT,
    imageUrl VARCHAR,
    createdAt TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    FOREIGN KEY (userId) REFERENCES users(userId) ON DELETE CASCADE
);


CREATE TABLE likes (
    likeId SERIAL PRIMARY KEY,
    postId INT NOT NULL,
    userId INT NOT NULL,
    createdAt TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    FOREIGN KEY (postId) REFERENCES posts(postId) ON DELETE CASCADE,
    FOREIGN KEY (userId) REFERENCES users(userId) ON DELETE CASCADE,
    UNIQUE (userId, postId)
);


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


CREATE TABLE tags (
    tagId SERIAL PRIMARY KEY,
    text VARCHAR(16) NOT NULL UNIQUE
);


CREATE TABLE postTags (
    postId INT NOT NULL,
    tagId INT NOT NULL,
    FOREIGN KEY (postId) REFERENCES posts(postId) ON DELETE CASCADE,
    FOREIGN KEY (tagId) REFERENCES tags(tagId) ON DELETE CASCADE
);

ALTER TABLE postTags
ADD CONSTRAINT pk_post_tags PRIMARY KEY (postId, tagId);

