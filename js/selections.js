var x = "acq_date";
var y= "brightness";
var graphType = 0;
var year = "2001";
var month1 = "01";
var month2 = "12";
var aggr = "Sum";

function selectionLoad() {
  //var select = document.getElementById("xSelection");
  var select2 = document.getElementById("ySelection");

  for (var attribute in currentDataset[0]) {
    //var el = document.createElement("option");
    //el.text = attribute;
    //el.value = attribute;
    //select.appendChild(el);

    var el1 = document.createElement("option");
    el1.text = attribute;
    el1.value = attribute;
    select2.appendChild(el1);
  }


  var select = document.getElementById("xSelection");
  x = select.options[select.selectedIndex].text;
  console.log(graphType);

  var select1 = document.getElementById("ySelection");
  y = select.options[select.selectedIndex].text;

  var select2 = document.getElementById("graphSelection");
  graphType = select.options[select.selectedIndex].text;
}


function selectEvent(menu) {
  var select = document.getElementById(menu);
  if (menu == "xSelection") {
    console.log("updating x");
    x = select.options[select.selectedIndex].text;
  }
  if (menu == "ySelection") {
    console.log("updating y");
    y = select.options[select.selectedIndex].text;
  }
  if (menu == "graphSelection") {
    console.log("updating graph type");
    graphType = select.selectedIndex;
  }
  if (menu == "yearSelection") {
    console.log("updating year");
    year = select.options[select.selectedIndex].text;
  }
  if (menu == "month1Selection") {
    console.log("updating month 1");
    month1 = select.options[select.selectedIndex].text;
  }
  if (menu == "month2Selection") {
    console.log("updating month 2");
    month2 = select.options[select.selectedIndex].text;
  }
  if (menu == "modeSelection") {
    console.log("updating aggregation mode");
    aggr = select.options[select.selectedIndex].text;
  }
}

function updateGraph() {
  if (/*x != null &&*/y != null && graphType != null) {
    var start = year + "-" + month1 + "-01";
    console.log(start);
    var end = year + "-" + month2 + "-01";
    console.log(end);
    var yObject = filterDateRange(filterByState(currentDataset, selectedState), start, end);

    // Object xObject = currentMonths ////////TODOOOOOOOO
    // string xAttribute = x
    // string yAttribute = y
    // String aggr

    var xp = 300; // center x position
    var yp = 300; // center y position
    var w = 100; //graph width
    var h = 100; //graph height
    console.log("I am almost drawing!");
    console.log(aggr);
    switch (graphType){
      case 0:
        pjs.drawLineGraph(xp, yp, w, h, currentMonths_12, x, yObject, y, aggr);
        break;
      case 1:
        pjs.drawSingleSpiral(xp, yp, w, h, currentMonths_12, x, yObject, y, aggr, 60);
        break;
      case 2:
        pjs.drawIntensityBar(xp, yp, w, h, currentMonths_12, x, yObject, y, aggr);
        break;
    }




    //for(var i = 0; i < states.length(); i++){
      //if (states[i] == 1) {
      //}
    // Checks if state(s) are selected, creates graph for selected graphs.
    // If no states are checked, loop over data to create graph
    //}
    //else{
      //get size of graph box if selected, otherwise make generic sized node to contain graph
      // send data to graph

    //}

    /*
    what can we do with a seleceted attribute combination?
    date on x - other value on y
      single date for spot on y/bucket ranges per spot on y
        could count occurance of value
        sum total value for date
        average value - average for that day
        percent of total presence over days
        How do we determine intention?
    value n x -
      bucket ranges? increasing in value

    */
  }
}