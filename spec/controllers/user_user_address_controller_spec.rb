# -*- encoding : utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UserUserAddressController do

  describe :edit do

    before(:each) do
      @user = FactoryGirl.create(:user)
      session[:user_id] = @user.id
    end

    it 'requires login' do
      session[:user_id] = nil

      get :edit

      post_redirect = PostRedirect.get_last_post_redirect
      expect(response).to redirect_to(
        :controller => 'user',
        :action => 'signin',
        :token => post_redirect.token)
    end

    it 'finds the logged in user to edit' do
      get :edit
      expect(assigns[:user]).to eql(@user)
    end

    it 'renders the form for changing the Address' do
      get :edit
      expect(response).to render_template('edit')
    end

  end

  describe :update do

    before(:each) do
      @user = FactoryGirl.create(:user)
      session[:user_id] = @user.id
    end

    it 'requires login' do
      session[:user_id] = nil

      put :update, { :user => { :user_address => '/s' } }

      post_redirect = PostRedirect.get_last_post_redirect
      expect(response).to redirect_to(
        :controller => 'user',
        :action => 'signin',
        :token => post_redirect.token)
    end

    it 'finds the logged in user to update' do
      get :edit
      expect(assigns[:user]).to eql(@user)
    end

    it 'changes the users Address' do
      put :update, { :user => { :user_address => '/s' } }
      expect(User.find(@user.id).user_address).to eql('Tunis')
    end

    it 'does not accept a blank Address' do
      put :update, { :user => { :user_address => nil } }
      expect(response).to render_template('edit')
    end

    it 'notifies the user that the update was successful' do
      put :update, { :user => { :user_address => 'Tunis' } }
      expect(flash[:notice]).to_not be_nil
    end

    it 'redirects to the user profile page after updating successfuly' do
      put :update, { :user => { :user_address => '/s' } }
      path = show_user_profile_path(:url_name => @user.url_name)
      expect(response).to redirect_to(path)
    end

  end

end
