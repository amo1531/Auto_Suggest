window.AutoSuggest = class AutoSuggest
    constructor: ->

        @displayDetails
        @boxWidth = 0
        @newInputArray = []
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
                    $(".Results_list").append(@displayDetails)


        $("#searchInput").easyAutocomplete(@options)

        @widthOnPageLoad()
            
        $(".Search_Button").on 'click', () =>
            @onSearchClick()

        # $('#searchInput').keypress((e) =>
        #     if(e.which == 13)
        #         @onSearchClick()
        #     )

    widthOnPageLoad: () ->
        $(".easy-autocomplete").css("width","100%")
        $("#searchInput").css("width","100%")

    onSearchClick: ->

        parentwidth = $(".easy-autocomplete").width()
        # console.log parentwidth
        @options.list.onChooseEvent() 

        searchValue = $("#searchInput").val()
        if searchValue.length > 25
            dynamicWidth = searchValue.length * 8
        else
            dynamicWidth = searchValue.length * 7

        console.log "search value length:- "+searchValue.length
        console.log "dynamic width:- "+dynamicWidth

        inputbox = '<input class="Search_Input dynamicInput" " type ="text" value ="'+searchValue+'" style="width:'+dynamicWidth+'px" />'
        console.log inputbox
        $("#searchInput").val(" ")
        $(".easy-autocomplete").prepend(inputbox)
        @changeMainSearchWidth(dynamicWidth+16)

    changeMainSearchWidth: (dynamicWidth) ->
        console.log "width with padding- "+dynamicWidth 
        @boxWidth += dynamicWidth
        console.log ("totalwidth"+@boxWidth)
        $("#searchInput").css("width","calc(100% - "+(@boxWidth)+"px)");


$(document).ready ->
    autoObject = new AutoSuggest()
    autoObject.init()
