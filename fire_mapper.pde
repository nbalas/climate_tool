PShape usa;
PShape minnesota;

float mapGeoLeft   =  -128.63;          // Longitude 125 degrees west
float mapGeoRight  =  -64.36;          // Longitude 153 degrees east
float mapGeoTop    =  51.99;          // Latitude 72 degrees north.
float mapGeoBottom =  25.01;          // Latitude 56 degrees south.

//+48.987386 is the northern most latitude 
//+18.005611 is the southern most latitude 
//-124.626080 is the west most longitude 
//-62.361014 is a east most longitude 
                         
float mapScreenWidth,mapScreenHeight;  // Dimension of map in pixels.

void setup()
{
  // svg size 959 × 593
  size(959,593);
  smooth();
  noLoop();
  usa   = loadShape("US_Map.svg");
  minnesota = usa.getChild("HI");
  //  usa.scale(2);
  smooth();
  mapScreenWidth  = width;
  mapScreenHeight = height;
}

void draw()
{
  background(255);
  // Draw the full map
  shape(usa);
  
  // Disable the colors found in the SVG file
  minnesota.disableStyle();
  // Set our own coloring
  fill(153, 0, 0);
  noStroke();
  // Draw a single state
  shape(minnesota);  // Buckeyes!
  
  fill(180,120,120);
  strokeWeight(0.5);
  
  PVector p = geoToPixel(new PVector(-74,40.71));        // New York
  ellipse(p.x,p.y,10,10);
  p = geoToPixel(new PVector(-93.2,44.9));        // Minneapolis
  ellipse(p.x,p.y,10,10);
  p = geoToPixel(new PVector(-96.7,32.77));        // Dallas
  ellipse(p.x,p.y,10,10); 
  p = geoToPixel(new PVector(-122.33,47.61));        // Seattle
  ellipse(p.x,p.y,10,10); 
  
  p = new PVector(mouseX, mouseY);
  for(int i=0;i<usa.getChildCount();i++){
//    if(usa.getChild(i).contains(p.x,p.y)){
       println(usa.getChild(i).height);
       fill(0,100,255,250);
       noStroke();
       usa.getChild(i).disableStyle();
       shape(usa.getChild(i));
    }
//  }
}

// Converts screen coordinates into geographical coordinates. 
// Useful for interpreting mouse position.
public PVector pixelToGeo(PVector screenLocation)
{
    return new PVector(mapGeoLeft + (mapGeoRight-mapGeoLeft)*(screenLocation.x)/mapScreenWidth,
                       mapGeoTop - (mapGeoTop-mapGeoBottom)*(screenLocation.y)/mapScreenHeight);
}

// Converts geographical coordinates into screen coordinates.
// Useful for drawing geographically referenced items on screen.
public PVector geoToPixel(PVector geoLocation)
{
    return new PVector(mapScreenWidth*(geoLocation.x-mapGeoLeft)/(mapGeoRight-mapGeoLeft),
                       mapScreenHeight - mapScreenHeight*(geoLocation.y-mapGeoBottom)/(mapGeoTop-mapGeoBottom));
}
