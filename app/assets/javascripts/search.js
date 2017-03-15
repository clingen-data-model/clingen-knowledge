var entities = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('label'),
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    remote: {
        url: '/home.json?term=%QUERY',
        wildcard: '%QUERY'
    }
});


$('#term.search-typeahead').typeahead(null,
{
    name: 'entities',
    display: 'label',
    source: entities,

    //display: 'completion',
	  //name: 'completion',
	  //valueKey: 'completion',
	  limit: 20,
	  minLength: 0,
	  highlight: true,
	  hint: false,
	  //source: data,
	  autoselect:true,
}).bind('typeahead:selected',function(evt,item){
  window.location = item.url;
});
