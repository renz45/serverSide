<cfparam name="form.username" type="string" default="">
<cfparam name="form.password" type="string" default="">

<cfset form.password = hash(form.password,"MD5")>


<cfset login = application.model.get_login_info(form)>

<cfif login.users_name neq "">
	<cfset session.user_id = login.users_id>
	<cfset session.user_name = login.users_name>
	<cfset session.is_logged_in = true>
	<cflocation url="admin.cfm" addtoken="false" >
<cfelse>
	<cflocation url="index.cfm?login_error=true&login=true" addtoken="false" >
</cfif>