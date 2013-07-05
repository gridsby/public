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

