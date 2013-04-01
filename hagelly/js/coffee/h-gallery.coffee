class @HGallery extends EventDispatcher
  constructor: (@images, @rowHeight, @containerMargin) ->
    super()
    @$gContainer = $("#gallery-container").empty()
    @gImages = []
    @gRows = []
    @images.forEach (image) =>
      $img = $ "<img src='#{image.uri}' alt=''>"
      $img.height(@rowHeight).load =>
        @pushGImage(@createGImage $img, image)
    $(window).resize => @refresh()

  refresh: ->
    lastGRows = @gRows
    @gRows = []
    @gImages.forEach (gImage) => @pushGImage gImage
    lastGRows.forEach (gRow) => gRow.remove()
    @gSelected.$img.click() if @gSelected
    @

  createGRow: ->
    gRow = new GRow @$gContainer, @containerMargin
    @gRows.push gRow
    gRow

  createGImage: ($img, data) ->
    gImage = new GImage $img, data
    $img.click =>
      @gSelected = gImage
      @trigger "gImageSelected", [gImage, data]
      $(".full-view-container").remove()
      $("""
        <div class="full-view-container">
          <img class="full-view-image" src="#{gImage.src}">
        </div>
        """
      ).insertBefore(gImage.gRow.$row)[0].scrollIntoView()
    @gImages.push gImage
    gImage

  pushGImage: (gImage) ->
    @lastGRow().push gImage
    if @lastGRow().contentWidth > @lastGRow().width
      if @lastGRow().width < @previousGRow().width
        # Scrollbar was enabled thus align all previuos rows
        @gRows.forEach (gRow) -> gRow.align()
      else
        #Align only last row
        @lastGRow().align()
      @createGRow()
    @

  empty: -> !@gRows.length

  lastGRow: ->
    @createGRow() if @empty()
    @gRows[@gRows.length - 1]

  previousGRow: ->
    if @gRows.length > 1
      @gRows[@gRows.length - 2]
    else
      @lastGRow()


class @GRow
  constructor: (@$gContainer, @imgContainerMargin) ->
    @$row = $("<div class='images-row'></div>").appendTo @$gContainer
    @setWidth @$gContainer.width()
    @gImages = []
    @contentWidth = 0

  setWidth: (width) ->
    @$row.width width
    @width = width
    @

  append: (gImage) ->
    gImage.appendTo @

  push: (gImage) ->
    @append gImage
    @gImages.push gImage
    @contentWidth += gImage.width + @imgContainerMargin
    @

  align: ->
    @setWidth @$gContainer.width()
    margin = @imgContainerMargin * @gImages.length
    imagesWidth = @contentWidth - margin
    alpha = 1.0 * (@width - margin) / imagesWidth
    @gImages.forEach (gImage) =>
      gImage.$imgContainer.width Math.floor(gImage.width * alpha)
      gImage.$img.css "margin-left", -Math.floor(gImage.width * (1.0 - alpha) / 2)
    @

  remove: ->
    @$row.remove()

class @GImage
  constructor: (@$img, @data) ->
    @$imgContainer = $ "<div class='image-container'></div>"
    @$imgContainer.append @$img
    @src = @$img.attr "src"

  appendTo: (@gRow) ->
    @gRow.$row.append @$imgContainer
    @width = @$img.width()
    @
