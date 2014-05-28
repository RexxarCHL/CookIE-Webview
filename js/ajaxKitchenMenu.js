// Generated by CoffeeScript 1.7.1
var getKitchenMenus, kitchenMenuAjaxd, lastId;

kitchenMenuAjaxd = 0;

lastId = -1;

$(document).ready(function() {
  var scrollerList;
  scrollerList = $('#main_Kitchen_Menus').scroller();
  scrollerList.addInfinite();
  $.bind(scrollerList, "infinite-scroll", function() {
    console.log("kitchen menu infinite-scroll");
    $("#main_Kitchen_Menus").find("#infinite").text("Loading...");
    scrollerList.addInfinite();
    clearTimeout(lastId);
    lastId = setTimeout(function() {
      return getKitchenMenus(kitchenMenuAjaxd);
    }, 1000);
    return void 0;
  });
  return void 0;
});

getKitchenMenus = function(times) {
  $.ajax({
    type: "GET",
    url: 'http://140.114.195.58:8080/CookIEServer/discover_recipelists',
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
      console.log("[SUCCESS]fetch kitchen menu");
      console.log(data);
      kitchenMenuAjaxd++;
      scrollerList = $('#main_Kitchen_Menus').scroller();
      scrollerList.clearInfinite();
      if (data.length === 0) {
        $("#main_Kitchen_Menus").find("#infinite").text("No more lists");
        menuAjaxd--;
        return void 0;
      }
      scope = $("#main_Kitchen_Menus");
      appendMenuResult(scope, data);
      return void 0;
    },
    error: function(data, status) {
      var scrollerList;
      console.log("[ERROR]fetch kitchen menu: " + status);
      $("#main_Kitchen_Menus").find("#infinite").text("Load More");
      scrollerList = $('#main_Kitchen_Menus').scroller();
      scrollerList.clearInfinite();
      return void 0;
    }
  });
  return void 0;
};
