$(document).ready(function() {
    $('#interactive_gene_disease_table').DataTable( {
        "paging":   false,
        //"ordering": false,
        //"info":     false,
        "autoWidth": false,
        //"searching": false
    } );


    var dataTable = $('#interactive_gene_disease_table').dataTable();
    $("#interactive_gene_disease_search").keyup(function() {
       dataTable.fnFilter(this.value);
    }); 

} );

