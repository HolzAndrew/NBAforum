

DROP TABLE IF EXISTS users CASCADE;

CREATE TABLE users(
  id SERIAL PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_digest VARCHAR(60),
  name VARCHAR(255) NOT NULL,
  avatar_url VARCHAR(255)
);

DROP TABLE IF EXISTS topics CASCADE;
CREATE TABLE topics (
  topics_id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users,
  topic_title VARCHAR (100) NOT NULL,
  topic_contents TEXT NOT NULL,
  topics_score INTEGER
);

DROP TABLE IF EXISTS comments CASCADE;
CREATE TABLE comments(
  comments_id SERIAL PRIMARY KEY,
  upvotes INTEGER,
  downvotes INTEGER,
  user_id INTEGER REFERENCES users,
  topic_id INTEGER REFERENCES topics,
  comment_contents TEXT NOT NULL,
  comments_score INTEGER

);
DROP TABLE IF EXISTS sub_comments CASCADE;
CREATE TABLE sub_comments(
  id SERIAL PRIMARY KEY,
  upvotes INTEGER,
  downvotes INTEGER,
  user_id INTEGER REFERENCES users,
  topic_id INTEGER REFERENCES topics,
  comment_id INTEGER REFERENCES comments,
  sub_comment_contents TEXT NOT NULL
);




