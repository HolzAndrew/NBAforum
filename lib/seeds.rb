require 'pg'

if ENV["RACK_ENV"] == 'production'
  conn = PG.connect(
    dbname: ENV["POSTGRES_DB"],
    host: ENV["POSTGRES_HOST"],
    password: ENV["POSTGRES_PASS"],
    user: ENV["POSTGRES_USER"]
    )

else

conn = PG.connect(dbname: "nbaforum")
end
#DROP TABLE IF EXISTS users
conn.exec("CREATE TABLE users(
  id SERIAL PRIMARY KEY,
  email VARCHAR(255) UNIQIE NOT NULL,
  password_digest VARCHAR(60) NOT NULL,
  name VARCHAR(255) NOT NULL,
  avatar_url VARCHAR(255),
  topics_score INTEGER,
  comments_score INTEGER,

  )"
)

#DROP TABLE IF EXISTS topics
conn.exec("CREATE TABLE topics(
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users,
  topic_title VARCHAR (100) NOT NULL,
  topic_contents TEXT NOT NULL
)"
)

#DROP TABLE IF EXISTS comments
conn.exec("CREATE TABLE comments(
  id SERIAL PRIMARY KEY,
  upvotes INTEGER,
  downvotes INTEGER,
  user_id INTEGER REFERENCES users id,
  author VARCHAR REFERENCES users name,
  topic_id INTEGER REFERENCES topics,
  comment_contents TEXT NOT NULL
    )"
)

conn.exec("
CREATE TABLE sub_comments(
  id SERIAL PRIMARY KEY,
  upvotes INTEGER,
  downvotes INTEGER,
  user_id INTEGER REFERENCES users id,
  author VARCHAR REFERENCES users name,
  topic_id INTEGER REFERENCES topics,
  comment_contents TEXT NOT NULL
  )"
)


