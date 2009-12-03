module IDology
  class Request
    
    attr_accessor :url, :data
    
    def set_data(subject)
      raise "IDology username is not set." if IDology[:username].blank?
      raise "IDology password is not set." if IDology[:password].blank?
      self.data = {
        :username => IDology[:username],
        :password => IDology[:password],
      }
    end
  end
end