getRecipeContent = (recipeId)->
	$.ajax(
		type: 'GET'
		url: 'http://54.178.135.71:8080/CookIEServer/recipedigest'
		#dataType: 'jsonp'
		#crossDomain: true
		#jsonp: false
		dataType: 'application/json'
		data:
			'recipe_id': recipeId
		timeout: 10000
		success: (data)->
			data = JSON.parse(data)
			console.log "[SUCCESS]fetch recipe #"+recipeId
			console.log data

			scope = $("#RecipeContent")
			setTimeout(loadRecipeContent(scope, data), 1000)
			undefined #avoid implicit rv
		error: (data, status)->
			console.log "[ERROR]fetch recipe #"+recipeId
			console.log data

			undefined #avoid implicit rv
	)
	undefined #avoid implicit rv

loadRecipeContent = (scope, recipe)->
	$.ui.setTitle recipe.recipeName
	scope.find("#Results").hide()
	scope.find("#Loading").show()

	# Info
	scope.find("#RecipeImg").attr("src", recipe.image)
	scope.find("#RecipeDescription").text recipe.description
	scope.find("#RecipeUploadInfo").text "Uploaded by: "+recipe.authorName+", "+(new Date(recipe.date))
	#scope.find("#RecipeTime").text "Time needed: "+recipe.timeNeeded

	# Ingredients
	ingredientList = scope.find("#RecipeIngredientList")
	ingredientList.html "" #remove previous content
	for group in recipe.ingredientGroup
		html = ''
		for ingredient in group.ingredients
			html += '<li>'+ingredient.ingredientName+" .............. "+ingredient.amount+" "+ingredient.unitName
		ingredientList.append html

	# Steps
	stepList = scope.find("#RecipeSteps")
	stepList.html "" #remove previous content
	for step, i in recipe.stepDigests
		html = '<li>'+i+'. '+step.digest+'</li>'
		stepList.append html

	# Comments
		# do something
	# Messages
		# do something
	#Photos
	imgList = scope.find("#RecipePhotos")
		# do something


	scope.find("#Loading").hide()
	scope.find("#Results").show()

	undefined #avoid implicit rv