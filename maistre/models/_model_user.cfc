<cfcomponent hint="model containing functions for user related queries">
	<cfsetting showdebugoutput="false" >
	<!---naming a function init makes this function the constructor of the component--->
	<cffunction name="init" returntype="Any" >
		<cfargument name="datasource" type="string" required="true">
		
		<cfset variables.datasource = arguments.datasource>
		
		<!---constructor always has to return itself--->
		<cfreturn this>
	</cffunction><!---end init--->

<!---														add_user														--->
	<cffunction name="add_user" returntype="Numeric"  hint="creates a new user">
		<cfargument name="username" type="string" required="true" >
		<cfargument name="password" type="string" required="true" >
		<cfargument name="email" type="string" required="true" >
		<cfargument name="gh_username" type="string" required="false" default="">
		
		
		<cfif arguments.password neq "">
			<cfset arguments.password = hash(arguments.password,"MD5")>
		</cfif>
		
		<cftry>
			<cfquery datasource="#variables.datasource#" result="user_added">
				INSERT INTO 
					pm_users 
				SET
					user_name=<cfqueryparam value="#arguments.username#" cfsqltype="cf_sql_varchar" >,
					password=<cfqueryparam value="#arguments.password#" cfsqltype="cf_sql_char"  >,
					email=<cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar" >,
					image_url="default_image.png",
					gh_username=<cfqueryparam value="#arguments.gh_username#">,
					date_added=NOW()
					
			</cfquery>
	
			<cfreturn #user_added.generatedkey#>
		
		<cfcatch type="database" >
			<cfreturn -1>
		</cfcatch>
		
		</cftry>
		
	</cffunction><!--- end create_user --->
	
	
	
	<!---												delete_user														--->
	<cffunction name="delete_user" returntype="Numeric"  hint="deletes a user">
		<cfargument name="user_id" type="numeric" required="true" >
		<cfargument name="password" type="string" required="true" >
		
		<cfif arguments.password neq "">
			<cfset arguments.password = hash(arguments.password,"MD5")>
		</cfif>
		
		<cftry>
			<cfquery datasource="#variables.datasource#" result="user_deleted">
				DELETE FROM
					pm_users 
				WHERE users_id=<cfqueryparam value="#arguments.user_id#"> AND password=<cfqueryparam value="#arguments.password#">		
			</cfquery>
	
			<cfreturn #arguments.user_id#>
		
		<cfcatch type="database" >
			<cfreturn -1>
		</cfcatch>
		
		</cftry>
	</cffunction><!--- end delete_user --->
	
	
	
	<!---												get_users														--->
	<cffunction name="get_users" returntype="struct"  hint="gets a list of users and the total count sorted by project single user or all users">
		<cfargument name="users_per_page" type="numeric" required="true" >
		<cfargument name="page" type="numeric" required="true" >
		<cfargument name="project_id" type="numeric" required="false" default=-2 hint="setting this returns a list of users for a specific project" >
		<cfargument name="user_id" type="numeric" required="false" default=-1 hint="setting this returns one user matching the user_id" >
		<cfargument name="use_pagination" type="boolean" required="false" default=true hint="turns pagination off and returns all users" >
		
		<cfif arguments.project_id eq -1>
			<cfreturn {query=queryNew("
												users_id,
												user_name,
												password,
												email,
												gh_username,
												description,
												image_url,
												date_added
											"), count=0}>
		</cfif>
		<cftry>
			<cfquery datasource="#variables.datasource#" name="local.user_list">
				SELECT 
					u.users_id,
					u.user_name,
					u.password,
					u.email,
					u.gh_username,
					u.description,
					u.image_url,
					u.date_added
					<cfif arguments.project_id gt -1>
						,p.projects_id
					</cfif>
				FROM
					pm_users AS u
				<cfif arguments.project_id gt -1>
					INNER JOIN pm_projects_to_users AS p ON(u.users_id = p.user_id ) AND (p.projects_id = <cfqueryparam value="#arguments.project_id#" cfsqltype="cf_sql_integer" >)
				</cfif>
					
				<cfif arguments.user_id gt -1>
					 WHERE users_id=<cfqueryparam value="#arguments.user_id#" cfsqltype="cf_sql_integer" >
				 <cfelse>
					ORDER BY date_added DESC
					<cfif arguments.use_pagination eq true>
						LIMIT #(arguments.page-1) * arguments.users_per_page#,#arguments.users_per_page#
					</cfif>
				</cfif>
	
			</cfquery>
	
		<cfcatch type="database" >
			
			<cfif arguments.project_id gt -1>
				<cfset local.user_list = queryNew("
												users_id,
												user_name,
												password,
												email,
												gh_username,
												description,
												image_url,
												date_added,
												projects_id
											")>
			<cfelse>
				<cfset local.user_list = queryNew("
												users_id,
												user_name,
												password,
												email,
												gh_username,
												description,
												image_url,
												date_added
											")>
			</cfif>
		</cfcatch>
		</cftry>
			
		<cftry>	
			<cfquery datasource="#variables.datasource#" name="local.user_count">
				SELECT 
					count(*) as count
				FROM
					pm_users AS u
				<cfif arguments.project_id gt -1>
					INNER JOIN pm_projects_to_users AS p ON(u.users_id = p.user_id ) AND (p.projects_id = <cfqueryparam value="#arguments.project_id#" cfsqltype="cf_sql_integer" >)
				</cfif>
				<cfif arguments.user_id lt -1>
					 WHERE users_id=<cfqueryparam value="#arguments.user_id#" cfsqltype="cf_sql_integer" >
				 </cfif>
			</cfquery>
		
		<cfcatch type="database" >
			<cfset local.user_count.count = -1>
		</cfcatch>
		</cftry>
		
		<cfreturn {query=local.user_list,count=local.user_count.count}>
	</cffunction><!--- end get_users --->
	
	
	
	<!---												edit_user_profile														--->
	<cffunction name="edit_user_profile" returntype="Numeric"  hint="deletes a user">
		<cfargument name="user_id" type="numeric" required="true" >
		<cfargument name="password" type="string" required="false" default="" >
		<cfargument name="avatar_url" type="string" required="false" default="" >
		<cfargument name="email" type="string" required="false" default="" >
		<cfargument name="description" type="string" required="false" default="" >
		<cfargument name="gh_username" type="string" required="false" default="" hint="git hub user name" >

		<cfif arguments.password neq "">
			<cfset arguments.password = hash(arguments.password,"MD5")>
		</cfif>
	
		
		<cftry>
			<cfquery datasource="#variables.datasource#" name="local.edit_user">
				UPDATE 
					pm_users
				SET
					<cfif arguments.password neq "">
						password=<cfqueryparam value="#arguments.password#" cfsqltype="cf_sql_char"  >,
					</cfif>
					<cfif arguments.email neq "">
						email=<cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar" >,
					</cfif>
					<cfif arguments.gh_username neq "">
						gh_username=<cfqueryparam value="#arguments.gh_username#" cfsqltype="cf_sql_varchar" >,
					</cfif>
					<cfif arguments.description neq "">
						description=<cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_longvarchar"  >,
					</cfif>
					<cfif arguments.avatar_url neq "">
						image_url=<cfqueryparam value="#arguments.avatar_url#">,
					</cfif>
					users_id = <cfqueryparam value="#arguments.user_id#">
				WHERE users_id = <cfqueryparam value="#arguments.user_id#">
			</cfquery>
			
			<cfreturn #arguments.user_id#>
		
		<cfcatch type="database" >
			<cfreturn -1>
		</cfcatch>
		
		</cftry>
	</cffunction><!--- end edit_user_profile --->
	
	
	<!---												get_user_login														--->
	<cffunction name="get_user_login" returntype="Query" hint="returns user name and user_id if login and password match">
		<cfargument name="username" type="string" required="true" >
		<cfargument name="password" type="string" required="true" >
		
		<cfparam name="error_message" type="string" default="">
		
		<cfif arguments.password neq "">
			<cfset arguments.password = hash(arguments.password,"MD5")>
		<cfelse>
			<cfset error_message &= "Please enter a password<br/>">
		</cfif>
		
		<cfif arguments.username eq "">
			<cfset error_message &= "Please enter a user name <br/>">
		</cfif>
		
		<cfif error_message neq "">
			<cfthrow message="#error_message#">
		</cfif>
		
		<cftry>
			<cfquery datasource="#variables.datasource#" name="login_data">
				SELECT
					user_name,
					users_id
				FROM pm_users
				WHERE 
					user_name = <cfqueryparam value="#arguments.username#" cfsqltype="cf_sql_varchar" > AND
					password = <cfqueryparam value="#arguments.password#" cfsqltype="cf_sql_varchar" >
			</cfquery>
			
			
		
		<cfcatch>
				<cfset local.login_data = queryNew("user_name,users_id")>
		</cfcatch>
		</cftry>
			<cfreturn #login_data#>
	
	</cffunction><!--- end get_user_login --->
	
	
	<!---												get_user														--->
	<cffunction name="get_user" returntype="String"  hint="returns true if user_id matches">
		<cfargument name="username" type="string" required="true" >
		<cftry>
			<cfquery datasource="#variables.datasource#" name="login_data">
				SELECT user_name
				FROM pm_users
				WHERE user_name = <cfqueryparam value="#arguments.username#" cfsqltype="cf_sql_varchar" >
			</cfquery>
			<cfcatch type="database">
					<cfreturn "">
			</cfcatch>
		</cftry>
		<cfif isQuery(login_data)>
			<cfreturn login_data.user_name>
		<cfelse>
			<cfreturn "">
		</cfif>
	</cffunction><!--- end get_user --->
	
	
	
	<!---												search_users														--->
	<cffunction access="public" name="search_users" returntype="Query" hint="matches string to user names">
		<cfargument name="search_query" type="string" required="true" >
		
		<cftry>
			<cfquery datasource="#variables.datasource#" name="search_data">
				SELECT
					user_name,
					users_id
				FROM pm_users
				WHERE 
					user_name LIKE '#arguments.search_query#%'
			</cfquery>
			
			
		
		<cfcatch>
				<cfset local.search_data = queryNew("user_name,users_id")>
		</cfcatch>
		</cftry>
			<cfreturn #search_data#>
	
	</cffunction><!--- end search_users --->
	
	
	<!---												add_to_portfolio														--->
	<cffunction name="add_to_portfolio" returntype="Numeric" hint="adds a project_id to the portfolio table for a user" >
		<cfargument name="user_id" type="numeric" required="true" >
		<cfargument name="project_id" type="numeric" required="true" >
		
		<cftry>
			<cfquery datasource="#variables.datasource#">
				INSERT INTO 
					pm_user_portfolios
				SET
					user_id=<cfqueryparam value="#arguments.user_id#" cfsqltype="cf_sql_integer" >,
					project_id=<cfqueryparam value="#arguments.project_id#" cfsqltype="cf_sql_integer" >
			</cfquery>
			
			<cfreturn arguments.project_id>
		<cfcatch>
			<cfreturn -1>
		</cfcatch>
		</cftry>
		
	</cffunction> <!---end add_to_portfolio--->
	
	
	
	<!---												delete_from_portfolio														--->
	<cffunction name="delete_from_portfolio" returntype="Numeric" hint="deletes a project_id from the portfolio table for a user" >
		<cfargument name="user_id" type="numeric" required="true" >
		<cfargument name="project_id" type="numeric" required="true" >
		
		<cftry>
			<cfquery datasource="#variables.datasource#">
				DELETE FROM
					pm_user_portfolios
				WHERE
					user_id=<cfqueryparam value="#arguments.user_id#" cfsqltype="cf_sql_integer" >
					AND
					project_id=<cfqueryparam value="#arguments.project_id#" cfsqltype="cf_sql_integer" >
			</cfquery>
			
			<cfreturn arguments.project_id>
		<cfcatch>
			<cfreturn -1>
		</cfcatch>
		</cftry>
		
	</cffunction> <!---end delete_from_portfolio--->
	
	
	
	
	<!---												get_portfolio														--->
	<cffunction name="get_portfolio" returntype="struct" hint="gets projects back for user portfolio page" >
		<cfargument name="users_per_page" type="numeric" required="true" >
		<cfargument name="page" type="numeric" required="true" >
		<cfargument name="user_id" type="numeric" required="true" >
		
		<cftry>
			<cfquery datasource="#variables.datasource#" name="local.portfolio_list">
			
				SELECT 
					p.projects_id,
					p.title,
					p.description,
					p.date_created,
					p.date_completed,
					p.manager_id,
					p.image_url,
					p.gh_repository_id	
				FROM
					pm_projects AS p
					INNER JOIN
						pm_user_portfolios as u
						ON(u.project_id = p.projects_id) 
						
						WHERE(u.user_id = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_varchar">)
				
					ORDER BY date_created DESC
					LIMIT #(arguments.page-1) * arguments.users_per_page#,#arguments.users_per_page#
	
			</cfquery>
		<cfcatch type="database" >
				<cfset local.portfolio_list = queryNew("
												projects_id,
												title,
												description,
												date_created,
												date_completed,
												manager_id,
												image_url,
												gh_repository_id	
											")>
		
		</cfcatch>
		</cftry>
			
		<cftry>	
			<cfquery datasource="#variables.datasource#" name="local.portfolio_count">
				SELECT 
					count(*) as count
				FROM
					pm_projects AS p
					INNER JOIN
						pm_user_portfolios as u
						ON(u.project_id = p.projects_id) AND (u.user_id = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_varchar">)
			</cfquery>
		
		<cfcatch type="database" >
			<cfset local.portfolio_count.count = -1>
		</cfcatch>
		</cftry>
		
		<cfreturn {query=local.portfolio_list,count=local.portfolio_count.count}>
		
	</cffunction> <!---end get_portfolio--->
	
	
	
	
	<!---												search_portfolio														--->
	<cffunction name="search_portfolio" returntype="struct" hint="gets projects back for user portfolio page" >
		<cfargument name="user_name" type="string" required="true" >
		
		<cftry>
			<cfquery datasource="#variables.datasource#" name="local.portfolio_list">
				SELECT user_name, users_id
				FROM pm_users 
				WHERE user_name LIKE '%#arguments.user_name#%'
				ORDER BY user_name DESC
			</cfquery>
			<cfcatch type="database" >
					<cfset local.portfolio_list = queryNew("user_name")>
			</cfcatch>
		</cftry>
		<cftry>	
			<cfquery datasource="#variables.datasource#" name="local.portfolio_count">
				SELECT count(*) as count
				FROM pm_users 
				WHERE user_name LIKE '%#arguments.user_name#%'
			</cfquery>
			<cfcatch type="database" >
				<cfset local.portfolio_count.count = -1>
			</cfcatch>
		</cftry>
		<cfreturn {query=local.portfolio_list,count=local.portfolio_count.count}>
	</cffunction> <!---end get_portfolio--->
	
	
	
		<!---												protect														--->
	<cffunction name="protect" returntype="void" hint="redirects user to index.cfm if they aren't logged in">
		<cfargument name="is_logged_in" type="boolean"  required="true">
	
		<cfparam name="session.is_logged_in" type="boolean" default="false">
		
		<cfif isNull(is_logged_in) or is_logged_in neq true>
			<cflocation url="index.cfm" addtoken="false" >
		</cfif><!---end log in check--->
	
	</cffunction><!--- end protect --->
	
	
	<cffunction name="advanced_protect" returntype="void" hint="checks to see if a user is part of the project assoc with the page, if they arent they get kicked back home.cfm">
		<cfargument name="project_id" type="numeric" required="true">
		<cfargument name="session_user_id" type="numeric" required="true">
		
		<cfif arguments.project_id eq -1>
			<cflocation url="home.cfm" addtoken="false" >
		</cfif>
		
		<cfset pu_args = {}>
		<cfset pu_args.users_per_page = 1>
		<cfset pu_args.page = 1>
		<cfset pu_args.project_id = arguments.project_id >
		<cfset pu_args.use_pagination = false>
		<cfset protect_users_results=application._model_user.get_users(argumentCollection = pu_args)>
		
		<cfset is_user_there = false>
		<cfloop query="protect_users_results.query">
			<cfif protect_users_results.query.users_id eq arguments.session_user_id>
				<cfset is_user_there = true>
			</cfif>
		</cfloop>
		<cfif is_user_there eq false>
			<cflocation url="home.cfm" addtoken="false">
		</cfif>
	</cffunction> <!---end advanced_protect--->
	
	
	<!---													login														--->
	<cffunction name="login" returntype="void" hint="redirects user to index.cfm if login fails">
		<cfargument name="username" type="string" required="true" default="">
		<cfargument name="password" type="string" required="true" default="">
		
		<cfif arguments.password neq "">
			<cfset arguments.password = hash(arguments.password,"MD5")>
		</cfif>
		
		<cftry>
			<cfquery name="login" datasource="#variables.datasource#">
				SELECT users_id, user_name
				FROM pm_users
				WHERE user_name = <cfqueryparam value="#arguments.username#"> 
				  AND password = <cfqueryparam value="#arguments.password#">
			</cfquery>
			<cfcatch type="database" >
				<cflocation url="index.cfm" addtoken="false" >
			</cfcatch>
		</cftry>
		<!---<cfquery name="user_project" datasource="#variables.datasource#">
			SELECT projects_id
			FROM pm_projects_to_users
			WHERE user_id = #login.users_id# 
			ORDER BY projects_id LIMIT 1
		</cfquery>--->
		<cfset session.is_logged_in = true>
		<cfset session.user_id = login.users_id>
		<cfset session.user_name = login.user_name>
		<cflocation url="home.cfm" addtoken="false">
	</cffunction><!--- end login --->
	
	<!---													logout														--->
	<cffunction name="logout" returntype="boolean" hint="redirects user to index.cfm on logout">
		<cfset session.is_logged_in = false>
		<cfset session.user_id = 0>
		<cfset session.user_name = "user">
		<cfreturn true>
	</cffunction><!--- end logout --->
	
	<cffunction name="rss" returntype="query" hint="rss">
	<cfargument name="project_id" type="numeric" required="true">
		<cfquery datasource="#variables.datasource#" name="Items">
		SELECT r.title AS title,
			p.content AS content, 
			p.date_added AS created, 
			u.user_name AS `name`,
			CONCAT('http://127.0.0.1/ASL/1009/project/maistre/dev/project.cfm?project_id=',CAST(p.projects_id AS CHAR)) AS link,
			'true' AS `true`
		FROM pm_project_notes AS p
			INNER JOIN pm_users AS u ON (p.user_id = u.users_id)
			LEFT JOIN pm_projects AS r ON (p.projects_id = r.projects_id)
			WHERE p.projects_id=<cfqueryparam value="#arguments.project_id#">
		GROUP BY 1, 2, 3, 4, 5
		ORDER BY p.date_added DESC
		</cfquery>
		<cfreturn Items>
	</cffunction>

</cfcomponent>