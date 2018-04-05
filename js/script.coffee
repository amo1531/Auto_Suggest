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
                    @displayDetails = '<li class="name"><p><label><strong>Country Name: </strong></label><label class = "countryname" >'+countryname+
                    '</label></p><p class="code"><label><strong>Dialling Code: </strong></label><label class = "dialingcode" >'+dialingcode+'</label></p></li>'
                    $(".Results_list").append(@displayDetails)
                onClickEvent: () =>
                    @createBoxDynamically()

        
        $("#searchInput").easyAutocomplete(@options)

        console.log window.location.href
        @widthOnPageLoad()

        $(".Search_Button").on 'click', () =>

            modifiedValue = ""
            inputBoxes = $(".Search_InputWrapper").find(".DynamicInput")

            $.each(inputBoxes,(index,elements) =>
                searchValue = $(elements).val()
                modifiedValue = modifiedValue + searchValue + "+"
            )
            modifiedValue = modifiedValue.substring(0, modifiedValue.length-1)
            advancedUrl = @currentUrl + "?countryNames=" + modifiedValue
            console.log advancedUrl
            if (history.pushState) 
                newurl = advancedUrl
                window.history.pushState({path:newurl},'',newurl);

        $("#searchInput").on('keydown', (e) => 
            keyCode = e.keyCode || e.which
            if (keyCode == 9) 
                e.preventDefault()
                @createBoxDynamically()    
        )

        $(".Search_InputWrapper").on "click", ".Search_cross", (e) =>

            closestEle = $(e.currentTarget)
            valueToBeRemoved = closestEle.siblings("input").val()
            res = $(".Results_list").find("li .countryname")  
            $.each(res,(i,v) =>
                if (valueToBeRemoved == $(v).html())
                    $(v).parent().parent().remove()
            )

            @removeItemFromInput(closestEle)  
             

    widthOnPageLoad: () ->
        $(".easy-autocomplete").css("width","100%")
        $("#searchInput").css("width","100%")

    createBoxDynamically: () ->
        
        searchValue = $("#searchInput").val()
        dynamicWidth = searchValue.length * 8
        if searchValue.length > 24
            dynamicWidth = searchValue.length * 7
        else
            dynamicWidth = searchValue.length * 8

        inputbox = '<input class="Search_Input DynamicInput" " type ="text" value ="'+searchValue+'"/>'+'<a class="Search_cross">×</a>'
        spanElement = '<span class = "SearchSpan" style="width:'+dynamicWidth+'px" >'+inputbox+'</span>'

        $("#searchInput").val("")
        $(".easy-autocomplete").prepend(spanElement)
        @changeMainSearchWidth(dynamicWidth+24)

    changeMainSearchWidth: (dynamicWidth) ->

        @boxWidth += dynamicWidth
        if(@boxWidth > 440)
            $("#searchInput").css("width","461px")
            @dynamicWidth = 0
        else   
            $("#searchInput").css("width","calc(100% - "+(@boxWidth)+"px)")


    # onSearchClick: (url ,obj) ->

    #     qs = ""
    #     $.each(obj,(key,value) =>
    #         val = obj[key]
    #         qs += encodeURIComponent(key) + "=" + encodeURIComponent(val) + "&"
    #     )
    #     if (qs.length > 0)
    #          qs = qs.substring(0, qs.length-1)
    #     url = url + "?" + qs

    #     return url
                    
    removeItemFromInput: (current) ->
    
        current.parent("span").next(".DynamicInput").remove()
        current.parent("span").remove()
    
    

$(document).ready ->
    autoObject = new AutoSuggest()
    autoObject.init()
