<cfcomponent>

	<cffunction name="show_pagination" returntype="void" hint="outputs html for pagination - changes the page url variable accordingly">
		<cfargument name="total_item_count" required="true" type="numeric" hint="total number of items(probably count variable from a get model function)">
		<cfargument name="items_per_page" required="true" type="numeric" hint="total items per page">
		<cfargument name="page_to_load" required="true" type="string"  hint="page to reload(probably the current controller)">
		<cfargument name="page" required="true" type="numeric"  hint="current_page(probably a url.page)">
		
		<cfargument name="url_var" required="false" default="page" type="string"  hint="variable to look at in the url(example: page, task_list_page, user_list_page etc)">
		<cfargument name="url" required="false" type="any" default="-1" hint="if the url global is passed in the function will preserve the url">		
		<cfargument name="anchor" required="false" default="" type="string" hint="Anchor to skip to(optional) defailts to empty string">
		
		<cfif anchor neq "">
			<cfset anchor = "##" & anchor>
		</cfif>
		
		<cfif !isStruct(url) and url eq -1>
			<cfset url = {}>
		</cfif>
		
		<!--- preserve the url vars that exist, but delete the one used for the url_var --->
		<cfset big_url = "">
		<cfif structCount(arguments.url) gt 0>
			<cfset big_url = application._view_unique.preserve_url(arguments.url,true,"","",arguments.url_var)>
		</cfif>
		
		<cfset total_pages=#ceiling(total_item_count / INT(items_per_page))#>
		
		<cfoutput>
			  <div class="pagination">
			  
			  	<cfif page gt 1>	
		            <a href="#page_to_load#?#big_url##url_var#=1#anchor#">&laquo; first</a>
		            <a href="#page_to_load#?#big_url##url_var#=<cfif page gt 1>#page - 1#<cfelse>1</cfif>#anchor#">&lsaquo; previous</a>
				</cfif>
				
	            <span id="current">#page#</span> of <span id="total">#total_pages#</span>
				
				<cfif page lt total_pages>
		            <a class="right" href="#page_to_load#?#big_url##url_var#=#total_pages##anchor#">last &raquo;</a>
		            <a class="right" href="#page_to_load#?#big_url##url_var#=<cfif page lt total_pages>#page + 1#<cfelse>#total_pages#</cfif>#anchor#">next &rsaquo;</a>
	          	</cfif>
			  </div>

		</cfoutput>
	
	</cffunction> <!---end show_pagination--->



	<cffunction name="show_errors" returntype="void" hint="shows the error list in the modal panel">
		<cfargument name="error_list" type="array" required="true" default="#[]#">
      	<cfif arrayIsEmpty(error_list) neq true>
			<cfoutput>
				<ul id="error_list">
					<cfloop array="#error_list#" index="error">
						<li>#error#</li>
					</cfloop>
				</ul>
		</cfoutput>
      	</cfif>
	</cffunction><!--- ends show_errors --->

	
	
	
	<cffunction name="preserve_url" returntype="String" hint="the url global var is passed in, and is formatted for url arguments.  Returns a string ready to insert.">
		<cfargument name="url" type="struct" required="true" hint="url global">
		
		<cfargument name="include_last_amp" required="false" default=false hint="boolean to whether the last ampersand is include on the variable list, useful for if you want to manually add vars.">		
		<cfargument name="change_var_name" type="string" required="false" default="" hint="var to change that is already in the url global">
		<cfargument name="change_var_value" type="string" required="false" default="" hint="value of var to change that is already in the url global">
		<cfargument name="delete_var_value" type="string" required="false" default="" hint="deletes a var and its value from the url struct">
		
		<cfif arguments.change_var_name neq "" >
			<cfset url[#arguments.change_var_name#] = arguments.change_var_value>
		</cfif>
			
		<cfset new_url = ''>
		<cfif include_last_amp eq false>
			<cfset count=1>
		<cfelse>
			<cfset count=0>
		</cfif>
		<cfloop collection="#arguments.url#" item="url_item">
			<cfif arguments.delete_var_value neq "" and url_item neq arguments.delete_var_value or arguments.delete_var_value eq "">
				<cfset new_url&=url_item&"="&structFind(arguments.url,url_item)>
				
				<cfif count lt structCount(arguments.url)>
					<cfset new_url&="&">
				</cfif>
			</cfif>
			<cfset count++>
		</cfloop>
		
		<cfreturn new_url>
	
	</cffunction> <!---end preserve_url--->
	
	
	<cffunction name="show_chart" returntype="void" hint="display chart">
		<cfargument name="chartData" type="query" required="true" >
		<cfoutput>
			<!--- chart code --->
			
			
			<cfset colorList = []>
			<cfset count = 1>
			<cfloop query="chartData">
				<cfset colorList[count] = "##"& formatBaseN(randRange(inputBaseN("bedb39",16),inputBaseN("2b3308",16)),16)>
				<cfset count++>
			</cfloop>
			<!---<cfdump var="#arrayToList(colorList,",")#">--->
			<cfchart  format="png" scalefrom="0" scaleto="10" title="Tasks Per Person" font="arial" fontsize="12" chartwidth="350" show3d="true" >
			<cfchartseries type="pie" query="chartData" itemcolumn="x" valuecolumn="c" colorlist="#toString(arrayToList(colorList,','))#">
			</cfchart>
			<!--- end chart code --->
		</cfoutput>
	
	</cffunction>
	

</cfcomponent>