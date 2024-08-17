class ApiKey < ApplicationRecord
  before_save { self.provider = provider.downcase }

  encrypts :access_token
  encrypts :refresh_token
  belongs_to :user
end
