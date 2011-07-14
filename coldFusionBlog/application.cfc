component{

	this.name = "blog";
	this.sessionManagement=true;
	this.clientManagement = false;
	
	
	public boolean function onRequestStart(required string pageName){
		/* this keeps the components cached in the system, when in development the "or true" will reload the components every
		time the page is refreshed.  remove the or true after site is launched than the components will only be loaded on server start
		results in large speed increase */
		if( structKeyExists(url,"reload") or true){
			onApplicationStart();
		}
		
		
		return true;
	};
	
	public Any function onApplicationStart(){
	
		application.model = new _model("asl1009");
		application.view = new _view();
		
		return this;
	}


}
