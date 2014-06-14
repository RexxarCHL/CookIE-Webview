### Class Definitions ###
class Step
	constructor: (@startTime, @duration, @percentage, @digest)->
		@endTime = @startTime + @duration
		undefined

	@calculatePercentage: (currentTime)->
		Math.ceil (@endTime - currentTime) / @duration * 100

### Function definitions ###
# on-panel-load function for #Step aka cooking step
cookingStarted = ->
	if window.cookingData is undefined then return undefined

	cookingData = window.cookingData
	currentStep = window.currentStep
	finishPercentage = Math.ceil currentStep / cookingData.steps.length * 100

	console.log "cooking started"

	# set panel title
	$.ui.setTitle "Step #{currentStep} (#{finishPercentage}%)"

	# load this/next step data
	loadStep(currentStep)

loadStep = (currentStep)->
	console.log "load step##{currentStep}"
	thisStep = window.cookingData.steps[currentStep]
	scope = $("#Step")

	# load this step
	scope.find(".this_step_recipe_name").html thisStep.recipeName
	if thisStep.imageURL isnt undefined
		console.log "img"
		scope.find(".this_step_img").attr "src", thisStep.imageURL
		scope.find(".this_step_img_wrapper").show()
	else
		console.log "no img"
		scope.find(".this_step_img_wrapper").hide()
	scope.find(".this_step_digest").html thisStep.digest

	# load next step info
	nextStep = window.cookingData.steps[currentStep+1]
	scope.find(".next_step_name").html nextStep.stepName
	scope.find(".next_step_time").html nextStep.time