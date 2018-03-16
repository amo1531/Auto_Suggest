window.AutoSuggest = class AutoSuggest
	constructor: ->

        @displayDetails = "Details:"

        # $(window).on "resize", () =>
        #     location.reload()

	init: ->

		@options = 
            url: "./json/countries.json"
            getValue: "country_name"
            list:
                match: 
                    enabled: true
                onChooseEvent: ()->
                    countryname = $("#countryname").getSelectedItemData().country_name
                    dialingcode = $("#countryname").getSelectedItemData().dialling_code

                    #@displayDetails = '<li>'+countryname+'</li>'
                    #@displayDetails = '<li>'+dialingcodes+'</li>'

                    @displayDetails = '<li class="attribute" ><strong>Country Name: </strong>'+countryname+'</li><li class="value"><strong>Dialling Code: </strong>'+dialingcode+'</li>'
                    

                    $(".Results_list").html(@displayDetails)

                    
            
        $("#countryname").easyAutocomplete(@options)
		

        $(".Search_Button").on "click",() =>

$(document).ready ->
	autoObject = new AutoSuggest()
	autoObject.init()


	