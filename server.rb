require "sinatra/base"
require "pg"
require "bcrypt"


module Forum
  class Server < Sinatra::Base
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

     erb :comment


  end

    


end
  end