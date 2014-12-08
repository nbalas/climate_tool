HashMap<String,TableRow[]> database = new HashMap<String,TableRow[]>();

interface Javascript{
  //function delcarations
  int findStates(String state);
}

void bindJavascript(Javascript js){
  javascript = js;
}

JavaScript javascript;

void drawGrid(int x, int y, int w, int h) {
	rect(x, y, w, h);
}
 
int num;

void setup() {
  size(600, 400);
} 

void draw(){
  background(102);
  fill(color(255,123,13));
  text("Current state: " + currState, 50, 50);
  fill(color(0,151,178));
  text("Selected state: " + selectedState, 50, 70);
  fill(color(255,123,13), 128);
  text("Data? " + num + " elements of " + selectedState, 50, 90)
  drawGrid(200,200,50,50);
}

void mouseClicked(){
    // if(javascript != null){
    //   num = javascript.findStates(selectedState);
    // }
}

void javaClicked(){
    if(javascript != null){
      num = javascript.findStates(selectedState);
    }
}