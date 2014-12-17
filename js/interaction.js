function graphBox(x,y,w,h) {
	this.x = x;	//x-coord
	this.y = y;	//y-coord
	this.w = w;	//width
	this.h = h;	//height
	this.z = 0;	//z-coord (layer)


	this.translateLock = false;
	this.xOffset = 0;
	this.yOffset = 0;

	this.transformLock = false;
	this.xTransform = 0;
	this.yTransform = 0;

	this.locked = false;
	this.selected = false;

	this.selector = false;
	this.sInitX = 0;
	this.sInitY = 0;

	this.r = 0;
	this.g = 0;
	this.b = 0;
	this.a = 127;
	this.intersect = function(clickX, clickY) {		//click intersection
		//console.log("calculating intersect");
		if (clickX > this.x-this.w+10 && clickX < this.x+this.w-10 &&
			clickY > this.y-this.h+10 && clickY < this.y+this.h-10)
		{
			this.xOffset = clickX - this.x;
			this.yOffset = clickY - this.y;
			this.translateLock = true;
			return [0 , 0];
		}
		else if (clickX > this.x+this.w-10 && clickX < this.x+this.w &&
				 clickY > this.y-this.h && clickY < this.y+this.h)	//Stretch Right
		{
			this.xTransform = 1;
			this.transformLock = true;
			return [1 , 0];
		}
		else if (clickX > this.x-this.w && clickX < this.x-this.w+10 &&
				 clickY > this.y-this.h && clickY < this.y+this.h) //Stretch Left
		{
			this.xTransform = -1;
			this.transformLock = true;
			return [-1 , 0];
		}
		else if (clickX > this.x-this.w && clickX < this.x+this.w &&
				 clickY > this.y-this.h && clickY < this.y-this.h+10) //Stretch Up
		{
			this.yTransform = -1;
			this.transformLock = true;
			return [0 , -1];
		}
		else if (clickX > this.x-this.w && clickX < this.x+this.w &&
				 clickY > this.y+this.h-10 && clickY < this.y+this.h) //Stretch Down
		{
			this.yTransform = 1;
			this.transformLock = true;
			return [0 , 1];
		}
		else {return null;}
	}
	this.inside = function(rectX, rectY, rectW, rectH)
	{
		//if(this.y + this.h )
		return null;
	}

}