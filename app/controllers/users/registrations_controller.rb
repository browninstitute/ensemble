class Users::RegistrationsController < Devise::RegistrationsController
  def preferences
    render 'users/preferences'
  end

  def save_preferences
    @emailprefs = params[:email]

    User.settings.all('email.').each do |k,v|
      current_user.settings[k] = !@emailprefs[k.split('.').last].nil?
    end

    redirect_to users_preferences_url, notice: 'Email notification preferences were saved.' 
  end
end
