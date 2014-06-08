$(document).ready ->
	$("body").find(".popup_btn").forEach (elem)->
		$(elem).click ->
			utilityDetect(this)

	undefined

utilityDetect = (elem)->
	console.log "Popup #"+elem.id
	switch elem.getAttribute 'data-function'
		when "edit"
			$("#popup_btn_trash").removeClass 'chosen'
			$(elem).toggleClass 'chosen'
			if $(elem).hasClass('chosen') then utilityEdit()
			else resetUtilBtn()
		when "trash"
			$("#popup_btn_edit").removeClass 'chosen'
			$(elem).toggleClass 'chosen'
			if $(elem).hasClass('chosen') then utilityTrash()
			else resetUtilBtn()
		else break
	undefined # avoid implicit rv

resetUtilBtn = ->
	$("#main_Kitchen_Recipes").find(".chosen").removeClass("chosen")
	utilBtn = $("#kitchenUtilityBtn")
	utilBtn.unbind 'click'
	utilBtn.html = "Tap on the Cog to begin."
	window.mode = 0

utilityEdit = ->
	console.log 'popup edit'
	window.mode = 1
	utilBtn = $("#kitchenUtilityBtn")
	utilBtn

	utilBtn.click ->
		alert "edit"
	undefined

utilityTrash = ->
	console.log 'popup trash'
	window.mode = 1
	utilBtn = $("#kitchenUtilityBtn")

	utilBtn.click ->
		alert "trash"
	undefined
