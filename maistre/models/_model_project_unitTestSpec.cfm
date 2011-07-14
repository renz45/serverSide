<cfsetting showdebugoutput="false" >
<cfset variables.datasource = "projectDevelopment">
<cfimport taglib="/cfspec">

<!---querys used for testing in the test functions below--->
	<cfquery datasource="#variables.datasource#">
		DELETE FROM	pm_users
		WHERE user_name = 'username'
	</cfquery>
	
	<cfquery datasource="#variables.datasource#">
		DELETE FROM pm_projects
		WHERE title = 'title'
	</cfquery>
	
	<cfquery datasource="#variables.datasource#">
		DELETE FROM pm_project_notes
		WHERE content = 'content'
	</cfquery>
	
	<cfquery datasource="#variables.datasource#" result="user_id">
		INSERT INTO pm_users
		SET	user_name = 'username',
			password = 'password',
			email = 'test@test.com',
			description = 'description',
			gh_username = 'gh_username'
	</cfquery>

	<cfquery datasource="#variables.datasource#" result="project_id">
		INSERT INTO pm_projects
		SET title = 'title',
			description = 'description',
			date_created = NOW(),
			manager_id = #user_id.generatedkey#,
			image_url = 'test.jpg',
			gh_repository_id = '00000'
	</cfquery>

	<cfquery datasource="#variables.datasource#" result="note_id">
		INSERT INTO pm_project_notes
		SET content = 'content',
			projects_id = #project_id.generatedkey#,
			user_id = #user_id.generatedkey#,
			date_added = NOW()
	</cfquery>

	<cfquery datasource="#variables.datasource#">
		INSERT INTO pm_projects_to_users
		SET projects_id = #project_id.generatedkey#,
			user_id = #user_id.generatedkey#
	</cfquery>
	<cfset model = new _model_project("projectDevelopment")>
	<!---end test querys--->

<describe hint = "_model_project.cfc for maistre">

	<it should = "be an object">
		<cfset $(model).shouldBeObject()>
	</it>
	
	<!---                       								promote_user   																--->
	<describe hint="**** promote_user method ****">
		<cfset args = {}>
		<cfset args.project_id = project_id.generatedkey>
		<cfset args.promote_user_id = user_id.generatedkey>
		
		<it should="return a -1 if the promote fails">
			<cfset $(model).promote_user(argumentCollection = args).shouldBeNumeric()>
		</it>
		<it should="return the promoted user's id if the promote is successful">
			<cfset $(model.promote_user(argumentCollection = args)).shouldEqual(args.project_id)>
		</it>
	</describe><!---end promote_user--->
	
	<!---                       								remove_user   																--->
	<describe hint="**** remove_user method ****">
		<cfset args = {}>
		<cfset args.project_id = project_id.generatedkey>
		<cfset args.remove_user_id = user_id.generatedkey>
		
		<it should="return a -1 if the remove fails">
			<cfset $(model).remove_user(argumentCollection = args).shouldBeNumeric()>
		</it>
		<it should="return the removed user's id if the remove is successful">
			<cfset $(model.remove_user(argumentCollection = args)).shouldEqual(args.project_id)>
		</it>
	</describe><!---end remove_user--->
	
	<!---                       								edit_project_note 		  													--->
	<describe hint="**** edit_project_note method ****">
		<cfset args={}>
		<cfset args.project_note_id = note_id.generatedkey>
		<cfset args.content = "content">
		
		<it should="return a -1 if the edit fails">
			<cfset $(model).edit_project_note(argumentCollection = args).shouldBeNumeric()>
		</it>
		<it should="return the edited note's id if the edit is successful">
			<cfset $(model.edit_project_note(argumentCollection = args)).shouldEqual(#args.project_note_id#)>
		</it>
	</describe> <!---end edit_project_note--->
	
	<!---                       								delete_project_note   														--->
	<describe hint="**** get_user_login method ****">
		<cfset args = {}>
		<cfset args.project_note_id = note_id.generatedkey>
		
		<it should="return a -1 if the delete fails">
			<cfset $(model).delete_project_note(argumentCollection = args).shouldBeNumeric()>
		</it>
		<it should="return the deleted note's id if the delete is successful">
			<cfset $(model.delete_project_note(argumentCollection = args)).shouldEqual(#args.project_note_id#)>
		</it>
	</describe><!---end delete_project_note--->
</describe>
			</cfquery>
				FROM pm_projects_to_users
				WHERE user_id=(SELECT users_id FROM pm_users WHERE user_name=<cfqueryparam value="username">)