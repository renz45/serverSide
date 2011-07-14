<cfparam name="session.is_logged_in" default="false">
<cfset application._model_user.protect(session.is_logged_in) >

<cfdump var="#form#">
	
<cfparam name="form.title" type="string" default="">
<cfparam name="form.description" type="string" default="">
<cfparam name="form.project_id" type="numeric" default=-1>
<cfparam name="form.assigned_user" type="any" default=-1>
<cfparam name="form.priority" type="any" default=-1 >
<cfparam name="form.status" type="numeric" default=1>
<cfparam name="form.page_to_load" type="string" default="home">

<cfif form.assigned_user eq "Select one...">
	<cfset form.assigned_user = -1>
</cfif>

<cfif form.priority eq "">
	<cfset form.priority = 1>
</cfif>

<cfset application._model_user.advanced_protect(form.project_id,session.user_id)>


<cfset args = {} >
<cfset args.title = form.title >
<cfset args.description = form.description >
<cfset args.project_id = form.project_id >
<cfif form.assigned_user neq -1>
	<cfset args.user_id = form.assigned_user>
</cfif>
<cfif form.priority neq -1>
	<cfset args.priority = form.priority >
	<cfelse> 
	<cfset args.priority = 1>
</cfif>
<cfset args.status = form.status >
<cfset application._model_task.add_task(argumentCollection = args)>
<cfif form.page_to_load eq "project">
	<cflocation url="project.cfm?project_id=#form.project_id#" addtoken="false" >
<cfelse>
	<cflocation url="home.cfm" addtoken="false" >
</cfif>
