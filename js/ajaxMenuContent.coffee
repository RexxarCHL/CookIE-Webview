getMenuContent = (scope, menuId)->
	console.log "fetch menu#"+menuId
	$.ajax(
		type: 'GET'
		url: 'http://54.178.135.71:8080/CookIEServer/recipelist'
		dataType: 'jsonp'
		crossDomain: true
		data:
			'list_id': menuId
		jsonp: false
		timeout: 10000
		success: (data)->
			console.log "[SUCCESS]fetch menu #"+menuId
			console.log data

			setTimeout(loadMenuContent(scope, data), 1000)
			undefined #avoid implicit rv
		error: (data, status)->
			console.log "[ERROR]fetch recipe #"+recipeId
			console.log data

			undefined #avoid implicit rv
	)
	undefined # avoid implicit rv

loadMenuContent = (scope, menu)->
	console.log "load for scope: "+scope[0].id

	$.ui.setTitle menu.listName
	scope.find("#Results").hide()
	scope.find("#Loading").show()

	# image
	imgHolder = scope.find ".menuContent_imgHolder"
	imgHolder.html ""
	for recipe in menu.recipes
		html = '<div class="menuContent_imgWrapper_left">'
		html += '<div class="menuContent_imgText_left">'+recipe.name+'</div>'
		html += '<img class="menuContent_img" src="'+recipe.smallURL+'">'
		html += '</div>'
		imgHolder.append html

	# description
	if menu.rating is 0 then menu.rating = 'No rating'
	scope.find("#MenuRating").html menu.rating
	scope.find("#MenuByUser").html "By: "+menu.userName
	scope.find("#MenuTime").html "Time: "+menu.costTime

	# messages
	scope.find("#MenuDescription").html menu.description

	# notes
	# do something

	# photos
	# do something
	
	scope.find("#Loading").hide()
	scope.find("#Results").show()
	undefined #avoid implicit rv