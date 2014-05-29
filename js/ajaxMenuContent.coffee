getMenuContent = (menuId)->
	$.ajax(
		type: 'GET'
		url: 'http://54.178.135.71:8080/CookIEServer/recipelist'
		dataType: 'jsonp'
		crossDomain: true
		data:
			'list_id': recipeId
		jsonp: false
		timeout: 10000
		success: (data)->
			console.log "[SUCCESS]fetch menu #"+menuId
			console.log data

			scope = $("#Collection")
			setTimeout(loadMenuContent(scope, data), 1000)
			undefined #avoid implicit rv
		error: (data, status)->
			console.log "[ERROR]fetch recipe #"+recipeId
			console.log data

			undefined #avoid implicit rv
	)

loadMenuContent = (scope, data)->

	undefined #avoid implicit rv