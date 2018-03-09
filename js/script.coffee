# $(window).resize(function(){location.reload();});
$(document).ready ->
	$(window).bind 'resize', (e) ->
		if window.RT
			clearTimeout window.RT
		window.RT = setTimeout((->
			@location.reload false
			return
		), 100)
		
	pivotpoints=[
					{id:0,x:129,y:109},
					{id:1,x:182,y:126},
					{id:2,x:205,y:146},
					{id:3,x:210,y:174}
				]
#/* *************************** For canva on page Load ********************************* */#

	canvas = document.querySelector("canvas")
	c = canvas.getContext("2d")
	screenWidth = $(window).width()
	if (screenWidth < 900) 
		canvas.height = 300
		canvas.width = 300
	else 
		canvas.height = 300
		canvas.width = 570
		
	$.each(pivotpoints,(index,value) ->
		xcord = pivotpoints[index].x
		ycord = pivotpoints[index].y
		idcord=pivotpoints[index].id
		topHeight=25+idcord*40
		c.beginPath()
		c.strokeStyle = "#666666"
		c.moveTo(xcord, ycord)
		if (screenWidth < 900)
			c.lineTo(265,topHeight)
			c.lineTo(340,topHeight)
			c.stroke()
		else
			if(idcord == 0) 
				c.lineTo(265,topHeight)
				c.lineTo(550,topHeight)
				c.stroke()
				c.closePath()
				c.beginPath()
				c.arc(550,topHeight,5,0,2 * Math.PI,false)
				c.fillStyle = '#666666'
				c.fill()
				c.stroke()
			else
				c.lineTo(265,topHeight)
				c.lineTo(500,topHeight)
				c.stroke()
	)
	
# /*========================================== Label Click ==================================================*/	

	$('.Label_listItem , .Composition_image_link').on "click", () -> 

		$('.Label_listItem').removeClass 'active'
		$('.Composition_image_link').removeClass 'active'
		className = $(this).attr('class')
		activePoint = $(this).attr('pivotpoint')

		if(className == 'Label_listItem')
			pivotpointList = $('.Composition_image').find('.Composition_image_link')
		else
			pivotpointList = $('.Label').find('.Label_listItem')

		for elements in pivotpointList
			if activePoint == $(elements).attr("pivotpoint")
				$(elements).addClass('active')
				$(this).toggleClass('active')

		compositionSec=$('.Component_info_details')
		for compElement in compositionSec
			if activePoint == $(compElement).attr('relpoint')
				$(compElement).removeClass("Component_info_details--disable")
			else	
				$(compElement).addClass("Component_info_details--disable")

		if(screenWidth > 900) 
			$.each(pivotpoints,(index,value) ->

				idcord=pivotpoints[index].id.toString()
				topHeight=25+idcord*40
				if (activePoint == idcord)
					c.beginPath()
					c.moveTo(500,topHeight)
					c.lineTo(550,topHeight)
					c.arc(550,topHeight,5,0,2 * Math.PI,false)
					c.fillStyle = '#666666'
					c.fill()
					c.stroke()
				else
					c.clearRect(500,topHeight-10,100,20)
			)

# /*========================================== Cross Click ==================================================*/

	$('.CrossButton').on 'click', () ->
		
		$(this).parent().parent().addClass('Component_info_details--disable')
		$(this).parent().find(".Components_wrapper").css({"display":"none"})
	
		pivotpointList = $('.Composition_image').find('.Composition_image_link')
		activePoint = $(this).parent().parent().attr('relpoint')

		for elements in pivotpointList
			if activePoint == $(elements).attr('pivotpoint')
				$(elements).removeClass('active')

		labelList = $('.Composition_image').find('.Label_listItem')
		for elements in labelList
			if activePoint == $(elements).attr('pivotpoint')
				$(elements).removeClass('active')

		idcord=pivotpoints[activePoint].id
		topHeight=25+idcord*40	
		c.clearRect(500,topHeight-10,100,20)
		

# /*========================================== Component Heading Click ======================================*/

	$(".Components_heading h3").on "click", () ->

		console.log("heading called")
		$(this).parent().parent().removeClass("Component_info_details--disable")
		$(this).parent().parent().siblings('div').addClass("Component_info_details--disable")

		pivotpointList = $('.Composition_image').find('.Composition_image_link')
		activePoint = $(this).parent().parent().attr('relpoint')
		
		for elements in pivotpointList
			if activePoint == $(elements).attr('pivotpoint')
				$(elements).addClass('active')
			else	
				$(elements).removeClass('active')

		labelList = $('.Composition_image').find('.Label_listItem')
		for elements in labelList
			if activePoint == $(elements).attr('pivotpoint')
				$(elements).addClass('active')	
			else		
				$(elements).removeClass('active')