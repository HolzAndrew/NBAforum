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