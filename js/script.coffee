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

        $("#searchInput").easyAutocomplete(@options)

        @widthOnPageLoad()

        # $("#searchInput").keydown(()->
        #      $(".Results_list").html(" ")
        # )                
            
        $(".Search_Button").on 'click', () =>
            @onSearchClick()

    
    widthOnPageLoad: () ->
        $(".easy-autocomplete").css("width","100%")
        $("#searchInput").css("width","100%")

    onSearchClick: ->
        searchValue = $("#searchInput").val()
        console.log searchValue.length
        parentwidth = $(".easy-autocomplete").width()
        console.log parentwidth
        @options.list.onChooseEvent() 
        # $("#searchInput").css('width','')
        inputbox = '<input class="Search_Input" value ="'+searchValue+'" type ="text" />'
    
        $("#searchInput").val(" ")
        $(".easy-autocomplete").prepend(inputbox)




$(document).ready ->
    autoObject = new AutoSuggest()
    autoObject.init()
