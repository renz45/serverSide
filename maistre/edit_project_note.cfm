<cfparam name="form.project_note_id" type="numeric" default="">
<cfparam name="form.project_id" type="numeric" default="">
<cfparam name="form.content" type="string" default="">

<cfset args = {} >
<cfset args.project_note_id = form.project_note_id >
<cfset args.content = form.content >

<cfset application._model_user.edit_project_note(argumentCollection=args)>

<cflocation url="project.cfm?project_id=#form.project_id#">