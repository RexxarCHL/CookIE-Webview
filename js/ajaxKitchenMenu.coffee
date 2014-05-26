menuAjaxd = 0
lastId = -1
$(document).ready ->
	scrollerList = $('#main_Kitchen_Menus').scroller()
	scrollerList.addInfinite()
	$.bind(scrollerList, "infinite-scroll", ->
		console.log "kitchen menu infinite-scroll"
		self = this
		$("#main_Kitchen_Menus").find("#infinite").text "Loading..."
		scrollerList.addInfinite()

		#change setTimeout to ajax call
		clearTimeout lastId
		lastId = setTimeout(->
			getKitchenMenus(menuAjaxd, self)
		,1000)
		undefined #avoid implicit return values by Coffeescript
	)
	undefined #avoid implicit return values by Coffeescript

getKitchenMenus = (times, scrollObj) ->
	$.ajax(
		type: "GET"
		#TODO: determine url
		url: 'http://140.114.195.58:8080/CookIEServer/discover_recipelists'
		dataType: 'jsonp'
		crossDomain: true
		#TODO: determine data
		data: 
			'type': 'popular'
			'times': times
		jsonp: false
		timeout: 10000
		success: (data)->
			console.log "[SUCCESS]fetch kitchen menu"
			console.log data
			appendKitchenMenuList(data, scrollObj)
			menuAjaxd++
			undefined #avoid implicit return values by Coffeescript
		error: (data, status)->
			console.log "[ERROR]fetch kitchen menu: " + status
			$("#main_Kitchen_Menus").find("#infinite").text "Load More"
			scrollObj.clearInfinite();
			undefined #avoid implicit return values by Coffeescript
	)
	undefined #avoid implicit return values by Coffeescript

appendKitchenMenuList = (data, scrollObj)->
	if data.length is 0
		$("#main_Kitchen_Menus").find("#infinite").text "No more lists"
		scrollObj.clearInfinite();
		menuAjaxd--
		return 1;

	menuList = $('#KitchenMenuList')
	for list in data
		html = ''
		id = list.list_id
		title = list.name
		rating = list.rating
		#if rating is '0' then rating = 'no'
		html = '<div class="menu_box" id="KitchenMenu'+id+'">'
		html += '<h2 class="menu_title">'+title+'</h2>&nbsp;&nbsp;&nbsp;<i class="icon star">'+rating+' stars</i>&nbsp;&nbsp;<i class="icon chat">comments</i>'

		html += '<div class="menu_img">'
		for recipe in list.recipes
			src = recipe.imageUrl
			src = 'img/love.jpg' # for test only
			html += '<img src="'+src+'" height="20%">'
		html += '</div>'
		
		html += '<div class="menu_cooking_box"><a class="button red menu_cooking_btn" href="#Cooking">Cook</a></div><div style="display:inline-block;height:0;width:100%;">&nbsp;</div>'
		html += '</div>'
		menuList.append html
		#console.log html
		#TODO add on click function to cook btn

	$("#main_Kitchen_Menus").find("#infinite").text "Load More"
	scrollObj.clearInfinite();
	undefined #avoid implicit return values by Coffeescript

