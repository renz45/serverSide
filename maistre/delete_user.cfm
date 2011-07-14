<cfparam name="form.user_id" type="numeric" default="">
<cfparam name="form.password" type="string" default="">

<cfset args = {} >
<cfset args.user_id = form.user_id >
<cfset args.password = form.password >

<cfset application._model_user.delete_user(argumentCollection=args)>

<cflocation url="home.cfm">