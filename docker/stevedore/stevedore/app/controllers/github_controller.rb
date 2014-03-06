class GithubController < ApplicationController
  respond_to :json
  def index
  	puts JSON.parse(params[:payload]).inspect
  end
end
