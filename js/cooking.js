// Generated by CoffeeScript 1.7.1

/* Class Definitions */
var Step, checkNextStep, checkProgress, cookingStarted, loadStep, pushStepToWaitingQueue, showMostUrgentTwoSteps;

Step = (function() {
  function Step(stepNum, startTime, duration, recipeName, digest, people) {
    this.stepNum = stepNum;
    this.startTime = startTime;
    this.duration = duration;
    this.recipeName = recipeName;
    this.digest = digest;
    this.people = people;
    this.finishTime = this.startTime + this.duration;
    this.percentage = 0;
    void 0;
  }

  Step.calculatePercentage = function(currentTime) {
    return this.percentage = Math.ceil((this.endTime - currentTime) / this.duration * 100);
  };

  return Step;

})();


/* Function definitions */

cookingStarted = function() {
  var cookingData, currentStepNum, finishPercentage;
  if (window.cookingData == null) {
    return void 0;
  }
  cookingData = window.cookingData;
  currentStepNum = window.currentStepNum;
  finishPercentage = Math.ceil((currentStepNum + 1) / window.cookingData.steps.length * 100);
  window.currentTime = 0;
  window.waitingStepQueue = [];
  console.log("cooking started");
  $("#Step").attr("data-title", "Step " + (currentStepNum + 1) + " (" + finishPercentage + "%)");
  loadStep(currentStepNum);
  return void 0;
};

loadStep = function(stepNum) {
  var finishPercentage, nextStep, scope, stepsLen, thisStep;
  stepsLen = window.cookingData.steps.length;
  if (stepNum >= stepsLen) {
    console.log("finished");
    $.ui.loadContent("Finish");
    return void 0;
  }
  console.log("load step#" + stepNum);
  thisStep = window.cookingData.steps[stepNum];
  window.currentStep = new Step(stepNum, parseInt(thisStep.startTime), convertTimeToSeconds(thisStep.time), thisStep.recipeName, thisStep.digest, thisStep.people);
  window.currentStepNum = stepNum;
  finishPercentage = Math.ceil((stepNum + 1) / stepsLen * 100);
  scope = $("#Step");
  $.ui.setTitle("Step " + (stepNum + 1) + " (" + finishPercentage + "%)");
  scope.find(".this_step_recipe_name").html(thisStep.recipeName);
  if (thisStep.imageURL != null) {
    scope.find(".this_step_img").attr("src", thisStep.imageURL);
    scope.find(".this_step_img_wrapper").show();
  } else {
    scope.find(".this_step_img_wrapper").hide();
  }
  scope.find(".this_step_digest").html(thisStep.digest);
  nextStep = window.cookingData.steps[stepNum + 1];
  if (nextStep != null) {
    scope.find(".next_step_name").html(nextStep.stepName);
    scope.find(".next_step_time").html(thisStep.time);
  } else {
    scope.find(".next_step_name").html("Final Step Reached");
    scope.find(".next_step_time").html("00:00");
    scope.find(".step_next_btn").html("Finish ");
  }
  scope.find(".step_next_btn").unbind('click');
  scope.find(".step_next_btn").click(function() {
    checkNextStep();
    return void 0;
  });
  return void 0;
};

checkNextStep = function() {
  var ans, currentTime, thisStep, thisStepFinishTime;
  currentTime = window.currentTime;
  thisStep = window.currentStep;
  thisStepFinishTime = thisStep.finishTime;
  if (thisStepFinishTime - currentTime <= 30) {
    console.log("<=30, time=" + thisStepFinishTime);
    window.currentTime = thisStepFinishTime;
  } else if (thisStep.people === false) {
    console.log(">30 but people=false, endtime=" + thisStepFinishTime);
    pushStepToWaitingQueue(thisStep, currentTime);
  } else {
    console.log(">30, currentTime=" + currentTime + ", time=" + thisStepFinishTime);
    ans = confirm("Steps waiting. Continue?");
    if (ans === true) {
      pushStepToWaitingQueue(thisStep, currentTime);
      window.currentTime = thisStepFinishTime;
    } else {
      return void 0;
    }
  }
  return loadStep(thisStep.stepNum + 1);
};

checkProgress = function() {};

pushStepToWaitingQueue = function(step, currentTime) {
  console.log("push " + step.stepNum + ": " + step.digest + " into queue");
  window.waitingStepQueue.push(step);
  window.waitingStepQueue.sort(function(a, b) {
    return a.endTime - b.endTime;
  });
  return showMostUrgentTwoSteps;
};

showMostUrgentTwoSteps = function() {};
