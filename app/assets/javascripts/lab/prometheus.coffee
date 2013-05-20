class window.Prometheus
	constructor: ->
		chart1 = $("#chart1")

		options = 			
			'radius': 200
			'width' : 500
			'height' : 500
			'padding': 1
			'dataUrl' : 'flare.json'
			'dataType' : 'json'
			'chartType' : 'bubble'
			'dataStructure' : 
				'name' : 'name'
				'children' : 'group'
				'value' : 'size'
		d3.sunburst chart1,options
		d3.sunburst.settings =
			'chartName': "human future"			
			'labelPosition': 0
		  