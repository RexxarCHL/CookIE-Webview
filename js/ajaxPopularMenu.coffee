menuAjaxd = 0
lastId = -1
$(document).ready ->
	addInfiniteScroll($('#main_Popular_Menus'), 1000, ->getPopularMenus(menuAjaxd))
	undefined #avoid implicit return values by Coffeescript

getPopularMenus = (times) ->
	$.ajax(
		type: "GET"
		url: 'http://54.178.135.71:8080/CookIEServer/discover_recipelists'
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
			appendPopularMenuResult(scope, data)
			undefined #avoid implicit return values by Coffeescript
		error: (data, status)->
			console.log "[ERROR]fetch popular menu: " + status
			$("#main_Popular_Menus").find("#infinite").text "Error. Try Again?"
			undefined #avoid implicit return values by Coffeescript
	)
	undefined #avoid implicit return values by Coffeescript

appendPopularMenuResult = (scope, data)->
	console.log "append menu for scope: " + scope[0].id

	results = scope.find "#Results"
	results.find(".new").removeClass "new"

	for list in data
		html = ''
		id = list.list_id
		title = list.name
		rating = list.rating

		if rating is 0 then rating = 'No rating'
		else rating += " stars"
		
		html = '<div class="menu_wrapper new" id="Menu'+id+'">'
		html += '<h2 class="menu_title">'+title+'&nbsp;&nbsp;&nbsp;<i class="icon star">'+rating+'</i>&nbsp;&nbsp;<i class="icon chat">comments</i></h2>'

		html += '<div class="menu_img_wrapper">'
		for recipe in list.recipes
			src = recipe.smallURL
			#src = 'img/love.jpg' # for test only
			html += '<img class="menu_img" src="'+src+'">'
		html += '</div>'
		
		html += '<div style="float:left;width:100%;background-color:white;border-radius:5px;"><a id="Cook" class="button red" style="float:right;width:20%;margin-right:5%;" href="#Ingredients</span>">Cook</a><a id="View" class="button green" style="float:right;width:20%;margin-right:2%;" href="#MenuContent">View</a></div><div class="aDivider">&nbsp;</div>'
		html += '</div>'
		results.append html
		#console.log html
		#TODO add on click function to cook btn

		#Fetch detailed menu content on click
		##
		scope.find("#Menu"+id).find("#View")[0].onclick = do(id)->
			-> # closure
				$("#MenuContent").find("#Results").hide()
				$("#MenuContent").find("#Loading").show()
				getMenuContent($("#MenuContent"), id)
				undefined
		#

	scope.find("#infinite").text "Load More"
	undefined #avoid implicit return values
