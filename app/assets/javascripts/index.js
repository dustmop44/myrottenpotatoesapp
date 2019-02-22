/* global $ */

$(document).on('turbolinks:load', function() {
  $('.aria').change(function () {
    // 'this' is *unwrapped* element that received event (checkbox)
    if ($(".aria").is(':checked')) {
      $('tr.adult').hide();
      $('#ratings_R').removeAttr('checked');
      $('#ratings_PG-13').removeAttr('checked');
    } else {
      $('tr.adult').show();
      $('#ratings_R').prop('checked', true);
      $('#ratings_PG-13').prop('checked', true);
    }
});
});

function sayhello() {
  alert("hello")
}



var MoviePopup = {
  Popitup: function() {
    $(document).on('turbolinks:load', function() {
    var popupDiv = $('<div id="movieInfo"></div>');
    popupDiv.hide().appendTo($('body'));
    $('.movie_info').click(function() {
      $.ajax({type: 'GET',
              url: $(this).attr('href'),
              timeout: 5000,
              success: MoviePopup.showMovieInfo,
              error: function(xhrObj, textStatus, exception) { alert('Error!'); }
              // 'success' and 'error' functions will be passed 3 args
             });
      return(false);
    });
  });
  }
  ,showMovieInfo: function(data, requestStatus, xhrObject) {
    // center a floater 1/2 as wide and 1/4 as tall as screen
    var oneFourth = Math.ceil($(window).width() / 4);
    $('#movieInfo').
      css({'left': oneFourth,  'width': oneFourth, 'top': 250}).
      html(data).
      show();
    // make the Close link in the hidden element work
    $('#closeLink').click(MoviePopup.hideMovieInfo);
    return(false);  // prevent default link action
  }
  ,hideMovieInfo: function() {
    $('#movieInfo').hide();
    return(false);
  }
}

$(MoviePopup.Popitup)
