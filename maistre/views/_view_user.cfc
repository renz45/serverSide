<cfcomponent>
	
	<cffunction name="show_signup_form" returntype="void" hint="shows the benefits for signing up">
		<cfargument name="error_list" type="array" required="false" default="#[]#">
		<cfset arrValidChars = ListToArray("a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z" & "2,3,4,5,6,7,8,9") />
		<cfset CreateObject("java","java.util.Collections").Shuffle(arrValidChars) />
		<cfset captcha_opt = (arrValidChars[ 1 ] & arrValidChars[ 2 ] & arrValidChars[ 3 ] & arrValidChars[ 4 ] & arrValidChars[ 5 ] & arrValidChars[ 6 ] & arrValidChars[ 7 ] & arrValidChars[ 8 ]) />
		<cfset form.captcha_check = hash(captcha_opt,"MD5") />
		<cfoutput>
	        <div id="signup" class="right form">
	          <h3>Make an account</h3>
	      	  <cfset application._view_unique.show_errors(error_list)>
	          <cfform method="post" action="index.cfm">
	            <label for="username">Username</label>
	            <input type="text" name="username" id="username" value="" required="true" message="Username required" >
	            <label for="password">Password</label>
	            <input type="password" name="password" id="password" value="" required="true" message="Password required" >
	            <label for="email">Email</label>
	            <input type="text" name="email" id="email" value="" required="true" message="Email required" >
	            <label for="gh_username">Github Username:</label>
	            <input type="text" name="gh_username" id="gh_username" value="" >
	            <a class="modal_link" href="signup">Sign up</a>
	            <div class="modal signup">
	              <p>Are you human?</p>
				  <input type="hidden" name="captcha_check" value="#form.captcha_check#" />
	              <cfimage action="captcha" height="50" width="275" text="#captcha_opt#" difficulty="medium" fonts="verdana,arial,times new roman,courier" fontsize="28" />
	              <input type="text" name="captcha_text" required="true" message="Captcha required" >
	              <input type="submit" name="signup_submit" class="submit" value="Sign up" >
	              <input type="submit" name="cancel" class="cancel" value="Cancel" >
	            </div>
	          </cfform>
	        </div>
		</cfoutput>
	</cffunction><!--- ends show_signup_form --->
	
	
	
	<cffunction name="show_user_list" returntype="void">
 		<cfargument name="query" required="true" type="query" >
 		<cfargument name="total_item_count" required="true" type="numeric" hint="total number of items(probably count variable from a get model function)">
		<cfargument name="items_per_page" required="true" type="numeric" hint="total items per page">
		<cfargument name="page_to_load" required="true" type="string"  hint="page to reload(probably the current controller)">
		<cfargument name="page" required="true" type="numeric"  hint="current_page(probably a url.page)">
		<cfargument name="load_home" required="false" default="false">
		<cfargument name="show_search" type="boolean" required="false" default="false">
		<cfargument name="enable_remove" type="boolean" required="false" default="false">
		<cfargument name="manager_id" type="numeric" required="false" default=-1>
		<cfargument name="url" required="false" default="#{}#" hint="global url to preserve values for pagination">
		
		<cfargument name="anchor" required="false" default="" type="string" hint="Anchor to skip to(optional) defailts to empty string">
 		<cfoutput>
 		<div id="users" class="left">
		  <cfif load_home eq true>
		  	<h2>Who's Using <span class="logo">maistre</span> for their projects now?</h2>
		  <cfelse>
          	<h2>Project Members</h2>
			<cfif arguments.show_search eq true>
				<form method="post" action="add_member.cfm" name="add_member">
		            <input type="text" name="username" value="" />
					<input type="hidden" name="project_id" value="#url.project_id#" />
		            <input type="submit" name="add_member_submit" value="Add Member" />
	         	 </form>
			</cfif>
		  </cfif>
          <ul>
          
		  
          <cfif isNull(arguments.url.project_id ) or arguments.url.project_id neq -1>
	          <cfloop query="arguments.query">
				  <cfset file_test = reFind(".[Jj][Pp][Gg]",#image_url#) + reFind(".[Gg][Ii][Ff]",#image_url#) + reFind("[Pp][Nn][Gg]",#image_url#) + reFind("[Bb][Ii][Tt]",#image_url#) >
				  
				  <cfif #image_url# CONTAINS 'http://'>
				  	<cfset file_test = 5>
				  </cfif>
				  
		            <li style="width:50px;">
						<a href="portfolio.cfm?user_id=#users_id#" title="#user_name#">
							<img src="<cfif #image_url# CONTAINS 'http://'><cfelse>images_members/</cfif><cfif image_url eq '' or file_test eq 0>default_image.png " alt="default maistre image"<cfelse>#image_url#"alt="image of #user_name#"</cfif> width="50" height="50" />
						</a>
						<cfif enable_remove eq true>
							<cfif arguments.manager_id neq #arguments.query.users_id#> 
								<a style="color:##70b219;" href="modify_project.cfm?delete_user=#users_id#&amp;project_id=#arguments.url.project_id#">
									remove
								</a>
							<cfelse>
								<span style="color:##000;">
									Manager
								</span>
							</cfif>
						</cfif>
					</li>
		        </cfloop>
			</cfif>
          </ul>
		  <cfif load_home eq true>
			  <p><a href="portfolio.cfm">more members...</a></p>
		  <cfelse>
			  <cfset args = {} >
			  <cfset args.total_item_count = arguments.total_item_count >
			  <cfset args.items_per_page = arguments.items_per_page >
			  <cfset args.page_to_load = arguments.page_to_load >
			  <cfset args.page = arguments.page >
			  <cfset args.url = arguments.url>
	          <cfset application._view_unique.show_pagination(argumentCollection = args)>
		  </cfif>
		
        </div>
		</cfoutput>
 </cffunction><!--- end show_user_list --->

</cfcomponent>