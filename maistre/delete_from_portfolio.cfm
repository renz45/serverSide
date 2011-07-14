<cfparam name="URL.project_id">
<cfparam name="URL.user_id">
<cfset application._model_user.delete_from_portfolio(URL.user_id,URL.project_id)>
<cflocation url="home.cfm">