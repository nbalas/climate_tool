void drawGrid(int x, int y, int w, int h) {
	rect(x, y, w, h);
}

void setup() {
  size(600, 400);
  // The file "bot1.svg" must be in the data folder
  // of the current sketch to load successfully
} 

void draw(){
  background(102);
  fill(color(255,123,13));
  text("Current state: " + currState, 50, 50);
  fill(color(0,151,178));
  text("Selected state: " + selectedState, 50, 70);
  fill(color(255,123,13), 128);
  drawGrid(200,200,50,50);
}