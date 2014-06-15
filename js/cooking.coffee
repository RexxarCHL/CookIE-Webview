### Class Definitions ###
class Step
	constructor: (@stepNum, @startTime, @duration, @recipeName, @digest, @people)->
		@finishTime = @startTime + @duration
		@percentage = 0
		undefined

	@calculatePercentage: (currentTime)->
		@percentage = Math.ceil (@endTime - currentTime) / @duration * 100

### Function definitions ###
# on-panel-load function for #Step aka cooking step
cookingStarted = ->
	if not window.cookingData? then return undefined
	cookingData = window.cookingData
	currentStepNum = window.currentStepNum
	finishPercentage = Math.ceil (currentStepNum+1) / window.cookingData.steps.length * 100
	window.currentTime = 0
	window.waitingStepQueue = []

	console.log "cooking started"

	# load this/next step data
	$("#Step").attr "data-title", "Step #{currentStepNum+1} (#{finishPercentage}%)"
	loadStep(currentStepNum)

	undefined # avoid implicit rv

loadStep = (stepNum)->
	stepsLen = window.cookingData.steps.length
	if stepNum >= stepsLen
		console.log "finished"
		$.ui.loadContent "Finish"
		return undefined

	console.log "load step##{stepNum}"
	thisStep = window.cookingData.steps[stepNum]
	window.currentStep = new Step(stepNum, parseInt(thisStep.startTime), convertTimeToSeconds(thisStep.time), thisStep.recipeName, thisStep.digest, thisStep.people)
	window.currentStepNum = stepNum

	finishPercentage = Math.ceil (stepNum+1) / stepsLen * 100
	scope = $("#Step")

	$.ui.setTitle "Step #{stepNum+1} (#{finishPercentage}%)"

	# load this step
	scope.find(".this_step_recipe_name").html thisStep.recipeName
	if thisStep.imageURL?
		scope.find(".this_step_img").attr "src", thisStep.imageURL
		scope.find(".this_step_img_wrapper").show()
	else
		scope.find(".this_step_img_wrapper").hide()
	scope.find(".this_step_digest").html thisStep.digest

	# load next step info
	nextStep = window.cookingData.steps[stepNum+1]
	if nextStep?
		scope.find(".next_step_name").html nextStep.stepName
		scope.find(".next_step_time").html thisStep.time
	else
		scope.find(".next_step_name").html "Final Step Reached"
		scope.find(".next_step_time").html "00:00"
		scope.find(".step_next_btn").html "Finish "
	scope.find(".step_next_btn").unbind 'click'
	scope.find(".step_next_btn").click ->
		checkNextStep()
		undefined # avoid implicit rv

	undefined # avoid implicit rv

checkNextStep = ->
	## TODO CHECK START TIME OF NEXT STEP AND COMPARE TO CURRENT STEP
	currentTime = window.currentTime
	thisStep = window.currentStep
	thisStepFinishTime = thisStep.finishTime
	if thisStepFinishTime - currentTime <= 30
		console.log "<=30, time=#{thisStepFinishTime}"
		window.currentTime = thisStepFinishTime
	else if thisStep.people is false
		console.log ">30 but people=false, endtime=#{thisStepFinishTime}"
		pushStepToWaitingQueue thisStep, currentTime
	else
		console.log ">30, currentTime=#{currentTime}, time=#{thisStepFinishTime}"
		ans = confirm "Steps waiting. Continue?"
		if ans is yes
			pushStepToWaitingQueue thisStep, currentTime
			window.currentTime = thisStepFinishTime
		else
			return undefined

	loadStep(thisStep.stepNum+1)
	# avoid implicit rv

checkProgress = ->


pushStepToWaitingQueue = (step, currentTime)->
	console.log "push #{step.stepNum}: #{step.digest} into queue"
	window.waitingStepQueue.push step
	window.waitingStepQueue.sort (a,b)->
		a.endTime - b.endTime
	showMostUrgentTwoSteps
	#checkProgress

showMostUrgentTwoSteps = ->
