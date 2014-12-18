var x;
var y;
var graphType;

function selectionLoad() {
  var select = document.getElementById("xSelection");
  var select2 = document.getElementById("ySelection");

  for (var attribute in currentDataset[0]) {
    var el = document.createElement("option");
    el.text = attribute;
    el.value = attribute;
    select.appendChild(el);

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
    graphType = select.selectedIndex
  }
}

function updateGraph() {
  if (x != null && y != null && graphType != null) {
    console.log("would update graph")
  }
}