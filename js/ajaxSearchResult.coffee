lastId = -1
searchAjaxd = 0
lastQuery = '\n'
$(document).ready ->
	$("#SearchBar").keyup(->
		console.log "searchbar keyup"
		clearTimeout(lastId)

		query = $("#SearchBar").text()
		if query isnt lastQuery
			searchAjaxd = 0
			if query is ""
				$("#SearchBar").html "<i>Search for recipes, food ingredients ...</i>"
			return undefined

		lastId = setTimeout((query)->
					search query, searchAjaxd
					undefined #avoid implicit return value
				, 1500)
		lastQuery = query
		undefined #avoid implicit return value
	)
	undefined #avoid implicit return value

search = (query, times) ->
	$.ajax(
		type: "GET"
		#TODO: determine search url
		url: 'http://140.114.195.58:8080/CookIEServer/discover_recipelists'
		dataType: 'jsonp'
		crossDomain: true
		#TODO: determine data
		data: 
			'query': query
			'times': searchAjaxd
		jsonp: false
		timeout: 10000
		success: (data)->
			console.log "[SUCCESS]search"
			console.log data
			showSearchResult(data)
			searchAjaxd++
			undefined #avoid implicit return values by Coffeescript
		error: (data, status)->
			console.log "[ERROR]search: " + status
			undefined #avoid implicit return values by Coffeescript
	)
	undefined #avoid implicit return values by Coffeescript

showSearchResult = (data)->
	if data.length is 0
		$("#SearchBar").html "<i>No results. Search with another query?</i>"
		return undefined

	if searchAjaxd
		undefined
