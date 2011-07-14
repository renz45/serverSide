<cfcomponent>

<cffunction name="init" returntype="Any" >
		<cfargument name="datasource" type="string" required="true">
		
		<cfset variables.datasource = arguments.datasource>
		
		<!---constructor always has to return itself--->
		<cfreturn this>
</cffunction>


<!--- add_project(user_id,"title","description",gh_repository_id,"project_image_url") --->
<cffunction name="add_project" returntype="any" >
		<cfargument name="user_id" type="numeric" required="true" hint="sets as manager">
		<cfargument name="title" type="string" required="true" >
		<cfargument name="description" type="string" required="true" >
		
		<cfargument name="gh_repository_id" type="string" required="true" >
		<cfargument name="project_image_url" type="string" required="false" >
		
		<cftry>
			<cfquery datasource="#variables.datasource#" result="addProject">
				INSERT INTO pm_projects 
				SET title=<cfqueryparam value="#title#">,
					description=<cfqueryparam value="#description#" cfsqltype="cf_sql_longvarchar"  >,
					gh_repository_id=<cfqueryparam value="#gh_repository_id#">,
					image_url=<cfqueryparam value="#project_image_url#">,
					manager_id=<cfqueryparam value="#user_id#">,
					date_created=NOW(),
					status = 1
			</cfquery>
			<cfquery datasource="#variables.datasource#" result="connectProject">
				INSERT INTO pm_projects_to_users
				SET user_id = #arguments.user_id#, projects_id = #addProject.generatedkey#
			</cfquery>
				<cfreturn #addProject.generatedkey#>
			<cfcatch type="database" >
					<cfreturn -1>
			</cfcatch>
		
		</cftry>
</cffunction>

<!--- get_projects( projects_per_page, page, project_id, user_id ) --->
<cffunction name="get_projects" returntype="struct">
		<cfargument name="projects_per_page" type="numeric" required="true" >
		<cfargument name="page" type="numeric" required="true" >	
		<cfargument name="project_id" type="numeric" required="false" default=-1 >
		<cfargument name="user_id" type="numeric" required="false" default=-1>
		<cfargument name="completed_only" type="boolean" default="false">
		<cfargument name="open_only" type="boolean" default="false">
		
		<cftry>
				<cfquery datasource="#variables.datasource#" name="local.get_projects">
					SELECT p.projects_id,
						   p.title,
						   p.description,
						   p.date_created,
						   p.date_completed,
						   p.image_url,
						   p.status,
						   p.gh_repository_id,
						   p.manager_id,
						   t.user_name
					FROM pm_projects as p
					<cfif arguments.user_id neq -1>
						INNER JOIN pm_projects_to_users AS u ON(u.projects_id = p.projects_id) AND (u.user_id = <cfqueryparam value="#arguments.user_id#" cfsqltype="cf_sql_integer" >)
						INNER JOIN pm_users AS s ON(u.user_id=s.users_id)
					</cfif>
						INNER JOIN pm_users AS t ON(p.manager_id = t.users_id)
						WHERE (1=1)
					<cfif arguments.completed_only eq true>
						AND p.date_completed IS NOT NULL AND p.date_completed != ''  
					</cfif>
					<cfif arguments.open_only eq true>
						AND p.date_completed IS NULL OR p.date_completed = ''  
					</cfif>
					<cfif arguments.project_id neq -1>
						AND p.projects_id = <cfqueryparam value="#arguments.project_id#" cfsqltype="cf_sql_integer" >
					<cfelse>

					ORDER BY p.date_created DESC
					LIMIT #(arguments.page-1) * arguments.projects_per_page#, #arguments.projects_per_page #
					</cfif>
			 </cfquery>
			
		<cfcatch type="database" >
			<cfset local.get_projects = queryNew("title,date_created,description,date_created,date_completed,image_url")>
						   
		</cfcatch>
		
		</cftry>		
		
		<cftry>
				<cfquery datasource="#variables.datasource#" name="local.get_count">
					SELECT
						COUNT(*) as count
						FROM pm_projects as p
					<cfif arguments.user_id neq -1>
						INNER JOIN pm_projects_to_users AS u ON(u.projects_id = p.projects_id) AND (u.user_id = <cfqueryparam value="#arguments.user_id#" cfsqltype="cf_sql_integer" >)
						INNER JOIN pm_users AS s ON(u.user_id=s.users_id)
					</cfif>
						INNER JOIN pm_users AS t ON(p.manager_id = t.users_id)
						WHERE (1=1)
					<cfif arguments.completed_only eq true>
						AND p.date_completed IS NOT NULL AND p.date_completed != ''  
					</cfif>
					<cfif arguments.open_only eq true>
						AND p.date_completed IS NULL OR p.date_completed = ''  
					</cfif>
					<cfif arguments.project_id neq -1>
						AND p.projects_id = <cfqueryparam value="#arguments.project_id#" cfsqltype="cf_sql_integer" >
					</cfif>
				</cfquery>
	
		<cfcatch type="database" >
			<cfset local.get_count.count = -1>
		</cfcatch>		
		</cftry>
		
		<cfreturn {query=local.get_projects,count=local.get_count.count}>
		
</cffunction>


<!--- edit_project(manager_id,project_id,"title","description","image_url",gh_repository,status) --->
<cffunction name="edit_project" returntype="Numeric" >
		<cfargument name="manager_id" type="numeric" required="false"  default=-1 >
		<cfargument name="projects_id" type="numeric" required="true"  >
		
		<cfargument name="users_id" type="numeric" required="false" default=-1>
		<cfargument name="title" type="string" required="false"  default="">
		<cfargument name="description" type="string" required="false" default="" >
		<cfargument name="image_url" type="string" required="false" default="" >
		<cfargument name="gh_repository" type="string"  required="false" default="" >
		<cfargument name="status" type="numeric" default=-1 required="false" >
		
		<cfdump var="#arguments#">
		<cftry>
				<cfquery result="local.edit_project" datasource="#variables.datasource#">
					UPDATE pm_projects
					SET 
					projects_id = <cfqueryparam value="#arguments.projects_id#">
					<cfif manager_id neq -1>
						,manager_id=<cfqueryparam value="#arguments.manager_id#" cfsqltype="cf_sql_integer" >
					</cfif>
					<cfif arguments.title neq "">
						,title=<cfqueryparam value="#title#" cfsqltype="cf_sql_varchar" >
					</cfif>
					<cfif arguments.description neq "">
						,description=<cfqueryparam value="#description#" cfsqltype="cf_sql_longvarchar" >
					</cfif>
					<cfif image_url neq "">
						,image_url=<cfqueryparam value="#image_url#" cfsqltype="cf_sql_varchar" >
					</cfif>
					<cfif gh_repository neq "">
						,gh_repository_id=<cfqueryparam value="#gh_repository#" cfsqltype="cf_sql_varchar" >
					</cfif>
					
					<cfif arguments.status gt -1>
						<cfif arguments.status eq 1>
							,date_completed = <cfqueryparam null="true" value="0000 00:00:00 ">
						<cfelse>
							,date_completed = NOW()
						</cfif>
					</cfif>
					WHERE projects_id=<cfqueryparam value="#projects_id#" cfsqltype="cf_sql_integer" >
					
				</cfquery>
				<cfdump var="#local.edit_project#">
				<cfreturn #arguments.projects_id#>
		<cfcatch type="database"  >
			<cfdump var="#cfcatch#">
				<cfreturn -1>
		</cfcatch>
		</cftry>
</cffunction>

<!--- delete_project(project_id) --->
<cffunction name="delete_project" returntype="Numeric" >
		<cfargument name="project_id" required="true" >
		
		<cftry>
				<cfquery name="local.delete_project" datasource="#variables.datasource#">
					DELETE FROM pm_projects WHERE projects_id=<cfqueryparam value="#project_id#" cfsqltype="cf_sql_integer" >
			     </cfquery>
				
				<cfreturn arguments.project_id>
			<cfcatch type="database" >
				
				<cfreturn -1> 
			</cfcatch>
		</cftry>
</cffunction>


<!--- add_user(project_id,add_user_id) --->
<cffunction name="add_user" returntype="numeric" >
		<cfargument name="project_id" type="numeric" required="true" >
		<cfargument name="username" type="string" required="true" >
		
		<cftry>
			<cfquery datasource="#variables.datasource#" result="add_user">
				INSERT INTO pm_projects_to_users
				SET user_id = (SELECT users_id FROM pm_users WHERE user_name=<cfqueryparam value="#username#">),
					projects_id = <cfqueryparam value="#project_id#">
			</cfquery>
		<cfcatch type="database"  >
			<cfreturn -1>
		</cfcatch>

		</cftry>
		<cftry>
			<cfquery datasource="#variables.datasource#" name="local.receiver_email">
				SELECT email
				FROM pm_users 
				WHERE user_name = <cfqueryparam value="#username#">
			</cfquery>
			<cfcatch type="database" >
				<cfreturn -1>
			</cfcatch>
		</cftry>
		<cftry>
			<cfquery datasource="#variables.datasource#" name="local.sender_email">
				SELECT u.email,p.manager_id,u.user_name
				FROM pm_projects as p
				INNER JOIN pm_users as u on(p.manager_id = u.users_id)
				WHERE projects_id = <cfqueryparam value="#project_id#">
			</cfquery>
			<cfcatch type="database" >
				<cfreturn -1>
			</cfcatch>
		</cftry>
			<cfdump var="#username#">
		<cftry>
			<cfmail to="#local.receiver_email.email#" from="#local.sender_email.email#" subject="Maistre Project Invite" server="localhost:8888" >
				You've been invited to a Maistre Work Project #local.sender_email.user_name#
			</cfmail>
			<cfcatch type="any" >
				<cfdump var="#cfcatch#">
			</cfcatch>
		</cftry>
 			<cfreturn #arguments.project_id#>
</cffunction>

<!---  email_member(receiver_email, sender_email) --->
<cffunction name="email_member" returntype="Numeric" >
		<cfargument name="receiver_email" type="string" required="true" >
		<cfargument name="sender_email" type="string" required="true" >
		<cfdump var="#cfargument#">
		<cftry>
			<cfmail to="#receiver_email#" from="#sender_email#" subject="Maistre Project Invite" >
				You've been invited to a Maistre Work Project
			</cfmail>
			<cfcatch type="any">
				<cfreturn -1>
			</cfcatch>
		</cftry>
</cffunction>

<!--- remove_user(project_id,remove_user_id) --->
<cffunction name="remove_user" returntype="Numeric" >
		<cfargument name="project_id" required="true" type="numeric" >
		<cfargument name="remove_user_id" required="true" type="numeric" >
		<cftry>
			<cfquery name="local.remove_user" datasource="#variables.datasource#" >
				DELETE FROM pm_projects_to_users
				WHERE projects_id = <cfqueryparam value="#project_id#">
				AND user_id = <cfqueryparam value="#remove_user_id#">
			</cfquery>
			<cfreturn project_id>
			<cfcatch type="database" >
				<cfreturn -1>
			</cfcatch>
		</cftry>
</cffunction>

<!--- promote_user(project_id,promote_user_id) --->
<cffunction name="promote_user" returntype="Numeric" >
		<cfargument name="project_id" required="true" type="numeric" >
		<cfargument name="promote_user_id" type="numeric" >
		
		<cftry>
				<cfquery name="local.promote_user" datasource="#variables.datasource#">
					UPDATE pm_projects
					SET manager_id = <cfqueryparam value="#promote_user_id#" cfsqltype="cf_sql_integer" >
					WHERE projects_id = <cfqueryparam value="#project_id#" cfsqltype="cf_sql_integer" >
				</cfquery>
				
				<cfreturn arguments.project_id>
			<cfcatch type="database" >
				
				<cfreturn -1>
			</cfcatch>
		</cftry>
</cffunction>

<!--- add_project_note(user_id,project_id,"content") --->
<cffunction name="add_project_note" returntype="Numeric" >
		<cfargument name="user_id" type="numeric" required="true" >
		<cfargument name="project_id" type="numeric" required="true" >
		<cfargument name="content" type="string" required="true" >
		
		
		<cftry>
			<cfquery result="local.add_note" datasource="#variables.datasource#">
				INSERT INTO pm_project_notes
				SET user_id = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" >,
					projects_id = <cfqueryparam value="#project_id#" cfsqltype="cf_sql_integer" >,
					content =<cfqueryparam value="#content#" cfsqltype="cf_sql_longvarchar" >,
					date_added=NOW()
			</cfquery>
			<cfreturn local.add_note.generatedkey>
			<cfcatch type="database" >
				<cfreturn -1>
			</cfcatch>
		</cftry>
</cffunction>

<!--- edit_project_note("content", project_note_id) --->
<cffunction name="edit_project_note" returntype="Numeric" >
		<cfargument name="content" required="true" type="string" >
		<cfargument name="project_note_id" required="true" type="numeric" >
		
		<cftry>
			<cfquery name="local.edit_project_note" datasource="#variables.datasource#">
				UPDATE pm_project_notes
				SET content = <cfqueryparam value="#content#" cfsqltype="cf_sql_varchar" >
				WHERE project_note_id = <cfqueryparam value="#project_note_id#" cfsqltype="cf_sql_integer" >
			</cfquery>
			<cfreturn project_note_id>
			<cfcatch type="database" >
				<cfreturn -1>
			</cfcatch>
		</cftry>
</cffunction>

<!--- delete_project_note(project_note_id) --->
<cffunction name="delete_project_note" returntype="Numeric" >
		<cfargument name="project_note_id" required="true" type="numeric" >
		
		<cftry>
			<cfquery name="local.delete_project_note" datasource="#variables.datasource#">
				DELETE FROM pm_project_notes
				WHERE project_note_id = <cfqueryparam value="#project_note_id#" cfsqltype="cf_sql_integer" >
			</cfquery>
			<cfreturn #arguments.project_note_id#>
			
			<cfcatch type="database" >
				<cfreturn -1>
			</cfcatch>
		</cftry>>
</cffunction>

<!--- get_project_notes(project_id,notes_per_page,page) --->
<cffunction name="get_project_notes" returntype="Struct" >
		<cfargument name="project_id" required="true" type="numeric" >
		<cfargument name="notes_per_page" required="true" type="numeric" >
		<cfargument name="page" required="true" type="numeric" >
		
		<cftry>
			<cfquery name="local.get_project_notes" datasource="#variables.datasource#">
				SELECT project_note_id,
					   content,
					   date_added,
					   projects_id,
					   user_id
				FROM pm_project_notes
				WHERE projects_id=<cfqueryparam value="#project_id#">
				ORDER BY date_added
				LIMIT #(arguments.page -1) * arguments.notes_per_page#, #arguments.notes_per_page #
			</cfquery>
			<cfcatch type="database" >
				<cfset local.get_project_notes = queryNew("project_note_id,content,date_added,projects_id,user_id")>
			</cfcatch>
		</cftry>
		<cftry>
			<cfquery name="local.get_count" datasource="#variables.datasource#">
				SELECT 
				COUNT(*) as note_count
				FROM pm_project_notes
				WHERE projects_id=<cfqueryparam value="#project_id#" cfsqltype="cf_sql_integer" >
			</cfquery>
			<cfcatch type="database" >
				
				<cfset local.get_count.count = -1>
			</cfcatch>
		</cftry>
		<cfreturn {query = local.get_project_notes, count= local.get_count.note_count}>
</cffunction>

<!--- get_all_task_notes(project_id, notes_per_page, page) --->
<cffunction name="get_all_task_notes" returntype="Struct" >
	<cfargument name="project_id" required="true" type="numeric" >
	<cfargument name="notes_per_page" required="true" type="numeric" >
	<cfargument name="page" required="true" type="numeric" >
		
	<cftry>
		<cfquery name="local.get_all_task_notes" datasource="#variables.datasource#">
			SELECT n.task_id, n.content, n.date_posted
			FROM pm_tasks_notes AS n
			INNER JOIN pm_tasks AS t ON(t.tasks_id = n.task_id)
			WHERE t.project_id = <cfqueryparam value="#project_id#">
			ORDER BY date_posted
			LIMIT #(arguments.page -1) * arguments.notes_per_page#, #arguments.notes_per_page #
		</cfquery>
		<cfcatch type="database" >
			<cfset local.get_all_task_notes = queryNew("task_id, content, date_posted")>
		</cfcatch>
	</cftry>
	<cftry>
		<cfquery name="local.get_count" datasource="#variables.datasource#">
			SELECT COUNT(*) as note_count
			FROM pm_tasks_notes AS n
			INNER JOIN pm_tasks AS t ON(t.tasks_id = n.task_id)
			WHERE t.project_id = <cfqueryparam value="#project_id#" cfsqltype="cf_sql_integer" >
		</cfquery>
		<cfcatch type="database" >
			<cfset local.get_count.note_count = -1>
		</cfcatch>
	</cftry>
	<cfreturn {query = local.get_all_task_notes, count= local.get_count.note_count}>
</cffunction>


<cffunction name="get_chart" returntype="query"  >
	<cfargument name="project_id" required="true" type="numeric" >
	<cftry>
	<cfquery name=chartData datasource="#variables.datasource#">
				SELECT COUNT(*) AS c,
					u.user_name AS x
				FROM pm_tasks AS p
					INNER JOIN pm_users AS u ON (u.users_id=p.user_id)
				WHERE project_id=#arguments.project_id#
				GROUP BY u.user_name
			</cfquery>

<cfcatch type="database">

</cfcatch>

</cftry>
	
	<cfreturn chartData>
</cffunction> 
</cfcomponent>
