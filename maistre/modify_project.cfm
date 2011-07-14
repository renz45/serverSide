<!---<cfset application._model_user.protect(is_logged_in) >
--->
<cfdump var="#form#">
<cfparam name="form.manager_id" type="numeric" default=-1>
<cfparam name="form.title" type="string" default="">
<cfparam name="form.description" type="string" default="">
<cfparam name="form.status" type="string" default="open">
<cfparam name="form.projects_id" type="numeric" default=-1>
<cfparam name="form.users_id" type="numeric" default=-1>
<cfparam name="form.gh_repository_id" type="string" default="">

<cfparam name="url.delete_user" type="numeric" default="-1">
<cfparam name="url.project_id" type="numeric" default="-1">

<cfif url.project_id neq -1>
	<cfset application._model_user.advanced_protect(url.project_id,session.user_id)>
</cfif>

<cfif form.projects_id neq -1>
	<cfset application._model_user.advanced_protect(form.projects_id,session.user_id)>
</cfif>

<!--- edit_project(manager_id,project_id,"title","description","image_url",gh_repository,status) --->

<cfset args = {} >
<cfset args.projects_id = form.projects_id >
<cfif form.manager_id neq -1>
	<cfset args.manager_id = form.manager_id >
</cfif>
<cfif form.title neq ''>
	<cfset args.title = form.title >
</cfif>
<cfif form.description neq "">
	<cfset args.description = form.description >
</cfif>
<cfif form.gh_repository_id neq "">
	<cfset args.gh_repository = form.gh_repository_id >
</cfif>
<cfif form.status eq "open">
	<cfset args.status = 1>
<cfelse>
	<cfset args.status = 2>
</cfif>
<cfif form.users_id neq -1>
	<cfset args.manager_id = form.users_id>
</cfif> 

<cfif url.delete_user neq -1 and url.project_id neq -1>
	<cfset application._model_project.remove_user(url.project_id,url.delete_user) >
	<cflocation url="project.cfm?project_id=#url.project_id#" addtoken="false" >
</cfif>

<cfset application._model_project.edit_project(argumentCollection= args) >

<cflocation url="project.cfm?project_id=#form.projects_id#" addtoken="false" >


