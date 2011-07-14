<cfcomponent>
	
	
	<cffunction name="profile_modal" returntype="void" hint="places a hidden modal for editing profiles onto the page.">
		<cfargument name="error_list" type="array" required="false" default="#[]#">
		<cfargument name="user_id" type="string" required="true" default=-1>
		<cfargument name="user_info" type="query" required="true">
		<cfargument name="page_to_load" type="string" required="true" default="home">
		<cfoutput>
	      <div id="signup" class="modal profile">
	      	<cfset application._view_unique.show_errors(error_list)>
	        <cfform method="post" action="edit_user_profile.cfm" enctype="multipart/form-data">
	          <label for="username">Username</label>
	          <input type="text" name="username" id="username" value="#arguments.user_info.user_name#" required="true" message="Username required" >
	          <label for="password">Password</label>
	          <input type="password" name="password" id="password" value="" required="true" message="Password required" >
	          <label for="email">Email</label>
	          <input type="text" name="email" id="email" value="#arguments.user_info.email#" required="true" message="Email required" >
	          <div id="profile_image">
	            <img src="images_members/#arguments.user_info.image_url#" alt="personal avitar" width="80" height="80" />
	            <input type="checkbox" name="gravitar" id="gravitar" value="" checked="checked" >
	            <label for="gravitar">Use Gravatar</label>
	            <input type="file" name="avatar_url" >
	          </div>
	          <label for="gh_username">Github Username:</label>
	          <input type="text" name="gh_username" id="gh_username" value="#arguments.user_info.gh_username#" >
			  <label for="description">User Description</label>
			  <textarea name="description" rows="5" cols="30">#arguments.user_info.description#</textarea>
			  <input type="hidden" name="user_id" value="#arguments.user_id#">
			  <input type="hidden" name="page_to_load" value="#arguments.page_to_load#">
	          <input type="submit" name="submit" class="submit" value="Edit Profile" >
	          <input type="submit" name="submit" class="cancel" value="Cancel" >
	        </cfform>
	      </div>
		</cfoutput>
	</cffunction><!--- ends profile_modal --->
	
	<cffunction name="project_modal" returntype="void" hint="places a hidden modal for adding projects onto the page.">
		<cfargument name="error_list" type="array" required="false" default="#[]#">
		<cfargument name="user_id" type="numeric" required="true" default="-1">
		<cfoutput>
	      <div class="modal project">
	      	<cfset application._view_unique.show_errors(error_list)>
	        <cfform method="post" action="add_project.cfm" enctype="multipart/form-data">
			  <input type="hidden" name="user_id" value="#arguments.user_id#" >
	          <label>Title</label>
	          <input type="text" name="title" required="true" message="Title required" >
	          <label>Description</label>
	          <textarea name="description" rows="5" cols="50" required="true" message="Description required"></textarea>
			  <label>GitHub Repository</label>
			  <input type="text" name="gh_repository_id" >
	          <label>Image</label>
	          <input type="file" name="project_image" required="true" >
	          <input type="submit" name="project_submit" class="submit" value="Create Project" >
	          <input type="submit" name="cancel" class="cancel" value="Cancel" >
	        </cfform>
	      </div>
		</cfoutput>
	</cffunction><!--- ends project_modal --->
	
	<cffunction name="note_modal" returntype="void" hint="places a hidden modal for adding notes onto the page.">
		<cfargument name="error_list" type="array" required="false" default="#[]#">
		<cfargument name="user_id" required="true" type="numeric" default=-1>
		<cfargument name="project_id" required="true" type="numeric" default=-1>
		<cfoutput>
	      <div class="modal note">
	      	<cfset application._view_unique.show_errors(error_list)>
	        <cfform method="post" action="add_project_note.cfm">
	          <label>Add Project Note</label>
	          <textarea name="note_content" rows="5" cols="50" required="true" message="Message required"></textarea>
			  <input type="hidden" name="user_id" value="#arguments.user_id#" >
			  <input type="hidden" name="project_id" value="#arguments.project_id#" >
	          <input type="submit" name="cancel" class="submit" value="Submit Note" >
	          <input type="submit" name="submit" class="cancel" value="Cancel" >
	        </cfform>
	      </div>
		</cfoutput>
	</cffunction><!--- ends note_modal --->
	
	<cffunction name="task_modal" returntype="void" hint="places a hidden modal for adding notes onto the page.">
		<cfargument name="error_list" type="array" required="false" default="#[]#">
		<cfargument name="users" type="query" required="true" default="#{}#">
		<cfargument name="project_id" type="numeric" required="true" default=-1>
		<cfargument name="page_to_load" type="string" required="true" default="home">
		<cfoutput>
	      <div class="modal task">
	        <cfform method="post" action="add_task.cfm">
	          <label>Title</label>
	          <input type="text" name="title" required="true">
	          <label>Description</label>
	          <textarea name="description" rows="5" cols="50" required="true"></textarea>
	          <p id="priority">Priority: <a href="1">&##9734;</a> <a href="2">&##9734;</a> <a href="3">&##9734;</a> <a href="4">&##9734;</a> <a href="5">&##9734;</a></p>
	          <input type="hidden" name="priority" value="" required="true">
	          <label>Assigned User</label>
	          <select name="assigned_user">
	            <option>Select one...</option>
	          	<cfloop query="arguments.users">
					<option value="#arguments.users.users_id#">#arguments.users.user_name#</option>
				</cfloop>
	          </select>
			  <input type="hidden" name="page_to_load" value="#arguments.page_to_load#">
			  <input type="hidden" name="status" value="1">
			  <input type="hidden" name="project_id" value="#arguments.project_id#">
	          <input type="submit" name="task_submit" class="submit" value="Submit Task" />
	          <input type="submit" name="cancel" class="cancel" value="Cancel" />
	        </cfform>
	      </div>
		</cfoutput>
	</cffunction><!--- ends task_modal --->
</cfcomponent>