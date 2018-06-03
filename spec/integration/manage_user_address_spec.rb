# -*- encoding : utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.join(File.dirname(__FILE__),'..','..','..','..','..','spec','integration','alaveteli_dsl'))

describe 'Signing up' do

  it 'allows the user to specify their address' do
    visit signin_path

    fill_in 'user_signup[email]', :with => 'test@example.com'
    fill_in 'user_signup[name]', :with => 'rspec'
    fill_in 'user_signup[password]', :with => 'secret'
    fill_in 'user_signup[password_confirmation]', :with => 'secret'

    fill_in 'user_signup[user_address]', :with => 'Tunisia'
    fill_in 'user_signup[user_status]', :with => '1'

    click_button 'Sign up'

    visit confirm_url(:email_token => PostRedirect.last.email_token)
    visit show_user_profile_path(:url_name => 'rspec')

    expect(response).to contain('Hello, rspec!')
    expect(response).to contain('Tunisia Address')
  end

end

describe 'Managing user address' do

  before :each do
    @user = login(FactoryGirl.create(:user, :user_address => 'Tunisia'))
  end

  it 'allows the user to change their address' do
    @user.visit user_edit_user_address_path
    @user.fill_in 'Address:', :with => 'Tunisia'
    @user.click_button 'Change Address'
    expect(@user.response).to contain('Tunisia Address')
  end

end
