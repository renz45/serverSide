<cfsetting showdebugoutput="false" >
<cfparam name="session.is_logged_in" type="boolean" default="false">
 <cfset application._model_user.protect(session.is_logged_in)>

<cfparam name="session.user_id" type="numeric" default=-1>
<cfparam name="session.user_name" type="string" default="">

<cfparam name="url.project_list_page" type="numeric" default="1">
<cfparam name="url.project_open" type="boolean" default="true">
<cfparam name="url.project_id" type="numeric" default=-1>
<cfparam name="url.task_list_page" type="numeric" default="1">
<cfparam name="url.task_open_state" type="boolean" default="true">
<cfparam name="url.page" default="1" type="numeric">


<!--- constants --->
<cfset projects_per_page = 10>
<cfset tasks_per_page = 10>
<cfset users_per_page = 7>
<cfset error = []>
<!--- end constants --->


<!--- show_page_setup --->
<cfset application._view_page.show_page_setup()>
<!--- show_page_setup --->

<!--- show_header --->
<cfset header_args={}>
<cfset header_args.is_logged_in=session.is_logged_in>
<cfset header_args.username=session.user_name>
<cfset header_args.user_id=session.user_id>
<cfset application._view_page.show_header(argumentCollection = header_args)>
<!--- end show_header --->

<!--- show_project_list --->
<cfset gp_args = {}>
<cfset gp_args.projects_per_page = projects_per_page>
<cfset gp_args.page = url.project_list_page>
<cfset gp_args.user_id = session.user_id>

<cfif url.project_open eq false>
	<cfset gp_args.completed_only = true>
<cfelse>
	<cfset gp_args.open_only = true>
</cfif>
<cfset project_result = application._model_project.get_projects(argumentCollection = gp_args)>

<cfset plist_args = {}>
<cfset plist_args.projects = project_result.query>
<cfset plist_args.project_open = url.project_open>
<cfset plist_args.total_item_count = project_result.count>
<cfset plist_args.items_per_page = projects_per_page>
<cfset plist_args.page = url.project_list_page>
<cfset plist_args.page_to_load = "home.cfm">
<cfset plist_args.url_var = "project_list_page">
<cfset plist_args.url = url>

<cfif url.project_id eq -1>
	<cfif project_result.query.projects_id neq "">
		<cfset url.project_id = project_result.query.projects_id>
	</cfif>
</cfif>

<cfset plist_args.view_project_id = url.project_id>

<!--- wtf the url variable dies after the show_program_list function? i dont get it so here is a hack to get around it :( --->
<cfset hack_st = {}>
<cfset structAppend(hack_st,url)>
<!--- end hack --->

<cfset application._view_project.show_project_list(argumentCollection = plist_args)>
<!--- end show_project_list --->


<!--- more CF wtf? hacked --->
<cfset structClear(url)>
<cfset structAppend(url,hack_st)>
<!--- end hack --->


<!---  show_task_list --->
<cfset gt_args = {}>
<cfset gt_args.tasks_per_page = tasks_per_page>
<cfset gt_args.page = url.task_list_page>
<cfset gt_args.project_id = url.project_id>
<cfset gt_args.user_id = session.user_id>
<cfset gt_args.status = []>

<cfset gt_args.project_id = url.project_id>

<cfif url.task_open_state eq true>
	<cfset gt_args.status = [1,2,3,4]>
	<cfset results = application._model_task.get_tasks(argumentCollection = gt_args)>
<cfelse>

	<cfset gt_args.status = [5]>
	<cfset results = application._model_task.get_tasks(argumentCollection = gt_args)>	
</cfif>


<cfset tlist_args = {}>
<cfset tlist_args.total_task_count = results.count>
<cfset tlist_args.tasks_per_page = tasks_per_page>
<cfset tlist_args.page_to_load = "home.cfm">
<cfset tlist_args.page = url.task_list_page>
<cfset tlist_args.task_query = results.query>
<cfset tlist_args.pagination_url_var = "task_list_page">
<cfset tlist_args.open_state = url.task_open_state>

<cfset tlist_args.url = url>


<cfset application._view_task.show_task_list(argumentCollection = tlist_args)>
<!--- end show_task_list --->


<!--- show_user_list --->



<cfset results=application._model_user.get_users(users_per_page,url.page,url.project_id)>

<cfset ul_args ={}>
<cfset ul_args.items_per_page = users_per_page>
<cfset ul_args.page = url.page>
<cfset ul_args.page_to_load = "home.cfm">
<cfset ul_args.query = results.query>
<cfset ul_args.total_item_count= results.count>
<cfset ul_args.url= url>

<cfset application._view_user.show_user_list(argumentCollection = ul_args)>

<!--- end show_user_list --->

<cfset user_args = {}>
<cfset user_args.users_per_page = 1>
<cfset user_args.page = 1>
<cfset user_args.user_id = session.user_id>
<cfset user_info = application._model_user.get_users(argumentCollection = user_args)>

<!--- modals --->
<cfset application._view_modal.project_modal(error, session.user_id)>
<cfset application._view_modal.task_modal(error, results.query, url.project_id, "home")>
<cfset application._view_modal.profile_modal(error, session.user_id, user_info.query, "home.cfm")>
<!--- end modals --->

<!--- end show_page_footer --->
<cfset application._view_page.show_page_footer()>
<!--- end show_page_footer --->