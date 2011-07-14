<cfcomponent>


<cffunction name="show_task_list" >
		<cfargument name="total_task_count" required="true" type="numeric" hint="total number of items(probably count variable from a get model function)">
		<cfargument name="tasks_per_page" required="true" type="numeric" hint="total items per page">
		<cfargument name="page_to_load" required="true" type="string"  hint="page to reload(probably the current controller)">
		<cfargument name="page" required="true" type="numeric"  hint="current_page(probably a url.page)">
		<cfargument name="task_query" required="true" type="query" >
		<cfargument name="pagination_url_var" required="true" type="string"  hint="variable to look at in the url(example: page, task_list_page, user_list_page etc)">
		<cfargument name="url" required="true" type="struct"  hint="url global variable, used to preserve the url list">
		
		<cfargument name="open_state" required="false" default="true" type="string" hint="changes card stack state">
		<cfargument name="state_var" required="false" default="task_open_state" type="string" hint="url var that holds the open_state boolean">
		<cfargument name="anchor" required="false" default="" type="string" hint="Anchor to skip to(optional) defailts to empty string">
		
		
		<!---task status'
		suggestion -1
		new - 2
		in_progress -3 
		invalid - 4
		completed -5--->
		<cfset orginal_url = application._view_unique.preserve_url(arguments.url,true,arguments.pagination_url_var,1,state_var)>
				
		<cfoutput>
			
			<cfset query1 = arguments.task_query>
			<cfset query2 = arguments.task_query>
			<cfset temp_user_list = []>
		
			<div id="tasks" class="right list">
				
	          <h2 <cfif arguments.open_state eq false>class="tab"</cfif>><a href="#page_to_load#?#orginal_url##state_var#=true">Open Tasks</a></h2>
	          <h2 <cfif arguments.open_state eq true>class="tab"</cfif>><a href="#page_to_load#?#orginal_url##state_var#=false">Closed Tasks</a><a class="add modal_link" href="task">&oplus;</a></h2>
	
	          <ul> <!--- current tasks --->
			  <cfif arguments.url.project_id neq -1>
			
		          	<cfloop query="query1">
						<cfif  !arraycontains(temp_user_list, query1.user_id)>
						
							<li class="author">&##9733; #query1.user_name#</li>
							<cfset arrayAppend(temp_user_list,#query1.user_id#)>
							
							<cfset u_id = #user_id#>
							<cfloop query="query2" >
								<cfif query2.user_id eq u_id>
									
									<li><a href="task.cfm?task_id=#tasks_id#&project_id=#project_id#">#query2.title#</a></li>
								</cfif>
							</cfloop>
						</cfif>
					</cfloop>
				</cfif>
	          </ul>
			  
	          <cfset application._view_unique.show_pagination(total_task_count,tasks_per_page,page_to_load,page,pagination_url_var,arguments.url,anchor)>
	        
			</div>
		</cfoutput>
	</cffunction> <!---end show_task_list--->
	
	
	
	<cffunction name="show_commit_list" returntype="void" hint="returns html for commit_list">
		<cfargument name="commits_per_page" required="true" type="numeric" hint="total items per page">
		<cfargument name="page_to_load" required="true" type="string"  hint="page to reload(probably the current controller)">
		<cfargument name="page" required="true" type="numeric"  hint="current_page(probably a url.page)">
		<cfargument name="commit_note_query" required="true" type="query" >
		<cfargument name="gh_commit_array" required="true" type="array" hint="array returned from the github_model.get_commits()">
		<cfargument name="pagination_url_var" required="true" type="string"  hint="variable to look at in the url(example: page, task_list_page, user_list_page etc)">
		<cfargument name="task_id" required="true" type="numeric">
		<cfargument name="user_id" required="true" type="numeric">
		<cfargument name="project_id" required="true" type="numeric">
		<cfargument name="url" required="true" type="struct"  hint="url global variable, used to preserve the url list">
		
		<cfset gh_array_length = arraylen(gh_commit_array)>
		<cfif arraylen(gh_commit_array) gt 1>
		<cfset master_commit_list = []>
		
		<cfloop query="commit_note_query">
			<cfif commit_note_query.commit_id neq "" and !isNull(commit_note_query.commit_id)>
				<cfset arrayAppend(master_commit_list,{content=#commit_note_query.content#,task_note_id=#task_note_id#,stored_commit_id = #commit_note_query.commit_id# })>
			</cfif>
		</cfloop>
		
		<cfset gh_commit_list = []>
		<cfloop array="#gh_commit_array#" index="commit">
			<cfset commits_match = false>
			<cfloop array="#master_commit_list#" index="current">
				
				<cfif toString(commit.id) eq toString(current.stored_commit_id) >
					<cfset commits_match = true>
					<cfbreak>
				</cfif>
			</cfloop>
			
			<cfif commits_match eq false>
				<cfset arrayAppend(gh_commit_list,{content=#commit.message#,commit_id=#commit.id#})>	
			</cfif>
		</cfloop>
		
		<cfloop array="#gh_commit_list#" index="new_commit">
			<cfset arrayAppend(master_commit_list,new_commit)>
		</cfloop>	
		
		
		<cfoutput>
			  <div id="commits" class="right list">
	          <h2><a href="##">Your Recent Commits</a></h2>
	          <ul>
	          	
				<cfset count3 = 1>
          		<cfloop array="#master_commit_list#" index="item">
					<cfif count3 lt ((arguments.page) * arguments.commits_per_page) and count3 gt arguments.commits_per_page * (arguments.page - 1) >
							<cfif structKeyExists(item,"task_note_id")>
								<li style="overflow:hidden; padding:5px 10px 5px 20px;">
									<p style="width:220px; float:left; clear:left; line-height:15px;">#item.content# <span style="color:##6F6"> - Added</span></p>
									<a href="delete_task_note.cfm?task_note_id=#item.task_note_id#&task_id=#arguments.task_id#&project_id=#arguments.project_id#" style="color:##f66; float:right; margin:0 0 0 0;">
										Delete
									</a>
								</li>
							</cfif>
							
							<cfif structKeyExists(item,"commit_id")>
								<li style="overflow:hidden; padding:5px 10px 5px 20px; clear:left;">
									<p style="width:230px; float:left; line-height:15px; clear:left;">#item.content# </p>
									
									<form style="width:0; height:0;background:none; float:right; margin:-3px 0 0 0; padding:0;" method="post" action="add_task_note.cfm">
										<input type="hidden" name="content" value="#item.content#" >
										<input type="hidden" name="commit_id" value="#item.commit_id#" >
										<input type="hidden" name="task_id" value="#arguments.task_id#">
										<input type="hidden" name="user_id" value="#arguments.user_id#">
										<input type="hidden" name="project_id" value="#arguments.project_id#">
										
										<input style="margin:0; width:40px;" type="submit" value="Add">
									</form>
								</li>
							</cfif>
					</cfif>
					
					<cfset count3++>
				</cfloop>
          </ul>

		 	<cfset total_count = arraylen(master_commit_list)>

			<cfset application._view_unique.show_pagination(total_count,commits_per_page,page_to_load,page,pagination_url_var,arguments.url,"commits")>

        </div>
		</cfoutput>
		
		<cfelse>
		
			<cfoutput>
				<div id="commits" class="right list">
	         	 	<h2><a href="##">Your Recent Commits</a></h2>
					<ul>
						<li>I'm sorry, you have no commits for this repository</li>
					</ul>
				</div>
			</cfoutput>
		
		</cfif>
	</cffunction><!--- end show_commit_list --->
	
	
	
	<cffunction name="show_task_details" returntype="void" >
		<cfargument name="task" type="query" required="true" >
		<cfargument name="current_user_id" type="numeric" required="true" >
		<cfargument name="project_id" type="numeric" required="true" >
		<cfargument name="user_list" type="query" required="true" >

		<cfif arguments.current_user_id eq arguments.task.user_id>
			<cfset show = true>
		</cfif>
		
		<cfoutput>
		<div id="content" class="task">

			 <p id="breadcrumbs"><a href="home.cfm">Home</a> &rarr; <a href="project.cfm?project_id=#arguments.project_id#">Project Page</a> &rarr; Task</p>

	        <div class="information">
	          <a class="right" href="delete_task.cfm?task_id=#arguments.task.tasks_id#&amp;project_id=#arguments.project_id#">delete task</a>
	          <h2>#arguments.task.title#<a class="edit" href="task.cfm?task_id=#arguments.task.tasks_id#&amp;project_id=#arguments.project_id#">edit</a></h2>
			  
	          <form class="inline" method="post" action="edit_task.cfm">
	            <input type="text" name="title" value="#arguments.task.title#" />
				<input type="hidden"name="task_id" value="#arguments.task.tasks_id#">
				<input type="hidden"name="project_id" value="#arguments.project_id#">
	            <input type="submit" name="submit" value="submit" />
	          </form>
	
	          <p class="right">#arguments.task.description#</p>
			  <p class="right" style="margin-top:-10px;padding-top:0;"><a class="edit" href="task.cfm?task_id=#arguments.task.tasks_id#&amp;project_id=#arguments.project_id#">edit description</a></p>
			  <form class="inline block" method="post" action="edit_task.cfm">
	            <textarea name="description">#arguments.task.description#</textarea>
				<input type="hidden"name="task_id" value="#arguments.task.tasks_id#">
				<input type="hidden"name="project_id" value="#arguments.project_id#">
	            <input type="submit" name="submit" value="submit" />
	          </form>
			  
			  
			  
			  <cfif #arguments.task.status# neq 5>
			  	<cfset status = "in progress">
			  <cfelse>
			 	<cfset status = "Closed">
			  </cfif>
			  
	          <p>Status: <span class="status in_progress">#status#</span><a class="edit" href="task.html">edit</a></p>
	          <form class="inline" method="post" action="edit_task.cfm">
	            <select name="status">
	              <option>open</option>
	              <option>closed</option>
	            </select>
				<input type="hidden" name="task_id" value="#arguments.task.tasks_id#">
				<input type="hidden"name="project_id" value="#arguments.project_id#">
	            <input type="submit" name="submit" value="submit" />
	          </form>
	
			<p id="<!-- priority -->">
	          	Priority: 
				<cfloop from="1" to="5" index="i">
					<a href="edit_task.cfm?priority=#i#&task_id=#arguments.task.tasks_id#&project_id=#arguments.project_id#"><cfif arguments.task.priority gte i><span style="font-size:18px; vertical-align:middle;">&##9733;</span><cfelse>&##9734;</cfif></a> 
				</cfloop>
			</p>
	          <p>Assignee: #arguments.task.user_name#<a class="edit" href="edit_task.cfm">edit</a></p>
	
	          <form class="inline" method="post" action="edit_task.cfm">
	            <select name=user_id>
	            	
					<cfloop query="user_list">
						<option value="#user_list.users_id#">#user_list.user_name#</option>
					</cfloop>

	            </select>
				<input type="hidden" name="task_id" value="#arguments.task.tasks_id#">
				<input type="hidden"name="project_id" value="#arguments.project_id#">
	            <input type="submit" name="submit" value="submit" />
	          </form>
	        </div>

		</cfoutput>
 </cffunction> <!---end show_task_details--->
 
 
 
 
 <cffunction name="show_task_notes" returntype="void" hint="shows note list for the task.cfm page">
	<cfargument name="query" required="true" type="query">
	<cfargument name="total_item_count" required="true" type="numeric" hint="total number of items">
	<cfargument name="items_per_page" required="true" type="numeric" hint="total items per page">
	<cfargument name="page_to_load" required="true" type="string"  hint="page to reload">
	<cfargument name="page" required="true" type="numeric"  hint="current_page">
	<cfargument name="url_var" required="true" type="string">
	<cfargument name="url" required="true" type="struct"  hint="url global">
	<cfargument name="current_user_id" required="true" type="numeric">
	<cfargument name="task_id" required="true" type="numeric">
	<cfargument name="project_id" required="true" type="numeric">
		

 	<cfoutput>
	
		<div id="notes" class="left list notes">
          <h2><a href="home.html">Task Notes</a></h2>
          <ul>
			<cfloop query="arguments.query">
	            <li>
	            	<cfif isNull(arguments.query.commit_id) or arguments.query.commit_id eq "">
	              		<p style="float:left;font-size:18px;">&##9733; #arguments.query.user_name#</p>
					<cfelse>
						<p style="float:left;font-size:18px;">&##9733; #arguments.query.user_name#<span style="color:##dd0;font-size:12px;"> - Commit</span></p>
				  	</cfif>
	              <p class="right" style="float:right;font-size:10px;">#dateFormat(arguments.query.date_posted,"full")#</p>
	              <p style="clear:both;">#arguments.query.content#</p>
	            </li>
			</cfloop>
           
          </ul>
        <cfset args = {}>
		<cfset args.total_item_count = arguments.total_item_count>
		<cfset args.items_per_page = arguments.items_per_page>
		<cfset args.page_to_load = arguments.page_to_load>
		<cfset args.page = arguments.page>
		<cfset args.url_var = arguments.url_var>
		<cfset args.url = arguments.url>
		<cfset args.anchor = "notes">
		
	  	<cfset application._view_unique.show_pagination(argumentCollection = args)>
		
		 <div id="note_add" class="form">
            <form method="post" action="add_task_note.cfm">

              <label for="note_content">Add new note</label>
              <textarea rows="5" cols="50" name="content" id="note_content"></textarea>
			  <input type="hidden" name="task_id" value="#arguments.task_id#">
			  <input type="hidden" name="project_id" value="#arguments.project_id#">
			  <input type="hidden" name="user_id" value="#arguments.current_user_id#">
              <input type="submit" name="submit" value="Add Note" />
            </form>
          </div>

	
	</cfoutput>
 
 </cffunction>


</cfcomponent>