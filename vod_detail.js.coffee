require ['view/EPGDetailView','models/program','view/EpisodesView'],(EPGDetailView,Program,EpisodesView) ->
	$.post "/v1/otts/ott_login"
		login: "veggie1989"

	episode_view = null
	detailView = null
	Workspace = Backbone.Router.extend
		routes:
			":vodid/episodes/:num": "episodes_view"
			":vodid" : "root"
			":vodid/play/:episode_id/:history" : "play"
		episodes_view: (vodid,num) ->
			if episode_view isnt null			
				episode_view.row_view.active()
			else
				episode_view = new EpisodesView
					id: vodid
					attributes: 
						num: num
					navOptions:
						layerNames: ['episodes']
				episode_view.render()	
			$("#episodes").addClass("fadeout")
		root: (vodid) ->
			if detailView isnt null and detailView.model.attributes.id is vodid
				detailView.active()
			else
				program = new Program
					id: vodid
				
				detailView = new EPGDetailView
					model: program	
				if program.localStorage.find(program) isnt null
					program.attributes = program.localStorage.find(program)
					detailView.render()
				else
					$.get "/v1/vods/" + vodid,(resp) ->
						program.attributes = resp.data				
						program.save()
					.complete ->
						detailView.render()
				
			$(".program").removeClass("fadein")		
			
		play: (vodid,episode_id,history = 0) ->
			# 播放vod
			# 取得vod_id,vod_media_url,vod_history
			# 如果有vod_history 则读取记录播放
			window.vod_video = $("#my_video").vod_player
				hide_el: $("#play_screen .tip-bar")
				source: "http://125.210.209.154:8089/brave_clip.mp4"
				history: history
			window.vod_video.attr "episode_id",episode_id
			$("#play_screen").addClass("fadeout")
			
	window.workspace = new Workspace()
	window.workspace.bind "all",(route,router) ->
		if route isnt "route:play"
			$("#play_screen").removeClass("fadeout")
			if window.vod_video
				$(document).unbind('keyup.play')
				# 如果退出播放，则暂停当前vod进度，并且记录vod history
				unless window.vod_video[0].paused
					window.vod_video[0].pause()		
					history = window.vod_video[0].currentTime
					program = new Program
						id: router
					program.attributes = program.localStorage.find(program)
					program.attributes["history"] = parseInt(history)
					program.save()
					$.post "/v1/vod_histories/create"
						vod_id: router
						episode_num: (window.vod_video.attr "episode_id")
						time: history
		if route isnt "route:episodes_view"
			$("#episodes").removeClass("fadeout")
		if route isnt "route:root"
			$(".program").addClass("fadein")
	Backbone.history.start()
