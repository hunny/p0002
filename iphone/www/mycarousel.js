/**
 * Version: 1.0
 * Author: hunny【胡泽雄】
 * Email: huxiong888@163.com
 * Licence: Open Source MIT Licence
 */
(function($){
	$.fn.mycarousel = function (options) {
		var defaults = {// setup default settings
			width: 350,
			height: 180,
			easing: 300,
			auto: false,
			touchmove: true,
			autoeasing: 4000
		}, s = $.extend({}, defaults, options);// This makes it so the users custom options overrides the default ones
		return this.each(function() {
			var $this = $(this);
			if ($this.find('.ui-carbox').length > 0) {
				var html = $this.data('mycarousel');
				$this.html(html);
				stopAutoEasing($this);
				//$this.show();
				//return;
			} else {
				$this.data('mycarousel', $this.html());
			}
			$this.css({
				'overflow': 'hidden'
			}).parent().css({
				'overflow': 'hidden'
			});
			var hrefs = [];
			var uiimage = $('<div class="ui-img"></div>').width(s.width).height(s.height);
			$this.find('.car-img').each(function(i) {
				$(this).wrap(uiimage);
				hrefs[i] = '<a href="#" class="click' + i + '">&nbsp;&nbsp;</a>';
			});
			var length = hrefs.length;
			var content = $('<div class="ui-carbox-content"></div>').width(s.width * hrefs.length).height(s.height);
			if (s.touchmove) {
				var onoffset = s.width / 3;
				content.bind('touchstart', function(e) {
					e.preventDefault();
					var touch = e.originalEvent.touches[0] || e.originalEvent.changedTouches[0];
					var that = $(this);
					that.data('pageX', touch.pageX);
					that.data('left', that.position().left);
				}).bind('touchmove', function(e) {
					e.preventDefault();
					var touch = e.originalEvent.touches[0] || e.originalEvent.changedTouches[0];
					var that = $(this);
					var pageX = that.data('pageX');
					var left = that.data('left');
					that.css({
						left: left + (touch.pageX - pageX) + 'px'
					});
				}).bind('touchend', function(e) {
					e.preventDefault();
					var that = $(this);
					var left = that.data('left');
					var offset = that.position().left - left;
					if (Math.abs(offset) >= onoffset) {
						if (offset < 0) {
							triggerNext($this, length);
						} else {
							triggerPrevious($this, length);
						}
					} else {
						scrollImage($this, getIndex($this));
					}
					that.removeData('pageX');
					that.removeData('left');
				});
			}
			$this.find('.ui-img').wrapAll(content);
			$this.find('.ui-carbox-content').wrap($('<div class="ui-carbox"></div>').width(s.width).height(s.height));
			$this.find('.ui-carbox').append($('<div class="ui-carbox-banner">' + hrefs.join('') + '</div>').width(s.width));
			$this.find('.ui-carbox-banner a').each(function(i) {
				$(this).click(function() {
					scrollImage($this, i);
				});
			});
			$this.show();
			scrollImage($this, 0);
			if (s.auto) {
				autoEasing($this, length, s.autoeasing);
			}
			return this;
		});
		function autoEasing(base, length, time) {
			var interval = setInterval(function() {
				triggerNext(base, length);
			}, time);
			base.data('interval', interval);
		}
		function stopAutoEasing(base) {
			var interval = base.data('interval');
			if (interval) {
				clearInterval(interval);
			}
		}
		function triggerNext(base, total) {
			var i = getIndex(base);
			i++;
			if (i > total - 1) {
				i = 0;
			}
			scrollImage(base, i)
			return i;
		}
		function triggerPrevious(base, total) {
			var i = getIndex(base);
			i--;
			if (i < 0) {
				i = 0;
			}
			scrollImage(base, i)
			return i;
		}
		function getIndex(base) {
			var i = base.data('index');
			if (isNaN(i)) {
				i = 0;
			}
			return i;
		}
		function putIndex(base, i) {
			base.data('index', i);
		}
		function scrollImage(base, i) {
			var offset = parseFloat(i * s.width * (-1));
			var content = base.find('div.ui-carbox-content');
			content.animate({left: offset}, s.easing, function() {
				$('body').addClass('dummyClass').removeClass('dummyClass');
			});
			base.find('.ui-carbox-banner a').removeClass('active');
			base.find('.ui-carbox-banner a.click' + i).addClass('active');
			putIndex(base, i);
		}
	};
})(jQuery);