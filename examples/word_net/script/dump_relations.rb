require 'bundler/setup'
root = File.join(File.dirname(__FILE__), '..')

$:.unshift File.join(root, 'lib')

require 'yaml'
require 'gridsby/api'
require 'pp'

config = YAML.load_file(File.join(root, 'config/wordnet-demo.yaml'))

$api = GridsBy::API.new('http://www.ontologyportal.org/WordNet', config['oauth'])

start = 'http://www.ontologyportal.org/WordNet#WN30-102130308'

MEANINGFUL_LINKS = %w[
hypernym instance-hypernym
hyponym instance-hyponym
member-holonym substance-holonym part-holonym
member-meronym substance-meronym part-meronym].map{|id| "http://www.ontologyportal.org/WordNet.owl##{id}"}

def follow_links(resource, max_depth = 100)
    MEANINGFUL_LINKS.each do |link|
        if ls = resource[link]
            unless ls.is_a?(Array)
                ls = [ls]
            end

            ls.each do |l|
                linked = $api.get(l['@id'])

                puts "#{resource['http://www.w3.org/2000/01/rdf-schema#label']} => #{link.sub(/^.+\#/, '')} => #{linked['http://www.w3.org/2000/01/rdf-schema#label']}"
                unless max_depth.zero?
                    follow_links(linked, max_depth - 1)
                end
            end
        end
    end
end

root = $api.get(start)

follow_links(root, 4)

#pp api.predicates
#pp api.get('http://www.ontologyportal.org/WordNet.owl#antonym')
#puts api.list_({}).sort.join("\n")
#pp api.get("http://www.ontologyportal.org/WordNet#WN30-104477387")
