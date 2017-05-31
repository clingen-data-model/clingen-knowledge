$(document).ready(function() {
    $('#interactive_curations_table').DataTable( {
        "paging":   false,
        //"ordering": false,
        "info":     false,
        "autoWidth": false
    } );


    var dataTable = $('#interactive_curations_table').dataTable();
    $("#interactive_curations_search").keyup(function() {
       dataTable.fnFilter(this.value);
    }); 

} );

