// Generated by CoffeeScript 1.7.1
var allCatAjaxd, appendAllCategoryResult, getAllCategory, getSingleCategory, lastId, singleCatAjaxd, singleCatId;

allCatAjaxd = 0;

singleCatAjaxd = 0;

singleCatId = 26;

lastId = -1;

$(document).ready(function() {
  addInfiniteScroll($("#main_AllCategories"), 1000, function() {
    return getAllCategory(allCatAjaxd);
  });
  addInfiniteScroll($("#main_Category"), 1000, function() {
    return getSingleCategory(singleCatAjaxd, singleCatId);
  });
  return void 0;
});

getAllCategory = function(times) {
  $.ajax({
    type: "GET",
    url: "http://54.178.135.71:8080/CookIEServer/discover_tags",
    dataType: 'jsonp',
    crossDomain: true,
    data: {
      'times': times
    },
    jsonp: false,
    timeout: 10000,
    success: function(data) {
      var scrollerList;
      console.log("[SUCCESS]fetch categories");
      console.log(data);
      allCatAjaxd++;
      scrollerList = $("#main_AllCategories").scroller();
      scrollerList.clearInfinite();
      if (data.length === 0) {
        $("#main_AllCategories").find("#infinite").text("No more categories");
        allCatAjaxd--;
        return void 0;
      }
      appendAllCategoryResult(data);
      return void 0;
    },
    error: function(data) {
      var scrollerList;
      console.log("[ERROR]fetch kitchen menu: " + status);
      scrollerList = $("#main_AllCategories").scroller();
      scrollerList.clearInfinite();
      $("#main_AllCategories").find("#infinite").text("Error. Try Again?");
      return void 0;
    }
  });
  return void 0;
};

appendAllCategoryResult = function(data) {
  var cat, html, recipe, results, _i, _j, _len, _len1, _ref;
  console.log("append all category result");
  results = $("#main_AllCategories").find("#Results");
  for (_i = 0, _len = data.length; _i < _len; _i++) {
    cat = data[_i];
    if (cat.recipes.length === 0) {
      continue;
    }
    html = '<div class="category_box" id="' + cat.tag.tagId + '">';
    html += '<a href="#main_Category"><h2 style="margin-left:5px">' + cat.tag.tagName + '</h2>';
    _ref = cat.recipes;
    for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
      recipe = _ref[_j];
      html += '<div class="category_recipe"><img class="category_img" src="' + recipe.smallURL + '"><div style="margin-left:3px">' + recipe.name + '</div></div>';
    }
    html += '</a></div><div class="divider">&nbsp;</div>';
    results.append(html);
  }
  return void 0;
};

getSingleCategory = function(times, catId) {
  $.ajax({
    type: "GET",
    url: "http://54.178.135.71:8080/CookIEServer/discover_recipes",
    dataType: 'jsonp',
    crossDomain: true,
    data: {
      'type': 'category',
      'category': catId,
      'times': times
    },
    jsonp: false,
    timeout: 10000,
    success: function(data) {
      var scrollerList;
      console.log("[SUCCESS]fetch cat #" + catId);
      console.log(data);
      singleCatAjaxd++;
      scrollerList = $('#main_Category').scroller();
      scrollerList.clearInfinite();
      if (data.length === 0) {
        $("#main_Category").find("#infinite").html("No more recipes.");
        singleCatAjaxd--;
        return void 0;
      }
      appendRecipeResult($('#main_Category'), data);
      return void 0;
    },
    error: function(data, status) {
      console.log("[ERROR]fetch cat #" + catId);
      $("#main_Category").find("#infinite").html("Error. Try Again?");
      return void 0;
    }
  });
  return void 0;
};
