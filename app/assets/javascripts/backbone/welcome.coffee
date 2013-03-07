class window.Welcome
	constructor: ->
        $('body').addClass 'welcome'
        $wrap = $("#impress")
        $wrap.jmpress()
        $wrap.show()
        active_tab = (id) ->
        	$("ul.tab li a[href='#"+id+"']").parent().addClass('active').siblings().removeClass("active")
        active_tab $(".step.active").attr("id")
        $(".step",$wrap).on 'enterStep', (e) ->
        	active_tab $(e.target).attr("id")
        	