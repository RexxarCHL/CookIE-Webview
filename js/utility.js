// Generated by CoffeeScript 1.7.1
var resetUtilBtn, utilityDetect, utilityEdit, utilityTrash;

$(document).ready(function() {
  $("body").find(".popup_btn").forEach(function(elem) {
    return $(elem).click(function() {
      return utilityDetect(this);
    });
  });
  return void 0;
});

utilityDetect = function(elem) {
  console.log("Popup #" + elem.id);
  switch (elem.getAttribute('data-function')) {
    case "edit":
      $("#popup_btn_trash").removeClass('chosen');
      $(elem).toggleClass('chosen');
      if ($(elem).hasClass('chosen')) {
        utilityEdit();
      } else {
        resetUtilBtn();
      }
      break;
    case "trash":
      $("#popup_btn_edit").removeClass('chosen');
      $(elem).toggleClass('chosen');
      if ($(elem).hasClass('chosen')) {
        utilityTrash();
      } else {
        resetUtilBtn();
      }
      break;
    default:
      break;
  }
  return void 0;
};

resetUtilBtn = function() {
  var utilBtn;
  utilBtn = $("#kitchenUtilityBtn");
  utilBtn.unbind('click');
  utilBtn.html = "Tap on the Cog to begin.";
  return window.mode = 0;
};

utilityEdit = function() {
  var utilBtn;
  console.log('popup edit');
  window.mode = 1;
  utilBtn = $("#kitchenUtilityBtn");
  utilBtn.click(function() {
    return alert("edit");
  });
  return void 0;
};

utilityTrash = function() {
  var utilBtn;
  console.log('popup trash');
  window.mode = 1;
  utilBtn = $("#kitchenUtilityBtn");
  utilBtn.click(function() {
    return alert("trash");
  });
  return void 0;
};