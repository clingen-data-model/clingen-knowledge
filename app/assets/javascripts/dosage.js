$(document).ready(function() {
    $('#interactive_dosage_table').DataTable( {
        "paging":   false,
        //"ordering": false,
        //"info":     false,
        "autoWidth": false,
        //"searching": false
    } );

 
    var dataTable = $('#interactive_dosage_table').dataTable();
    $("#interactive_dosage_search").keyup(function() {
       dataTable.fnFilter(this.value);
    }); 

} );

$(document).ready(function() {
    $('#interactive_actionability_table').DataTable( {
        "paging":   false,
        //"ordering": false,
        //"info":     false,
        "autoWidth": false,
        //"searching": false
    } );


    var dataTable = $('#interactive_actionability_table').dataTable();
    $("#interactive_actionability_search").keyup(function() {
       dataTable.fnFilter(this.value);
    }); 

} );

