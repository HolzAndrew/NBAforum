each comment will have a link
  render the page using PG to pull the info for the comment and pull different aspects into individual divs

###
TO DELETE
<form method="post" action="/superheroes"/ <%=hero["id"]%>
  <input type="hidden" name="_method" value="DELETE">  
  <input type="submit" value="DELETE THIS PERSON">
</form>


inside class:
  set :method_override, true #need this for method_override 
END TO DELETE
## 


heroku git:remote -a [project_name]

<li<a class="btn btn-lg btn-success" href="#" role="presentation">Sign up today</a></li>


  <div class="dropdown">
          <button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
            Teams
            <span class="caret"></span>
          </button>
          <ul class="dropdown-menu" aria-labelledby="dropdownMenu1">
            <li><a href="#">Atlanta Hawks</a></li>
            <li><a href="#">Boston Celtics</a></li>
            <li><a href="#">Brooklyn Nets</a></li>
            <li role="separator" class="divider"></li>
            <li><a href="#">Charlotte Hornets</a></li>
            <li><a href="#">Chicago Bulls</a></li>
            <li><a href="#">Cleveland Cavaliers</a></li>
            <li><a href="#">Dallas Mavericks</a></li>
            <li><a href="#">Denver Nuggets</a></li>
            <li><a href="#">Detroit Pistons</a></li>
            <li><a href="#">Golden State Warriors</a></li>
            <li><a href="#">Houston Rockets</a></li>
            <li><a href="#">Indiana Pacers</a></li>
            <li><a href="#">L.A. Clippers</a></li>
            <li><a href="#">L.A. Lakers</a></li>
            <li><a href="#">Memphis Grizzlies</a></li>
            <li><a href="#">Miami Heat</a></li>
            <li><a href="#">Milwaukee Bucks</a></li>
            <li><a href="#">Minnesota Timberwolves</a></li>
            <li><a href="#">New Orleans Pelicans</a></li>
            <li><a href="#">New York Knicks</a></li>
            <li><a href="#">Oklahoma City Thunder</a></li>
            <li><a href="#">Orlando Magic</a></li>
            <li><a href="#">Philadelphia 76ers</a></li>
            <li><a href="#">Phoenix Suns</a></li>
            <li><a href="#">Portland Trailblazers</a></li>
            <li><a href="#">Sacramento Kings</a></li>
            <li><a href="#">San Antonio Spurs</a></li>
            <li><a href="#">Toronto Raptors</a></li>
            <li><a href="#">Utah Jazz</a></li>
            <li><a href="#">Washington Wizards</a></li>

         </ul>
        </div>



         "INSERT INTO users (name, email, password_digest, avatar_url) VAULES ($1, $2, $3, $4)" RETURNING ID,
            [name, email, password, ]



###old new topic form


  <% if @topic_submitted %>
  <div class="jumbotron">
        <h1>THANK YOU!</h1>

  <% else %>
  <div class="jumbotron">
        <h1>Post new topic</h1>
  <form class = "new_post" action="/newtopic" method="post">
    <div class = "input-row">
    <label for="name">Your name: </label>
    <input name="name" type="text" value="<%= @user['name'] %>"/>    
    </div>
    <div class = "input-row">
    <label for="email">Email Address: </label>
    <input name="email" type="text" value="<%= @user['email'] %>"/>
    </div>
    <div class = "input-row">
    <label for="title">Title: (100 character limit) </label>
    <input name="title" type="text" />
    </div>
    <div class = "input-row">
    <label for="topic">Topic: </label>
    <textarea name="topic"></textarea>
    </div>
    <div class = "input-row">
    <input type="submit" value="Sumbit!" />
    </div>
  </form>
  <% end %>
</div>

__________________________________________________________

for logout
  if they click logout
  session.clear

  ____________________________________