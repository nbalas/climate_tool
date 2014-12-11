function findStates(state){
  var num = 0;
  for(var entry in modis_2001_states){
    if(modis_2001_states[entry].State == state){
      num++;
    }
  }
  return num;
}

// EXAMPLE USAGE:
// filterDateRange("2001-01-01", "2001-02-01");
// returns json object
function filterDateRange(start, end){
  var num 	   = 0;
  var startNum = Date.parse(start);
  var endNum   = Date.parse(end);
  var newObject = {"max":{}, "min":{}};
  var dateNum;
  for (var attribute in currentDataset[0]){
  	console.log(attribute + ' "hello" ');
  	eval('newObject.max.' + attribute + ' = -99999');
  	eval('newObject.min.' + attribute + ' = 99999');
  }
  for(var entry in currentDataset){
    dateNum = Date.parse(currentDataset[entry].acq_date);
    if(startNum < dateNum && dateNum < endNum){
      newObject[entry] = currentDataset[entry];
      for(var attribute in currentDataset[entry]){
      	eval('newObject.max.' + attribute + ' = Math.max(currentDataset[entry]. ' +attribute + ', newObject.max.' + attribute + ")");
      	eval('newObject.min.' + attribute + " = Math.min(currentDataset[entry]. " +attribute + ', newObject.min.' + attribute + ")");
      }
    }
  }
  return newObject;
}