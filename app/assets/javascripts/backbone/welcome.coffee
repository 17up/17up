class window.Welcome
	constructor: ->
        $('body').addClass 'welcome'
        $wrap = $("#impress")
        $wrap.jmpress
        	transitionDuration: 0
        $wrap.show()
        Utils.active_tab $(".step.active").attr("id")
        $(".step",$wrap).on 'enterStep', (e) ->
        	Utils.active_tab $(e.target).attr("id")
        mixpanel.track("new visitor")