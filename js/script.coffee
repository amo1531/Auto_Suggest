window.AutoSuggest = class AutoSuggest
    constructor: ->

        @displayDetails
        @boxWidth = 0
        @countryNames = []
        @currentUrl = window.location.href
        @countryObject = {}
        @encodedSearchTerm
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

        @widthOnPageLoad()
        $(".Search_Button").on 'click', () =>
           advancedUrl = @onSearchClick(@currentUrl,@countryObject)
           console.log advancedUrl
           # @encodedSearchTerm = encodeURIComponent(advancedUrl).replace(/%20/g,'+')
           # console.log @encodedSearchTerm

        $("#searchInput").on('keydown', (e) => 
            keyCode = e.keyCode || e.which
            if (keyCode == 9) 
                e.preventDefault()
                @createBoxDynamically()    
        )
        $(".Search_cross").on "click", () =>
            # removeItemFromInput(this)
            # console.log $(this).closest("input")
            console.log ("clicked")

    widthOnPageLoad: () ->
        $(".easy-autocomplete").css("width","100%")
        $("#searchInput").css("width","100%")

    createBoxDynamically: () ->
        # parentwidth = $(".easy-autocomplete").width()
        searchValue = $("#searchInput").val()
        console.log searchValue.length
        dynamicWidth = searchValue.length * 8
        if searchValue.length > 24
            dynamicWidth = searchValue.length * 7
        else
            dynamicWidth = searchValue.length * 8

        inputbox = '<input class="Search_Input DynamicInput" " type ="text" value ="'+searchValue+'"/>'+'<a class="Search_cross">×</a>'
        spanElement = '<span class = "SearchSpan" style="width:'+dynamicWidth+'px" >'+inputbox+'</span>'

        $("#searchInput").val("")
        $(".easy-autocomplete").prepend(spanElement)
        latestname = $(".DynamicInput:first").val()
        @countryObject['name'+@i] = latestname
        @i += 1
        console.log @countryObject
        @changeMainSearchWidth(dynamicWidth+24)

    changeMainSearchWidth: (dynamicWidth) ->

        @boxWidth += dynamicWidth
        if(@boxWidth > 440)
            $("#searchInput").css("width","461px")
            @dynamicWidth = 0
        else   
            $("#searchInput").css("width","calc(100% - "+(@boxWidth)+"px)")


    onSearchClick: (url ,obj) ->

        qs = ""
        $.each(obj,(key,value) =>
            val = obj[key]
            qs += encodeURIComponent(key) + "=" + encodeURIComponent(val) + "&"
        )
        if (qs.length > 0)
             qs = qs.substring(0, qs.length-1)
        url = url + "?" + qs

        return url
                    
        # recursiveDecoded = decodeURIComponent( $.param( @countryObject ) )
        # console.log ("search terms :- " +recursiveDecoded)

        # advancedUrl = @currentUrl + "?" +recursiveDecoded
        # console.log ("final url:- " +advancedUrl)
    # removeItemFromInput: (current) ->
        


$(document).ready ->
    autoObject = new AutoSuggest()
    autoObject.init()
