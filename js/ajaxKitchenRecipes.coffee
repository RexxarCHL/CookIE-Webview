kitchenRecipeAjaxd = 0
lastId = -1
$(document).ready ->
	scrollerList = $("#main_Kitchen_Recipes").scroller()
	scrollerList.addInfinite()
	$.bind(scrollerList, "infinite_scroll", ->
		console.log "kitchen recipe infinite_scroll"
		self = this
		$("#main_Kitchen_Recipes").find("#infinite").text "Loading..."
		scrollerList.addInfinite()

		clearTimeout lastId
		lastId = setTimeout(->
			getKitchenRecipes()
		, 3000)
		undefined #avoid implicit return values by CoffeeScript
	)
	undefined #avoid implicit return values by CoffeeScript

getKitchenRecipes = (times, scrollObj) ->
	$.ajax(
		type: "GET"
		#TODO: url to be determined
		url: 'http://140.114.195.58:8080/CookIEServer/discover_recipes'
		dataType: 'jsonp'
		crossDomain: true
		#TODO: data to be determined
		data:
			'type': 'popular'
			'times': times
		jsonp: false
		timeout: 10000
		success: (data)->
			console.log "[SUCCESS]fetch kitchen recipes"
			console.log data
			appendKitchenRecipeList(data, scrollObj)
			recipeAjaxd++
			undefined #avoid implicit return values by Coffeescript
		error: (data, status)->
			console.log "[ERROR]fetch kitchen recipes: " + status
			console.log data
			$("#main_Kitchen_Recipes").find("#infinite").text "Load More"
			scrollObj.clearInfinite();
			undefined #avoid implicit return values by Coffeescript
	)
	undefined #avoid implicit return values by Coffeescript

appendKitchenRecipeList = (data, scrollObj) ->
	if data.length is 0
		$("#main_Kitchen_Recipes").find("#infinite").text "No more recipes"
		scrollObj.clearInfinite();
		recipeAjaxd--
		return 1;

	if data.length%2 then data.length-- # prevent empty image slot

	recipeList = $('#KitchenRecipeList')
	count = 0
	for recipe in data
		html = ''
		id = recipe.recipe_id
		name = recipe.name
		rating = recipe.rating
		url = recipe.imageUrl
		url = 'img/love.jpg' # for test only
		if count%2 is 0 #left part of the row
			html += '<div class="recipe_list_row list_row_left" id="KitchenRecipe'+id+'">'
		else
			html += '<div class="recipe_list_row list_row_right" id="KitchenRecipe'+id+'">'
		
		html += '<img class="recipe_img" src="'+url+'">'
		html += '<div class="recipe_title">'+name+'</div>'
		html += '<div class="icon star recipe_rating">'+rating+'</div>'
		html += '</div>'

		recipeList.append html
		#console.log html
		count++
		# TODO Add onclick fcn to link to recipe

	recipeList.find("#bottomBar").remove()
	recipeList.append '<div id="bottomBar" style="display:block;height:0;clear:both;">&nbsp;</div>'
	$("#main_Popular_Recipes").find("#infinite").text "Load More"
	scrollObj.clearInfinite();
	undefined #avoid implicit return values by Coffeescript