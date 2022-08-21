class SiteController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @posts = Post.all.order(:id)
  end
end