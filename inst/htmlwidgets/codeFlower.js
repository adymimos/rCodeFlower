HTMLWidgets.widget({

  name: 'codeFlower',

  type: 'output',
  
  renderOnNullValue: true,

  initialize: function(el, width, height) {

  var svg = d3.select(el).append("svg")
        .attr("class", "rCodeFlower");
  var currentCodeFlower;        
    return {
      svg: svg,
      rCodeFlower: currentCodeFlower
    }

  },

  renderValue: function(el, x, instance) {
    var currentCodeFlower = instance.rCodeFlower;
	var width = el.offsetWidth;
    var height = el.offsetHeight;
    var createCodeFlower = function(json) {
        // remove previous flower to save memory
        if (currentCodeFlower) currentCodeFlower.cleanup();
        // adapt layout size to the total number of elements
        var total = countElements(json);
        w = parseInt(Math.sqrt(total) * 30, 10);
        h = parseInt(Math.sqrt(total) * 30, 10);
        // create a new CodeFlower
		var str1 = "#";
        currentCodeFlower = new CodeFlower(str1.concat(el.id), width, height).update(json);
      };
	  
	//var df = HTMLWidgets.dataframeToD3(x);
	//d3.json(x, createCodeFlower);
	createCodeFlower(JSON.parse(x));
    instance.lastValue = x;
  },

  resize: function(el, width, height, instance) {
    // Re-render the previous value, if any
    if (instance.lastValue) {
      this.renderValue(el, instance.lastValue, instance);
    }
  }

});
