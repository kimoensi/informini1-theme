# -*- encoding : utf-8 -*-
class UserIdentityCardNumberController < ApplicationController
  before_filter :authenticate

  def edit; end

  def update
    if @user.update_attributes(:identity_card_number => params[:user][:identity_card_number])
      redirect_to show_user_profile_path(:url_name => @user.url_name),
                  :notice => _('Your Identification Card Number was successfully updated')
    else
      render :edit
    end
  end

  protected

  def authenticate
    unless authenticated?(
      :web => _("To change your email address used on {{site_name}}", :site_name => site_name),
      :email => _("Then you can change your email address used on {{site_name}}", :site_name => site_name),
      :email_subject => _("Change your email address used on {{site_name}}",:site_name => site_name)
    )
      # "authenticated?" has done the redirect to signin page for us
      return
    end
  end

end
