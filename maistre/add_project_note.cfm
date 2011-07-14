<cfparam name="form.user_id" type="numeric" default=0>
<cfparam name="form.project_id" type="numeric" default=0>
<cfparam name="form.note_content" type="string" default="">


<cfset application._model_user.advanced_protect(form.project_id,session.user_id)>


<cfset args = {} >
<cfset args.user_id = form.user_id >
<cfset args.project_id = form.project_id >
<cfset args.content = form.note_content >

<cfset application._model_project.add_project_note(argumentCollection=args)>

<cflocation url="project.cfm?project_id=#form.project_id#" addtoken="false" >