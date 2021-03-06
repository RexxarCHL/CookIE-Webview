kitchenRecipeAjaxd = 0
$(document).ready ->
	addInfiniteScroll($('#main_Kitchen_Recipes'), 3000, ->getKitchenRecipes(kitchenRecipeAjaxd, self))
	return #avoid implicit return values by Coffeescript

getKitchenRecipes = (times) ->
	$.ajax(
		type: "GET"
		url: 'http://54.178.135.71:8080/CookIEServer/discover_recipes'
		#dataType: 'jsonp'
		#crossDomain: true
		#jsonp: false
		dataType: 'application/json'
		data: 
			'user_id': window.user_id
			'token': window.token
			'type': 'favorite'
			'times': times
		timeout: 10000
		success: (data)->
			data = JSON.parse(data)
			console.log "[SUCCESS]fetch kitchen recipes"
			console.log data

			kitchenRecipeAjaxd++

			scrollerList = $('#main_Kitchen_Recipes').scroller()
			scrollerList.clearInfinite()
			
			if data.length is 0
				$("#main_Kitchen_Recipes").find("#infinite").text "No more recipes"
				kitchenRecipeAjaxd--
				return

			scope = $("#main_Kitchen_Recipes")
			appendRecipeResult(scope, data)
			
			return #avoid implicit return values by Coffeescript
		error: (data, status)->
			console.log "[ERROR]fetch kitchen recipes: " + status
			console.log data
			$("#main_Kitchen_Recipes").find("#infinite").text "Load More"
			$('#main_Kitchen_Recipes').scroller().clearInfinite();
			return #avoid implicit return values by Coffeescript
	)
	return #avoid implicit return values by Coffeescript
	