HashMap<String,TableRow[]> database = new HashMap<String,TableRow[]>();

var dateFireCount = {};
int hT = 400;
int wT = 800;
int numberOfDays = 0;
int maxFirePtDayCount = 0;
HashMap<String, ArrayList<String>> dataByState = new HashMap<String, ArrayList<String>>();

interface Javascript{
  //function delcarations
  int findStates(String state);
  int getSize(Object obj);
  float getMax(Object obj, String attribute);
  float getMin(Object obj, String attribute);
  float average(Object obj, String attribute, String date);
  float sum(Object obj, String attribute, String date);
  float count(Object obj, String attribute, String date);
  float evaluateAggr(String aggr, Object obj, String attribute, String date);
  Object filterDateRange(String startDate, String endDate);
  Object filterByState(String state);
}

void bindJavascript(Javascript js){
  javascript = js;
}

JavaScript javascript;


// Generic Line Graph
// Assuming the object is already setup - 
void drawLineGraph(int x, int y, int w, int h, Object xObject, string xAttribute, Object yObject, string yAttribute, String aggr) {
  fill(255,255,255);
  float xCount = 4;//(float) getSize(xObject) - 2;
  float xMax   = (float) getMax(xObject, xAttribute);
  float xMin   = (float) getMin(xObject, xAttribute);
  float yMax   = (float) getMax(yObject, yAttribute);
  float yMin   = (float) getMin(yObject, yAttribute);
  float thing  = x-w;
  float widthScaler = (float)(w*2)/xCount;
  float heightScaler = (float)(h*2)/(float)(yMax-yMin); // do we want the graph to scale between the min/max value? or not?
  int i = 0;
  float previous = null;

  for(var date in xObject){
    float value = evaluateAggr(aggr.toLowerCase(), yObject, yAttribute, xObject[date]);
    int current = (y+h)-(value*heightScaler);
    if(previous != null){
      stroke(255);
      strokeWeight(1);
      line((i-1)*(widthScaler)+(int)thing, previous, i*(widthScaler)+(int)thing,current); 
    }
    previous = current;
    i++;
  }
}

void drawIntensityBar(int x, int y, int w, int h, Object xObject, string xAttribute, Object yObject, string yAttribute, String aggr) {
  fill(255,255,255);
  float xCount = 4;//(float) getSize(xObject) - 2;
  float xMax   = (float) getMax(xObject, xAttribute);
  float xMin   = (float) getMin(xObject, xAttribute);
  float yMax   = (float) getMax(yObject, yAttribute);
  float yMin   = (float) getMin(yObject, yAttribute);
  float thing  = x-w;
  float widthScaler = (float)(w*2)/xCount;
  float heightScaler = (float)(h*2)/(float)(yMax-yMin); // do we want the graph to scale between the min/max value? or not?
  int i = 0;
  
  for(var date in xObject){
    // histogram
    float value = evaluateAggr(aggr.toLowerCase(), yObject, yAttribute, xObject[date]);
    int color = 255*(value/yMax);
    fill(color,0,0);
    stroke(color,0,0);
    rect((i*(widthScaler)+thing), y-h, (widthScaler+thing), h);
	
  	int positionInGraph = Math.round(i*(widthScaler)+100);
  	if(mouseX == positionInGraph){
        fill(255);
        text(date +" had a fire presence count of: "+value, 50, 105);
      }

      i++;
    }
}

void drawSingleSpiral(int x, int y, int r, int weight) {
  float degree = 360/numberOfDays;
  int i = 1;
  float startRad = 0;
  strokeWeight(weight);
  
  for(var z in dateFireCount){
    // histogram
    int fireCount = dateFireCount[z].count;    
	int color = 255*(fireCount/maxFirePtDayCount);
    fill(color,0,0);
    stroke(color,0,0);
	float endRad = radians(i*degree);
	
    noFill();
    arc(x, y, r, r, startRad, endRad, open);
	startRad = endRad;
	i++
  }
}

void deleteGraphs() {
  graphBoxes.each(function(item) {
    if(item.data.selected) {console.log("Deleting"); graphBoxes.delete(item.data); console.log("Deleted");}
  });
}

void snapGraphs() {
  graphBoxes.each(function(item) {
    if(item.data.selected) {item.data.x = mouseX; item.data.y = mouseY;}
  });
}

void snapGraphsDim() {
  var maxHeight = 0;
  var maxWidth = 0;
  graphBoxes.each(function(item) {
    if(item.data.selected) {
      if(item.data.h > maxHeight)
      {
          maxHeight = item.data.h;
      }
      if(item.data.w > maxWidth)
      {
          maxWidth = item.data.w;
      }
    }
  });
  graphBoxes.each(function(item) {
    if(item.data.selected) {item.data.h = maxHeight; item.data.w = maxWidth;}
  });
}

void selectAll() {
  graphBoxes.each(function(item) {item.data.selected = true;});
}

void deselectAll() {
  graphBoxes.each(function(item) {item.data.selected = false;});
}

void expandGraphs() {
  var expandCount = 0;
  graphBoxes.each(function(item) {if(item.data.selected) {item.data.x += (expandCount++)*20;}});
}

void testBoxCreate() {
  var box1 = new graphBox(400,200,100,100);
  box1.r = 255;
  var box2 = new graphBox(350,200,50,50);
  box2.g = 255;
  /*var box3 = new graphBox(500,200,50,50);
  box3.b = 255;*/
  graphBoxes.add(box1);
  graphBoxes.add(box2);
  //graphBoxes.add(box3);
  console.log("test boxes created");
}

int num;


void setup() {
  size(wT, hT);
  rectMode(RADIUS);
  String fireLines[] = loadStrings("data/modis_2001.csv");
 
  // Grap the header of the csv file
  String fireHeader[] = split(fireLines[0], ",");
 
  int state = -1;
  int acq_date = -1;
 
  // Find state/acq_date indexes
  for(int hI = 0; hI< fireHeader.length; hI++){
    if(fireHeader[hI]=="state"){
      state = hI;
    }
    if(fireHeader[hI]=="acq_date"){
      acq_date = hI;
    }
  }
 
  // populate our data structures with state/date
  for(int row = 1; row < fireLines.length; row++){
   String[] singleLine = split(fireLines[row], ",");
   int countTotal = 1;
   if(singleLine[acq_date] in dateFireCount){
    countTotal = countTotal + dateFireCount[singleLine[acq_date]].count;
    dateFireCount[singleLine[acq_date]].count = countTotal;
   }
   dateFireCount[singleLine[acq_date]] = {count:countTotal};
  }
  for(var x in dateFireCount){
    if(dateFireCount[x].count > maxFirePtDayCount){
        maxFirePtDayCount = dateFireCount[x].count;
    }
    numberOfDays++;
  }
  console.log("setup complete");
  testBoxCreate();
}

void draw(){
  background(80);
  fill(color(255,123,13));
  text("Current state: " + currState, 50, 50);
  fill(color(0,151,178));
  text("Selected state: " + selectedState, 50, 70);
  fill(color(255,123,13), 128);
  text("Data: " + num + " elements of " + selectedState, 50, 90);
  
  //drawLineGraph(100,350, 600, 300);
  // drawIntensityBar(100,380, 600, 10);
  //drawSingleSpiral(400, 200, 300, 2);
  graphBoxes.each(function(item) {
    //if(item.data.selected) {stroke(0, 102, 204);}
    
    //rect(item.data.x, item.data.y, item.data.w, item.data.h);
    //stroke(0,0,0);
    if(item.data.selector){rect(item.data.x, item.data.y, item.data.w, item.data.h);}
    else{
    fill(color(item.data.r,item.data.g,item.data.b,item.data.a));
    item.data.drawLineGraph(item.data.x, item.data.y, item.data.w, item.data.h);
  }
  });
    // drawLineGraph(100, 350, 600, 300, currentMonths, "acq_date", stateEntires, "confidence", "Sum");

  
}

void mousePressed(){
    // if(javascript != null){
    //   num = javascript.findStates(selectedState);
    // }
    //console.log("clicked at X:" + mouseX + " Y:" + mouseY);
    drawIntensityBar(100, 350, 100, 10, currentMonths, "acq_date", stateEntires, "confidence", "Count");


    var current = graphBoxes.end;
    while(current !== null) {
      
      //current.data.selected = false;
      //console.log(current.data.intersect(mouseX,mouseY));
      if(current.data.intersect(mouseX,mouseY) != null) { //hit something
        //console.log("intersected");
        if(current.data.selected==false) {graphBoxes.each(function(item) {item.data.selected = false;});}
        //current.data.locked = true;
        current.data.selected = true;
        graphBoxes.delete(current.data);
        graphBoxes.add(current.data);
        return;
      }
      current = current.prev;
    }

    //Not clicking a graph, create selection rectangle
    graphBoxes.each(function(item) {item.data.selected = false;});
    graphBoxes.selectCount = 0;
    graphBoxes.add(new graphBox(mouseX,mouseY,0,0));
    graphBoxes.end.data.locked = true;
    graphBoxes.end.data.selector = true;
    graphBoxes.end.data.sInitX = mouseX;
    graphBoxes.end.data.sInitY = mouseY;
}

void mouseReleased(){
  /*for(int i = 0; i<graphBoxes.length() ; i++){
      if(graphBoxes[i] != null) {
        graphBoxes[i].locked = false;
      }
    }*/
    graphBoxes.end.data.transformLock = false;
    graphBoxes.end.data.translateLock = false;
    graphBoxes.end.data.locked = false;
    graphBoxes.end.data.xTransform = 0;
    graphBoxes.end.data.yTransform = 0;
    if(graphBoxes.end.data.selector && graphBoxes.end.prev != null)
    {
      var current = graphBoxes.end.prev;
      while(current !== null) {
        if(current.data.inside(graphBoxes.end.data.x, graphBoxes.end.data.y,
                                graphBoxes.end.data.w, graphBoxes.end.data.h)) {
          //current.data.locked = true;
          current.data.selected = true;
          graphBoxes.selectCount++;
        }
        current = current.prev;
      }
      graphBoxes.delete(graphBoxes.end.data);
    }
}

void mouseDragged() {
  /*for(int i = 0; i<graphBoxes.length() ; i++){
      if(graphBoxes[i] != null && graphBoxes[i].locked) {
        graphBoxes[i].x = mouseX - graphBoxes[i].xOffset;
        graphBoxes[i].y = mouseY - graphBoxes[i].yOffset;
      }
    }*/
      if(graphBoxes.end.data.transformLock) //stretch or shrink
      {
        if(graphBoxes.selectCount>1) {
          graphBoxes.revEach(function(item) {
            if(item.data.selected) {
              
            item.data.w += (mouseX-pmouseX)*graphBoxes.end.data.xTransform;
            item.data.h += (mouseY-pmouseY)*graphBoxes.end.data.yTransform;
            }
          });
          return;
        }
       graphBoxes.end.data.w += (mouseX-pmouseX)*graphBoxes.end.data.xTransform;
       graphBoxes.end.data.h += (mouseY-pmouseY)*graphBoxes.end.data.yTransform;
      }
      else if(graphBoxes.end.data.translateLock)  //move around canvas
      {
        if(graphBoxes.selectCount>1) {
          graphBoxes.revEach(function(item) {
            item.data.x += (mouseX-pmouseX);
            item.data.y += (mouseY-pmouseY);
          });
          return;
        }
       graphBoxes.end.data.x = mouseX - graphBoxes.end.data.xOffset;
       graphBoxes.end.data.y = mouseY - graphBoxes.end.data.yOffset;
      }
      else if(graphBoxes.end.data.selector)
      {
        graphBoxes.end.data.w += (mouseX-pmouseX)/2;
        graphBoxes.end.data.h += (mouseY-pmouseY)/2;
        graphBoxes.end.data.x = graphBoxes.end.data.sInitX + (graphBoxes.end.data.w);
        graphBoxes.end.data.y = graphBoxes.end.data.sInitY + (graphBoxes.end.data.h);
      }
}

void keyPressed() {
  if(key == DELETE)   //delete graph
  {
      deleteGraphs();
  }
  if(key == ' ')    //snap to 'center' coordinates
  {
      snapGraphs();
  }
  if(key == CODED)
  {
    if(keyCode == ALT)  //snap width and height
    {
        snapGraphsDim();
    }
  }
  if(key == 'e')
  {
    expandGraphs();
  }
  if(key == 'a')
  {
    selectAll();
  }
  if(key == 'd')
  {
    deselectAll();
  }
}

void javaClicked(){
  console.log("here");
    if(javascript != null){
      num = javascript.findStates(selectedState);
    }
}