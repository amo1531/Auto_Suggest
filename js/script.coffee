window.AutoSuggest = class AutoSuggest
    constructor: ->

        @displayDetails

    init: ->

        @options = 
            url: "./json/countries.json"
            getValue: "country_name"
            list:
                match: 
                    enabled: true
                onChooseEvent: ()->
                    countryname = $("#searchInput").getSelectedItemData().country_name
                    dialingcode = $("#searchInput").getSelectedItemData().dialling_code

                    console.log (countryname+" , "+dialingcode)

                    @displayDetails = '<li class="attribute" ><strong>Country Name: </strong>'+countryname+'</li><li class="value"><strong>Dialling Code: </strong>'+dialingcode+'</li>'
                    

                    $(".Results_list").html(@displayDetails)

        $("#searchInput").keydown(()->

             $(".Results_list").html(" ")
        )                
    
        $("#searchInput").easyAutocomplete(@options)
        

        # $(".Search_Button").on "click",() =>

$(document).ready ->
    autoObject = new AutoSuggest()
    autoObject.init()
