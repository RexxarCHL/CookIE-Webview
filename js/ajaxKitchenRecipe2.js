// Generated by CoffeeScript 1.7.1
var getKitchenRecipes, kitchenRecipeAjaxd, lastId;

kitchenRecipeAjaxd = 0;

lastId = -1;

$(document).ready(function() {
  var scrollerList;
  scrollerList = $('#main_Kitchen_Recipes').scroller();
  scrollerList.addInfinite();
  $.bind(scrollerList, "infinite-scroll", function() {
    var self;
    console.log("kitchen recipe infinite-scroll");
    self = this;
    $("#main_Kitchen_Recipes").find("#infinite").text("Loading...");
    scrollerList.addInfinite();
    clearTimeout(lastId);
    lastId = setTimeout(function() {
      return getKitchenRecipes(kitchenRecipeAjaxd, self);
    }, 3000);
    return void 0;
  });
  return void 0;
});

getKitchenRecipes = function(times, scrollObj) {
  $.ajax({
    type: "GET",
    url: 'http://140.114.195.58:8080/CookIEServer/discover_recipes',
    dataType: 'jsonp',
    crossDomain: true,
    data: {
      'type': 'favorite',
      'times': times
    },
    jsonp: false,
    timeout: 10000,
    success: function(data) {
      var scope, scrollerList;
      console.log("[SUCCESS]fetch kitchen recipes");
      console.log(data);
      kitchenRecipeAjaxd++;
      scrollerList = $('#main_Kitchen_Recipes').scroller();
      scrollerList.clearInfinite();
      if (data.length === 0) {
        $("#main_Kitchen_Recipes").find("#infinite").text("No more recipes");
        kitchenRecipeAjaxd--;
        return void 0;
      }
      scope = $("#main_Kitchen_Recipes");
      appendRecipeResult(scope, data);
      return void 0;
    },
    error: function(data, status) {
      console.log("[ERROR]fetch kitchen recipes: " + status);
      console.log(data);
      $("#main_Kitchen_Recipes").find("#infinite").text("Load More");
      scrollObj.clearInfinite();
      return void 0;
    }
  });
  return void 0;
};
