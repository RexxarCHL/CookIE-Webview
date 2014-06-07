###
ajaxSearchResults2.coffee
	initSelectBtn()
 		Initialize the Recipes/Menus tab button functionality.
 	search(query, times)
 		Search for 'query' in server. Fetch (times*20)th to (times*20+20)th results.
 	appendRecipeResult(scope, data)
 		Append 'data' to the #Results div in 'scope', in Recipe style.
 	appendMenuResult(scope, data)
 		Append 'data' to the #Results div in 'scope', in Menu style.
 	addInfiniteScroll(scope, delay, callback)
 		Add infinite scroll functionality to 'scope'. 'callback' is called after 'delay' miliseconds after infinite-scroll event is fired.
###

lastId = -1
searchAjaxd = 0
$(document).ready ->
	initSelectBtn()
	$("#SearchBar").keyup(->
		console.log "searchbar keyup"
		scrollerList = $('#main_Search').scroller()
		clearTimeout(lastId)

		query =  $("#SearchBar")[0].value
		if query is ""
			searchAjaxd = 0
			$("#main_Search").find("#Results").html ""
			$("#main_Search").find("#infinite").html "<i>Search for recipes, food ingredients ...</i>"
			return undefined

		scrollerList.clearInfinite()
		$("#main_Search").find("#infinite").text "Searching..."
		lastId = setTimeout(->
					search query, searchAjaxd
					undefined #avoid implicit return value
				, 1500)
		lastQuery = query
		undefined #avoid implicit return value
	)
	undefined #avoid implicit return value

initSelectBtn = ->
	$("#SearchSelectTab").children().each(->
		$(this).on("click", (evt)->
			if $(this).hasClass 'orange'
				return undefined

			other = $(this).siblings()[0]
			$(other).removeClass 'orange'
			$(this).addClass 'orange'
			console.log "search tab switch"
			searchAjaxd = 0
			$("#main_Search").find("#Results").html ""
			$("#main_Search").find("#infinite").html "<i>Search for recipes, food ingredients ...</i>"
			$("#SearchBar").trigger("keyup")

			evt.stopPropagation()
		)
		undefined
	)

search = (query, times) ->
	if $("#SearchSelectTab").find('a').hasClass('orange')
		type = 0
		url = 'http://54.178.135.71:8080/CookIEServer/discover_recipes'
	else
		type = 1
		url = 'http://54.178.135.71:8080/CookIEServer/discover_recipelists'

	$.ajax(
		type: "GET"
		#TODO: determine search url
		url: url
		dataType: 'jsonp'
		crossDomain: true
		#TODO: determine data
		data: 
			'type': 'search'
			'name': query
			'times': searchAjaxd
		jsonp: false
		timeout: 10000
		success: (data)->
			console.log "[SUCCESS]search"
			console.log data

			scope = $("#main_Search")
			if searchAjaxd is 0
				addInfiniteScroll(scope, 1000, ->$("#SearchBar").trigger("keyup"))

			searchAjaxd++

			scrollerList = $("#main_Search").scroller()
			scrollerList.clearInfinite()

			if data.length is 0
				$("#main_Search").find("#infinite").html "<i>No more results.</i>"
				searchAjaxd--;
				return undefined

			if type then appendMenuResult(scope, data)
			else appendRecipeResult(scope, data)
			undefined #avoid implicit return values by Coffeescript
		error: (data, status)->
			console.log "[ERROR]search: " + status
			undefined #avoid implicit return values by Coffeescript
	)
	undefined #avoid implicit return values by Coffeescript

appendRecipeResult = (scope, data)->
	console.log "append recipe for scope: " + scope[0].id
	if data.length%2 and data.length isnt 1 then data.length-- #prevent empty slot

	results = scope.find "#Results"
	count = 0
	for recipe in data
		html = ''
		id = recipe.recipe_id
		name = recipe.name
		rating = recipe.rating
		url = recipe.smallURL
		#url = 'img/love.jpg' # for test only
		if count%2 is 0 #left part of the row
			html += '<div class="recipe_item left" id="Recipe'+id+'">'
		else
			html += '<div class="recipe_item right" id="Recipe'+id+'">'
		
		html += '<a href="#RecipeContent"><img class="recipe_img" src="'+url+'"></a>'
		html += '<div class="recipe_title">'+name+'</div>'
		html += '<div class="icon star recipe_rating">'+rating+'</div>'
		html += '</div>'

		results.append html
		#console.log html
		count++
		
		#Fetch detailed recipe content on click
		scope.find("#Recipe"+id).find("img")[0].onclick = do (id)->
			-> # closure 
				$("#RecipeContent").find("#Results").hide()
				$("#RecipeContent").find("#Loading").show()
				getRecipeContent(id)
				undefined

		

	results.find("#bottomBar").remove()
	results.append '<div id="bottomBar" style="display:block;height:0;clear:both;">&nbsp;</div>'
	scope.find("#infinite").text "Load More"
	undefined #avoid implicit return value

appendMenuResult = (scope, data)->
	console.log "append menu for scope: " + scope[0].id

	results = scope.find "#Results"
	for list in data
		html = ''
		id = list.list_id
		title = list.name
		rating = list.rating

		if rating is 0 then rating = 'No rating'
		else rating += " stars"
		
		html = '<div class="menu_box" id="Menu'+id+'">'
		html += '<h2 class="menu_title" style="margin-left:5px;color:black;">'+title+'&nbsp;&nbsp;&nbsp;<i class="icon star">'+rating+'</i>&nbsp;&nbsp;<i class="icon chat">comments</i></h2>'

		html += '<div class="menu_img">'
		for recipe in list.recipes
			src = recipe.smallURL
			#src = 'img/love.jpg' # for test only
			html += '<img src="'+src+'" height="20%">'
		html += '</div>'
		
		html += '<div class="menu_cooking_box"><a id="Cook" class="button red menu_cooking_btn" href="#Cooking" style="margin-right:5%;">Cook</a><a id="View" class="button green menu_view_btn" style="float:right;width:20%;margin-right:2%;" href="#Collection">View</a></div><div style="display:inline-block;height:0;width:100%;">&nbsp;</div>'
		html += '</div>'
		results.append html
		#console.log html
		#TODO add on click function to cook btn

		#Fetch detailed menu content on click
		scope.find("#Menu"+id).find("#View")[0].onclick = do(id)->
			-> # closure
				$("#Collection").find("#Results").hide()
				$("#Collection").find("#Loading").show()
				getMenuContent(id)
				undefined

	scope.find("#infinite").text "Load More"
	undefined #avoid implicit return values

addInfiniteScroll = (scope, delay, callback)->
	console.log "add infinite-scroll to scope:" + scope[0].id
	scrollerList = scope.scroller()
	scrollerList.clearInfinite()
	scrollerList.addInfinite()
	$.bind(scrollerList, 'infinite-scroll', ->
		console.log scope[0].id+" infinite-scroll"
		scope.find("#infinite").text "Loading more..."
		scrollerList.addInfinite()

		clearTimeout lastId
		lastId = setTimeout(->
			callback()
		, delay)
	)
	undefined #avoid implicit return values
