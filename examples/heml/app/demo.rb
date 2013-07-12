require 'bundler/setup'
root = File.join(File.dirname(__FILE__), '..')
$:.unshift File.join(root, 'lib')

require 'sinatra'
require 'sinatra/config_file'
require 'gridsby/api'
require 'ostruct'
require 'pp'

config_path = File.expand_path(File.join(root, 'config', 'settings.yaml'))
unless File.exists?(config_path)
    puts "You first need to setup your app config at #{config_path}, see README.md"
    exit
end

set :root, File.dirname(__FILE__)
set :public_folder, 'public'
set :static, true
config_file '../config/settings.yaml'

include GridsBy::API::QueryHelpers

class Event
    def initialize(res)
        @resource = res
        
        @title = [*res["http://www.w3.org/2000/01/rdf-schema#label"]].first

        case
        when res.has_key?('http://www.heml.org/schemas/2003-09-17/hemlSimpleTime')
            @type = :moment
            @start = make_date(res['http://www.heml.org/schemas/2003-09-17/hemlSimpleTime']['@value'])
        when res.has_key?('http://www.heml.org/schemas/2003-09-17/hemlTerminusAnteQuem')
            @type = :period
            @start = make_date(res['http://www.heml.org/schemas/2003-09-17/hemlTerminusAnteQuem']['@value'])
            @end = make_date(res['http://www.heml.org/schemas/2003-09-17/hemlTerminusPostQuem']['@value'])
        else
            raise ArgumentError, "Unknown event type: #{res.inspect}"
        end
    end

    attr_reader :title, :type, :start, :end

    def make_date(str)
        Date.parse(str)
    end

    def to_s
        case @type
        when :moment
            "#{title}: #{@start.strftime('%d.%m.%Y')}"
        when :period
            "#{title}: #{@start.strftime('%d.%m.%Y')}-#{@end.strftime('%d.%m.%Y')}"
        end
    end
end

helpers do
    def api
        @api ||= GridsBy::API.new('http://heml.mta.ca/releases/Rdf/Heml', settings.oauth)
    end
end

get '/' do
    ids = api.list_({}).grep(/alexander\.xml/)
    data = ids.map{|id| api.get(id)}
    events = data.select{|res| res["@type"] == "http://www.heml.org/schemas/2003-09-17/hemlEvent"}.
        map{|res| Event.new(res)}.
        sort_by(&:start)

    %Q{
        <html>
        <head>
            <script src="//ajax.googleapis.com/ajax/libs/jquery/1.8/jquery.min.js" type="text/javascript"></script>
            <script src="/jquery.timelinr-0.9.53.js" type="text/javascript"></script>
            <script type="text/javascript">
                $(function(){
                   $().timelinr();
                });
            </script>
            <link rel="stylesheet" href="/css/style.css" media="screen" />
        </head>
        <body>
            <div id="timeline">
                <ul id="dates">
                    #{events.map{|e| "<li><a href='##{e.start.year.abs}'>#{e.start.year.abs}&nbsp;BC</a></li>"}.join("\n")}
                </ul>
                <ul id="issues">
                    #{events.map{|e| "<li id='#{e.start.year.abs}'><h1>#{e.start.year.abs}&nbsp;BC</h1><p>#{e.title}</p></li>"}.join("\n")}
                </ul>
            </div>
        </body>
        </html>
    }
end
