HTMLWidgets.widget({

  name: 'codeFlower',

  type: 'output',
  
  renderOnNullValue: true,

  initialize: function(el, width, height) {

  var svg;
  var currentCodeFlower;        
    return {
      svg: svg,
      rCodeFlower: currentCodeFlower
    }

  },

  renderValue: function(el, x, instance) {
    
     var createCodeFlower = function(json) {
        // remove previous flower to save memory
        if (currentCodeFlower) currentCodeFlower.cleanup();
        // adapt layout size to the total number of elements
        var total = countElements(json);
        w = parseInt(Math.sqrt(total) * 30, 10);
        h = parseInt(Math.sqrt(total) * 30, 10);
        // create a new CodeFlower
        currentCodeFlower = new CodeFlower(el, w, h).update(json);
      };
	  
	var df = HTMLWidgets.dataframeToD3(x);
	d3.json(df, createCodeFlower);
    instance.lastValue = x;
  },

  resize: function(el, width, height, instance) {
    // Re-render the previous value, if any
    if (instance.lastValue) {
      this.renderValue(el, instance.lastValue, instance);
    }
  }

});
