<cfset structDelete(session,"is_logged_in")>
<cfset structDelete(session,"user_name")>

<cflocation url="index.cfm" addtoken="false" >