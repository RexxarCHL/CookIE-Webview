allCatAjaxd = 0
singleCatAjaxd = 0
singleCatId = 26
lastId = -1
$(document).ready ->
	addInfiniteScroll($("#main_AllCategories"), 1000, -> getAllCategory(allCatAjaxd))
	addInfiniteScroll($("#main_Category"), 1000, -> getSingleCategory(singleCatAjaxd, singleCatId))

	undefined #prevent implicit rv

getAllCategory = (times) ->
	$.ajax(
		type: "GET"
		url: "http://54.178.135.71:8080/CookIEServer/discover_tags"
		dataType: 'jsonp'
		crossDomain: true
		data:
			'times': times
		jsonp: false
		timeout: 10000
		success: (data)->
			console.log "[SUCCESS]fetch categories"
			console.log data

			allCatAjaxd++

			scrollerList = $("#main_AllCategories").scroller()
			scrollerList.clearInfinite()

			if data.length is 0
				$("#main_AllCategories").find("#infinite").text "No more categories"
				allCatAjaxd--
				return undefined

			appendAllCategoryResult(data)
			undefined #avoid implicit rv
		error: (data)->
			console.log "[ERROR]fetch kitchen menu: " + status
			scrollerList = $("#main_AllCategories").scroller()
			scrollerList.clearInfinite()
			$("#main_AllCategories").find("#infinite").text "Error. Try Again?"
			undefined #avoid implicit rv

	)

	undefined #avoid implicit rv

appendAllCategoryResult = (data)->
	console.log "append all category result"

	results = $("#main_AllCategories").find("#Results")
	for cat in data
		if cat.recipes.length is 0 then continue
		html = '<div class="category_box" id="'+cat.tag.tagId+'">'
		html += '<a href="#main_Category"><h2 style="margin-left:5px">'+cat.tag.tagName+'</h2>'
		for recipe in cat.recipes
			html += '<div class="category_recipe"><img class="category_img" src="'+recipe.smallURL+'"><div style="margin-left:3px">'+recipe.name+'</div></div>'
		html += '</a></div><div class="divider">&nbsp;</div>'

		results.append html

	undefined

getSingleCategory = (times, catId)->
	$.ajax(
		type: "GET"
		url: "http://54.178.135.71:8080/CookIEServer/discover_recipes"	
		dataType: 'jsonp'
		crossDomain: true
		data:
			'type': 'category'
			'category': catId
			'times': times
		jsonp: false
		timeout: 10000
		success: (data)->
			console.log "[SUCCESS]fetch cat #"+catId
			console.log data

			singleCatAjaxd++

			scrollerList = $('#main_Category').scroller()
			scrollerList.clearInfinite()
			if data.length is 0
				$("#main_Category").find("#infinite").html "No more recipes."
				singleCatAjaxd--
				return undefined

			appendRecipeResult($('#main_Category'), data)
			undefined #avoid implicit rv
		error: (data, status)->
			console.log "[ERROR]fetch cat #"+catId
			$("#main_Category").find("#infinite").html "Error. Try Again?"
			undefined #avoid implicit rv
	)

	undefined #avoid implicit rv
