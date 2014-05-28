kitchenMenuAjaxd = 0
lastId = -1
$(document).ready ->
	scrollerList = $('#main_Kitchen_Menus').scroller()
	scrollerList.addInfinite()
	$.bind(scrollerList, "infinite-scroll", ->
		console.log "kitchen menu infinite-scroll"
		self = this
		$("#main_Kitchen_Menus").find("#infinite").text "Loading..."
		scrollerList.addInfinite()

		#change setTimeout to ajax call
		clearTimeout lastId
		lastId = setTimeout(->
			getKitchenMenus(kitchenMenuAjaxd, self)
		,1000)
		undefined #avoid implicit return values by Coffeescript
	)
	undefined #avoid implicit return values by Coffeescript

getKitchenMenus = (times, scrollObj) ->
	$.ajax(
		type: "GET"
		#TODO: determine url
		url: 'http://140.114.195.58:8080/CookIEServer/discover_recipelists'
		dataType: 'jsonp'
		crossDomain: true
		#TODO: determine data
		data: 
			'type': 'popular'
			'times': times
		jsonp: false
		timeout: 10000
		success: (data)->
			console.log "[SUCCESS]fetch kitchen menu"
			console.log data
			scrollerList = $('#main_Kitchen_Menus').scroller()
			scrollerList.clearInfinite()

			if data.length is 0
				$("#main_Kitchen_Menus").find("#infinite").text "No more lists"
				menuAjaxd--
				return undefined

			scope = $("main_Kitchen_Menus")
			appendMenuResult(scope, data)
			kitchenMenuAjaxd++
			undefined #avoid implicit return values by Coffeescript
		error: (data, status)->
			console.log "[ERROR]fetch kitchen menu: " + status
			$("#main_Kitchen_Menus").find("#infinite").text "Load More"
			scrollObj.clearInfinite();
			undefined #avoid implicit return values by Coffeescript
	)
	undefined #avoid implicit return values by Coffeescript
	

