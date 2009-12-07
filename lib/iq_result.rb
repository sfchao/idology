module IDology
  class IQResult
    include HappyMapper
    tag 'idliveq-result'
    element :key, String
    element :message, String

    def incorrect
      key =~ /result\.questions\.(\d)\.incorrect/ ? $1.to_i : nil
    end

    def verified?
      (0..2).include?(incorrect)
    end
  end
end