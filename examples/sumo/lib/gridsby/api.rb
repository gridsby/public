require 'oauth'
require 'yajl/json_gem'
require 'cgi'

module GridsBy
    class API
        module QueryHelpers
            def string(string, lang = 'en')
                {'@value' => string, '@language' => lang}
            end

            def resource(url)
                {'@id' => url}
            end
        end
        
        def initialize(graph, cfg)
            config = OpenStruct.new(cfg)
            @graph = graph
            @consumer = OAuth::Consumer.new(config.consumer_token, config.consumer_secret)
            @oauth = OAuth::AccessToken.new(@consumer, config.access_token, config.access_secret)
        end

        def list(filters)
            query('list.json',
                params: {
                    '@id' => @graph,
                    '@graph' => {
                        '@id' => 'uri:gridsby:filter'
                    }.merge(filters)
                },
                headers: {'Content-Type' => 'application/ld+json'},
                method: :post
            )
        end

        def get(subject)
            query('get.jsonld',
                params: {
                    graph: @graph,
                    subject: subject
                }
            )
        end

        private 

        def query(path, options = {})
            base_url = "https://api.grids.by/v1/#{path}"
            method = options.delete(:method) || :get
            params = options.delete(:params) || {}
            headers = options.delete(:headers) || {}
            
            response = case method
            when :get
                url = base_url + '?' + params.map{|k, v| make_query_params(k, v)}.flatten.join('&')
                @oauth.get(url)
            when :post
                url = base_url
                @oauth.post(url,
                    params.to_json,
                    {'Accept'=>'application/json', 'Content-Type' => 'application/json'}.merge(headers)
                )
            end

            case response.code.to_i
            when 200...300
                JSON.parse(response.body)
            else
                raise RuntimeError, "#{response.code}: #{response.body}"
            end
        end

        def make_query_params(key, value)
            case value
            when Hash
                value.each.map{|k, v| make_params("#{key}[#{k}]", v)}
            when Array
                value.each_with_index.map{|v, i| make_params("#{key}[#{i}]", v)}
            else
                "#{CGI.escape(key.to_s)}=#{CGI.escape(value.to_s)}"
            end
        end
    end
    
end
