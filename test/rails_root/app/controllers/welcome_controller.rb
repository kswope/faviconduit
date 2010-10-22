class WelcomeController < ApplicationController

  def index
    render :text =>
      "Just the index page, used to test rails accepting connections"
  end

end
