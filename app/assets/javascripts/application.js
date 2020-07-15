// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
//= require dataTables/jquery.dataTables
//= require twitter/bootstrap
//= require typeahead.bundle
//= require selectize
//= require notes
//= require curations
//= require gene_disease_validity
//= require actionability
//= require dosage
//= require search


$( '[data-toggle="popover"]' ).hover( function() {
        $(this).popover({ 
            selector: true,
            template:'<div class="popover info-popover-template" role="tooltip"><div class="arrow"></div><div class="popover-content"></div><a href="' + $(this).data('href') + '" target="blank" class="popover-title"></a></div>'
        });
});

// $(function () {
//   $('[data-toggle="popover"]').popover({
//         selector: true,
//         template:'<div class="popover info-popover-template" role="tooltip"><div class="arrow"></div><div class="popover-content"></div><a href="' + $(this).data('href') + '" class="popover-title"></a></div>'
//     })
// })


// Tracking for google of the onclicks
$( ".externallink" ).on( "click", function() {
    var title = $(this).attr("title");
    //console.log( "externallink" );
    //console.log( title );
    ga('send', 'event', 'external_link', 'click', title );
});

$( ".externalresource" ).on( "click", function() {
    var title = $(this).attr("title");
    //console.log( "externallink" );
    //console.log( title );
    ga('send', 'event', 'external_resource', 'click', title );
});
$( ".watchreportclick" ).on( "click", function() {
    var title = $(this).attr("title");
    console.log( "watchreportclick" );
    console.log( title );
    ga('send', 'event', 'track_report_click', 'click', title );
});
$( ".watchdownloadclick" ).on( "click", function() {
    var title = $(this).attr("title");
    console.log( "watchdownloadclick" );
    console.log( title );
    ga('send', 'event', 'track_download_click', 'click', title );
});




/**
 * Project: Bootstrap Hover Dropdown
 * Author: Cameron Spear
 * Contributors: Mattia Larentis
 *
 * Dependencies: Bootstrap's Dropdown plugin, jQuery
 *
 * A simple plugin to enable Bootstrap dropdowns to active on hover and provide a nice user experience.
 *
 * License: MIT
 *
 * http://cameronspear.com/blog/bootstrap-dropdown-on-hover-plugin/
 */
;(function ($, window, undefined) {
    // outside the scope of the jQuery plugin to
    // keep track of all dropdowns
    var $allDropdowns = $();

    // if instantlyCloseOthers is true, then it will instantly
    // shut other nav items when a new one is hovered over
    $.fn.dropdownHover = function (options) {
        // don't do anything if touch is supported
        // (plugin causes some issues on mobile)
        if('ontouchstart' in document) return this; // don't want to affect chaining

        // the element we really care about
        // is the dropdown-toggle's parent
        $allDropdowns = $allDropdowns.add(this.parent());

        return this.each(function () {
            var $this = $(this),
                $parent = $this.parent(),
                defaults = {
                    delay: 500,
                    instantlyCloseOthers: true
                },
                data = {
                    delay: $(this).data('delay'),
                    instantlyCloseOthers: $(this).data('close-others')
                },
                showEvent   = 'show.bs.dropdown',
                hideEvent   = 'hide.bs.dropdown',
                // shownEvent  = 'shown.bs.dropdown',
                // hiddenEvent = 'hidden.bs.dropdown',
                settings = $.extend(true, {}, defaults, options, data),
                timeout;

            $parent.hover(function (event) {
                // so a neighbor can't open the dropdown
                if(!$parent.hasClass('open') && !$this.is(event.target)) {
                    // stop this event, stop executing any code
                    // in this callback but continue to propagate
                    return true;
                }

                openDropdown();
            }, function () {
                timeout = window.setTimeout(function () {
                    $parent.removeClass('open');
                    $this.trigger(hideEvent);
                }, settings.delay);
            });

            // this helps with button groups!
            $this.hover(function () {
                // this helps prevent a double event from firing.
                // see https://github.com/CWSpear/bootstrap-hover-dropdown/issues/55
                if(!$parent.hasClass('open') && !$parent.is(event.target)) {
                    // stop this event, stop executing any code
                    // in this callback but continue to propagate
                    return true;
                }

                openDropdown();
            });

            // handle submenus
            $parent.find('.dropdown-submenu').each(function (){
                var $this = $(this);
                var subTimeout;
                $this.hover(function () {
                    window.clearTimeout(subTimeout);
                    $this.children('.dropdown-menu').show();
                    // always close submenu siblings instantly
                    $this.siblings().children('.dropdown-menu').hide();
                }, function () {
                    var $submenu = $this.children('.dropdown-menu');
                    subTimeout = window.setTimeout(function () {
                        $submenu.hide();
                    }, settings.delay);
                });
            });

            function openDropdown() {
                $allDropdowns.find(':focus').blur();

                if(settings.instantlyCloseOthers === true)
                    $allDropdowns.removeClass('open');

                window.clearTimeout(timeout);
                $parent.addClass('open');
                $this.trigger(showEvent);
            }
        });
    };

    $(document).ready(function () {
        // apply dropdownHover to all elements with the data-hover="dropdown" attribute
        $('[data-hover="dropdown"]').dropdownHover();
    });
})(jQuery, this);
