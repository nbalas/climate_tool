function graphBox(x,y,w,h) {
	this.x = x;	//x-coord
	this.y = y;	//y-coord
	this.w = w;	//width
	this.h = h;	//height
	this.z = 0;	//z-coord (layer)

	this.processingInstance = Processing.getInstanceById('code');

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

	this.axisY = "";
	this.axisX = "acq_date";
	this.graphType = "";
	this.year = "";
	this.startMonth = "";
	this.endMonth = "";
	this.aggr = "";

	this.xObject =currentMonths_12;
	this.yObject;

	this.r = 0;
	this.g = 0;
	this.b = 0;
	this.a = 64;
	this.drawLineGraph = function(x, y, w, h, xObject, axisX, yObject, axisY, aggr) {
		this.processingInstance.drawLineGraph(x, y, w, h, xObject, axisX, yObject, axisY, aggr);
	}
	this.drawIntensityBar = function(x, y, w, h, xObject, axisX, yObject, axisY, aggr) {
		this.processingInstance.drawIntensityBar(x, y, w, h, xObject, axisX, yObject, axisY, aggr);
	}
	this.drawSingleSpiral = function(x, y, w, h, xObject, axisX, yObject, axisY, aggr, r) {
		this.processingInstance.drawSingleSpiral(x, y, w, h, xObject, axisX, yObject, axisY, aggr, r);
	}
	this.intersect = function(clickX, clickY) {		//click intersection
		/*console.log("calculating intersect");*/
		var absW = Math.abs(this.w);
		var absH = Math.abs(this.h);
		if (clickX > this.x-absW+10 && clickX < this.x+absW-10 &&
			clickY > this.y-this.h+10 && clickY < this.y+this.h-10)
		{
			this.xOffset = clickX - this.x;
			this.yOffset = clickY - this.y;
			this.translateLock = true;
			return [0 , 0];
		}
		else if (clickX > this.x+absW-10 && clickX < this.x+absW &&
				 clickY > this.y-absH && clickY < this.y+absH)	//Stretch Right
		{
			this.xTransform = 1;
			this.transformLock = true;
			return [1 , 0];
		}
		else if (clickX > this.x-absW && clickX < this.x-absW+10 &&
				 clickY > this.y-absH && clickY < this.y+absH) //Stretch Left
		{
			this.xTransform = -1;
			this.transformLock = true;
			return [-1 , 0];
		}
		else if (clickX > this.x-absW && clickX < this.x+absW &&
				 clickY > this.y-absH && clickY < this.y-absH+10) //Stretch Up
		{
			this.yTransform = -1;
			this.transformLock = true;
			return [0 , -1];
		}
		else if (clickX > this.x-absW && clickX < this.x+absW &&
				 clickY > this.y+absH-10 && clickY < this.y+absH) //Stretch Down
		{
			this.yTransform = 1;
			this.transformLock = true;
			return [0 , 1];
		}
		else {return null;}
	}
	this.inside = function(rectX, rectY, rectW, rectH)	//box within bounding box intersection
	{
		var absRectH = Math.abs(rectH);
		var absRectW = Math.abs(rectW);
		if(this.y + this.h > rectY-absRectH && this.y + this.h < rectY+absRectH)	//check bottom edge
		{
			if(this.x + this.w > rectX-absRectW && this.x + this.w < rectX+absRectW)	//check right edge
			{
				return true;
			}
			if(this.x - this.w > rectX-absRectW && this.x - this.w < rectX+absRectW)	//check left edge
			{
				return true;
			}
		}
		if(this.y - this.h > rectY-absRectH && this.y - this.h < rectY+absRectH)	//check top edge
		{
			if(this.x + this.w > rectX-absRectW && this.x + this.w < rectX+absRectW)	//check right edge
			{
				return true;
			}
			if(this.x - this.w > rectX-absRectW && this.x - this.w < rectX+absRectW)	//check left edge
			{
				return true;
			}
		}
		return false;
	}

}