<cfparam name="url.project_id">
<cfset application._model_project.delete_project(url.project_id)>
<cflocation url="home.cfm">
