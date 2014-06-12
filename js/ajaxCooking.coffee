getCookingIngredientList = (recipeIds)->
	$.ajax(
		type: "POST"
		url: "http://54.178.135.71:8080/CookIEServer/list_ingredient"
		contentType: "application/json"
		origin: "http://54.178.135.71:8080/CookIEServer/"
		data:
			recipes: recipeIds
		timeout: 10000
		success: (data)->
			data = JSON.parse data
			console.log '[SUCCESS]fetch ing. list for recipes ##{recipeIds}'
			console.log data

			undefined # avoid implicit rv
		error: (data, status)->
			console.log "[ERROR]fetch ing. list for recipes ##{recipeIds}"
			undefined # avoid implicit rv
	)
	undefined # avoid implicit rv