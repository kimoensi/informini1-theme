# -*- encoding : utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UserController do

  before do
    # Don't call out to external url during tests
    controller.stub!(:country_from_ip).and_return('gb')
  end

  describe :signup do

    before(:each) do
      @signup_params = { :user_signup => {
                           :name => 'New User',
                           :email => 'new@localhost',
                           :password => 'insecurepassword',
                           :password_confirmation => 'insecurepassword',
                           :identity_card_number => '201-180954-0009J',
                           :terms => '1',
                           :general_law_attributes => {
                             :date_of_birth => Date.yesterday,
                             :marital_status => 'single',
                             :occupation => 'programmer',
                             :domicile => 'Nicaragua'
                           }}}
    end

    it 'creates a user with general law attributes' do
      post :signup, @signup_params
      expect(assigns[:user_signup]).to be_valid
    end

    it 'requires the user to accept the terms and conditions' do
      @signup_params[:user_signup][:terms] = '0'
      post :signup, @signup_params
      expect(response).to render_template('sign')
    end

    it 'registers the user if they accept the terms and conditions' do
      post :signup, @signup_params
      expect(User.where(:email => 'new@localhost')).to have(1).item
    end

  end

end
