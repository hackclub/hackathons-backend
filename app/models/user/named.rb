module User::Named
  extend ActiveSupport::Concern

  included do
    encrypts :name
  end

  def display_name
    name.presence || email_address
  end

  def first_name
    name&.split(" ")&.first
  end

  def gravatar_url
    hash = Digest::MD5.hexdigest email_address.downcase
    "https://www.gravatar.com/avatar/#{hash}"
  end
end
