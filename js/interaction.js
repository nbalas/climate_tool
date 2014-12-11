function graphBox(x,y,w,h) {
	this.x = x;	//x-coord
	this.y = y;	//y-coord
	this.w = w;	//width
	this.h = h;	//height
	this.z = 0;	//z-coord (layer)
	this.xOffset = 0;
	this.yOffset = 0;
	this.locked = false;
	this.intersect = function(clickX, clickY) {
		console.log("calculating intersect");
		if (clickX > this.x && clickX < this.x+this.w &&
			clickY > this.y && clickY < this.y+this.h)
		{
			this.xOffset = clickX - this.x;
			this.yOffset = clickY - this.y;
			return true;
		}
		else {return false;}
	}
}