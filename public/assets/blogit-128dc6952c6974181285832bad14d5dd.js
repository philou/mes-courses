// Supporting functions for the display of post archives
jQuery(function(){$("a[data-blogit-click-to-toggle-children]").click(function(e){e.preventDefault(),$(this).siblings("ul").toggle()})});