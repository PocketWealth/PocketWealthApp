class PublicController < ApplicationController
  before_action :logged_in_user
  def index

  end
end
