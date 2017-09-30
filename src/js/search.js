
function runSearch(term) {
  var frmStr = $('#form_search').serialize();

  $('#results').html("searching...");
  
  $.ajax({
    url: './querydb.cgi',
    data: frmStr,
    success: function(data, textStatus, jqXHR) {
        processData(data);
    },
    error: function(jqXHR, textStatus, errorThrown){
        alert("Failed to perform query! textStatus: (" + textStatus +
              ") and errorThrown: (" + errorThrown + ")");
    }
  });
}

// process our data
function processData(data) {
  $('#results').html(data);
}

$(document).ready(function() {
  $('#submit').click( function() {
      runSearch();
      return false;  // prevents 'normal' form submission
  });
});
