recipeAjaxd = 0
lastId = -1

$(document).ready ->
	scrollerList = $('#main_Popular_Recipes').scroller()
	scrollerList.addInfinite()
	$.bind(scrollerList, "infinite-scroll", ->
		console.log "recipe infinite-scroll"
		$("#main_Popular_Recipes").find("#infinite").text "Loading..."
		scrollerList.addInfinite()

		#change setTimeout to ajax call
		clearTimeout lastId
		lastId = setTimeout(->
			getPopularRecipes(recipeAjaxd)
		,3000)
		undefined #avoid implicit return values by Coffeescript
	)
	undefined #avoid implicit return values by Coffeescript

getPopularRecipes = (times) ->
	$.ajax(
		type: "GET"
		url: 'http://140.114.195.58:8080/CookIEServer/discover_recipes'
		#url:'./ajaxTest.html'
		dataType: 'jsonp'
		crossDomain: true
		data: 
			'type': 'popular'
			'times': times
		jsonp: false
		timeout: 10000
		success: (data)->
			console.log "[SUCCESS]fetch popular recipes"
			console.log data

			recipeAjaxd++

			scrollerList = $('#main_Popular_Recipes').scroller()
			scrollerList.clearInfinite()

			if data.length is 0
				$("#main_Popular_Recipes").find("#infinite").text "No more recipes"
				recipeAjaxd--
				return undefined

			scope = $("#main_Popular_Recipes")
			appendRecipeResult(scope, data)
			undefined #avoid implicit return values by Coffeescript
		error: (data, status)->
			console.log "[ERROR]fetch popular recipes: " + status
			console.log data
			$("#main_Popular_Recipes").find("#infinite").text "Load More"
			scrollerList = $('#main_Popular_Recipes').scroller()
			scrollerList.clearInfinite()
			undefined #avoid implicit return values by Coffeescript
	)
	undefined #avoid implicit return values by Coffeescript
	