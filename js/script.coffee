window.AutoSuggest = class AutoSuggest
    constructor: ->

        @displayDetails
        @boxWidth = 0
        @countryNames = []
        @currentUrl = window.location.hrefs
        @countryObject = {}
        @i = 1
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
                onClickEvent: () =>
                    @createBoxDynamically()

        
        $("#searchInput").easyAutocomplete(@options)

        @widthOnPageLoad("page  url"+@currentUrl)
            
        $(".Search_Button").on 'click', () =>
            # @options.list.onChooseEvent()
            @onSearchClick()

        $("#searchInput").on('keydown', (e) => 
            keyCode = e.keyCode || e.which
            if (keyCode == 9) 
                e.preventDefault()
                @createBoxDynamically()    
        )

    widthOnPageLoad: () ->
        $(".easy-autocomplete").css("width","100%")
        $("#searchInput").css("width","100%")

    createBoxDynamically: () ->

        parentwidth = $(".easy-autocomplete").width()
        searchValue = $("#searchInput").val()
       
        if searchValue.length > 25
            dynamicWidth = searchValue.length * 8
        else
            dynamicWidth = searchValue.length * 7

        inputbox = '<input class="Search_Input dynamicInput" " type ="text" value ="'+searchValue+'" style="width:'+dynamicWidth+'px" />'
        spanElement = '<span class = "Search_Span" >'+inputbox+'</span>'

        $("#searchInput").val(" ")
        $(".easy-autocomplete").prepend(spanElement)
        latestname = $(".dynamicInput:first").val()
        @countryObject['name'+@i] = latestname
        @i += 1
        console.log @countryObject
        @changeMainSearchWidth(dynamicWidth+16)

    changeMainSearchWidth: (dynamicWidth) ->

        @boxWidth += dynamicWidth
        if(@boxWidth > 440)
            $("#searchInput").css("width","461px")
            @dynamicWidth = 0
        else   
            $("#searchInput").css("width","calc(100% - "+(@boxWidth)+"px)")


    onSearchClick: ->
       
        recursiveDecoded = decodeURIComponent( $.param( @countryObject ) )
        console.log ("search terms :- " +recursiveDecoded)

        advancedUrl = @currentUrl + "?" +recursiveDecoded
        console.log ("final url:- " +advancedUrl)
        window.location.href = advancedUrl
        # # @currentUrl = advancedUrl
        # console.log (@currentUrl)

        # console.log ("recursiveEncoded := " +recursiveEncoded)
       
    

$(document).ready ->
    autoObject = new AutoSuggest()
    autoObject.init()
