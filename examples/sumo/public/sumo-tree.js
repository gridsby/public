/*
$(function(){
    $('li.node').live('click', function(){
        $target = $(this);
        
        $.getJSON('/children', {id: $target.attr('id')}, function(data){
            $ul = $('<ul></ul>').appendTo($target);
            console.log(data);
            $.each(data, function(){
                $('<li></li>').addClass('node').
                    attr('id', this.id).text(this.label).
                    appendTo($ul);
            });
        });
        return false;
    });
});
*/

$(function () {
    $("#tree").jstree({ 
        "json_data": {
            "ajax": {
                "url" : "/children",
                "data" : function(node){return {id: node.attr('id')}}
            },
            "data": root_json
        },
        "plugins" : [ "themes", "json_data" ]
    });
});

