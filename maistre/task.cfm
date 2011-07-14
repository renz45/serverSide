﻿<cfsetting showdebugoutput="false" ><cfparam name="session.is_logged_in" type="boolean" default=false><Cfset application._model_user.protect(session.is_logged_in)><cfparam name="session.user_name" type="string" default=""><cfparam name="session.user_id" type="numeric" default=-1><cfparam name="url.task_id" type="numeric" default=-1><cfparam name="url.project_id" type="numeric" default=-1><cfparam name="url.notes_page" type="numeric" default="1" ><cfparam name="url.commit_list_page" type="numeric" default="1"><cfparam name="url.task_open_state" type="boolean" default="true"><cfset application._model_user.advanced_protect(url.project_id,session.user_id)><!---<cfset session.user_id = 1><cfset url.project_id = 2>---><!--- constants ---><cfset tasks_per_page = 10><cfset notes_per_page = 5><cfset users_per_page = 7><cfset commits_per_page = 10><cfset error = []><!--- end constants ---><!--- show_page_setup ---><cfset application._view_page.show_page_setup()><!--- show_page_setup ---><!--- show_header ---><cfset header_args={}><cfset header_args.is_logged_in=session.is_logged_in><cfset header_args.username=session.user_name><cfset header_args.user_id=session.user_id><cfset application._view_page.show_header(argumentCollection = header_args)><!--- end show_header ---><!--- show_tasks_details ---><cfset gt_args = {}><cfset gt_args.tasks_per_page=1><cfset gt_args.page=1><cfset gt_args.task_id=url.task_id><cfset get_tasks = application._model_task.get_tasks(argumentCollection = gt_args)><cfset gu_args = {}><cfset gu_args.use_pagination = false><cfset gu_args.users_per_page = 0><!--- pagination is turned off with, user_pagination, so this doesnt matter, but its still required ---><cfset gu_args.page = 0><!--- pagination is turned off with, user_pagination, so this doesnt matter, but its still required ---><cfset gu_args.project_id = url.project_id><cfset results=application._model_user.get_users(argumentCollection = gu_args)><cfset args = {} ><cfset args.task = get_tasks.query ><cfset args.current_user_id = session.user_id><cfset args.project_id = url.project_id><cfset args.user_list=results.query><cfset application._view_task.show_task_details(argumentCollection = args)><!--- end show_tasks_details ---><!--- show_commit_list ---><cfset scl_args = {}><cfset scl_args.notes_per_page = commits_per_page><cfset scl_args.task_id = url.task_id><cfset scl_args.page = url.commit_list_page><cfset scl_args.use_pagination=false><cfset results = application._model_task.get_task_notes(argumentCollection=scl_args)><cfset gu_args = {}><cfset gu_args.user_id = session.user_id><cfset gu_args.page = 1><cfset gu_args.users_per_page = 2><cfset current_user_result = application._model_user.get_users(argumentCollection = gu_args)><cfset current_project_result = application._model_project.get_projects(1,1,url.project_id)><cfset gh_results = application._model_github.get_commits(current_user_result.query.gh_username,current_project_result.query.gh_repository_id,"master")>	<cfset scl_args = {}><cfset scl_args.commits_per_page = commits_per_page><cfset scl_args.page_to_load = "task.cfm"><cfset scl_args.page = url.commit_list_page><cfset scl_args.commit_note_query = results.query><cfset scl_args.gh_commit_array = gh_results><cfset scl_args.pagination_url_var = "commit_list_page"><cfset scl_args.url = url><cfset scl_args.task_id = url.task_id><cfset scl_args.project_id = url.project_id><cfset scl_args.user_id = session.user_id><cfset application._view_task.show_commit_list(argumentCollection=scl_args)><!--- end show_commit_list ---><!--- end show_note_list ---><cfset gtn_args = {}><cfset gtn_args.task_id= url.task_id><cfset gtn_args.notes_per_page=notes_per_page><cfset gtn_args.page=url.notes_page><cfset tn_return = application._model_task.get_task_notes(argumentCollection = gtn_args)><cfset stn_args = {}><cfset stn_args.query =tn_return.query><cfset stn_args.total_item_count =tn_return.count ><cfset stn_args.items_per_page = notes_per_page><cfset stn_args.page_to_load = "task.cfm"><cfset stn_args.page = url.notes_page><cfset stn_args.url_var = "notes_page"><cfset stn_args.url = url><cfset stn_args.current_user_id = session.user_id><cfset stn_args.task_id = url.task_id><cfset stn_args.project_id = url.project_id><cfset application._view_task.show_task_notes(argumentCollection = stn_args)><!--- end show_note_list ---><cfset user_args = {}><cfset user_args.users_per_page = 1><cfset user_args.page = 1><cfset user_args.user_id = session.user_id><cfset user_info = application._model_user.get_users(argumentCollection = user_args)><!--- modals ---><cfset application._view_modal.profile_modal(error, session.user_id, user_info.query, "task.cfm?project_id=#url.project_id#&task_id=#url.task_id#")><!--- end modals ---><!--- end show_page_footer ---><cfset application._view_page.show_page_footer()><!--- end show_page_footer --->
