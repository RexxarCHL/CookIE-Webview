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
				loadIngredientList(scope, data, recipeIds)

				undefined # avoid implicit rv
			error: (data, status)->
				console.log '[ERROR] fetching #'+recipeIds
				console.log data

				undefined # avoid implicit rv
	)
	undefined # avoid implicit rv

loadIngredientList = (scope, list, recipeIds)->
	listContent = scope.find('#ListContent')
	listContent.html ""

	for ingredient in list
		html = "<input type='checkbox' id='#{ingredient.ingredientId}' /><label for='#{ingredient.ingredientId}'>"
		html += "<b>#{ingredient.amount}#{ingredient.unitName}</b> #{ingredient.ingredientName}</label>"
		listContent.append html



	scope.find("#Next").unbind 'click'
	scope.find("#Next").click( do(list)->
		-> #closure
			getScheduledRecipe(recipeIds)
	)


	scope.find("#Loading").hide()
	scope.find("#Results").show()

getScheduledRecipe = (recipeIds)->
	console.log "schedule_recipe #"+recipeIds
	undefined