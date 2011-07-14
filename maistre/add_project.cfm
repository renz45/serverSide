<cfparam name="session.is_logged_in" default="false">
<cfset application._model_user.protect(session.is_logged_in) >

<!--- add_project(user_id,"title","description",gh_repository_id,"project_image_url") --->

<cfparam name="form.user_id" type="numeric" default=-1>
<cfparam name="form.title" type="string" default="">
<cfparam name="form.description" type="string"  default="">
<cfparam name="form.gh_repository_id" type="string"  default="">
<cfparam name="form.project_image">

<cfset args = {} > 
<cfset args.user_id = form.user_id >
<cfset args.title = form.title >
<cfset args.description = form.description >
<cfset args.gh_repository_id = form.gh_repository_id >

<cfif form.project_image neq "">
	<!--- set the full path to the images folder --->
	<cfset mediapath = expandpath('images/')>
	
	<!--- set the desired image height ---->
	<cfset thumbsize = 80>
	
	<!--- set the desired image width --->
	<cfset imagesize = 80>
	
	<cfif structKeyExists(form,"project_image") and len(form.project_image)>
	   <cffile action="upload" filefield="project_image" destination="#MediaPath#" nameconflict="makeunique">
	   
	   <!--- read the image ---->
	   <cfimage name="uploadedImage" source="#MediaPath#/#file.serverFile#">
	
	   <!--- figure out which way to scale the image --->
	   <cfif uploadedImage.width gt uploadedImage.height>
	      <cfset thmb_percentage = (thumbsize / uploadedImage.width)>
	      <cfset percentage = (imagesize / uploadedImage.width)>
	   <cfelse>
	      <cfset thmb_percentage = (thumbsize / uploadedImage.height)>
	      <cfset percentage = (imagesize / uploadedImage.height)>
	   </cfif>
	   
	   <!--- calculate the new thumbnail and image height/width --->
	   <cfset thumbWidth = round(uploadedImage.width * thmb_percentage)>
	   <cfset thumbHeight = round(uploadedImage.height * thmb_percentage)>
	   <cfset newWidth = round(uploadedImage.width * percentage)>
	   <cfset newHeight = round(uploadedImage.height * percentage)>
	
	   <!--- see if we need to resize the image, maybe it is already smaller than our desired size --->
	   <cfif uploadedImage.width gt imagesize>
	         <cfimage action="resize" height="#newHeight#" width="#newWidth#" source="#uploadedImage#" destination="#MediaPath#/#file.serverFile#" overwrite="true"/>
	   </cfif>
	   <cfset args.project_image_url = "#file.serverFile#">
	</cfif>
</cfif>

<cfset application._model_project.add_project(argumentCollection = args)>

<cflocation url="home.cfm">
