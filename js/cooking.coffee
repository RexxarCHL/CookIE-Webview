### Class Definitions ###
class Step
	constructor: (@startTime, @duration, @percentage, @recipeName, @digest)->
		@endTime = @startTime + @duration
		undefined

	@calculatePercentage: (currentTime)->
		Math.ceil (@endTime - currentTime) / @duration * 100

### Function definitions ###
# on-panel-load function for #Step aka cooking step
cookingStarted = ->
	if not window.cookingData? then return undefined
	cookingData = window.cookingData
	currentStep = window.currentStep
	finishPercentage = Math.ceil (currentStep+1) / window.cookingData.steps.length * 100
	window.currentTime = 0

	console.log "cooking started"

	# load this/next step data
	$("#Step").attr "data-title", "Step #{currentStep+1} (#{finishPercentage}%)"
	loadStep(currentStep)

	undefined # avoid implicit rv

loadStep = (currentStep)->
	if currentStep >= window.cookingData.steps.length
		console.log "finished"
		$.ui.loadContent "Finish"
		return undefined


	console.log "load step##{currentStep}"
	window.currentStep = currentStep
	thisStep = window.cookingData.steps[currentStep]
	finishPercentage = Math.ceil (currentStep+1) / window.cookingData.steps.length * 100
	scope = $("#Step")

	$.ui.setTitle "Step #{currentStep+1} (#{finishPercentage}%)"

	# load this step
	scope.find(".this_step_recipe_name").html thisStep.recipeName
	if thisStep.imageURL?
		console.log "img:#{thisStep.imageURL}"
		scope.find(".this_step_img").attr "src", thisStep.imageURL
		scope.find(".this_step_img_wrapper").show()
	else
		console.log "no img"
		scope.find(".this_step_img_wrapper").hide()
	scope.find(".this_step_digest").html thisStep.digest

	# load next step info
	nextStep = window.cookingData.steps[currentStep+1]
	if nextStep?
		scope.find(".next_step_name").html nextStep.stepName
		scope.find(".next_step_time").html nextStep.time
	else
		scope.find(".next_step_name").html "Final Step Reached"
		scope.find(".next_step_time").html "00:00"
		scope.find(".step_next_btn").html "Finish "
	scope.find(".step_next_btn").unbind 'click'
	scope.find(".step_next_btn").click ->
		loadStep(currentStep+1)



