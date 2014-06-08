// Generated by CoffeeScript 1.7.1

/*
ajaxSearchResults2.coffee
	initSelectBtn()
 		Initialize the Recipes/Menus tab button functionality.
 	search(query, times)
 		Search for 'query' in server. Fetch (times*20)th to (times*20+20)th results.
 	appendRecipeResult(scope, data)
 		Append 'data' to the #Results div in 'scope', in Recipe style.
 	appendMenuResult(scope, data)
 		Append 'data' to the #Results div in 'scope', in Menu style.
 	addInfiniteScroll(scope, delay, callback)
 		Add infinite scroll functionality to 'scope'. 'callback' is called after 'delay' miliseconds after infinite-scroll event is fired.
 */
var addInfiniteScroll, appendRecipeResult, initSelectBtn, search, searchAjaxd;

searchAjaxd = 0;

$(document).ready(function() {
  initSelectBtn();
  $("#SearchBar").keyup(function() {
    var lastQuery, query, scrollerList;
    console.log("searchbar keyup");
    scrollerList = $('#main_Search').scroller();
    clearTimeout(window.lastId);
    query = $("#SearchBar")[0].value;
    if (query === "") {
      searchAjaxd = 0;
      $("#main_Search").find("#Results").html("");
      $("#main_Search").find("#infinite").html("<i>Search for recipes, food ingredients ...</i>");
      return void 0;
    }
    scrollerList.clearInfinite();
    $("#main_Search").find("#infinite").text("Searching...");
    window.lastId = setTimeout(function() {
      search(query, searchAjaxd);
      return void 0;
    }, 1500);
    lastQuery = query;
    return void 0;
  });
  return void 0;
});

initSelectBtn = function() {
  return $("#SearchSelectTab").children().each(function() {
    $(this).on("click", function(evt) {
      var other;
      if ($(this).hasClass('orange')) {
        return void 0;
      }
      other = $(this).siblings()[0];
      $(other).removeClass('orange');
      $(this).addClass('orange');
      console.log("search tab switch");
      searchAjaxd = 0;
      $("#main_Search").find("#Results").html("");
      $("#main_Search").find("#infinite").html("<i>Search for recipes, food ingredients ...</i>");
      $("#SearchBar").trigger("keyup");
      return evt.stopPropagation();
    });
    return void 0;
  });
};

search = function(query, times) {
  var type, url;
  if ($("#SearchSelectTab").find('a').hasClass('orange')) {
    type = 0;
    url = 'http://54.178.135.71:8080/CookIEServer/discover_recipes';
  } else {
    type = 1;
    url = 'http://54.178.135.71:8080/CookIEServer/discover_recipelists';
  }
  $.ajax({
    type: "GET",
    url: url,
    dataType: 'jsonp',
    crossDomain: true,
    data: {
      'type': 'search',
      'name': query,
      'times': searchAjaxd
    },
    jsonp: false,
    timeout: 10000,
    success: function(data) {
      var scope, scrollerList;
      console.log("[SUCCESS]search");
      console.log(data);
      scope = $("#main_Search");
      if (searchAjaxd === 0) {
        addInfiniteScroll(scope, 1000, function() {
          return $("#SearchBar").trigger("keyup");
        });
      }
      searchAjaxd++;
      scrollerList = $("#main_Search").scroller();
      scrollerList.clearInfinite();
      if (data.length === 0) {
        if (searchAjaxd > 0) {
          $("#main_Search").find("#infinite").html("<i>No more results.</i>");
        } else {
          $("#main_Search").find("#infinite").html("<i>No result. Try another query?</i>");
        }
        searchAjaxd--;
        return void 0;
      }
      if (type) {
        appendMenuResult(scope, data);
      } else {
        appendRecipeResult(scope, data);
      }
      return void 0;
    },
    error: function(data, status) {
      console.log("[ERROR]search: " + status);
      return void 0;
    }
  });
  return void 0;
};

appendRecipeResult = function(scope, data) {
  var count, html, id, name, rating, recipe, results, url, _i, _len;
  console.log("append recipe for scope: " + scope[0].id);
  results = scope.find("#Results");
  results.find('.new').removeClass('new');
  count = 0;
  for (_i = 0, _len = data.length; _i < _len; _i++) {
    recipe = data[_i];
    html = '';
    id = recipe.recipe_id;
    name = recipe.name;
    rating = recipe.rating;
    url = recipe.smallURL;
    if (count % 2 === 0) {
      html += '<div class="recipe_item left new" id="Recipe' + id + '" recipe-id="' + id + '">';
    } else {
      html += '<div class="recipe_item right new" id="Recipe' + id + '" recipe-id="' + id + '">';
    }
    html += '<img class="recipe_image_wrapper" src="' + url + '">';
    html += '<div class="recipe_descrip">' + name + '</div>';
    html += '<div class="icon star recipe_descrip">' + rating + '</div>';
    html += '</div>';
    results.append(html);
    count++;
    scope.find("#Recipe" + id)[0].onclick = (function(id) {
      return function() {
        if (mode) {
          $(this).toggleClass('chosen');
          return void 0;
        }
        $.ui.loadContent("#RecipeContent");
        $("#RecipeContent").find("#Results").hide();
        $("#RecipeContent").find("#Loading").show();
        getRecipeContent(id);
        return void 0;
      };
    })(id);
  }
  results.find("#bottomBar").remove();
  results.append('<div id="bottomBar" style="display:block;height:0;clear:both;">&nbsp;</div>');
  scope.find("#infinite").text("Load More");
  return void 0;
};


/*
appendMenuResult = (scope, data)->
	console.log "append menu for scope: " + scope[0].id

	results = scope.find "#Results"
	results.find(".new").removeClass "new"

	for list in data
		html = ''
		id = list.list_id
		title = list.name
		rating = list.rating

		if rating is 0 then rating = 'No rating'
		else rating += " stars"
		
		html = '<div class="menu_wrapper new" id="Menu'+id+'">'
		html += '<h2 class="menu_title">'+title+'&nbsp;&nbsp;&nbsp;<i class="icon star">'+rating+'</i>&nbsp;&nbsp;<i class="icon chat">comments</i></h2>'

		html += '<div class="menu_img_wrapper">'
		for recipe in list.recipes
			src = recipe.smallURL
			 *src = 'img/love.jpg' # for test only
			html += '<img class="menu_img" src="'+src+'">'
		html += '</div>'
		
		html += '<div style="float:left;width:100%;background-color:white;border-radius:5px;"><a id="Cook" class="button red" style="float:right;width:20%;margin-right:5%;" href="#Ingredients</span>">Cook</a><a id="View" class="button green" style="float:right;width:20%;margin-right:2%;" href="#MenuContent">View</a></div><div class="aDivider">&nbsp;</div>'
		html += '</div>'
		results.append html
		 *console.log html
		 *TODO add on click function to cook btn

		 *!!! TODO MODIFY FROM COLLECTION TO MENUCONTENT !!!
		 *Fetch detailed menu content on click
		 *#
		scope.find("#Menu"+id).find("#View")[0].onclick = do(id)->
			-> # closure
				$("#Collection").find("#Results").hide()
				$("#Collection").find("#Loading").show()
				getMenuContent(id)
				undefined
		 *

	scope.find("#infinite").text "Load More"
	undefined #avoid implicit return values
 */

addInfiniteScroll = function(scope, delay, callback) {
  var scrollerList;
  console.log("add infinite-scroll to scope:" + scope[0].id);
  scrollerList = scope.scroller();
  scrollerList.clearInfinite();
  scrollerList.addInfinite();
  $.bind(scrollerList, 'infinite-scroll', function() {
    console.log(scope[0].id + " infinite-scroll");
    scope.find("#infinite").text("Loading more...");
    scrollerList.addInfinite();
    clearTimeout(window.lastId);
    return window.lastId = setTimeout(function() {
      return callback();
    }, delay);
  });
  return void 0;
};
