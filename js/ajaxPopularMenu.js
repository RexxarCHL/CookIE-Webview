// Generated by CoffeeScript 1.7.1
var getPopularMenus, lastId, menuAjaxd;

menuAjaxd = 0;

lastId = -1;

$(document).ready(function() {
  var scrollerList;
  scrollerList = $('#main_Popular_Menus').scroller();
  scrollerList.addInfinite();
  $.bind(scrollerList, "infinite-scroll", function() {
    var self;
    console.log("menu infinite-scroll");
    self = this;
    $("#main_Popular_Menus").find("#infinite").text("Loading...");
    scrollerList.addInfinite();
    clearTimeout(lastId);
    lastId = setTimeout(function() {
      return getPopularMenus(menuAjaxd, self);
    }, 1000);
    return void 0;
  });
  return void 0;
});

getPopularMenus = function(times, scrollObj) {
  $.ajax({
    type: "GET",
    url: 'http://140.114.195.58:8080/CookIEServer/discover_recipelists',
    dataType: 'jsonp',
    crossDomain: true,
    data: {
      'type': 'popular',
      'times': times
    },
    jsonp: false,
    timeout: 10000,
    success: function(data) {
      var scope, scrollerList;
      console.log("[SUCCESS]fetch popular menu");
      console.log(data);
      scrollerList = $('#main_Popular_Menus').scroller();
      scrollerList.clearInfinite();
      if (data === null || data.length === 0) {
        $("#main_Popular_Menus").find("#infinite").text("No more menu");
        scrollObj.clearInfinite();
        menuAjaxd--;
        return void 0;
      }
      scope = $("#main_Popular_Menus");
      appendMenuResult(scope, data);
      menuAjaxd++;
      return void 0;
    },
    error: function(data, status) {
      console.log("[ERROR]fetch popular menu: " + status);
      $("#main_Popular_Menus").find("#infinite").text("Load More");
      scrollObj.clearInfinite();
      return void 0;
    }
  });
  return void 0;
};
