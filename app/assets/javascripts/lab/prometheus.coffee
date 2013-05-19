class window.Prometheus
	constructor: ->
		params = 
			title: 
				text: "what can we do for the human future?"
			theme: "theme2"
			data: [    
				type: "doughnut"
				indexLabelFontFamily: "Garamond"     
				indexLabelFontSize: 20
				startAngle: 90
				indexLabelFontColor: "dimgrey"       
				indexLabelLineColor: "darkgrey" 
				toolTipContent: "focus this?"					
				dataPoints: [
					{  
						y: 50
						label: "Environmental protection" 
					}
					{  
						y: 50
						label: "Education" 
					}
				]
			]
		chart = new CanvasJS.Chart("chart",params)
		chart.render()
			

		



