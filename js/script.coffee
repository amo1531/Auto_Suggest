window.AutoSuggest = class AutoSuggest
	constructor: ->
		
	init: ->
		console.log "linked"
		$("#countryname").autocomplete(
			country = $("#countryname").val()
			$.ajax(
				url: 'json/countries.json',
				dataType: 'json',
				success: (data) ->
					displayDetails = ''
					$.each(data.countryCodes,(index,value)=>
						if(data.countryCodes[index].country_name.toLowerCase() == country.toLowerCase())
							displayDetails += '<li> Country Name:- '+data.countryCodes[index].country_name+'</li>'  
							displayDetails += '<li> Country Code:- '+data.countryCodes[index].country_code+'</li>'  
							displayDetails += '<li> Dialling Code:- '+data.countryCodes[index].dialling_code+'</li>'  
					)
					$("#results").html(displayDetails)
			)
		)

$(document).ready ->
	autoObject = new AutoSuggest()
	autoObject.init()