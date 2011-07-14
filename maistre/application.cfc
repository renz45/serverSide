component {

	this.name = "Maistre";
	this.sessionManagement=true;
	this.clientManagement = false;


	public boolean function onRequestStart(required string pageName){
		/* this keeps the components cached in the system, when in development the "or true" will reload the components every
		time the page is refreshed.  remove the or true after site is launched than the components will only be loaded on server start
		results in large speed increase */
		if( structKeyExists(url,"reload")){
			onApplicationStart();
		}


		return true;
	};

	public Any function onApplicationStart(){
		var dbName = "asl1009";
		application._model_user = new models._model_user(dbName);
		application._model_project = new models._model_project(dbName);
		application._model_task = new models._model_task(dbName);
		application._model_github = new models._model_github(dbName);

		application._view_page = new views._view_page();
		application._view_project = new views._view_project();
		application._view_task = new views._view_task();
		application._view_unique = new views._view_unique();
		application._view_user = new views._view_user();
		application._view_modal = new views._view_modal();


		return this;
	}


}
