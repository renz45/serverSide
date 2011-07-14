<cfsetting showdebugoutput="false" enablecfoutputonly="true" >
<cfparam name="session.is_logged_in" type="boolean" default="false">
<cfparam name="session.user_id" type="string" default=0>
<cfparam name="session.user_name" type="string" default="user">

<cfif session.is_logged_in>
	<cflocation url="home.cfm" addtoken="false">
</cfif>

<cfset page = application._view_page>
<cfset view = application._view_user>
<cfset users_per_page = 7>
<cfset users_page = 1>
<cfset error = []>

<cfset header_args = {}>
<cfset header_args.is_logged_in = session.is_logged_in>
<cfset header_args.username = session.user_name>

<cfset users = application._model_user.get_users(users_per_page, users_page)>
<cfset args = {}>
<cfset args.query = users.query>
<cfset args.total_item_count = users.count>
<cfset args.items_per_page = users_per_page>
<cfset args.page_to_load = "index.cfm">
<cfset args.page = users_page>
<cfset args.load_home = true>

<!--- Logs a user in --->
<cfif structKeyExists(form, "login_submit")>
	<cfif form.username neq "" and form.password neq "">
		<cfset application._model_user.login(form.username, form.password)>
	</cfif>
</cfif>

<!--- Signs a user up for the site. --->
<cfif structKeyExists(form, "signup_submit")>
	<cfif form.username neq "" and form.password neq "" and form.email neq "" and captcha_text neq "">
		<cfparam name="form.captcha_text" type="string" default="" />
		<cfparam name="form.captcha_check" type="string" default="" />
		<cfif (form.captcha_check eq hash(form.captcha_text,"MD5"))>
			<cfset already_exists = application._model_user.get_user(form.username)>
			<cfif already_exists eq "">
				<cfset add_user = application._model_user.add_user(form.username, form.password, form.email, form.gh_username)>
				<cfif add_user neq -1>
					<cfset session.user_id = add_user>
					<cfset session.user_name = form.username>
					<cfset session.is_logged_in = true>
					<cflocation url="home.cfm" addtoken="false">
				<cfelse>
					
					<cfset error = ["Sorry, an error has occured."]>
				</cfif>
			<cfelse>
				<cfset error = ["Sorry, username already exists."]>
			</cfif>
		<cfelse>
			<cfset error = ["Sorry, we prefer human users."]>
		</cfif>
	</cfif>
</cfif>

<cfoutput>
	<cfset page.show_page_setup()>
	<cfset page.show_header(argumentCollection = header_args)>
	<div id="content">
		<cfset application._view_page.show_benefits()>
		<cfset view.show_signup_form(error)>
		<cfset view.show_user_list(argumentCollection = args)>
		<cfset page.show_page_footer()>
	</div>
</cfoutput>