class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def autocomplete
    @users = User.where("name LIKE ?", "%" + params[:query] + "%")
    @users = @users - [@current_user]
    @users_json = @users.map do |u|
      {:id => u.id, :name => u.name}
    end
    respond_to do |format|
      format.json { render json: @users_json }
    end
  end
end
