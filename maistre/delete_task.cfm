<!---<cffunction name="delete_task" hint="deletes a task">
	<cfargument name="task_id" type="numeric" required="true">--->
	
	<cfparam name="url.task_id" type="numeric" default=-1>
	<cfparam name="url.project_id" type="numeric" default=-1>
	
	<cfset application._model_task.delete_task(url.task_id)>
	<cflocation url="project.cfm?project_id=#url.project_id#" addtoken="false" >