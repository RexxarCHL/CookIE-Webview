kitchenMenuAjaxd = 0
lastId = -1
$(document).ready ->
	addInfiniteScroll($('#main_Kitchen_Menus'), 1000, ->getKitchenMenus(kitchenMenuAjaxd))
	undefined #avoid implicit return values by Coffeescript

getKitchenMenus = (times) ->
	$.ajax(
		type: "GET"
		url: 'http://54.178.135.71:8080/CookIEServer/discover_recipelists'
		dataType: 'jsonp'
		crossDomain: true
		data: 
			'type': 'favorite'
			'times': times
		jsonp: false
		timeout: 10000
		success: (data)->
			console.log "[SUCCESS]fetch kitchen menu"
			console.log data

			kitchenMenuAjaxd++
			
			scrollerList = $('#main_Kitchen_Menus').scroller()
			scrollerList.clearInfinite()

			if data.length is 0
				$("#main_Kitchen_Menus").find("#infinite").text "No more lists"
				menuAjaxd--
				return undefined

			scope = $("#main_Kitchen_Menus")
			appendMenuResult(scope, data)
			undefined #avoid implicit return values by Coffeescript
		error: (data, status)->
			console.log "[ERROR]fetch kitchen menu: " + status
			$("#main_Kitchen_Menus").find("#infinite").text "Load More"
			scrollerList = $('#main_Kitchen_Menus').scroller()
			scrollerList.clearInfinite()
			undefined #avoid implicit return values by Coffeescript
	)
	undefined #avoid implicit return values by Coffeescript
	

