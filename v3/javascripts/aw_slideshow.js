(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  window.AWSlideshow = (function() {
    function AWSlideshow(slideshow, options) {
      this.showSlideshowItemByNumber = __bind(this.showSlideshowItemByNumber, this);
      this.showSlideshowItemByIndicator = __bind(this.showSlideshowItemByIndicator, this);
      this.showPreviousSlideshowItem = __bind(this.showPreviousSlideshowItem, this);
      this.showNextSlideshowItem = __bind(this.showNextSlideshowItem, this);
      var _this = this;
      this.slideshow = $(slideshow);
      this.container = this.slideshow.find(".aw__slideshow__container");
      this.items = this.slideshow.find(".aw__slideshow__items");
      this.paginationContainer = this.container.find(".aw__slideshow__pagination-indicators");
      this.containerDimensions = {
        width: this.container.width(),
        height: this.container.height()
      };
      this.state = {
        currentItem: 0,
        itemArray: []
      };
      this.options = {
        itemPadding: 100,
        itemGroupSize: 1,
        itemGroupPadding: 100,
        fadeElement: "item"
      };
      $.extend(true, this.options, options);
      this.slideshow.find(".aw__slideshow__look-right").on("click", this.showNextSlideshowItem);
      this.slideshow.find(".aw__slideshow__look-left").on("click", this.showPreviousSlideshowItem);
      this.paginationContainer.on("click", ".aw__pagination__indicator", function(event) {
        return _this.showSlideshowItemByIndicator(event);
      });
      this.arrangeSlideshowItems();
    }

    AWSlideshow.prototype.arrangeSlideshowItems = function() {
      var _this = this;
      this.items.children().each(function(index, element) {
        $(element).css({
          position: "absolute",
          left: index * (_this.containerDimensions.width + _this.options.itemPadding) + "px",
          width: _this.containerDimensions.width
        });
        _this.state.itemArray.push($(element));
        return _this.paginationContainer.append('<div class="aw__pagination__indicator" data-indicate-page="' + index + '"></div>');
      });
      this.adjustPaginationIndicators();
      return this.fadeSlideshowElements();
    };

    AWSlideshow.prototype.showNextSlideshowItem = function(event) {
      if (this.state.currentItem < this.state.itemArray.length - 1) {
        return this.showSlideshowItemByNumber(this.state.currentItem + 1);
      }
    };

    AWSlideshow.prototype.showPreviousSlideshowItem = function(event) {
      if (this.state.currentItem > 0) {
        return this.showSlideshowItemByNumber(this.state.currentItem - 1);
      }
    };

    AWSlideshow.prototype.showSlideshowItemByIndicator = function(event) {
      return this.showSlideshowItemByNumber($(event.target).data("indicate-page"));
    };

    AWSlideshow.prototype.showSlideshowItemByNumber = function(itemNumber) {
      if (itemNumber >= 0 && itemNumber < this.state.itemArray.length) {
        this.state.currentItem = itemNumber;
        this.items.css({
          left: (this.containerDimensions.width + this.options.itemPadding) * this.state.currentItem * -1 + "px"
        });
        this.adjustPaginationIndicators();
        return this.fadeSlideshowElements();
      }
    };

    AWSlideshow.prototype.fadeSlideshowElements = function() {
      var _this = this;
      if (this.options.fadeElement === "item") {
        $(this.state.itemArray).each(function(index, element) {
          if (index !== _this.state.currentItem) {
            return $(element).css({
              opacity: 0
            });
          }
        });
        return $(this.state.itemArray[this.state.currentItem]).css({
          opacity: 0.9999
        });
      } else {
        $(this.state.itemArray).each(function(index, element) {
          if (index !== _this.state.currentItem) {
            return $(element).find(_this.options.fadeElement).css({
              opacity: 0
            });
          }
        });
        return $(this.state.itemArray[this.state.currentItem]).find(this.options.fadeElement).css({
          opacity: 0.9999
        });
      }
    };

    AWSlideshow.prototype.adjustPaginationIndicators = function() {
      var _this = this;
      return this.paginationContainer.find(".aw__pagination__indicator").each(function(index, element) {
        if (index === _this.state.currentItem) {
          return $(element).addClass("aw__pagination__indicator_active");
        } else {
          return $(element).removeClass("aw__pagination__indicator_active");
        }
      });
    };

    return AWSlideshow;

  })();

}).call(this);
