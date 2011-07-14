<cfcomponent>


<cffunction name="show_page_setup" returntype="void">
	<cfoutput>
		<!DOCTYPE html>
		<html>
		  <head>
		    <meta http-equiv="Content-type" content="text/html; charset=utf-8">
		    <meta name="description" content="" />
		    <meta name="keywords" content="" />
		    <meta name="author" content="Zachary Nicoll" />
		    <title>maistre</title>
		    <link rel="shortcut icon" type="image/ico" href="" />
		    <link rel="stylesheet" href="css/style.css" type="text/css">
		    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js" ></script>
		    <script src="js/jquery.md5.js" type="text/javascript"></script>
		    <script src="js/site.js" type="text/javascript"></script>
		  </head>
		  <body>
		    <div id="wrapper">
	</cfoutput>
</cffunction> <!---end show_page_setup--->



<cffunction name="show_page_footer" returntype="void">
<cfoutput>
	</div>
    <div id="darknessification"></div>
  </body>
</html>
</cfoutput>
</cffunction><!--- show_page_footer --->




<cffunction name="show_header" returntype="void">
	<cfargument name="is_logged_in" type="boolean" required="true">
	<cfargument name="username" type="string" required="true">
	<cfargument name="user_id" type="numeric" required="false" default="0">
	
	<cfoutput>
	<cfif arguments.is_logged_in neq true>
		<div id="header">
        <h1><a href="index.cfm">Maistre</a></h1>
        <form method="post" action="index.cfm">
          <label for="username">username</label>
          <label for="password">password</label>
          <input type="text" name="username" value="" />
          <input type="password" name="password" value="" />
          <input type="submit" name="login_submit" value="Login" />
        </form>
      </div>
	<cfelse>
		<div id="header">
        <h1><a href="home.cfm">Maistre</a></h1>
        <div id="nav">
          <h3>Welcome, #arguments.username#!</h3>
          <ul>
            <li><a href="logout.cfm">logout</a>|</li>
            <li><a class="modal_link" href="profile">edit profile</a>|</li>
            <li><a href="portfolio.cfm?user_id=#arguments.user_id#">view portfolio</a></li><!--- needs user id --->
          </ul>
        </div>
      </div>
	 

	</cfif>
	</cfoutput>
</cffunction> <!---end show_header--->




<cffunction name="show_portfolio_list">
<cfargument name="projects" type="query" required="true">
<cfargument name="portfolio_user_id" type="numeric" required="true">

<!--- pagination arguments --->
<cfargument name="total_item_count" required="true" type="numeric" hint="total number of items(probably count variable from a get model function)">
<cfargument name="items_per_page" required="true" type="numeric" hint="total items per page">
<cfargument name="page_to_load" required="true" type="string"  hint="page to reload(probably the current controller)">
<cfargument name="page" required="true" type="numeric"  hint="current_page(probably a url.page)">
<cfargument name="url_var" required="true" type="string"  hint="variable to look at in the url(example: page, task_list_page, user_list_page etc)">
<cfargument name="url" required="true" type="struct"  hint="url global variable, used to preserve the url list">
<cfargument name="anchor" required="false" default="" type="string" hint="Anchor to skip to(optional) defailts to empty string">
<!--- end pagination arguments --->
<cfif arguments.portfolio_user_id neq 0>
	<cfoutput>
		<div id="projects" class="list">
		<cfset get_user=application._model_user.get_users(5,1,-2,arguments.portfolio_user_id)>
          <h2>#get_user.query.user_name#'s Completed Projects</h2>
          <ul><!--- loop here --->
		  
			<cfloop query="arguments.projects">
			<cfset file_test = reFind(".[Jj][Pp][Gg]",#image_url#) + reFind(".[Gg][Ii][Ff]",#image_url#) + reFind("[Pp][Nn][Gg]",#image_url#) + reFind("[Bb][Ii][Tt]",#image_url#) >
				
				<cfif #image_url# CONTAINS 'http://'>
				  	<cfset file_test = 5>
				</cfif>
				
				<cfif arguments.projects.date_completed neq "" or !isNull(arguments.projects.date_completed)>
				  
				  	<li>
		              <img src="<cfif #image_url# CONTAINS 'http://'><cfelse>images_members/</cfif><cfif image_url eq '' or file_test eq 0>default_image.png " alt="default maistre image"<cfelse>#image_url#" alt="image of project"</cfif> width="65" height="65" />
		              <div class="portfolio_content">
		                <p class="title">#arguments.projects.title#</p>
		                <p class="right">#arguments.projects.date_completed#</p>
		                <p class="content">#arguments.projects.description#</p>
		              </div>
		              <p>Other project members:</p>
					  <cfset users=application._model_user.get_users(5,1,arguments.projects.projects_id)>
		              <ul>
		                <li>
		                <cfloop query="users.query">
							<cfif users.query.users_id neq #arguments.portfolio_user_id#>
		                		<a href="portfolio.cfm?user_id=#users.query.users_id#">#users.query.user_name#</a>,
							</cfif>
						</cfloop>
						</li>
		              </ul>
		              <a class="remove" href="delete_from_portfolio.cfm?user_id=#arguments.url.user_id#&project_id=#arguments.projects.projects_id#">remove from portfolio</a>
		            </li>
				</cfif>
			</cfloop>
            
          </ul>
         <cfset application._view_unique.show_pagination(#arguments.total_item_count#,#arguments.items_per_page#,#arguments.page_to_load#,#arguments.page#,#arguments.url_var#,#arguments.url#)>
        </div>
	</cfoutput>
</cfif>
</cffunction> <!--- end show_portfolio_list --->




<cffunction name="show_user_portfolio_list">
	<cfargument name="search" type="query" required="true">
	
	<!--- pagination arguments --->
	<cfargument name="total_item_count" required="true" type="numeric" hint="total number of items(probably count variable from a get model function)">
	<cfargument name="items_per_page" required="true" type="numeric" hint="total items per page">
	<cfargument name="page_to_load" required="true" type="string"  hint="page to reload(probably the current controller)">
	<cfargument name="page" required="true" type="numeric"  hint="current_page(probably a url.page)">
	<cfargument name="url_var" required="true" type="string"  hint="variable to look at in the url(example: page, task_list_page, user_list_page etc)">
	<cfargument name="url" required="true" type="struct"  hint="url global variable, used to preserve the url list">
	<cfargument name="anchor" required="false" default="" type="string" hint="Anchor to skip to(optional) defailts to empty string">
	<!--- end pagination arguments --->
	
	<cfoutput>
		<div id="projects" class="list search">
          <h2>Search Results</h2>
          <ul>
		  <cfif arguments.search.user_name neq "">
			  <cfloop query="arguments.search">
				<li><a href="portfolio.cfm?user_id=#arguments.search.users_id#">#arguments.search.user_name#</a></li>
		      </cfloop>
		  <cfelse>
		  	  <li>No results found</li>
		  </cfif>
          </ul>
         <cfset application._view_unique.show_pagination(#arguments.total_item_count#,#arguments.items_per_page#,#arguments.page_to_load#,#arguments.page#,#arguments.url_var#,#arguments.url#)>
        </div>
	</cfoutput>
</cffunction> <!--- end show_user_portfolio_list --->




<cffunction name="show_portfolio_top" >
<cfargument name="get_user" type="query" required="true">
	<cfoutput>
    	<div id="content" class="portfolio">
	        <form method="post" action="portfolio.cfm">
	          <label>search users</label>
	          <input type="text" name="user_name" value="" />
	          <input type="submit" name="portfolio_submit" value="Search" />
	        </form>
			<cfif get_user.users_id neq "">
		        <div class="information">
		          <cfset file_test = reFind(".[Jj][Pp][Gg]",#arguments.get_user.image_url#) + reFind(".[Gg][Ii][Ff]",#arguments.get_user.image_url#) + reFind("[Pp][Nn][Gg]",#arguments.get_user.image_url#) >
		          <img src="images_members/<cfif arguments.get_user.image_url eq "" or file_test eq 0>default_image.png " alt="default maistre image"<cfelse>#arguments.get_user.image_url#"alt="image of #arguments.get_user.user_name#"</cfif> width="50" height="50" />
		          <h2>#arguments.get_user.user_name#'s Portfolio</h2>
		          <p>#arguments.get_user.description#</p>
				  <p><a href="portfolio_pdf.cfm?user_id=#URL.user_id#">PDF download</a></p>
		        </div>
			</cfif>
    </cfoutput>
</cffunction><!--- end show_portfolio_top --->




<cffunction name="show_benefits" returntype="void" hint="shows the benefits for signing up">
		<cfoutput>
	        <div id="benefits" class="left">
	          <h2>Why are people using <span class="logo">maistre</span> for their project management?</h2>
	          <ul>
	            <li>Manage your team easily from any where in the world with only an internet conection.</li>
	            <li>Able to assign tasks / jobs to each member of your team.</li>
	            <li>Projects can be handed off to different managers as the project enters different phases.</li>
	            <li>Direct connection to GitHub giving you access to all your committed file comments.</li>
	          </ul>
	        </div>
		</cfoutput>
	</cffunction><!--- ends show_benefits --->


</cfcomponent>