$(document).ready(function(){
    
    /* --------------------------------------------------------
	Components
    -----------------------------------------------------------*/
    (function(){
        /* Textarea */
	if($('.auto-size')[0]) {
	    $('.auto-size').autosize();
	}

        //Select
	if($('.select')[0]) {
	    $('.select').selectpicker();
	}
        
        //Sortable
  if($('.sortable')[0]) {
	    $('.sortable').sortable();
	}
	
        //Tag Select
	if($('.tag-select')[0]) {
	    $('.tag-select').chosen();
	}
        
        /* Tab */
	if($('.tab')[0]) {
	    $('.tab a').click(function(e) {
		e.preventDefault();
		$(this).tab('show');
	    });
	}
        
        /* Collapse */
	if($('.collapse')[0]) {
	    $('.collapse').collapse();
	}
        
        /* Accordion */
        $('.panel-collapse').on('shown.bs.collapse', function () {
            $(this).prev().find('.panel-title a').removeClass('active');
        });

        $('.panel-collapse').on('hidden.bs.collapse', function () {
            $(this).prev().find('.panel-title a').addClass('active');
        });

        //Popover
    	if($('.pover')[0]) {
    	    $('.pover').popover();
    	} 
    })();

    /* --------------------------------------------------------
	Sidebar + Menu
    -----------------------------------------------------------*/
    (function(){
        /* Menu Toggle */
        $('body').on('click touchstart', '#menu-toggle', function(e){
            e.preventDefault();
            $('html').toggleClass('menu-active');
            $('#sidebar').toggleClass('toggled');
            //$('#content').toggleClass('m-0');
        });
         
        /* Active Menu */
        $('#sidebar .menu-item').hover(function(){
            $(this).closest('.dropdown').addClass('hovered');
        }, function(){
            $(this).closest('.dropdown').removeClass('hovered');
        });

        /* Prevent */
        $('.side-menu .dropdown > a').click(function(e){
            e.preventDefault();
        });
	

    })();

    /* --------------------------------------------------------
	Custom Scrollbar
    -----------------------------------------------------------*/
    (function() {
	if($('.overflow')[0]) {
	    var overflowRegular, overflowInvisible = false;
	    overflowRegular = $('.overflow').niceScroll();
	}
    })();

    /* --------------------------------------------------------
	Messages + Notifications
    -----------------------------------------------------------*/
    (function(){
        $('body').on('click touchstart', '.drawer-toggle', function(e){
            e.preventDefault();
            var drawer = $(this).attr('data-drawer');

            $('.drawer:not("#'+drawer+'")').removeClass('toggled');

            if ($('#'+drawer).hasClass('toggled')) {
                $('#'+drawer).removeClass('toggled');
            }
            else{
                $('#'+drawer).addClass('toggled');
            }
        });

        //Close when click outside
        $(document).on('mouseup touchstart', function (e) {
            var container = $('.drawer, .tm-icon');
            if (container.has(e.target).length === 0) {
                $('.drawer').removeClass('toggled');
                $('.drawer-toggle').removeClass('open');
            }
        });

        //Close
        $('body').on('click touchstart', '.drawer-close', function(){
            $(this).closest('.drawer').removeClass('toggled');
            $('.drawer-toggle').removeClass('open');
        });
    })();

    /* --------------------------------------------------------
	Form Validation
    -----------------------------------------------------------*/
    (function(){
	if($("[class*='form-validation']")[0]) {
	    $("[class*='form-validation']").validationEngine();

	    //Clear Prompt
	    $('body').on('click', '.validation-clear', function(e){
		e.preventDefault();
		$(this).closest('form').validationEngine('hide');
	    });
	}
    })();

    /* --------------------------------------------------------
     Date Time Picker
     -----------------------------------------------------------*/
    (function(){
        //Date Only
      if($('.date-only')[0]) {
        $('.date-only').datetimepicker({
          pickTime: false,
          language: 'ru'
        });
      }

      //Time only
      if($('.time-only')[0]) {
        $('.time-only').datetimepicker({
          pickDate: false,
          language: 'ru'
        });
      }

      //12 Hour Time
      if($('.time-only-12')[0]) {
        $('.time-only-12').datetimepicker({
          pickDate: false,
          pick12HourFormat: true,
          language: 'ru'
        });
      }
        
        $('.datetime-pick input:text').on('click', function(){
            $(this).closest('.datetime-pick').find('.add-on i').click();
        });
    })();

    /* --------------------------------------------------------
     Input Slider
     -----------------------------------------------------------*/
    (function(){
	if($('.input-slider')[0]) {
	    $('.input-slider').slider().on('slide', function(ev){
		$(this).closest('.slider-container').find('.slider-value').val(ev.value);
	    });
	}
    })();

    /* ---------------------------
	Image Popup [Pirobox]
    --------------------------- */
    (function() {
	if($('.pirobox_gall')[0]) {
	    //Fix IE
	    jQuery.browser = {};
	    (function () {
		jQuery.browser.msie = false;
		jQuery.browser.version = 0;
		if (navigator.userAgent.match(/MSIE ([0-9]+)\./)) {
		    jQuery.browser.msie = true;
		    jQuery.browser.version = RegExp.$1;
		}
	    })();
	    
	    //Lightbox
	    $().piroBox_ext({
		piro_speed : 700,
		bg_alpha : 0.5,
		piro_scroll : true // pirobox always positioned at the center of the page
	    });
	}
    })();

    /* ---------------------------
     Vertical tab
     --------------------------- */
    (function(){
        $('.tab-vertical').each(function(){
            var tabHeight = $(this).outerHeight();
            var tabContentHeight = $(this).closest('.tab-container').find('.tab-content').outerHeight();

            if ((tabContentHeight) > (tabHeight)) {
                $(this).height(tabContentHeight);
            }
        })

        $('body').on('click touchstart', '.tab-vertical li', function(){
            var tabVertical = $(this).closest('.tab-vertical');
            tabVertical.height('auto');

            var tabHeight = tabVertical.outerHeight();
            var tabContentHeight = $(this).closest('.tab-container').find('.tab-content').outerHeight();

            if ((tabContentHeight) > (tabHeight)) {
                tabVertical.height(tabContentHeight);
            }
        });


    })();
    
    /* --------------------------------------------------------
     Login + Sign up
    -----------------------------------------------------------*/
    (function(){
	$('body').on('click touchstart', '.box-switcher', function(e){
	    e.preventDefault();
	    var box = $(this).attr('data-switch');
	    $(this).closest('.box').toggleClass('active');
	    $('#'+box).closest('.box').addClass('active'); 
	});
    })();
    
    /* --------------------------------------------------------
     Photo Gallery
    -----------------------------------------------------------*/
    (function(){
    	if($('.photo-gallery')[0]){
    	    $('.photo-gallery').SuperBox();
    	}
    })();
    
    
    /* --------------------------------------------------------
     Checkbox + Radio
     -----------------------------------------------------------*/
    if($('input:checkbox, input:radio')[0]) {
    	
	//Checkbox + Radio skin
	$('input:checkbox:not([data-toggle="buttons"] input, .make-switch input, input.except-iCheck), input:radio:not([data-toggle="buttons"] input, input.except-iCheck)').iCheck({
		    checkboxClass: 'icheckbox_minimal',
		    radioClass: 'iradio_minimal',
		    increaseArea: '20%' // optional
	});
    
	//Checkbox listing
	var parentCheck = $('.list-parent-check');
	var listCheck = $('.list-check');
    
	parentCheck.on('ifChecked', function(){
		$(this).closest('.list-container').find('.list-check').iCheck('check');
	});
    
	parentCheck.on('ifClicked', function(){
		$(this).closest('.list-container').find('.list-check').iCheck('uncheck');
	});
    
	listCheck.on('ifChecked', function(){
		    var parent = $(this).closest('.list-container').find('.list-parent-check');
		    var thisCheck = $(this).closest('.list-container').find('.list-check');
		    var thisChecked = $(this).closest('.list-container').find('.list-check:checked');
	    
		    if(thisCheck.length == thisChecked.length) {
			parent.iCheck('check');
		    }
	});
    
	listCheck.on('ifUnchecked', function(){
		    var parent = $(this).closest('.list-container').find('.list-parent-check');
		    parent.iCheck('uncheck');
	});
    
	listCheck.on('ifChanged', function(){
		    var thisChecked = $(this).closest('.list-container').find('.list-check:checked');
		    var showon = $(this).closest('.list-container').find('.show-on');
		    if(thisChecked.length > 0 ) {
			showon.show();
		    }
		    else {
			showon.hide();
		    }
	});
	   
    }
    
    /* --------------------------------------------------------
        MAC Hack 
    -----------------------------------------------------------*/
    (function(){
	//Mac only
        if(navigator.userAgent.indexOf('Mac') > 0) {
            $('body').addClass('mac-os');
        }
    })();
    
});

$(window).load(function(){
    /* --------------------------------------------------------
     Tooltips
     -----------------------------------------------------------*/
    (function(){
        if($('.tooltips')[0]) {
            $('.tooltips').tooltip();
        }
    })();

    /* --------------------------------------------------------
     Animate numbers
     -----------------------------------------------------------*/
    $('.quick-stats').each(function(){
        var target = $(this).find('h2');
        var toAnimate = $(this).find('h2').attr('data-value');
        // Animate the element's value from x to y:
        $({someValue: 0}).animate({someValue: toAnimate}, {
            duration: 1000,
            easing:'swing', // can be anything
            step: function() { // called on every step
                // Update the element's text with rounded-up value:
                target.text(commaSeparateNumber(Math.round(this.someValue)));
            }
        });

        function commaSeparateNumber(val){
            while (/(\d+)(\d{3})/.test(val.toString())){
                val = val.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,");
            }
            return val;
        }
    });
    
});

/* --------------------------------------------------------
Date Time Widget
-----------------------------------------------------------*/
(function(){
    var monthNames = [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" ];
    var dayNames= ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]

    // Create a newDate() object
    var newDate = new Date();

    // Extract the current date from Date object
    newDate.setDate(newDate.getDate());

    // Output the day, date, month and year
    $('#date').html(dayNames[newDate.getDay()] + " " + newDate.getDate() + ' ' + monthNames[newDate.getMonth()] + ' ' + newDate.getFullYear());

    setInterval( function() {

        // Create a newDate() object and extract the seconds of the current time on the visitor's
        var seconds = new Date().getSeconds();

        // Add a leading zero to seconds value
        $("#sec").html(( seconds < 10 ? "0":"" ) + seconds);
    },1000);

    setInterval( function() {

        // Create a newDate() object and extract the minutes of the current time on the visitor's
        var minutes = new Date().getMinutes();

        // Add a leading zero to the minutes value
        $("#min").html(( minutes < 10 ? "0":"" ) + minutes);
    },1000);

    setInterval( function() {

        // Create a newDate() object and extract the hours of the current time on the visitor's
        var hours = new Date().getHours();

        // Add a leading zero to the hours value
        $("#hours").html(( hours < 10 ? "0" : "" ) + hours);
    }, 1000);
})();


