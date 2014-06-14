$(document).ready ->
	$('body').find('.popup_btn').forEach (elem)->
		$(elem).click ->
			utilityDetect(this)
		undefined # avoid implicit rv

	undefined

utilityDetect = (elem)->
	console.log 'Popup #'+elem.id
	switch elem.getAttribute 'data-function'
		when 'edit'
			$('#popup_btn_trash').removeClass 'selected'
			$(elem).toggleClass 'selected'
			if $(elem).hasClass('selected') then utilityEdit()
			else resetUtilBtn()
		when 'trash'
			$('#popup_btn_edit').removeClass 'selected'
			$(elem).toggleClass 'selected'
			if $(elem).hasClass('selected') then utilityTrash()
			else resetUtilBtn()
		else break
	undefined # avoid implicit rv

resetUtilBtn = ->
	$('#main_Kitchen_Recipes').find('.selected').removeClass('selected')
	utilBtn = $('#kitchenUtilityBtn')
	utilBtn.removeClass 'trash'
	utilBtn.removeClass 'edit'
	utilBtn.unbind 'click'
	utilBtn.html 'Tap on the Cog to begin.'
	window.mode = 0

utilityEdit = ->
	console.log 'popup edit'
	window.mode = 1
	utilBtn = $('#kitchenUtilityBtn')
	utilBtn.removeClass 'trash'
	utilBtn.addClass 'edit'
	utilBtn.html 'Start Cooking.'

	utilBtn.click ->
		selectedId = findChosenRecipeId()
		$.ui.popup(
			title: '為Menu命名'
			message: '<input type="text"><label>公開</label><input id="toggle2" type="checkbox" name="toggle2" value="1" class="toggle"><label for="toggle2" data-on="私密" data-off="公開"><span></span></label><br>'
			cancelText:"Cancel"
			cancelCallback: ->
				console.log "cancelled"
				undefined
			doneText:"Done"
			doneCallback: ->
				console.log "Done for!"
			cancelOnly:false
		)


	undefined

kitchenRecipesAjaxd = 0 #DEBUG
utilityTrash = ->
	console.log 'popup trash'
	window.mode = 1
	utilBtn = $('#kitchenUtilityBtn')
	utilBtn.removeClass 'edit'
	utilBtn.addClass 'trash'
	utilBtn.html 'Delete selected recipe.'

	utilBtn.click ->
		selectedId = findChosenRecipeId()
		if selectedId.length is 0 then return undefined

		ans = confirm "Deleteing recipes from Kitchen. Are you sure?"
		if ans is false then return undefined

		data = 
			'type': 'recipe'
			'recipe_id': selectedId
		console.log data
		data = JSON.stringify(data)
		console.log data
		
		$.ajax(
			type: 'DELETE'
			url: 'http://54.178.135.71:8080/CookIEServer/favorite'
			dataType: 'application/json'
			#crossDomain: true
			#jsonp: false
			data: data
			timeout: 10000
			success: (data)->
				#data = JSON.parse(data)
				console.log "[SUCCESS] deleting recipes #"+selectedId
				console.log data
				
				scope = $("#main_Kitchen_Recipes")
				scope.find("#Results").html ""
				scope.find("#infinite").text "Reloading..."
				kitchenRecipesAjaxd = 0
				getKitchenRecipes(kitchenRecipesAjaxd)
				undefined # avoid implicit rv
			error: (data, status)->
				console.log "[ERROR] deleting recipes #"+selectedId
				console.log data

				undefined # avoid implicit rv
		)
		

		undefined # avoid implicit rv

	undefined

findChosenRecipeId = ->
	recipeSelectedId = []
	$('#main_Kitchen_Recipes').find('.chosen').forEach (elem)->
		recipeSelectedId.push elem.getAttribute 'data-recipe-id'
	console.log recipeSelectedId
	return recipeSelectedId

parseTimeToMinutes = (time)->
	time = time.split ":"
	time = parseInt(time[0])*60 + parseInt(time[1]) + parseInt(time[2])/60
