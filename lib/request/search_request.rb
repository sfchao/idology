module Idology
  class SearchRequest < Request

    def initialize
      # corresponds to an IDology ExpectID API call
      self.url = '/idiq.svc'
      super
    end

    def set_data(subject)
      self.data = super(subject).merge(
        :firstName => subject.firstName,
        :lastName => subject.lastName,
        :address => subject.address,
        :city => subject.city,
        :state => subject.state,
        :zip => subject.zip,
        :ssnLast4 => subject.ssnLast4,
        :dobMonth => subject.dobMonth,
        :dobYear => subject.dobYear,
        :uid => subject.userID
      )
    end
  end
end