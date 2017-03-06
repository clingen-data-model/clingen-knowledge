var entities = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('label'),
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    remote: {
        url: '/home.json?term=%QUERY',
        wildcard: '%QUERY'
    }
});

$('.search-typeahead').typeahead(null,
{
    name: 'entities',
    display: 'label',
    source: entities
});
