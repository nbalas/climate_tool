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
  var startNum = Date.parse(start);
  var endNum   = Date.parse(end);
  var newObject = {"max":{}, "min":{}};
  var dateNum;
  for (var attribute in currentDataset[0]){
  	eval('newObject.max.' + attribute + ' = -99999');
  	eval('newObject.min.' + attribute + ' = 99999');
  }
  for(var entry in currentDataset){
    dateNum = Date.parse(currentDataset[entry].acq_date);
    if(startNum < dateNum && dateNum < endNum){
      newObject[entry] = currentDataset[entry];
      for(var attribute in currentDataset[entry]){
      	eval('newObject.max.' + attribute + ' = Math.max(currentDataset[entry]. ' + attribute + ', newObject.max.' + attribute + ")");
      	eval('newObject.min.' + attribute + " = Math.min(currentDataset[entry]. " + attribute + ', newObject.min.' + attribute + ")");
      }
    }
  }
  return newObject;
}

function filterByState(state){
  var newObject = {"max":{}, "min":{}};
  for (var attribute in currentDataset[0]){
    eval('newObject.max.' + attribute + ' = -99999');
    eval('newObject.min.' + attribute + ' = 99999');
  }
  for(var entry in currentDataset){
    if(currentDataset[entry].State == state){
      newObject[entry] = currentDataset[entry];
      for(var attribute in currentDataset[entry]){
        eval('newObject.max.' + attribute + ' = Math.max(currentDataset[entry]. ' + attribute + ', newObject.max.' + attribute + ")");
        eval('newObject.min.' + attribute + " = Math.min(currentDataset[entry]. " + attribute + ', newObject.min.' + attribute + ")");
      }
    }
  }
  return newObject;
}

// TODO: convert string to int to accumulate properly
function averages(object){
  var nonNum    = {"acq_date":{}, "State":{}};
  var newObject = {"avg":{}};
  var maxValue  = '';
  var current   = 0;
  var max;
  //inital average attributes
  for (var attribute in object[Object.keys(object)[0]]){
    eval('newObject.avg.' + attribute + ' = 0.0');
  }
  // gather values for each attribute
  for(var entry in object){
    for(var attribute in object[entry]){
      entryValue = eval('object[entry].' + attribute);
      if (attribute == 'State'){
        console.log('nonNum value: ' + eval('nonNum.' + attribute + '.' + entryValue));
        console.log('entry       : ' + entryValue);
        if (eval('nonNum.' + attribute + '.' + entryValue) == undefined){
          eval('nonNum.' + attribute + '.' + entryValue + ' = 1');
        } else {
          eval('nonNum.' + attribute + '.' + entryValue + ' += 1');
        }
      } else {
        eval('newObject.avg.' + attribute + ' = object[entry].' + attribute + ' + newObject.avg.' + attribute);
      }
    }
  }
  // Average the values
  for (var attribute in newObject.avg){
    console.log(attribute);
    if (attribute == 'State'){
      max = 0;
      console.log(attribute);
      for (var value in eval('nonNum.' + attribute)){
        console.log('currValue: ' + value);
        console.log('maxValue : ' + maxValue + " max: " + max);
        eval('current = nonNum.' + attribute + '.' + value);
        if (max < current){
          maxValue = value;
          max      = current;
        }
      }
      eval('newObject.avg.' + attribute + ' = ' + "'" + maxValue + "'");
    } else {
      eval('newObject.avg.' + attribute + ' = newObject.avg.' + attribute + ' / 5');
    }
  }
  return newObject;
}
