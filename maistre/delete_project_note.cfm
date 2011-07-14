<cfparam name="url.project_note_id">
<cfparam name="url.projects_id">
<cfset application._model_project.delete_project_note(url.project_note_id)>
<cflocation url="project.cfm?project_id=#url.projects_id#">