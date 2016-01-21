require "sinatra/base"
require "pg"
require "bcrypt"


module Forum
  class Server < Sinatra::Base
    enable :sessions
    def current_user
      db = PG.connect(dbname: "nbaforum")
      if session["name"]
        @user ||= db.exec_params(<<-SQL, [ session["name"] ]).first
          SELECT * FROM users WHERE id = $1
        SQL
      else
        # THE USER IS NOT LOGGED IN
        {}
      end
    end
    conn = PG.connect(dbname: "nbaforum")

      get "/" do
        @topics = conn.exec_params("SELECT * from topics JOIN users on users.id = topics.user_id ")
        erb :index
      end

      get "/newtopic" do
        erb :newtopic
      end

      post '/newtopic' do
     
        name = params["name"]
        email = params["email"]
        title = params["title"]
        topic = params["topic"]

      #if ENV["RACK_ENV"] == 'production'
       # conn = PG.connect(
        #dbname: ENV["POSTGRES_DB"],
        #host: ENV["POSTGRES_HOST"],
        #password: ENV["POSTGRES_PASS"],
        #user: ENV["POSTGRES_USER"]
        #)
      #else

        conn = PG.connect(dbname: "nbaforum")
      #end  
        userhash = conn.exec_params(
        "INSERT INTO users (name, email) VALUES ($1, $2) returning *",
          [name, email]
        )
        conn.exec_params(
        "INSERT INTO topics (topic_title, topic_contents, user_id ) VALUES ($1, $2, $3)",
          [title, topic, userhash.first["id"]]
        )
        @topic_submitted = true

        erb :newtopic
      end

      get "/topic/:id" do
        @id = params[:id]
        conn = PG.connect(dbname: "nbaforum")
        @topic = conn.exec_params("SELECT * from topics WHERE topics_id = #{params['id'].to_i}").first
        @author = conn.exec_params("SELECT name FROM users JOIN topics on users.id = topics.user_id WHERE topics.topics_id = #{params['id'].to_i}").first
        @comments = conn.exec_params("SELECT comment_contents from comments JOIN topics on comments.topic_id = topics_id WHERE topics.topics_id = #{params['id'].to_i}")
        erb :topic
      end

      get "/topics" do
        @topics = conn.exec_params("SELECT * from topics JOIN users on users.id = topics.user_id ")
        erb :topics
      end

      get "/login" do
        erb :login
      end

      get "/topic/:id/comment" do
        @id = params[:id]
        erb :comment
      end

      post "/topic/:id/comment" do
        @id = params[:id]
        name = params["name"]
        email = params["email"]
        comment = params["comment"]

        #if ENV["RACK_ENV"] == 'production'
       # conn = PG.connect(
        #dbname: ENV["POSTGRES_DB"],
        #host: ENV["POSTGRES_HOST"],
        #password: ENV["POSTGRES_PASS"],
        #user: ENV["POSTGRES_USER"]
        #)
        #else

        conn = PG.connect(dbname: "nbaforum")
        #end  
        userhash = conn.exec_params(
          "INSERT INTO users (name, email) VALUES ($1, $2) returning *",
          [name, email]
        )
        conn.exec_params(
          "INSERT INTO comments (comment_contents, user_id, topic_id ) VALUES ($1, $2, $3)",
          [comment, userhash.first["id"], @id]
        )
        @comment_submitted = true
        @vote = conn.exec_params("SELECT upvotes, downvotes from comments")
        erb :comment
      end

      get "/signup" do
        erb :signup
      end

      post "/signup" do
        conn = PG.connect(dbname: "nbaforum")
        password_digest = BCrypt::Password.create(params["password"])
        new_user = conn.exec_params(<<-SQL, [params["name"], params["email"], password_digest, params["avatar"]])
          INSERT INTO users (name, email, password_digest, avatar_url)
          VALUES ($1, $2, $3, $4) RETURNING id;
          SQL
        session["user_id"] = new_user.first["id"].to_i
        erb :signupsuccess
      end


      get "/signupsuccess" do
        erb :signupsuccess
      end

      get "/login" do
        erb :login
      end

      post "/login" do
        conn = PG.connect(dbname: "nbaforum")
        password_input = (params[:password])
        login_user = conn.exec_params("SELECT * FROM users WHERE email = $1", [params[:email]]).first
      if BCrypt::Password.new(login_user["password_digest"]) == password_input 
        @topics = conn.exec_params("SELECT * from topics JOIN users on users.id = topics.user_id ")
        erb :index
      else
        erb :loginfail

      end
    end
  end
end