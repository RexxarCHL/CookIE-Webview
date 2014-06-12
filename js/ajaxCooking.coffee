getCookingIngredientList = (recipeIds)->
	data = ''
	recipeIds = JSON.parse(recipeIds)
	for id in recipeIds
		data += 'recipes='+id+'&'
	$.ajax(
			type: 'GET'
			url: 'http://54.178.135.71:8080/CookIEServer/list_ingredient?'+data
			timeout: 10000
			success: (data)->
				data = JSON.parse(data)
				console.log '[SUCCESS] fetching #'+recipeIds
				console.log data

				scope = $('#Ingredients')
				loadIngredientList(scope, data)

				undefined # avoid implicit rv
			error: (data, status)->
				console.log '[ERROR] fetching #'+recipeIds
				console.log data

				undefined # avoid implicit rv
	)
	undefined # avoid implicit rv

loadIngredientList = (scope, list)->
	listContent = scope.find('#ListContent')
	listContent.html ""

	for ingredient in list
		html = "<input type='checkbox' id='#{ingredient.ingredientId}' /><label for='#{ingredient.ingredientId}'>"
		html += "<b>#{ingredient.amount}#{ingredient.unitName}</b> #{ingredient.ingredientName}</label>"
		listContent.append html

	scope.find("#Loading").hide()
	scope.find("#Results").show()