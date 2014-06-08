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
		url: "http://54.178.135.71:8080/CookIEServer/discover_category"
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

			$("#main_AllCategories").find("#infinite").text "Load more"
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
	results.find(".new").removeClass("new")

	for tagGroup in data
		if tagGroup.tagWithRecipe.length is 0 then continue
		html = '<div class="category_box" id="TagFilter'+tagGroup.tagfilter.filterId+'"><h2 style="margin-left:5px;">'+tagGroup.tagfilter.filterName+'</h2>'
		for tag in tagGroup.tagWithRecipe
			id = tag.tag.tagId
			html += '<div id="Tag'+id+'" class="cat_wrapper new" data-tag-id="'+id+'" data-times="0"><img class="cat_img" src="'+tag.mostPopularRecipe.smallURL+'"><div class="cat_text">'+tag.tag.tagName+'</div></div>'
	
		html += '</div><div class="divider">&nbsp;</div>'
		results.append html

	results.find(".new").forEach (elem)->
		$(elem).click ->
			$.ui.loadContent "#main_Category"
			times = this.getAttribute 'data-times'
			getSingleCategory times, this.getAttribute 'data-tag-id'
			this.setAttribute 'data-times', times+1
	
	undefined #avoid implicit rv

getSingleCategory = (times, tagId)->
	$.ajax(
		type: "GET"
		url: "http://54.178.135.71:8080/CookIEServer/get_tag"	
		dataType: 'jsonp'
		crossDomain: true
		data:
			'times': times
			'tag_id': tagId
		jsonp: false
		timeout: 10000
		success: (data)->
			console.log "[SUCCESS]fetch cat #"+tagId
			console.log data

			singleCatAjaxd++

			scrollerList = $('#main_Category').scroller()
			scrollerList.clearInfinite()
			if data.length is 0
				$("#main_Category").find("#infinite").html "No more recipes."
				singleCatAjaxd--
				return undefined

			#TODO change pageTitle
			$.ui.setTitle data.tag.tagName
			scope = $('#main_Category')
			scope.find("#Results").html ""
			appendRecipeResult(scope, data.recipes)
			undefined #avoid implicit rv
		error: (data, status)->
			console.log "[ERROR]fetch cat #"+tagId
			$("#main_Category").find("#infinite").html "Error. Try Again?"
			undefined #avoid implicit rv
	)
	
	undefined #avoid implicit rv
