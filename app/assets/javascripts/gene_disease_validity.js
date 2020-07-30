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


$(document).ready(function() {
    var urlParams       = new URLSearchParams(window.location.search);
    var searchParam  = urlParams.get('search').replace(/\W/g, '');
    var table           = $('#interactive_gene_disease_table').DataTable();
    $('#interactive_gene_disease_search').val(searchParam);
    table.search( searchParam ).draw();
    console.log("searchParam" + searchParam);
    
});