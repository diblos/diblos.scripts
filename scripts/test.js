//Shows optional arguments when absent
function accident() {
	//Mandatory Arguments
	var driver = arguments[0];
	var condition = arguments[1]
	
	//Optional Arguments
	var blame_on = (arguments[2]) ? arguments[2] : "Irresponsible tree" ;
	
	for (var i = 0; i < arguments.length; i++) {
		//WSH.Echo( "Hello World" );
		
			WSH.Echo( arguments[i] );
		
	};
		//WSH.Echo( blame_on);
}
accident("Me","Drunk","ss","Hello World");