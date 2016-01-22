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

conn.exec("CREATE TABLE users(
  id SERIAL PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_digest VARCHAR(60) NOT NULL,
  name VARCHAR(255) NOT NULL,
  avatar_url VARCHAR(255),
  )"
)

conn.exec("DROP TABLE IF EXISTS topics CASCADE")
conn.exec("CREATE TABLE topics (
  topics_id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users,
  topic_title VARCHAR (100) NOT NULL,
  topic_contents TEXT NOT NULL,
  topics_score INTEGER,
  num_comments INTEGER default 0,
  team_tag VARCHAR (3)
)"
)

conn.exec("DROP TABLE IF EXISTS comments CASCADE")
conn.exec("CREATE TABLE comments(
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users,
  topic_id INTEGER REFERENCES topics,
  comments_score
  comment_contents TEXT NOT NULL,
    )"
)

conn.exec("
CREATE TABLE sub_comments(
  id SERIAL PRIMARY KEY,
  upvotes INTEGER,
  downvotes INTEGER,
  user_id INTEGER REFERENCES users,
  topic_id INTEGER REFERENCES topics,
  comment_id INTEGER REFERENCES comments,
  comment_contents TEXT NOT NULL
  )"
)


