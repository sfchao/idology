module Idology
  class Request
    
    attr_accessor :url, :data
    
    def set_data(subject)
      self.data = {
        :username => Idology[:username],
        :password => Idology[:password],
      }
    end
  end
end