module Loops
  class Contact < Resource
    ENDPOINT = "contacts/"

    class << self
      def find(email_address)
        response = connection.get(ENDPOINT + "find", email: email_address)

        if response.body.present?
          new(**response.body.first)
        end
      end
    end
  end
end
