	
<cfparam name="form.task_id" type="numeric" default=-1>
<cfparam name="form.title" type="string" default="">
<cfparam name="form.project_id" type="numeric" default=-1>
<cfparam name="form.description" type="string" default="">
<cfparam name="form.priority" type="numeric" default=-1>
<cfparam name="form.status" type="string" default="">
<cfparam name="form.user_id" type="numeric" default=-1>

<cfparam name="url.priority" type="numeric" default="-1">
<cfparam name="url.project_id" type="numeric" default="-1">
<cfparam name="url.task_id" type="numeric" default="-1">

<cfif url.project_id neq -1>
	<cfset application._model_user.advanced_protect(url.project_id,session.user_id)>
</cfif>

<cfif form.project_id neq -1>
	<cfset application._model_user.advanced_protect(form.project_id,session.user_id)>
</cfif>


<cfset args = {} >
<cfset args.task_id = form.task_id >

<cfif form.title neq "">
	<cfset args.title = form.title >
</cfif>
<cfif form.description neq ''>
	<cfset args.description = form.description >
</cfif>
<cfif form.priority neq -1>
	<cfset args.priority = form.priority >
</cfif>
<cfif form.status neq "">
	<cfif form.status eq "open">
		<cfset args.status = 3 >
	</cfif>
	<cfif form.status eq "closed">
		<cfset args.status = 5 >
	</cfif>
	<cfdump var="#args#">
	
</cfif>
<cfif form.user_id neq -1>
	<cfset args.user_id = form.user_id >
</cfif> 

<cfif url.priority neq -1 and url.task_id neq -1>
	<cfset args = {}>
	<cfset args.priority = url.priority>
	<cfset args.task_id = url.task_id>
	<cfset application._model_task.edit_task(argumentCollection = args)>
	<cflocation url="task.cfm?task_id=#url.task_id#&project_id=#url.project_id#" addtoken="false">
</cfif>

<cfset application._model_task.edit_task(argumentCollection = args)>

<cflocation url="task.cfm?task_id=#form.task_id#&project_id=#form.project_id#" addtoken="false">

