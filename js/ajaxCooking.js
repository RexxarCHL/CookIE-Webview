// Generated by CoffeeScript 1.7.1
var getCookingIngredientList, getScheduledRecipe, loadIngredientList;

getCookingIngredientList = function(recipeIds) {
  var data, id, _i, _len;
  data = '';
  recipeIds = JSON.parse(recipeIds);
  for (_i = 0, _len = recipeIds.length; _i < _len; _i++) {
    id = recipeIds[_i];
    data += 'recipes=' + id + '&';
  }
  $.ajax({
    type: 'GET',
    url: 'http://54.178.135.71:8080/CookIEServer/list_ingredient?' + data,
    timeout: 10000,
    success: function(data) {
      var scope;
      data = JSON.parse(data);
      console.log('[SUCCESS] fetching #' + recipeIds);
      console.log(data);
      scope = $('#Ingredients');
      loadIngredientList(scope, data, recipeIds);
      return void 0;
    },
    error: function(data, status) {
      console.log('[ERROR] fetching #' + recipeIds);
      console.log(data);
      return void 0;
    }
  });
  return void 0;
};

loadIngredientList = function(scope, list, recipeIds) {
  var html, ingredient, listContent, _i, _len;
  listContent = scope.find('#ListContent');
  listContent.html("");
  for (_i = 0, _len = list.length; _i < _len; _i++) {
    ingredient = list[_i];
    html = "<input type='checkbox' id='" + ingredient.ingredientId + "' /><label for='" + ingredient.ingredientId + "'>";
    html += "<b>" + ingredient.amount + ingredient.unitName + "</b> " + ingredient.ingredientName + "</label>";
    listContent.append(html);
  }
  scope.find("#Next").unbind('click');
  scope.find("#Next").click((function(list) {
    return function() {
      return getScheduledRecipe(recipeIds);
    };
  })(list));
  scope.find("#Loading").hide();
  return scope.find("#Results").show();
};

getScheduledRecipe = function(recipeIds) {
  var data, id, _i, _len;
  console.log("schedule_recipe #" + recipeIds);
  data = '';
  for (_i = 0, _len = recipeIds.length; _i < _len; _i++) {
    id = recipeIds[_i];
    data += 'recipes=' + id + '&';
  }
  $.ajax({
    type: 'GET',
    url: 'http://54.178.135.71:8080/CookIEServer/schedule_recipe?' + data,
    success: function(data) {
      var scope;
      data = JSON.parse(data);
      console.log('[SUCCESS] fetching #' + recipeIds);
      console.log(data);
      scope = $('#Cooking');
      loadIngredientList(scope, data, recipeIds);
      return void 0;
    },
    error: function(data, status) {
      console.log('[ERROR] fetching #' + recipeIds);
      console.log(data);
      return void 0;
    }
  });
  return void 0;
};
