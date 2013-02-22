class Users::RegistrationsController < Devise::RegistrationsController
  def preferences
    render 'users/preferences'
  end

  def update_profile
    @user = User.find(current_user.id)
    if @user.update_attributes(params[:user])
      render 'users/edit_profile'
    else
      render 'users/edit_profile'
    end
  end

  def edit_profile
    @user = current_user
    render 'users/edit_profile'
  end

  def change_password
    @user = current_user
    if @user.provider.blank?
      render 'users/change_password'
    else
      redirect_to root_path
    end
  end

  def update_password
    @user = User.find(current_user.id)
    if @user.update_with_password(params[:user])
      sign_in @user, :bypass => true
      redirect_to root_path
    else
      render "edit"
    end
  end

  def save_preferences
    @emailprefs = params[:email]

    User.settings.all('email.').each do |k,v|
      current_user.settings[k] = !@emailprefs[k.split('.').last].nil?
    end

    redirect_to users_preferences_url, notice: 'Email notification preferences were saved.' 
  end
end
