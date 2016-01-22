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

conn.exec("DROP TABLE IF EXISTS users CASCADE")

conn.exec("CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email VARCHAR UNIQUE NOT NULL,
  password_digest VARCHAR(60) NOT NULL,
  name VARCHAR NOT NULL,
  avatar_url VARCHAR)
  ")

conn.exec("DROP TABLE IF EXISTS topics CASCADE")
conn.exec("CREATE TABLE topics (
  topics_id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users,
  topic_title VARCHAR (100) NOT NULL,
  topic_contents TEXT NOT NULL,
  topics_score INTEGER default 0,
  num_comments INTEGER default 0,
  team_tag VARCHAR (3)
)"
)

conn.exec("DROP TABLE IF EXISTS comments CASCADE")
conn.exec("CREATE TABLE comments(
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users,
  topic_id INTEGER REFERENCES topics,
  comments_score INTEGER default 0,
  comment_contents TEXT NOT NULL
    )"
)
conn.exec("DROP TABLE IF EXISTS sub_comments CASCADE")
conn.exec("
CREATE TABLE sub_comments(
  id SERIAL PRIMARY KEY,
  upvotes INTEGER,
  downvotes INTEGER,
  user_id INTEGER REFERENCES users,
  comment_id INTEGER REFERENCES comments,
  sub_comment_contents TEXT NOT NULL
  )"
)


