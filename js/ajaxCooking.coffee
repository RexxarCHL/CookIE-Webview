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
	$.ui.showMask "Loading data from server..."

	data = ''
	#recipeIds = JSON.parse(recipeIds)
	for id in recipeIds
		data += 'recipes='+id+'&'
	$.ajax(
			type: 'GET'
			url: 'http://54.178.135.71:8080/CookIEServer/schedule_recipe?'+data
			#timeout: 10000
			success: (data)->
				data = JSON.parse(data)
				console.log '[SUCCESS] fetching #'+recipeIds
				console.log data

				scope = $('#Cooking')
				window.cookingData = data
				appendSteps scope, data

				undefined # avoid implicit rv
			error: (data, status)->
				console.log '[ERROR] fetching #'+recipeIds
				console.log data

				undefined # avoid implicit rv
	)
	undefined

appendSteps = (scope, data)->
	console.log "append steps"
	$.ui.showMask "Processing Data"

	# append time
	scope.find("#totalCookingTime").html "<b>"+parseTimeToMinutes(data.originTime)+" mins -> "+parseTimeToMinutes(data.scheduledTime)+" min</b>"

	# append step list
	stepsList = scope.find "#stepsList"
	stepsList.html '<h2 style="margin-left:5%;">Steps:</h2>'
	html = ""
	for step in data.steps
		html = '<div class="overview_stepWrapper">'
		if steps.imageURL isnt undefined
			html += '<img src="'+steps.imageURL+'" class="overview_stepImg"></img>'
		html += '<h3 class="overview_stepText">'+(_i + 1)+'. '+step.digest+'</h3>'
		html += '</div>'
		stepsList.append html

	$.ui.hideMask();
	undefined
