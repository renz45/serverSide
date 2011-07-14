<cfset logout_success = application._model_user.logout()>
<cflocation url="index.cfm" addtoken="false" >