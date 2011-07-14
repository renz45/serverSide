<cfsetting showdebugoutput="false" enablecfoutputonly="true">
<cfparam name="URL.project_list_page" type="numeric" default=1>
<cfparam name="URL.user_id" type="numeric" default=0>
<cfparam name="session.is_logged_in" type="boolean" default="false">
<cfparam name="session.user_id" type="string" default=2>
<cfparam name="session.user_name" type="string" default="user">
<cfset error = []>

<cfset search_list = false>
<cfset search_struct = structNew()>
<cfif structKeyExists(form,"portfolio_submit")>
	<cfif form.user_name neq "">
		<cfset search = application._model_user.search_portfolio(form.user_name)>
		<cfif search.count neq -1>
			<cfset search_list = true>
			<cfset search_struct = search>
		</cfif>
	</cfif>
</cfif>

<cfset pargs={}>
<cfset pargs.users_per_page=5>
<cfset pargs.page=URL.project_list_page>
<cfset pargs.user_id=URL.user_id>
<cfset get_projects=application._model_user.get_portfolio(argumentCollection=pargs)>

<cfset args={}>
<cfset args.projects=get_projects.query>
<cfset args.portfolio_user_id=URL.user_id>
<cfset args.total_item_count=get_projects.count>
<cfset args.items_per_page=5>
<cfset args.page_to_load="portfolio.cfm">
<cfset args.page=URL.project_list_page>
<cfset args.url_var="project_list_page">
<cfset args.url=URL>

<cfif search_list eq true>
	<cfset args.search = search_struct.query>
	<cfset args.total_item_count = search_struct.count>
</cfif>

<cfset uargs={}>
<cfset uargs.users_per_page=5>
<cfset uargs.page=URL.project_list_page>
<cfset uargs.user_id=URL.user_id>
<cfset get_users=application._model_user.get_users(argumentCollection=uargs)>

<cfset user_args = {}>
<cfset user_args.users_per_page = 1>
<cfset user_args.page = 1>
<cfset user_args.user_id = session.user_id>
<cfset user_info = application._model_user.get_users(argumentCollection = user_args)>

<cfoutput>
	<cfset application._view_page.show_page_setup()>
	<cfset header_args={}>
	<cfset header_args.is_logged_in=session.is_logged_in>
	<cfset header_args.username=session.user_name>
	<cfset application._view_page.show_header(argumentCollection = header_args)>
	
	<cfset application._view_page.show_portfolio_top(get_users.query)>
	
	<cfif search_list eq true>
		<cfset application._view_page.show_user_portfolio_list(argumentCollection=args)>
	</cfif>
	<cfset application._view_page.show_portfolio_list(argumentCollection=args)>
	<cfset application._view_page.show_page_footer()>
	<cfset application._view_modal.profile_modal(error, session.user_id, user_info.query, "portfolio.cfm?user_id=#url.user_id#")>
</cfoutput>