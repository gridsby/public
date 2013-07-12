require 'rubygems'
require 'bundler/setup'
root = File.join(File.dirname(__FILE__), '..')

$:.unshift File.join(root, 'lib')

require 'ostruct'
require 'yaml'
require 'gridsby/api'
require 'pp'

config = YAML.load_file(File.join(root, 'config/settings.yaml'))

api = GridsBy::API.new('http://heml.mta.ca/releases/Rdf/Heml', config['oauth'])

ids = api.list_({}).grep(/alexander\.xml/)

class Array
    def to_hash
        Hash[*self.flatten(1)]
    end
end

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

data = ids.map{|id| [id, api.get(id)]}.to_hash

events = data.select{|id, res| res["@type"] == "http://www.heml.org/schemas/2003-09-17/hemlEvent"}.
    values.map{|res| Event.new(res)}

events.sort_by(&:start).
each do |e|
    puts e.to_s
end
