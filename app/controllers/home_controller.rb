class HomeController < ApplicationController
  def index
    authorize :home, :index?
    @users = policy_scope(User)
  end
end
