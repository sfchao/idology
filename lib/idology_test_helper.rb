require 'fakeweb'

module IDology
  module TestHelper
    
    def fake_idology(request_type, response_name)
      FakeWeb.register_uri(:post, 
        "#{Subject.base_uri}#{Subject::Paths[request_type]}", 
        :body => idology_response_path(response_name))
    end

    def idology_response_path(name)
      file = File.expand_path(File.dirname(__FILE__)+"/../spec/fixtures/#{name}.xml")
      raise "Unknown File: #{file}" unless File.exist?(file)
      file
    end
    
    def load_idology_response(name)
      File.read idology_response_path(name)
    end

    def parse_idology_response(name)
      Response.parse(load_idology_response(name))
    end
  end
end