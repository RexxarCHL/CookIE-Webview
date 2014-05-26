recipeAjaxd = 0
lastId = -1

$(document).ready ->
	scrollerList = $('#main_Popular_Recipes').scroller()
	scrollerList.addInfinite()
	$.bind(scrollerList, "infinite-scroll", ->
		console.log "recipe infinite-scroll"
		self = this
		$("#main_Popular_Recipes").find("#infinite").text "Loading..."
		scrollerList.addInfinite()

		#change setTimeout to ajax call
		clearTimeout lastId
		lastId = setTimeout(->
			getPopularRecipes(recipeAjaxd, self)
		,3000)
		undefined #avoid implicit return values by Coffeescript
	)
	undefined #avoid implicit return values by Coffeescript

getPopularRecipes = (times, scrollObj) ->
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
			appendPopularRecipeList(data, scrollObj)
			recipeAjaxd++
			undefined #avoid implicit return values by Coffeescript
		error: (data, status)->
			console.log "[ERROR]fetch popular recipes: " + status
			console.log data
			$("#main_Popular_Recipes").find("#infinite").text "Load More"
			scrollObj.clearInfinite();
			undefined #avoid implicit return values by Coffeescript
	)
	undefined #avoid implicit return values by Coffeescript

appendPopularRecipeList = (data, scrollObj)->
	if data.length is 0
		$("#main_Popular_Recipes").find("#infinite").text "No more recipes"
		scrollObj.clearInfinite();
		recipeAjaxd--
		return 1;

	if data.length%2 then data.length-- # prevent empty image slot

	recipeList = $('#PopularRecipeList')
	count = 0
	for recipe in data
		html = ''
		id = recipe.recipe_id
		name = recipe.name
		rating = recipe.rating
		url = recipe.imageUrl
		url = 'img/love.jpg' # for test only
		if count%2 is 0 #left part of the row
			html += '<div class="recipe_list_row list_row_left" id="PopularRecipe'+id+'">'
		else
			html += '<div class="recipe_list_row list_row_right" id="PopularRecipe'+id+'">'
		
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

