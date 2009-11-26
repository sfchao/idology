module Idology
  class Question
    include HappyMapper
    
    element :prompt, String
    element :type, String
    has_many :answers, String, :tag => 'answer'
    
    attr_accessor :chosen_answer

  end
end