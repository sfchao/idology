module IDology
  class Request
    
    attr_accessor :url, :data
    
    def set_data(subject)
      self.data = {
        :username => IDology[:username],
        :password => IDology[:password],
      }
    end
  end
end