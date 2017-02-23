// console.log("adding notes typeahead");
// $('.gene-typeahead').selectize({
//     valueField: 'hgnc_id',
//     labelField: 'symbol',
//     labelField: 'symbol',
    
// });

var genes = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('symbol'),
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    remote: {
        url: '/genes.json?term=%QUERY',
        wildcard: '%QUERY'
    }
});

$('.gene-typeahead').typeahead({
    hint: true,
    highlight: true,
    minLength: 1
},
{
    name: 'genes',
    display: 'symbol',
    source: genes
});


var conditions = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('label'),
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    remote: {
        url: '/conditions.json?term=%QUERY',
        wildcard: '%QUERY'
    }
});

$('.condition-typeahead').typeahead({
    hint: true,
    highlight: true,
    minLength: 3
},
{
    name: 'conditions',
    display: 'label',
    source: conditions
});

