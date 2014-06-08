recipeAjaxd = 0

$(document).ready ->
	addInfiniteScroll($('#main_Popular_Recipes'), 3000, ->getPopularRecipes(recipeAjaxd))
	undefined #avoid implicit return values by Coffeescript

getPopularRecipes = (times) ->
	$.ajax(
		type: "GET"
		url: 'http://54.178.135.71:8080/CookIEServer/discover_recipes'
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
	