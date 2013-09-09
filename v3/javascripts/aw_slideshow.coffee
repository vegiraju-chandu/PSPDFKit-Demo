class window.AWSlideshow
  constructor: (slideshow, options) ->
    
    @slideshow = $(slideshow)
    @container = @slideshow.find(".aw__slideshow__container")
    @items = @slideshow.find(".aw__slideshow__items")
    @paginationContainer = @container.find(".aw__slideshow__pagination-indicators")
    
    @containerDimensions = 
      width: @container.width()
      height: @container.height()

    @state = 
      currentItem: 0
      itemArray: []

    @options =
      itemPadding:100
      itemGroupSize: 1
      itemGroupPadding: 100
      fadeElement: "item"

    $.extend(true, @options, options);

    @slideshow.find(".aw__slideshow__look-right").on "click", @showNextSlideshowItem
    @slideshow.find(".aw__slideshow__look-left").on "click", @showPreviousSlideshowItem
    @paginationContainer.on "click", ".aw__pagination__indicator", (event) =>
      @showSlideshowItemByIndicator(event)

    @arrangeSlideshowItems()

  arrangeSlideshowItems: ->
    @items.children().each (index, element) =>
      $(element).css({ position: "absolute", left: index*(@containerDimensions.width + @options.itemPadding)+"px", width: @containerDimensions.width })
      @state.itemArray.push $(element)
      @paginationContainer.append('<div class="aw__pagination__indicator" data-indicate-page="'+index+'"></div>')

    @adjustPaginationIndicators()
    @fadeSlideshowElements()

  showNextSlideshowItem: (event) =>
    if @state.currentItem < @state.itemArray.length-1
      @showSlideshowItemByNumber (@state.currentItem+1)
    
  showPreviousSlideshowItem: (event) =>
    if @state.currentItem > 0
      @showSlideshowItemByNumber (@state.currentItem-1)

  showSlideshowItemByIndicator: (event) =>
    @showSlideshowItemByNumber $(event.target).data("indicate-page")

  showSlideshowItemByNumber: (itemNumber) =>
    if itemNumber >= 0 and itemNumber < @state.itemArray.length
      @state.currentItem = itemNumber
      @items.css(left: (@containerDimensions.width + @options.itemPadding) * @state.currentItem * -1 + "px")
      @adjustPaginationIndicators()
      @fadeSlideshowElements()

  fadeSlideshowElements: ->
    if @options.fadeElement == "item"
      $(@state.itemArray).each (index, element) =>
        $(element).css({ opacity: 0 }) unless index is @state.currentItem
      $(@state.itemArray[@state.currentItem]).css({ opacity: 0.9999 })
    else
      $(@state.itemArray).each (index, element) =>
        $(element).find(@options.fadeElement).css({ opacity: 0 }) unless index is @state.currentItem
      $(@state.itemArray[@state.currentItem]).find(@options.fadeElement).css({ opacity: 0.9999 })

  adjustPaginationIndicators: ->
    @paginationContainer.find(".aw__pagination__indicator").each (index, element) =>
      if index == @state.currentItem
        $(element).addClass("aw__pagination__indicator_active")
      else
        $(element).removeClass("aw__pagination__indicator_active")
