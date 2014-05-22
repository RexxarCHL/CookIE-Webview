// Generated by CoffeeScript 1.7.1
var appendPopularRecipe, getPopularRecipe, lastId, recipeAjaxd;

$(document).ready(function() {
  var scrollerList;
  scrollerList = $('#main_Popular_Recipes').scroller();
  scrollerList.addInfinite();
  return $.bind(scrollerList, "infinite-scroll", function() {
    var lastId, self;
    console.log("recipe infinite-scroll");
    self = this;
    $("#main_Popular_Recipes").find("#infinite").text("Loading...");
    scrollerList.addInfinite();
    clearTimeout(lastId);
    lastId = setTimeout(function() {
      return getPopularRecipe(recipeAjaxd, self);
    }, 3000);
    return void 0;
  });
});

recipeAjaxd = 0;

lastId = -1;

getPopularRecipe = function(times, scrollObj) {
  $.ajax({
    type: "GET",
    url: 'http://140.114.195.58:8080/CookIEServer/discover_recipes',
    dataType: 'jsonp',
    crossDomain: true,
    data: {
      'type': 'popular',
      'times': times
    },
    jsonp: false,
    timeout: 10000,
    success: function(data) {
      console.log("success");
      console.log(data);
      appendPopularRecipe(data, scrollObj);
      recipeAjaxd++;
      return void 0;
    },
    error: function(data, status) {
      console.log("error" + status);
      console.log(data);
      $("#main_Popular_Recipes").find("#infinite").text("Load More");
      scrollObj.clearInfinite();
      return void 0;
    }
  });
  return void 0;
};

appendPopularRecipe = function(data, scrollObj) {
  var count, html, id, name, rating, recipe, recipeList, url, _i, _len;
  if (data.length === 0) {
    $("#main_Popular_Recipes").find("#infinite").text("No more lists");
    scrollObj.clearInfinite();
    recipeAjaxd--;
    return 1;
  }
  if (data.length % 2) {
    data.length--;
  }
  recipeList = $('#PopularRecipeList');
  count = 0;
  for (_i = 0, _len = data.length; _i < _len; _i++) {
    recipe = data[_i];
    html = '';
    id = recipe.recipe_id;
    name = recipe.name;
    rating = recipe.rating;
    url = recipe.imageUrl;
    url = 'img/love.jpg';
    if (count % 2 === 0) {
      html += '<div id="PopularRecipe' + id + '" style="display:inline-block; width:48%; margin:5px 1.5% 5px 0.4%; background-color:white;float:left;">';
    } else {
      html += '<div id="PopularRecipe' + id + '" style="display:inline-block; width:48%; margin:5px 0.4% 5px 1.5%; background-color:white;float:right;">';
    }
    html += '<img style="max-width:100%;max-height:100%;" src="' + url + '">';
    html += '<div class="recipeName">' + name + '</div>';
    html += '<div class="recipeRating">' + rating + '</div>';
    html += '</div>';
    recipeList.append(html);
    count++;
  }
  recipeList.find("#bottomBar").remove();
  recipeList.append('<div id="bottomBar" style="display:block;height:0;clear:both;">&nbsp;</div>');
  $("#main_Popular_Recipes").find("#infinite").text("Load More");
  scrollObj.clearInfinite();
  return void 0;
};
