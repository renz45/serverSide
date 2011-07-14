<cfparam name="form.username" type="string" default="">
<cfparam name="form.password" type="string" default="">
<cfparam name="form.email" type="string" default="">
<cfparam name="form.description" type="string" default="">
<cfparam name="form.gh_username" type="string" default="">

<cfset args = {} >
<cfset args.username = form.manager_id >
<cfset args.password = form.password >
<cfset args.email = form.email >
<cfset args.description = form.description >
<cfset args.gh_username = form.gh_username >

<cfset application._model_user.add_user(argumentCollection=args)>

<cflocation url="home.cfm">