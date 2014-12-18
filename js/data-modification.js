Object.size = function(obj) {
    var size = 0, key;
    for (key in obj) {
        if (obj.hasOwnProperty(key)) size++;
    }
    return size;
};

function findStates(state){
  var num = 0;
  for(var entry in modis_2001_states){
    if(modis_2001_states[entry].State == state){
      num++;
    }
  }
  return num;
}

function getSize(object) {
  return object.size;
}

function getMin(object, attribute) {
  return eval('object.min' + attribute);
}

function getMax(object, attribute) {
  return eval('object.max' + attribute);
}

function sum(object, attribute, date) {
  var sum = 0;
  for(var entry in object){
    var dateArray = object[entry].acq_date.split('-');
    var month     = dateArray[1];
    if(month == matchMonth){
      var current = eval('object[entry].' + attribute);
      sum = sum + current;
    }
  }
  return sum;
}

function average(object, attribute, date) {
  var sum = 0;
  var numEntries = 0;
  for(var entry in object){
    var dateArray = object[entry].acq_date.split('-');
    var month     = dateArray[1];
    if(month == matchMonth){
      var current = eval('object[entry].' + attribute);
      sum = sum + current;
      numEntries++;
    }
  }
  return sum / numEntries;
}

function count(object, attribute, date) {
  var numEntries = 0;
  for(var entry in object){
    var dateArray = object[entry].acq_date.split('-');
    var month     = dateArray[1];
    if(month == matchMonth){
      numEntries++;
    }
  }
  return numEntries;
}

function evaluateAggr(aggr, object, attribute, date) {
  return eval(aggr + '(' + object + ', ' + attribute + ', ' + date + ')');
}
// EXAMPLE USAGE:
// filterDateRange("2001-01-01", "2001-02-01");
// returns json object
function filterDateRange(object, start, end){
  var startNum = Date.parse(start);
  var endNum   = Date.parse(end);
  var newObject = {"max":{}, "min":{}};
  var dateNum;
  for (var attribute in object[Object.keys(object)[0]]){
  	eval('newObject.max.' + attribute + ' = -99999');
  	eval('newObject.min.' + attribute + ' = 99999');
  }
  for(var entry in object){
    dateNum = Date.parse(object[entry].acq_date);
    if(startNum < dateNum && dateNum < endNum){
      newObject[entry] = object[entry];
      for(var attribute in object[entry]){
        if(attribute == 'acq_date'){
          var dateArray = object[entry].acq_date.split('-');
          var month     = dateArray[1];
          month         = parseInt(month);
          newObject.max.acq_date = Math.max(month, newObject.max.acq_date);
          newObject.min.acq_date = Math.min(month, newObject.min.acq_date);
        } else{
          eval('newObject.max.' + attribute + ' = Math.max(object[entry]. ' + attribute + ', newObject.max.' + attribute + ")");
          eval('newObject.min.' + attribute + " = Math.min(object[entry]. " + attribute + ', newObject.min.' + attribute + ")");
        }
      }
    }
  }
  return newObject;
}

function filterByState(object, state){
  var newObject = {"max":{}, "min":{}};
  for (var attribute in object[Object.keys(object)[0]]){
    eval('newObject.max.' + attribute + ' = -99999');
    eval('newObject.min.' + attribute + ' = 99999');
  }
  for(var entry in object){
    if(object[entry].State == state){
      newObject[entry] = object[entry];
      for(var attribute in object[entry]){
        eval('newObject.max.' + attribute + ' = Math.max(object[entry]. ' + attribute + ', newObject.max.' + attribute + ")");
        eval('newObject.min.' + attribute + " = Math.min(object[entry]. " + attribute + ', newObject.min.' + attribute + ")");
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
      if (attribute == 'State' && entryValue != 'undefined'){
        entryValue = entryValue.replace(/\s+/g, '');
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
      eval('newObject.avg.' + attribute + " = '" + maxValue + "'");
    } else {
      eval('newObject.avg.' + attribute + ' = newObject.avg.' + attribute + ' / 5');
    }
  }
  return newObject;
}
