<cfcomponent>


<cffunction name="show_project_list">
	<cfargument name="projects" type="query" required="true">
	<cfargument name="project_open" type="boolean" required="true">
	<cfargument name="view_project_id" type="numeric" required="true">
	
	<!--- pagination arguments --->
	<cfargument name="total_item_count" required="true" type="numeric" hint="total number of items(probably count variable from a get model function)">
	<cfargument name="items_per_page" required="true" type="numeric" hint="total items per page">
	<cfargument name="page_to_load" required="true" type="string"  hint="page to reload(probably the current controller)">
	<cfargument name="page" required="true" type="numeric"  hint="current_page(probably a url.page)">
	<cfargument name="url_var" required="true" type="string"  hint="variable to look at in the url(example: page, task_list_page, user_list_page etc)">
	<cfargument name="url" required="true" type="struct" default="#{}#"  hint="url global variable, used to preserve the url list">
	<cfargument name="anchor" required="false" default="" type="string" hint="Anchor to skip to(optional) defailts to empty string">
	<!--- end pagination arguments --->
	

	
	<cfoutput>
		<div id="content" class="home">
	
		
		<div id="projects" class="left list">
		<cfif arguments.project_open eq true>
			<cfset count=0>
		      <h2><a href="#arguments.page_to_load#?project_open=true">Open Projects</a></h2>
		      <h2 class="tab"><a href="#arguments.page_to_load#?project_open=false">Closed Projects</a><a class="add modal_link" href="project">&oplus;</a></h2>
		      <ul><!--- loop here --->
				<cfif arguments.view_project_id neq -1>
		        <cfloop query="arguments.projects">
					<cfif arguments.projects.date_completed eq "">
						<cfset count++>
						<cfset orginal_url = application._view_unique.preserve_url(arguments.url,false,"project_id",arguments.projects.projects_id)>
						<li<cfif projects_id eq arguments.view_project_id> class="current"</cfif>><a href="project.cfm?project_id=#arguments.projects.projects_id#">#arguments.projects.title#</a><a class="view_more" href="#arguments.page_to_load#?#orginal_url#">view tasks &rarr;</a></li>
		        	</cfif>
				</cfloop>
				</cfif>
		      </ul>
		      <cfset application._view_unique.show_pagination(#arguments.total_item_count#,#arguments.items_per_page#,#arguments.page_to_load#,#arguments.page#,#arguments.url_var#,#arguments.url#)>
		    </div>
		<cfelse>
		
		  <h2 class="tab"><a href="#arguments.page_to_load#?project_open=true">Open Projects</a></h2>
	      <h2><a href="#arguments.page_to_load#?project_open=false">Closed Projects</a><a class="add modal_link" href="project">&oplus;</a></h2>
		  <ul><!--- loop here --->
		  <cfset count=0>
		  <cfif arguments.view_project_id neq -1>
	        <cfloop query="arguments.projects">
				<cfif arguments.projects.date_completed neq "">
					<cfset count++>
					<cfset orginal_url = application._view_unique.preserve_url(arguments.url,false,"project_id",arguments.projects.projects_id)>
					<li<cfif projects_id eq arguments.view_project_id> class="current"</cfif>><a href="project.cfm?project_id=#arguments.projects.projects_id#">#arguments.projects.title#</a><a class="view_more" href="#arguments.page_to_load#?#orginal_url#">view tasks &rarr;</a></li>
	        	</cfif>
	        </cfloop>
		</cfif>
	      </ul>
	      <cfset application._view_unique.show_pagination(total_item_count,items_per_page,page_to_load,page,url_var,url)>
	   	  </div>
		</cfif>		
	</cfoutput>
</cffunction> <!--- end show_project_list --->



<cffunction name="show_notes_list" returntype="void" hint="shows the notes list">
 		<cfargument name="query" required="true" type="query">
		<cfargument name="list" required="true" type="string">
 		<cfargument name="total_item_count" required="true" type="numeric" hint="total number of items">
		<cfargument name="items_per_page" required="true" type="numeric" hint="total items per page">
		<cfargument name="page_to_load" required="true" type="string"  hint="page to reload">
		<cfargument name="page" required="true" type="numeric"  hint="current_page">
		<cfargument name="url" required="true" type="struct"  hint="url global">
		<cfif list eq "project">
			<cfoutput>
		        <div id="notes" class="left list">
		          <h2><a href="?notes_page=1&notes=project&project_id=#arguments.url.project_id#">Project Notes</a></h2>
		          <h2 class="tab"><a href="?notes_page=1&notes=task&project_id=#arguments.url.project_id#">Recent Task Notes</a><a class="add modal_link" href="note">&oplus;</a></h2>
		          <ul>
	          		<cfloop query="arguments.query">
		            <li>#content#</li>
					</cfloop>
		          </ul>
				  <cfset args = {}>
				<cfset args.total_item_count = arguments.total_item_count>
				<cfset args.items_per_page = arguments.items_per_page>
				<cfset args.page_to_load = arguments.page_to_load>
				<cfset args.page = arguments.page>
				<cfset args.url_var = "notes_page">
				<cfset args.url = arguments.url>
				
	          	<cfset application._view_unique.show_pagination(argumentCollection = args)>
		        </div>
			</cfoutput>
		<cfelse>
			<cfoutput>
		        <div id="notes" class="left list">
		          <h2 class="tab"><a href="?notes_page=1&notes=project&project_id=#arguments.url.project_id#">Project Notes</a></h2>
		          <h2><a href="?notes_page=1&notes=task&project_id=#arguments.url.project_id#">Recent Task Notes</a><a class="add modal_link" href="note">&oplus;</a></h2>
		          <ul>
	          		<cfloop query="arguments.query">
		            <li><a href="task.cfm?task_id=#task_id#">#content#</a></li>
					</cfloop>
		          </ul>
				
				<cfset args = {}>
				<cfset args.total_item_count = arguments.total_item_count>
				<cfset args.items_per_page = arguments.items_per_page>
				<cfset args.page_to_load = arguments.page_to_load>
				<cfset args.page = arguments.page>
				<cfset args.url_var = "notes_page">
				<cfset args.url = arguments.url>
				<cfset args.anchor = "notes">
				
	          	<cfset application._view_unique.show_pagination(argumentCollection = args)>
		        </div>
			</cfoutput>
		</cfif>
	</cffunction><!--- ends show_notes_list --->
	
	
	
	 <!--- this is suppose to show all the information pertaining to a specific project --->
 <!--- from projects status, title, description --->
 <!--- from projects to users members for project --->
 <cffunction name="show_project_details" returntype="void" >
 		<cfargument name="users" type="query" required="true"  >
		<cfargument name="project" type="query" required="true" >
		<cfargument name="project_id" required="true" type="numeric" default=-1>
		<cfargument name="current_user_id" type="numeric" required="true" >
		
		<div id="content" class="project">
		<p id="breadcrumbs"><a href="home.cfm">Home</a> &rarr; Project Page</p>
		<div class="information">
 		<cfoutput query="project">
		<cfset projects_id = #project_id#>
          <a class="right" href="delete_project.cfm?project_id=#project_id#">delete project</a>
          <a class="right" href="add_to_portfolio.cfm?user_id=#arguments.current_user_id#&project_id=#project_id#">add project to portfolio</a>
          <a class="right" href="rss.cfm?project_id=#project_id#">Subscribe to this project(RSS)</a>
		  <h2>#title#<a href="project.html" class="edit">edit</a></h2>
		  <form class="inline" method="post" name="mod_title" action="modify_project.cfm">
            <input type="text" name="title" value="#title#" />
			<input type="hidden" name="projects_id" value="#projects_id#">
            <input type="submit" name="submit" value="submit" />
          </form>
		  
          <p class="right">#description#</p>
		  <p class="right" style="margin-top:-10px;padding-top:0;"><a href="project.html" class="edit">edit description</a></p>
		  <form class="inline block" method="post" name="mod_description" action="modify_project.cfm">
            <textarea name="description">#description#</textarea>
			<input type="hidden" name="projects_id" value="#projects_id#">
            <input type="submit" name="submit" value="submit" />
          </form>
		  
		  <cfif tostring(#date_completed#) eq "null" or #date_completed# eq "">
		  	<cfset stat = "open">
		<cfelse> 
			<cfset stat = "closed">
		  </cfif>
          <p>Status: <span class="status open">#stat#</span><a href="project.html" class="edit">edit</a></p>
         
		  <form class="inline" method="post" name="mod_status" action="modify_project.cfm">
            <select name="status">
              <option>open</option>
              <option>closed</option>
            </select>
			<input type="hidden" name="projects_id" value="#projects_id#">
            <input type="submit" name="submit" value="submit" />
          </form>
		  
		  <p>Github Repository: #gh_repository_id#<a href="modify_project.cfm" class="edit">edit</a></p>
		  <form class="inline" method="post" name="mod_repo" action="modify_project.cfm">
            <input type="text" name="gh_repository_id" value="#gh_repository_id#" />
			<input type="hidden" name="projects_id" value="#projects_id#">
            <input type="submit" name="submit" value="submit" />
          </form>
          
		  <p>Project Manager: #user_name#<a href="modify_project.cfm" class="edit">edit</a></p>
          
 		</cfoutput>
		  <form class="inline" method="post" name="manager" action="modify_project.cfm">
            <select name="users_id">
		<cfoutput query="users">
              <option value="#users_id#">#user_name#</option>
		</cfoutput>
		<cfoutput >
			<input type="hidden" name="projects_id" value="#projects_id#">
            </select>
            <input type="submit" name="submit" value="submit" />
          </form>
        </div>
		</cfoutput>
 </cffunction> <!---end show_project_details--->


</cfcomponent>