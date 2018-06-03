# -*- encoding : utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UserController do

  before do
    # Don't call out to external url during tests
    controller.stub!(:country_from_ip).and_return('tn')
  end

  describe :signup do

    before(:each) do
      @signup_params = { :user_signup => {
                           :name => 'New User',
                           :email => 'new@localhost',
                           :password => 'insecurepassword',
                           :password_confirmation => 'insecurepassword',
                           :user_address => 'Tunis',
                           :user_status => 'PM'
						   }}
    end

    it 'creates a user with address attributes' do
      post :signup, @signup_params
      expect(assigns[:user_signup]).to be_valid
    end

    it 'registers the user if they specify the address' do
      post :signup, @signup_params
      expect(User.where(:email => 'new@localhost')).to have(1).item
    end

  end

end
