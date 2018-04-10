window.AutoSuggest = class AutoSuggest
    constructor: ->

        @displayDetails
        @boxWidth = 0
        @countryNames = []
        @currentUrl = window.location.href
    init: ->

        if @currentUrl.indexOf("countryNames=") > -1
            @createBoxOnloadOfPage()
        
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
                    @setWidthOfDynamicInputBox()

        $("#searchInput").easyAutocomplete(@options)

        @widthOnPageLoad()

        $(".Search_Button").on 'click', () =>

            modifiedValue = ""
            inputBoxes = $(".Search_InputWrapper").find(".DynamicInput")
            $.each(inputBoxes,(index,elements) =>
                searchValue = $(elements).val()
                if ((modifiedValue.length > 0) && (searchValue.length > 0))
                    modifiedValue = modifiedValue + " AND "
                modifiedValue = modifiedValue + searchValue

                $(".Results_list").css("display","block")
                
            )
        
            encodedTerm = encodeURIComponent(modifiedValue).replace(/%20/g,'+')
            advancedUrl = @buildqueryStringUrl(@currentUrl, "countryNames", encodedTerm)
        
            if (history.pushState) 
                newurl = advancedUrl
                window.history.pushState({path:newurl},'',newurl)

        $("#searchInput").on('keydown', (e) => 
            keyCode = e.keyCode || e.which
            if (keyCode == 9) 
                e.preventDefault()
                @setWidthOfDynamicInputBox()    
        )

        $(".Search_InputWrapper").on "click", ".Search_cross", (e) =>

            closestEle = $(e.currentTarget)
            valueToBeRemoved = closestEle.siblings("input").val()
            
            res = $(".Results_list").find("li .countryname") 

            $.each(res,(index,elements) =>
                if (valueToBeRemoved == $(elements).html())
                    $(elements).parent().parent().remove()
            )

            @removeItemFromInput(closestEle)  


    widthOnPageLoad: () ->
        $(".easy-autocomplete").css("width","100%")
        $("#searchInput").css("width","100%")

    setWidthOfDynamicInputBox: () ->
        
        searchValue = $("#searchInput").val()
        dynamicWidth = searchValue.length * 8
        if searchValue.length > 24
            dynamicWidth = searchValue.length * 7
        else
            dynamicWidth = searchValue.length * 8

        spanElement = @getInputStructure(dynamicWidth,searchValue)

    
        $(".easy-autocomplete").prepend(spanElement)
        @setWidthOfMainInputBox(dynamicWidth+24)


    buildqueryStringUrl:(currenturl, parameter, searchTerm) ->
        currenturl + "?" + parameter + "=" + searchTerm

    setWidthOfMainInputBox: (dynamicWidth) ->

        @boxWidth += dynamicWidth
        if(@boxWidth > 440)
            $("#searchInput").css("width","461px")
            @dynamicWidth = 0
        else   
            $("#searchInput").css("width","calc(100% - "+(@boxWidth)+"px)")
                    
    removeItemFromInput: (current) ->
        current.parent("span").next(".DynamicInput").remove()
        current.parent("span").remove()

    searchForMatchingData: (value) ->
        $.getJSON('./json/countries.json',(data) =>
            $.each(data,(index,obj) =>
                if(value == data[index].country_name) 
                    @displayDetails = @resultDetails(data[index].country_name,data[index].dialling_code)
                    # @displayDetails = '<li class="name"><p><label><strong>Country Name: </strong></label><label class = "countryname" >'+data[index].country_name+
                    # '</label></p><p class="code"><label><strong>Dialling Code: </strong></label><label class = "dialingcode" >'+data[index].dialling_code+'</label></p></li>'
                    $(".Results_list").append(@displayDetails)
                    $(".Results_list").css("display","block")

            )
        )

    getInputStructure: (dynamicWidth, searchValue) ->
        htmlStructure = '<span class = "SearchSpan" style="width:'+dynamicWidth+'px" >'+
                            '<input class="Search_Input DynamicInput" " type ="text" value ="'+searchValue+'"/>'+
                            '<a class="Search_cross">×</a>'+
                        '</span>'

        $("#searchInput").val("")

        return $(htmlStructure)

    resultDetails: (name,code) ->
        result = '<li class="name">'+
                        '<p>'+
                            '<label><strong>Country Name: </strong></label>'+
                            '<label class = "countryname" >'+name+'</label>'+
                        '</p>'+
                        '<p>'+
                            '<label><strong>Dialling Code: </strong></label>'+
                            '<label class = "dialingcode" >'+code+'</label>'+
                        '</p>'+
                '</li>'
        return $(result)


    createBoxOnloadOfPage: () ->
        queryString = @currentUrl.split('?countryNames=')[1]
        console.log queryString
        queryString=queryString.split("+AND+")
        $.each(queryString,(index,value) =>
            country = queryString[index].replace(/\+/g," ")
            console.log country
            @countryNames.push(country)
            @searchForMatchingData(country)
        )
        console.log queryString
        $.each(@countryNames,(index,value) =>

            dynamicWidth = @countryNames[index].length * 8
            if @countryNames[index].length > 24
                dynamicWidth = @countryNames[index].length * 7
            else
                dynamicWidth = @countryNames[index].length * 8

            spanElement = @getInputStructure(dynamicWidth,@countryNames[index])
            
            $(".Search_InputWrapper").prepend(spanElement)
            @setWidthOfMainInputBox(dynamicWidth+24)
         )

$(document).ready ->
    autoObject = new AutoSuggest()
    autoObject.init()
