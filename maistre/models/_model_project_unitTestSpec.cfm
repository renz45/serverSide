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
</describe><cfquery datasource="#variables.datasource#">		DELETE FROM			pm_users		WHERE			user_name='test username 523411'</cfquery><cfquery datasource="#variables.datasource#" result="project_id">	DELETE FROM		pm_projects	WHERE		title='test title 1237771233'</cfquery><cfquery datasource="#variables.datasource#" result="user_id">	INSERT INTO 		pm_users	SET		user_name='test username 523411',		password='937EE4AF1A7A08949AFA0AC110229FCE',		email='test@test.com2387123',		gh_username='gh_tester126128',		description='test description 1283999992321237787',		image_url='test.jpg 1239812996523',		date_added=NOW()</cfquery><cfquery datasource="#variables.datasource#" result="project_id">	INSERT INTO 		pm_projects	SET		title='test title 1237771233',		description='test description 123897723',		date_created=NOW(),		manager_id=#user_id.generatedkey#,		image_url='testporject.jpg 0987368723',		gh_repository_id='89238'</cfquery><cfset model = new _model_project("projectDevelopment")><cfset args2={}><cfset args2.title="default test test 1238721376623"><cfset args2.description="default 2test test 981237721"><cfset args2.project_id=project_id.generatedkey><cfset args2.user_id=user_id.generatedkey><cfset args2.gh_repository_id=89273><cfset args2.project_image_url="myimage256.jpg"><describe hint="_model_project.cfc spec sheet for maistre">	<it should="be an object">		<cfset $(model).shouldBeObject()>	</it>		<describe hint="add_project">		<cfset args={}>		<cfset args.user_id=user_id.generatedkey>		<cfset args.title="321testproject">		<cfset args.description="18description92">		<cfset args.gh_repository_id=98743>		<cfset args.project_image_url="myimage56.jpg">				<cfset args.project_id=project_id.generatedkey>				<it should="add a new project">			<cfset model.add_project(argumentCollection=args)>			<cfquery datasource="#variables.datasource#" name="check_project_add">				SELECT title				FROM pm_projects				WHERE title="#args.title#"
			</cfquery>			<cfset $(check_project_add.title).shouldEqual(#args.title#) >		</it>		<it should="return a -1 if the add fails">			<cfset args.project_id=9816723891283978970128703879128791238977897891>			<cfset $(model).add_project(argumentCollection=args).shouldBeNumeric()>			<cfset args.project_id=project_id.generatedkey>		</it>				<it should="return the created project's id if the add is successful">			<cfset test = model.add_project(argumentCollection=args)>			<cfquery datasource="#variables.datasource#" name="project_added_success">				SELECT projects_id FROM pm_projects WHERE title = '#args.title#'			</cfquery>			<cfset $(project_added_success.projects_id).shouldEqual(#test#) >		</it>		<cfquery datasource="#variables.datasource#">			DELETE FROM pm_projects			WHERE title="#args.title#"		</cfquery>	</describe><!--- end add_project --->		<describe hint="get_projects">		<it should="return a struct">			<cfset $(model.get_projects(5,1)).shouldBeStruct()>		</it>		<describe hint="returned struct">				<it should="have the correct keys '{query,count}'">					<cfset $( structKeyList(model.get_projects(5,1))).shouldEqual("QUERY,COUNT")>				</it>			<describe hint="struct.query">			<cfset test = model.get_projects(5,1)>				<it should="be a query">					<cfset $(test.query).shouldBeQuery()>				</it>				<it should="have the right columns: DATE_COMPLETED,DATE_CREATED,DESCRIPTION,IMAGE_URL,PROJECTS_ID,STATUS,TITLE,USER_NAME">					<cfset $(test.query.columnList).shouldEqual("DATE_COMPLETED,DATE_CREATED,DESCRIPTION,IMAGE_URL,PROJECTS_ID,STATUS,TITLE,USER_NAME")>				</it>			</describe>			<describe hint="struct.count">				<it should="be a numeric value">					<cfset test = model.get_projects(5,1)>					<cfset $(test.count).shouldBeNumeric()>				</it>			</describe>		</describe>	</describe><!--- end get_projects --->		<describe hint="edit_project">		<cfset project_added = model.add_project(argumentCollection=args2)>		<cfset args.projects_id = #project_added#>		<cfset args.user_id=user_id.generatedkey>		<cfset args.title="993editproject">		<cfset args.description="18descriptiondf92">		<cfset args.gh_repository=88543>		<cfset args.project_image_url="myimage56.jpg">		<it should="edit project information">			<cfset project_edited = model.edit_project(argumentCollection=args)>			<cfquery datasource="#variables.datasource#" name="edited_project_info">				SELECT 					title				FROM					pm_projects				WHERE 					projects_id=#project_added#			</cfquery>			<cfset $(edited_project_info.title).shouldEqual("993editproject")>		</it>		<it should="return a numeric value">			<cfset project_edited = model.edit_project(argumentCollection=args)>			<cfset $(project_edited).shouldBeNumeric()>		</it>		<describe hint="returned value">			<it should="return a -1 if there was an error">				<cfset args.user_id=498123897123891238891238712378912387913>				<cfset project_edited = model.edit_project(argumentCollection=args)>				<cfset $(project_edited).shouldEqual(#project_added#)>			</it>			<it should="return the edited project's id if edit was successful">				<cfset project_edited = model.edit_project(argumentCollection=args)>				<cfset $(project_edited).shouldEqual(#project_added#)>			</it>		</describe>		<cfquery datasource="#variables.datasource#">			DELETE FROM pm_projects			WHERE title="#args.title#"		</cfquery>	</describe><!--- end edit project --->		<describe hint="delete_project">		<it	should="delete a project">			<cfquery datasource="#variables.datasource#" result="temp_add_project">				INSERT INTO					pm_projects				SET					title="test 23901823",					description="delete me",					date_created=NOW(),					image_url="myimg.jpg"			</cfquery>						<cfset model.delete_project(temp_add_project.generatedkey)>			<cfquery datasource="#variables.datasource#" name="looking_for_deleted">				SELECT *				FROM					pm_projects				WHERE					projects_id = #temp_add_project.generatedkey#			</cfquery>			<cfset $(looking_for_deleted).shouldBeEmpty()>		</it>				<it should="should return a numeric value">			<cfquery datasource="#variables.datasource#" result="temp_add_project2">				INSERT INTO					pm_projects				SET					title="test 23901823",					description="delete me",					date_created=NOW(),					image_url="myimg.jpg"			</cfquery>			<cfset edit_test_value = model.delete_project(temp_add_project2.generatedkey)>					<cfset $(edit_test_value).shouldBeNumeric()>		</it>		<describe hint="returned numeric value">			<it should="be the deleted project's id if delete is successful">				<cfquery datasource="#variables.datasource#" result="temp_add_project2">					INSERT INTO						pm_projects					SET						title="test 23901823",						description="delete me",						date_created=NOW(),						image_url="myimg.jpg"				</cfquery>				<cfset edit_test_value = model.delete_project(temp_add_project2.generatedkey)>				<cfset $(edit_test_value).shouldEqual(temp_add_project2.generatedkey)>			</it>						<it should="be -1 if the delete fails">								<cfset edit_test_value = model.delete_project(-1)>				<cfset $(edit_test_value).shouldEqual(-1)>			</it>		</describe>	</describe><!--- end delete project --->		<describe hint="add_user">		<cfset args={}>		<cfset args.project_id=project_id.generatedkey>		<cfset args.username="username">				<it should="assign a user to a project">			<cfset model.add_user(argumentCollection=args)>			<cfquery datasource="#variables.datasource#" name="check_user_add">				SELECT projects_id				FROM pm_projects_to_users				WHERE user_id=(SELECT users_id FROM pm_users WHERE user_name=<cfqueryparam value="username">)			</cfquery>			<cfset $(check_user_add.projects_id).shouldEqual(#args.project_id#-1) >		</it>		<it should="return a -1 if the add fails">			<cfset args.project_id=9816723891283978970128703879128791238977897891>			<cfset $(model).add_user(argumentCollection=args).shouldBeNumeric()>			<cfset args.project_id=project_id.generatedkey>		</it>				<it should="return the project's id if the add is successful">			<cfset test = model.add_user(argumentCollection=args)>			<cfquery datasource="#variables.datasource#" name="user_added_success">				SELECT projects_id
				FROM pm_projects_to_users
				WHERE user_id=(SELECT users_id FROM pm_users WHERE user_name=<cfqueryparam value="username">)			</cfquery>			<cfset $(user_added_success.projects_id).shouldEqual(#test#-1) >		</it>		<cfquery datasource="#variables.datasource#">			DELETE FROM pm_projects_to_users			WHERE user_id=(SELECT users_id FROM pm_users WHERE user_name=<cfqueryparam value="username">)			AND projects_id="#args.project_id#"		</cfquery>	</describe>		<describe hint="add_project_note">		<cfset args={}>		<cfset args.user_id=user_id.generatedkey>		<cfset args.project_id=project_id.generatedkey>		<cfset args.content="5827testnote">				<it should="add a new project note">			<cfset model.add_project_note(argumentCollection=args)>			<cfquery datasource="#variables.datasource#" name="check_project_add">				SELECT content				FROM pm_project_notes				WHERE content="#args.content#"			</cfquery>			<cfset $(check_project_add.content).shouldEqual(#args.content#) >		</it>		<it should="return a -1 if the add fails">			<cfset args.project_id=9816723891283978970128703879128791238977897891>			<cfset $(model).add_project_note(argumentCollection=args).shouldBeNumeric()>			<cfset args.project_id=project_id.generatedkey>		</it>				<it should="return the created note's id if the add is successful">			<cfset test = model.add_project_note(argumentCollection=args)>			<cfquery datasource="#variables.datasource#" name="project_added_success">				SELECT project_note_id 				FROM pm_project_notes 				WHERE content = '#args.content#'			</cfquery>			<cfset $(project_added_success.project_note_id).shouldEqual(#test#) >		</it>		<cfquery datasource="#variables.datasource#">			DELETE FROM pm_project_notes			WHERE content="#args.content#"		</cfquery>	</describe>		<describe hint="delete_project_note">		<it	should="delete a project note">			<cfquery datasource="#variables.datasource#" result="temp_add_note">				INSERT INTO					pm_project_notes				SET					content="test 23901823",					projects_id=1,					user_id=1,					date_added=NOW()			</cfquery>						<cfset model.delete_project_note(temp_add_note.generatedkey)>			<cfquery datasource="#variables.datasource#" name="looking_for_deleted">				SELECT *				FROM					pm_project_notes				WHERE					projects_id = #temp_add_note.generatedkey#			</cfquery>			<cfset $(looking_for_deleted).shouldBeEmpty()>		</it>				<it should="should return a numeric value">			<cfquery datasource="#variables.datasource#" result="temp_add_note2">				INSERT INTO					pm_project_notes				SET					content="test 23901823",					projects_id=1,					user_id=1,					date_added=NOW()			</cfquery>			<cfset edit_test_value = model.delete_project_note(temp_add_note2.generatedkey)>					<cfset $(edit_test_value).shouldBeNumeric()>		</it>		<describe hint="returned numeric value">			<it should="be the deleted project's id if delete is successful">				<cfquery datasource="#variables.datasource#" result="temp_add_note2">					INSERT INTO						pm_project_notes					SET						content="test 23901823",						projects_id=1,						user_id=1,						date_added=NOW()				</cfquery>				<cfset edit_test_value = model.delete_project_note(temp_add_note2.generatedkey)>				<cfset $(edit_test_value).shouldEqual(temp_add_note2.generatedkey)>			</it>						<it should="be -1 if the delete fails">								<cfset edit_test_value = model.delete_project_note(-1)>				<cfset $(edit_test_value).shouldEqual(-1)>			</it>		</describe>	</describe>		<describe hint="get_project_notes">		<cfset args={}>		<cfset args.title="test test 1238721376623">		<cfset args.description="2test test 981237721">				<cfset args.project_id=project_id.generatedkey>		<cfset args.user_id=user_id.generatedkey>		<cfset args.notes_per_page=5>		<cfset args.page=1>				<it should="return a struct">			<cfset $(model.get_project_notes(argumentCollection=args)).shouldBeStruct()>		</it>		<describe hint="returned struct">				<it should="have the correct keys QUERY,COUNT">					<cfset $( structKeyList(model.get_project_notes(argumentCollection=args))).shouldEqual("QUERY,COUNT")>				</it>			<describe hint="struct.query">			<cfset test = model.get_project_notes(argumentCollection=args)>				<it should="be a query">					<cfset $(test.query).shouldBeQuery()>				</it>				<it should="have the right columns: CONTENT,DATE_ADDED,PROJECTS_ID,PROJECT_NOTE_ID,USER_ID">					<cfset $(test.query.columnList).shouldEqual("CONTENT,DATE_ADDED,PROJECTS_ID,PROJECT_NOTE_ID,USER_ID")>				</it>			</describe>			<describe hint="struct.count">			<cfset test = model.get_project_notes(argumentCollection=args)>				<it should="be a numeric value">					<cfset $(test.count).shouldBeNumeric()>				</it>			</describe>		</describe>	</describe>		<cfquery name="clean_up" datasource="#variables.datasource#">		DELETE FROM pm_projects		WHERE title="#args2.title#"		OR title="test title 1237771233"	</cfquery></describe>