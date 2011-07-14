<cfcomponent hint="all the task related queries"> 
<cfset variables.datasource="projectDevelopment">
<cffunction name="init" returntype="any">
	<cfargument name="datasource" type="string" required="true">
	<cfset variables.datasource=arguments.datasource>
	<cfreturn this>
</cffunction>

<cffunction name="add_task" returntype="Numeric" hint="creates a new task for a project">
	<cfargument name="title" type="string" required="true">
	<cfargument name="description" type="string" required="true">
	<cfargument name="project_id" type="numeric" required="true">
	<cfargument name="user_id" type="numeric" required="false" default=-1>
	<cfargument name="priority" type="numeric" required="false" default=10>
	<cfargument name="status" type="numeric" required="false" default=1>
	
	<!---<cfset var add_task=0>--->
	
	<cfif arguments.user_id eq -1>
		<cfset isNull=true>
	<cfelse>
		<cfset isNull=false>
	</cfif>
	
	<cftry>
    	<cfquery result="local.add_task" datasource="#variables.datasource#">
			INSERT INTO pm_tasks
			SET title=<cfqueryparam value="#arguments.title#">, 
				description=<cfqueryparam value="#arguments.description#">,
				priority=<cfqueryparam value="#arguments.priority#">,
				status=<cfqueryparam value="#arguments.status#">,
				project_id=<cfqueryparam value="#arguments.project_id#">,
				user_id=<cfqueryparam null="#isNull#" value="#arguments.user_id#">,
				date_added=NOW()
		</cfquery>    
	    <cfcatch type="database">
	    	<cfreturn -1>
	    </cfcatch>
    </cftry>
	<cfreturn add_task.generatedkey>
</cffunction><!--- end add_task --->

<!--- application._model_task.get_tasks(tasks_per_page,page,user_id,project_id,task_id,status) --->
<cffunction name="get_tasks" returntype="Struct" hint="gets a list of tasks">
	<cfargument name="tasks_per_page" type="numeric" required="true">
	<cfargument name="page" type="numeric" required="true">
	<cfargument name="user_id" type="numeric" required="false" default="-1">
	<cfargument name="project_id" type="numeric" required="false" default=-2>
	<cfargument name="task_id" type="numeric" required="false" default=-1>
	<cfargument name="status" required="false" type="array" default="#[]#" hint="an array of status values 1, 2, 3, 4, 5">
	
	<cfif arguments.project_id eq -1>
		<cfreturn {query=queryNew("tasks_id, title, description, priority, status, project_id, date_added, user_id, user_name "),count=0}>
	</cfif>
		
	<cftry>
	<cfset tester = Arraylen(arguments.status)<!---arrayToList(arguments.status,",")--->>
	
		<cfquery name="local.get_tasks" datasource="#variables.datasource#">
			SELECT 
				t.tasks_id,
				t.title,
				t.description, 
				t.priority, 
				t.status, 
				t.project_id,
				t.date_added,
				t.user_id,
				u.user_name
			FROM pm_tasks AS t
			
			LEFT JOIN pm_users AS u ON(t.user_id = u.users_id)
			WHERE 1=1
			
			<cfif Arraylen(arguments.status) gt 0>
				AND (t.status in(#toString(arrayToList(arguments.status,","))#))
				
			</cfif>
			<cfif arguments.project_id gt -1>
				AND t.project_id=<cfqueryparam value="#arguments.project_id#" cfsqltype="cf_sql_integer" >
			</cfif>
			<cfif arguments.user_id neq -1>
				AND t.user_id=<cfqueryparam value="#arguments.user_id#">
			</cfif>
		
			<cfif arguments.task_id neq -1>
				AND t.tasks_id=<cfqueryparam value="#arguments.task_id#">
			</cfif>
			ORDER BY u.user_name
			LIMIT #(arguments.page-1)*arguments.tasks_per_page#,#arguments.tasks_per_page#
		</cfquery> 
		
	    <cfcatch type="database" >
	    
	    	<cfset local.get_tasks=queryNew("tasks_id, title, description, priority, status, project_id, date_added, user_id, user_name ")>
	    </cfcatch>
    </cftry>
	<cftry>
		<cfquery name="local.get_task_count" datasource="#variables.datasource#">
			SELECT
			COUNT(*) AS count
			FROM pm_tasks AS t
			
			LEFT JOIN pm_users AS u ON(t.user_id = u.users_id)
			WHERE 1=1
			
			<cfif Arraylen(arguments.status) gt 0>
				AND (t.status in(#toString(arrayToList(arguments.status,","))#))
				
			</cfif>
			<cfif arguments.project_id gt -1>
				AND t.project_id=<cfqueryparam value="#arguments.project_id#" cfsqltype="cf_sql_integer" >
			</cfif>
			<cfif arguments.user_id neq -1>
				AND t.user_id=<cfqueryparam value="#arguments.user_id#">
			</cfif>
		
			<cfif arguments.task_id neq -1>
				AND t.tasks_id=<cfqueryparam value="#arguments.task_id#">
			</cfif>
		</cfquery>
	    <cfcatch type="database" >
	    	<cfset local.get_task_count.count = -1>
	    </cfcatch>
    </cftry>
	<cfreturn {query=local.get_tasks,count=local.get_task_count.count}>
</cffunction><!--- end get_task --->

<cffunction name="edit_task" returntype="Numeric" hint="edits a task">
	<cfargument name="task_id" type="numeric" required="true">
	<cfargument name="title" type="string" required="false" default="">
	<cfargument name="description" type="string" required="false" default="">
	<cfargument name="priority" type="numeric" required="false" default=-1>
	<cfargument name="status" type="numeric" required="false" default=-1>
	<cfargument name="user_id" type="numeric" required="false" default=-1>
	
	<cftry>
		<cfquery name="local.edit_task" datasource="#variables.datasource#">
			UPDATE pm_tasks
			SET 
			tasks_id=<cfqueryparam value="#arguments.task_id#" cfsqltype="cf_sql_integer" >
			<cfif arguments.title neq "">
				,title=<cfqueryparam value="#arguments.title#" cfsqltype="cf_sql_varchar" >
			</cfif>
			<cfif arguments.description neq "">
				,description=<cfqueryparam value="#arguments.description#">
			</cfif>
			<cfif arguments.priority neq -1>
				,priority=<cfqueryparam value="#arguments.priority#">
			</cfif>
			<cfif arguments.status neq -1>
				,status=<cfqueryparam value="#arguments.status#">
			</cfif>
			<cfif arguments.user_id neq -1>
				,user_id=<cfqueryparam value="#arguments.user_id#">
			</cfif>
			WHERE tasks_id=<cfqueryparam value="#arguments.task_id#">
		</cfquery>	  
		 
	    <cfcatch type="database" >
	    	
	    	<cfreturn -1>
	    </cfcatch>
    </cftry>
	<cfreturn arguments.task_id>
</cffunction><!--- end edit_task --->

<cffunction name="delete_task" hint="deletes a task">
	<cfargument name="task_id" type="numeric" required="true">
	<!---<cfset var delete_task=0>--->
	
	<cfif arguments.task_id lt 0 >
		<cfreturn -1>
	</cfif>
	
	<cftry>
    	<cfquery name="local.delete_task" datasource="#variables.datasource#">
    		DELETE FROM pm_tasks
			WHERE tasks_id=<cfqueryparam value="#arguments.task_id#">
		</cfquery>
	    <cfcatch type="database" >
	    	<cfreturn -1>
	    </cfcatch>
    </cftry>
	<cfreturn arguments.task_id>
</cffunction><!--- end delete_task --->


<cffunction name="get_task_notes" returntype="Struct" hint="gets notes for a specific task">
	<cfargument name="notes_per_page" type="numeric" required="true">
	<cfargument name="page" type="numeric" required="true">
	<cfargument name="use_pagination" type="boolean" required="false" default=true hint="disables pagination and returns the full list query.  Ignores page and notes_per_page">
	<cfargument name="task_id" type="numeric" required="false" default="-1">
	<cfargument name="user_id" type="numeric" required="false" default=-1>
	<cfargument name="commit_id" type="numeric" required="false" default=-1>
	<!---<cfset var get_task_notes=0>--->
	<cftry>
    	<cfquery name="local.get_task_notes" datasource="#variables.datasource#">
    		SELECT
				 n.task_note_id,
				 n.task_id,
				 n.content,
				 n.user_id, 
				 u.user_name,
				 n.commit_id,
				 n.date_posted
			FROM pm_tasks_notes AS n
			INNER JOIN pm_users AS u ON (n.user_id=u.users_id)
			WHERE 1=1 
			<cfif arguments.task_id neq -1>
				AND task_id=<cfqueryparam value="#arguments.task_id#">
			</cfif>
			<cfif arguments.user_id neq -1>
				AND user_id=<cfqueryparam value="#arguments.user_id#">
			</cfif>
			<cfif arguments.commit_id neq -1>
				AND commit_id=<cfqueryparam value="#arguments.commit_id#">
			</cfif>
			ORDER BY n.date_posted DESC
			<cfif use_pagination eq true>
				LIMIT #(arguments.page-1)*arguments.notes_per_page#,#arguments.notes_per_page#
			</cfif>
		</cfquery>    
	    <cfcatch type="database" >
	    	<cfset local.get_task_notes=queryNew("task_note_id, task_id, content, user_id, user_name, commit_id, date_posted")>
	    </cfcatch>
    </cftry>
	<cftry>
		<cfquery name="local.get_task_notes_count" datasource="#variables.datasource#">
			SELECT
			COUNT(*) AS count
			FROM pm_tasks_notes
			WHERE 1=1 
			<cfif arguments.task_id neq -1>
				AND task_id=<cfqueryparam value="#arguments.task_id#">
			</cfif>
			<cfif arguments.user_id neq -1>
				AND user_id=<cfqueryparam value="#arguments.user_id#">
			</cfif>
			<cfif arguments.commit_id neq -1>
				AND commit_id=<cfqueryparam value="#arguments.commit_id#">
			</cfif>
		</cfquery>
	    <cfcatch type="database" >
	    	<cfset local.get_task_notes_count.count = -1>
	    </cfcatch>
    </cftry>
	<cfreturn {query=local.get_task_notes,count=local.get_task_notes_count.count}>
</cffunction><!--- end get_task_notes --->

<cffunction name="add_task_note" returntype="numeric" hint="gets notes for a specific task">
	<cfargument name="task_id" type="numeric" required="true">
	<cfargument name="user_id" type="numeric" required="true">
	<cfargument name="content" type="string" required="true">
	<cfargument name="commit_id" type="string" required="false" default="">
	<!---<cfset var add_task_note=0>--->
	<cftry>
    	<cfquery result="local.add_task_note" datasource="#variables.datasource#">
    		INSERT INTO pm_tasks_notes
			SET task_id=<cfqueryparam value="#arguments.task_id#">,
				user_id=<cfqueryparam value="#arguments.user_id#">,
				content=<cfqueryparam value="#arguments.content#">,
				commit_id=<cfqueryparam value="#arguments.commit_id#">,
				date_posted=NOW()
		</cfquery>    
	    <cfcatch type="database" >
	    	<cfreturn -1>
	    </cfcatch>
    </cftry>

	<cfreturn add_task_note.generatedkey>
</cffunction> <!--- end add_task_note --->

<cffunction name="edit_task_note" returntype="Numeric" hint="gets notes for a specific task">
	<cfargument name="task_note_id" type="numeric" required="true">
	<cfargument name="content" type="string" required="true">
	<!---<cfset var edit_task_note=0>--->
	
	<cfif arguments.task_note_id lt 0>
		<cfreturn -1>
	</cfif>
	
	<cftry>
    	<cfquery name="local.edit_task_note" datasource="#variables.datasource#">
    		UPDATE 
				pm_tasks_notes
			SET 
				content=<cfqueryparam value="#arguments.content#">
			WHERE task_note_id=<cfqueryparam value="#arguments.task_note_id#">
			<!---AND commit_id is NULL--->
		</cfquery>    
	    <cfcatch type="database" >
	    	<cfdump var="#cfcatch#">
	    	<cfreturn -1>
	    </cfcatch>
    </cftry>
	<cfreturn arguments.task_note_id>
</cffunction> <!--- end edit_task_note --->

<cffunction name="delete_task_note" returntype="Numeric" hint="gets notes for a specific task">
	<cfargument name="task_note_id" type="numeric" required="true">
	<!---<cfset var delete_task_note=0>--->
	
	<cfif arguments.task_note_id lt 0>
		<cfreturn -1>
	</cfif>
	
	<cftry>
    	<cfquery name="local.delete_task_note" datasource="#variables.datasource#">
    		DELETE FROM pm_tasks_notes
			WHERE task_note_id=<cfqueryparam value="#arguments.task_note_id#">
		</cfquery>    
	    <cfcatch type="database" >
	    	<cfreturn -1>
	    </cfcatch>
    </cftry>
	<cfreturn arguments.task_note_id>
</cffunction> <!--- end delete_task_note --->

</cfcomponent>




