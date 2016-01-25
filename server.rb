require "sinatra/base"
require "pg"
require "bcrypt"


module Forum
  class Server < Sinatra::Base
    enable :sessions

    if ENV["RACK_ENV"] == 'production'
        @@conn ||= PG.connect(
        dbname: ENV["POSTGRES_DB"],
        host: ENV["POSTGRES_HOST"],
        password: ENV["POSTGRES_PASS"],
        user: ENV["POSTGRES_USER"]
        )
    else
      @@conn ||= PG.connect(dbname: "nbaforum")
    end  

    def current_user
      # db = PG.connect(dbname: "nbaforum")
      if session["user_id"]
        @user ||= @@conn.exec_params(<<-SQL, [ session["user_id"] ]).first
          SELECT * FROM users WHERE id = $1
        SQL
      else
        # THE USER IS NOT LOGGED IN
        {}
      end
    end

      get "/" do
        @user = current_user
        #@topics = @@conn.exec_params("SELECT * from topics JOIN users on users.id = topics.user_id ORDER BY topics_score DESC")
        erb :welcome
      end

      get "/home" do
        @user = current_user
        @topics = @@conn.exec_params("SELECT * from topics JOIN users on users.id = topics.user_id ORDER BY topics_score DESC")
        erb :index
      end

      get "/newtopic" do
        @user = current_user
        erb :newtopic
      end

      post '/newtopic' do
        @user = current_user
        name = params["name"]
        email = params["email"]
        title = params["title"]
        #topic = params["topic"]


        markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
        topic = markdown.render(params["topic"])
        #userhash = @@conn.exec_params(
        #{}"INSERT INTO users (name, email) VALUES ($1, $2) returning *",
          #[name, email]
        #)
        @@conn.exec_params(
        "INSERT INTO topics (topic_title, topic_contents, user_id ) VALUES ($1, $2, $3)",
          [title, topic, @user["id"]]
        )
        @topic_submitted = true

        erb :newtopic
      end

      get "/topic/:id" do
        @user = current_user
        @id = params[:id]
        # conn = PG.connect(dbname: "nbaforum")
        @topic = @@conn.exec_params("SELECT * from topics WHERE topics_id = #{params['id'].to_i}").first
        @author = @@conn.exec_params("SELECT name FROM users JOIN topics on users.id = topics.user_id WHERE topics.topics_id = #{params['id'].to_i}").first
        @comments = @@conn.exec_params("SELECT comment_contents from comments JOIN topics on comments.topic_id = topics_id WHERE topics.topics_id = #{params['id'].to_i}")
        @comment_totals = @@conn.exec_params("SELECT COUNT(*) FROM comments where topic_id = #{params['id'].to_i}").first
        #@comment_author = @@conn.exec_params("SELECT name FROM users JOIN comments on users.id = comments.user_id WHERE comments.topic_id = #{params['id'].to_i}")
      
        erb :topic
      end

      get "/topics" do
        @user = current_user
        @topics = @@conn.exec_params("SELECT * from topics JOIN users on users.id = topics.user_id ")
        erb :topics
      end
      get "/topic/:id/comment" do
        @user = current_user
        @id = params[:id]
        @topics = @@conn.exec_params("SELECT * from topics JOIN users on users.id = topics.user_id ")
        erb :comment
      end

      post "/topic/:id/comment" do
        @user = current_user
        @topics = @@conn.exec_params("SELECT * from topics JOIN users on users.id = topics.user_id ")
        @id = params[:id]
        #comment = params["comment"]

        # if ENV["RACK_ENV"] == 'production'
        #   conn = PG.connect(
        # dbname: ENV["POSTGRES_DB"],
        # host: ENV["POSTGRES_HOST"],
        # password: ENV["POSTGRES_PASS"],
        # user: ENV["POSTGRES_USER"]
        # )
        # else


        # conn = PG.connect(dbname: "nbaforum")
        # end
        markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
        comment = markdown.render(params["comment"])
        #end  
        #userhash = @@conn.exec_params(
        #  "INSERT INTO users (name, email) VALUES ($1, $2) returning *",
        #  [name, email]
        #)
        
        @@conn.exec_params(
          "INSERT INTO comments (comment_contents, user_id, topic_id ) VALUES ($1, $2, $3)",
          [comment, @user['id'], @id]
        )
        #binding.pry
        @@conn.exec_params(
          "update topics SET num_comments = num_comments + 1 WHERE topics_id = (#{@id})"
          )
        @comment_submitted = true
        #@vote = @@conn.exec_params("SELECT upvotes, downvotes from comments")
        
        erb :topics
      end

      get "/signup" do
        erb :signup
      end

      post "/signup" do
        # if ENV["RACK_ENV"] == 'production'
        #   conn = PG.connect(
        # dbname: ENV["POSTGRES_DB"],
        # host: ENV["POSTGRES_HOST"],
        # password: ENV["POSTGRES_PASS"],
        # user: ENV["POSTGRES_USER"]
        # )
        # else
        # conn = PG.connect(dbname: "nbaforum")
        # end
        password_digest = BCrypt::Password.create(params["password"])
        new_user = @@conn.exec_params(<<-SQL, [params["name"], params["email"], password_digest, params["avatar"]])
          INSERT INTO users (name, email, password_digest, avatar_url)
          VALUES ($1, $2, $3, $4) RETURNING id;
          SQL
        session["user_id"] = new_user.first["id"].to_i
        erb :signupsuccess
      end


      get "/signupsuccess" do
        @user = current_user
        erb :signupsuccess
      end

      get "/login" do
        erb :login
      end

      post "/login" do
        # conn = PG.connect(dbname: "nbaforum")
        password_input = (params[:password])
        login_user = @@conn.exec_params("SELECT * FROM users WHERE email = $1", [params[:email]]).first
        
        if login_user
          if BCrypt::Password.new(login_user["password_digest"]) == password_input 
             session["user_id"] = login_user["id"].to_i
            @topics = @@conn.exec_params("SELECT * from topics JOIN users on users.id = topics.user_id ")
            erb :index
          else
            erb :loginfail

          end
        end
      end

      get "/topic_upvote/:id" do
      @user = current_user
      @id = params[:id]
      # conn = PG.connect(dbname: "nbaforum")
      @@conn.exec_params(
          "update topics SET topics_score = topics_score + 1 WHERE topics_id = (#{@id})"
          )
      redirect back
      end

      get "/topic_downvote/:id" do
      @user = current_user
      @id = params[:id]
      # conn = PG.connect(dbname: "nbaforum")
      @@conn.exec_params(
          "update topics SET topics_score = topics_score - 1 WHERE topics_id = (#{@id})"
          )
      redirect back
      end

      get "/logout" do
         @user = current_user
         session.clear
         redirect "/"
       end

    end
  end


