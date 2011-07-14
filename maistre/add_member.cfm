<cfparam name="form.username" type="string" default="">
<cfparam name="form.project_id" type="numeric" default=-1>

<cfif form.username neq '' and form.project_id neq -1>
	<cfset args={}>
	<cfset args.username = form.username>
	<cfset args.project_id = form.project_id>
<cfset application._model_project.add_user(argumentCollection = args)>
</cfif>

<cflocation url="project.cfm?project_id=#form.project_id#" addtoken="false" >

