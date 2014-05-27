// Generated by CoffeeScript 1.7.1
var appendPopularMenuList, getPopularMenus, lastId, menuAjaxd;

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
      console.log("[SUCCESS]fetch popular menu");
      console.log(data);
      appendPopularMenuList(data, scrollObj);
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

appendPopularMenuList = function(data, scrollObj) {
  var html, id, list, menuList, rating, recipe, src, title, _i, _j, _len, _len1, _ref;
  if (data === null || data.length === 0) {
    $("#main_Popular_Menus").find("#infinite").text("No more lists");
    scrollObj.clearInfinite();
    menuAjaxd--;
    return 1;
  }
  menuList = $('#PopularMenuList');
  for (_i = 0, _len = data.length; _i < _len; _i++) {
    list = data[_i];
    html = '';
    id = list.list_id;
    title = list.name;
    rating = list.rating;
    html = '<div class="menu_box" id="PopularMenu' + id + '">';
    html += '<h2 class="menu_title">' + title + '</h2>&nbsp;&nbsp;&nbsp;<i class="icon star">' + rating + ' stars</i>&nbsp;&nbsp;<i class="icon chat">comments</i>';
    html += '<div class="menu_img">';
    _ref = list.recipes;
    for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
      recipe = _ref[_j];
      src = recipe.imageUrl;
      src = 'img/love.jpg';
      html += '<img src="' + src + '" height="20%">';
    }
    html += '</div>';
    html += '<div class="menu_cooking_box"><a class="button red menu_cooking_btn" href="#Cooking">Cook</a></div><div style="display:inline-block;height:0;width:100%;">&nbsp;</div>';
    html += '</div>';
    menuList.append(html);
  }
  $("#main_Popular_Menus").find("#infinite").text("Load More");
  scrollObj.clearInfinite();
  return void 0;
};
