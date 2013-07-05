require 'rubygems'
require 'bundler/setup'

root = File.join(File.dirname(__FILE__), '..')
$:.unshift File.join(root, 'lib')

require 'sinatra'
require 'sinatra/config_file'
require 'gridsby/api'
require 'ostruct'
require 'pp'

config_path = File.expand_path(File.join(root, 'config', 'wordnet-demo.yaml'))
unless File.exists?(config_path)
    puts "You first need to setup your app config at #{config_path}, see README.md"
    exit
end

set :root, File.dirname(__FILE__)
set :public_folder, 'public'
set :static, true
config_file '../config/wordnet-demo.yaml'

include GridsBy::API::QueryHelpers

MEANINGFUL_LINKS = %w[
    hypernym instance-hypernym
    hyponym instance-hyponym
    member-holonym substance-holonym part-holonym
    member-meronym substance-meronym part-meronym
].map{|id| "http://www.ontologyportal.org/WordNet.owl##{id}"}

helpers do
    def node(url)
        data = api.get(url)
        node = OpenStruct.new(
            id: url,
            definition: data,
            label: data['http://www.w3.org/2000/01/rdf-schema#label'] || node.id
        )

        node
    end

    def children(url)
        data = api.get(url)

        MEANINGFUL_LINKS.map{|link|
            [data[link]].compact.flatten.map{|res|
                [link, res['@id']]
            }
        }.flatten(1).map{|link, url|
            [link, node(url)]
        }
    end

    def linked2jstree(link, node)
        {
            data: "[#{link.sub(/^.+\#/, '')}] #{node.label}",
            attr: {id: node.id},
            state: 'closed'
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
        @api ||= GridsBy::API.new('http://www.ontologyportal.org/WordNet', settings.oauth)
    end
end

ROOT = 'http://www.ontologyportal.org/WordNet.owl#WN30-102130308'

get '/tree' do
    root = node(ROOT)
    root_json = [node2jstree(root)].to_json

    %Q{
        <html>
        <head>
            <script src="//ajax.googleapis.com/ajax/libs/jquery/1.8/jquery.min.js" type="text/javascript"></script>
            <script src="/jquery.jstree.js" type="text/javascript"></script>
            <script src="/wordnet-tree.js" type="text/javascript"></script>
            <script type="text/javascript">
                root_json = #{root_json};
            </script>
        </head>
        <body>
            <ul id='tree'>
            </ul>
        </body>
        </html>
    }
end

get '/children' do
    url = params[:id]
    
    children(url).map{|l, c|
        linked2jstree(l, c)
    }.to_json
end
