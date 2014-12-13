function bindJavascript() {
	pjs = Processing.getInstanceById('code');
	if(pjs!=null) {
	pjs.bindJavascript(this);
	bound = true;
	}
	if(!bound) setTimeout(bindJavascript, 125);
}

function sendClick() {
	if(pjs!=null) {
	pjs.javaClicked();
	}
}

function printJSON(json){
	for (var entry in json){
		console.log(json[entry].acq_date);
	}
	for (var attr in json.max){
		console.log(attr);
		eval('console.log(json.max.' +  attr + ")");
		eval('console.log(json.min.' +  attr + ")");
	}
}