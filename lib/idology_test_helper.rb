require 'fakeweb'

module IDology
  module TestHelper
    
    def fake_idology(request_type, response_name)
      request = request_type.new
      FakeWeb.register_uri(:post, 
        "#{Service.base_uri}#{request.url}", 
        :response => load_idology_response(response_name))
    end

    def load_idology_response(name)
      File.read(File.dirname(__FILE__)+"/../spec/fixtures/#{name}.xml")
    end

    def parse_idology_response(name)
      Response.parse(load_idology_response(name))
    end
  end
end