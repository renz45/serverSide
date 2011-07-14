<cfsetting showdebugoutput="false" >
<cfset variables.datasource = "projectDevelopment">
<cfimport taglib="/cfspec">

<cfset model = new _model_github("projectDevelopment")>
<describe hint="_model_github.cfc for maistre">

	
	<it should="be an object">
		<cfset $(model).shouldBeObject()>
	</it>
<!--- get_user_info --->
	<describe hint="****get_user_info****">
		<describe hint="should return struct">
			<it should="be a struct">
				<cfset $(model).get_user_info("john").shouldBeStruct()>
			</it>
			<!---<it should="return a -1">
				<cfset $(model).get_user_info("").shouldEqual(-1)>
				
			</it>--->
		</describe>
	</describe>
	
<!--- get_repository --->
	<describe hint="****get_repository****">
		<describe hint="should return any">
			<it should="should return repo list">
				<cfset $(model).get_repository("john","john").shouldBeStruct()>
			</it>
		</describe>
	</describe>	
<!--- get_commits --->	
	<describe hint="****get_commits****">
		<describe hint="should be array">
			<it should="an array">
				<cfset $(model).get_commits("john","john","master").shouldBeArray()>
			</it>
		</describe>
	</describe>
</describe>

