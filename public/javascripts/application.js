
$('#toggle > div').click(function() {
    var ix = $(this).index();
    $('#description').toggle( ix === 0 );
    $('#procedure').toggle( ix === 1 );
    $('#sample_submission').toggle( ix === 2 );
   
});