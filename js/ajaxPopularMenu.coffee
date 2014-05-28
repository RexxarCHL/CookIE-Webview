menuAjaxd = 0
lastId = -1
$(document).ready ->
	addInfiniteScroll($('#main_Popular_Menus'), 1000, ->getPopularMenus(menuAjaxd))
	undefined #avoid implicit return values by Coffeescript

getPopularMenus = (times) ->
	$.ajax(
		type: "GET"
		url: 'http://140.114.195.58:8080/CookIEServer/discover_recipelists'
		#url:'./ajaxTest.html'
		dataType: 'jsonp'
		crossDomain: true
		data: 
			'type': 'popular'
			'times': times
		jsonp: false
		timeout: 10000
		success: (data)->
			console.log "[SUCCESS]fetch popular menu"
			console.log data

			menuAjaxd++

			scrollerList = $('#main_Popular_Menus').scroller()
			scrollerList.clearInfinite()

			if data is null or data.length is 0
				$("#main_Popular_Menus").find("#infinite").text "No more menu"
				menuAjaxd--
				return undefined

			scope = $("#main_Popular_Menus")
			appendMenuResult(scope, data)
			undefined #avoid implicit return values by Coffeescript
		error: (data, status)->
			console.log "[ERROR]fetch popular menu: " + status
			$("#main_Popular_Menus").find("#infinite").text "Error. Try Again?"
			undefined #avoid implicit return values by Coffeescript
	)
	undefined #avoid implicit return values by Coffeescript
