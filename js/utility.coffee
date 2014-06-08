$(document).ready ->
	$("body").find(".popup_btn").forEach (elem)->
		$(elem).click ->
			utilityDetect(this)

	undefined

utilityDetect = (elem)->
	console.log "Popup #"+elem.id
	switch elem.getAttribute 'data-function'
		when "edit"
			utilityEdit()
		when "trash"
			utilityTrash()
		else break
	undefined # avoid implicit rv

utilityEdit = ->
	console.log 'popup edit'
	undefined

utilityTrash = ->
	console.log 'popup trash'
	undefined