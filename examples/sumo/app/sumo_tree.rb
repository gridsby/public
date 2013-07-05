require 'bundler/setup'
root = File.join(File.dirname(__FILE__), '..')
$:.unshift File.join(root, 'lib')

require 'sinatra'
require 'sinatra/config_file'
require 'gridsby/api'
require 'ostruct'
require 'pp'

config_path = File.expand_path(File.join(root, 'config', 'sumo-demo.yaml'))
unless File.exists?(config_path)
    puts "You first need to setup your app config at #{config_path}, see README.md"
    exit
end

set :root, File.dirname(__FILE__)
set :public_folder, 'public'
set :static, true
config_file '../config/sumo-demo.yaml'

include GridsBy::API::QueryHelpers

helpers do
    def node(url)
        data = api.get(url)
        node = OpenStruct.new(
            id: url,
            definition: data
        )
        node.label = if data['http://www.w3.org/2000/01/rdf-schema#label']
            data['http://www.w3.org/2000/01/rdf-schema#label']['@value']
        else
            node.id
        end

        node
    end

    def children(url)
        children = api.list( 'http://www.w3.org/2000/01/rdf-schema#subClassOf' => resource(url) )

        children.map{|url|
            node(url)
        }
    end

    def node2jstree(node)
        {
            data: node.label,
            attr: {id: node.id},
            state: 'closed'
        }
    end

    def api
        @api ||= GridsBy::API.new('http://www.ontologyportal.org/SUMO', settings.oauth)
    end
end

ROOT = 'http://www.ontologyportal.org/SUMO.owl#Organism'

get '/tree' do
    root = node(ROOT)
    root_json = [node2jstree(root)].to_json

    %Q{
        <html>
        <head>
            <script src="//ajax.googleapis.com/ajax/libs/jquery/1.8/jquery.min.js" type="text/javascript"></script>
            <script src="/jquery.jstree.js" type="text/javascript"></script>
            <script src="/sumo-tree.js" type="text/javascript"></script>
            <script type="text/javascript">
                root_json = #{root_json};
            </script>
        </head>
        <body>
            <ul id='tree'>
                <!-- <li class='node' id='#{root.id}'>#{root.label}</li> -->
            </ul>
        </body>
        </html>
    }
end

get '/children' do
    url = params[:id]
    
    children(url).map{|c|
        node2jstree(c)
    }.to_json
end
