<cfcomponent>
<cfsetting showdebugoutput="false" >
	<!---naming a function init makes this function the constructor of the component--->
	<cffunction name="init" returntype="Any" >
		<cfargument name="datasource" type="string" required="true">
		
		<cfset variables.datasource = arguments.datasource>
		
		<!---constructor always has to return itself--->
		<cfreturn this>
	</cffunction><!---end init--->
	
	
	<cffunction name="get_user_info" returntype="struct"  hint="gets user info from github, data returned as a structure">
		<cfargument name="gh_user_name" type="string" required="true" >
		
		<cfhttp method="get" url="http://github.com/api/v2/xml/user/search/#arguments.gh_user_name#" result="xml_result">
		
		
		<cfif (xml_result.statusCode CONTAINS "200") and (xml_result.mimeType CONTAINS "xml") and (isXML(xml_result.fileContent))>
		
			<cfset xml=xmlParse(xml_result.filecontent).users.xmlchildren[1].xmlchildren>
			
			
			<cfset user_info = {}>
			<cfloop array="#xml#" index="entry">
				<cfset structAppend(user_info, {#entry.xmlname# = #entry.xmltext#}) > 
			</cfloop>
			
			<cfreturn user_info >
		<cfelse>
			<cfreturn {error=-1}>
		</cfif>
	
	</cffunction><!--- end get_user_info --->
	
	
	
	<cffunction name="get_repository" returntype="any"  hint="gets repository info from github, data returned as a structure">
		<cfargument name="gh_user_name" type="string" required="true" >
		<cfargument name="gh_repo_name" type="string" required="false" default="" >
		
		<cfhttp method="get" url="http://github.com/api/v2/xml/repos/show/#arguments.gh_user_name#/#arguments.gh_repo_name#" result="xml_result">
		
		<!---<cfdump var="#xmlParse(xml_result.filecontent).repositories.xmlchildren#">--->
		
		<cfif (xml_result.statusCode CONTAINS "200") and (xml_result.mimeType CONTAINS "xml") and (isXML(xml_result.fileContent))>
			
			<cfif arguments.gh_repo_name neq "">
			
				<cfset xml = #xmlParse(xml_result.filecontent).repository.xmlchildren#>
				
				<cfset repo_list = {}>
				
				<cfloop array="#xml#" index="entry">
					<cfset structAppend(repo_list,{#entry.xmlname# = entry.xmltext})>
				</cfloop>
			
			<cfelse>
				<cfset xml=xmlParse(xml_result.filecontent).repositories.xmlchildren>
				
				<cfset repo_list = []>
				<cfset count = 1>
				<cfloop array="#xml#" index="repo">
					
					<cfset repo_list[count] = structnew()>
					<cfloop array="#repo.xmlchildren#" index="child">
						
						<cfset structAppend(repo_list[count], {#child.xmlname# = #child.xmltext#})>
						
					</cfloop>
	
					<cfset count++>
				</cfloop>
				<cfset user_info = {}>
				
			</cfif>
			<cfreturn repo_list >	
		<cfelse>
			<cfreturn {error=-1}>
		</cfif>
		
	
	</cffunction><!--- end get_repository --->
	
	
	<cffunction name="get_commits" returntype="array" hint="returns commits for a github repository for a user or all commits">
		<cfargument name="gh_user_name" type="string" required="true" >
		<cfargument name="gh_repo_name" type="string" required="true">
		<cfargument name="branch" type="string" required="true">
		
		<cfhttp method="get" url="http://github.com/api/v2/xml/commits/list/#arguments.gh_user_name#/#arguments.gh_repo_name#/#arguments.branch#" result="xml_result">
		
		
		
		<cfif (xml_result.statusCode CONTAINS "200") and (xml_result.mimeType CONTAINS "xml") and (isXML(xml_result.fileContent))>
			
		
			
			<cfset xml = xmlParse(xml_result.filecontent).commits.xmlchildren>
			<cfset commit_list = []>
			
		
			
			<cfset count = 1>
			<cfloop array="#xml#" index="commit">
				<cfset commit_list[count] = {}>
				
				<cfloop array="#commit.xmlchildren#" index="commit_info">
					
					<cfif arraylen(commit_info.xmlchildren) lt 1>
						<cfset structAppend(commit_list[count],{#commit_info.xmlname# = commit_info.xmltext})>
					<cfelse>
						<cfset structAppend(commit_list[count],{#commit_info.xmlname# = {}})>
						
						<cfset count2=1>
						<cfloop array="#commit_info.xmlchildren#" index="more_info">
							<cfif arraylen(more_info.xmlchildren) lt 1>
								<cfset structAppend(commit_list[count][#commit_info.xmlname#],{#more_info.xmlname# = more_info.xmltext})>
							<cfelse>
								<cfset structAppend(commit_list[count][#commit_info.xmlname#],{#count2# = {}})>
								
								<cfloop array="#more_info.xmlchildren#" index="still_more_info">	
									<cfset structAppend(commit_list[count][#commit_info.xmlname#][#count2#],{#still_more_info.xmlname# = still_more_info.xmltext})>				
								</cfloop>
							</cfif>
							<cfset count2++>
						</cfloop>
					</cfif>

				</cfloop>			
				<cfset count++>
			</cfloop>
			<cfreturn commit_list>
		<cfelse>
			<cfreturn [-1]>	
		</cfif>
	</cffunction><!--- end get_commits --->
	
	
</cfcomponent>