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
}

void bindJavascript(Javascript js){
  javascript = js;
}

JavaScript javascript;


// Line Graph
void drawLineGraph(int x, int y, int w, int h) {
  fill(255,255,255);
  int spacer = 0;
  float widthScaler = w/numberOfDays;
  float heightScaler = h/maxFirePtDayCount;
  int i = 0;
  float previous = null;

  for(var z in dateFireCount){
    int current = y-dateFireCount[z].count*heightScaler;
    if(previous != null){
      stroke(255);
      strokeWeight(1);
	  //using width + spacer to match the intensity bar sizing
      line((i-1)*(widthScaler+spacer)+100, previous, i*(widthScaler+spacer)+100,current); 
    }
    previous = current;
    i++;
  }
}

void drawIntensityBar(int x, int y, int w, int h) {
  fill(255,255,255);
  int spacer = 0;
  float widthOfBar = w/numberOfDays;
  int i = 0;
  
  for(var z in dateFireCount){
    // histogram
    int fireCount = dateFireCount[z].count;
    int color = 255*(fireCount/maxFirePtDayCount);
    fill(color,0,0);
    stroke(color,0,0);
    rect(i*(widthOfBar+spacer)+x, y,widthOfBar-spacer, h);
	
	int positionInGraph = Math.round(i*(widthOfBar+spacer)+100);
	if(mouseX == positionInGraph){
      fill(255);
      text(z+" had a fire presence count of: "+fireCount, 50, 105);
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

void testBoxCreate() {
  graphBoxes[0] = new graphBox(200,200,50,50);
  graphBoxes[1] = new graphBox(400,200,50,50);
  graphBoxes[2] = new graphBox(500,200,50,50);
  console.log("test box created");
}

int num;


void setup() {
  size(wT, hT);
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
  background(102);
  fill(color(255,123,13));
  text("Current state: " + currState, 50, 50);
  fill(color(0,151,178));
  text("Selected state: " + selectedState, 50, 70);
  fill(color(255,123,13), 128);
  text("Data: " + num + " elements of " + selectedState, 50, 90);
  
  // drawLineGraph(100,350, 600, 300);
  // drawIntensityBar(100,380, 600, 10);
  //drawSingleSpiral(400, 200, 300, 2);

  //rect(graphBoxes[0].x, graphBoxes[0].y, graphBoxes[0].w, graphBoxes[0].h)
 for(int i = 0; i<graphBoxes.length() ; i++) {
    if(graphBoxes[i] != null) {
        rect(graphBoxes[i].x, graphBoxes[i].y, graphBoxes[i].w, graphBoxes[i].h);
      }
    }
  
}

void mousePressed(){
    // if(javascript != null){
    //   num = javascript.findStates(selectedState);
    // }
    console.log("clicked at X:" + mouseX + " Y:" + mouseY);
    for(int i = 0; i<graphBoxes.length() ; i++){
      if(graphBoxes[i] != null && graphBoxes[i].intersect(mouseX,mouseY)) {
        graphBoxes[i].locked = true;
        console.log(i);
        console.log("intersected box");
      }
    }
}

void mouseReleased(){
  for(int i = 0; i<graphBoxes.length() ; i++){
      if(graphBoxes[i] != null) {
        graphBoxes[i].locked = false;
      }
    }
}

void mouseDragged() {
  for(int i = 0; i<graphBoxes.length() ; i++){
      if(graphBoxes[i] != null && graphBoxes[i].locked) {
        graphBoxes[i].x = mouseX - graphBoxes[i].xOffset;
        graphBoxes[i].y = mouseY - graphBoxes[i].yOffset;
      }
    }

}

void javaClicked(){
    if(javascript != null){
      num = javascript.findStates(selectedState);
    }
}