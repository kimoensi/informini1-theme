# -*- encoding : utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GeneralLawsController do

  before(:each) do
    @user = FactoryGirl.create(:user)
    session[:user_id] = @user.id
  end

  describe :edit do

    it 'requires login' do
      session[:user_id] = nil

      get :edit

      post_redirect = PostRedirect.get_last_post_redirect
      expect(response).to redirect_to(
        :controller => 'user',
        :action => 'signin',
        :token => post_redirect.token)
    end

    it 'finds the logged in user' do
      get :edit
      expect(assigns[:user]).to eql(@user)
    end

    it 'finds the general law belonging to the user' do
      get :edit
      expect(assigns(:general_law)).to eq(@user.general_law)
    end

    it 'renders the edit template' do
      get :edit
      expect(response).to render_template('edit')
    end

  end

  describe :update do

    let(:general_law_params) { @user.general_law.serializable_hash }

    it 'requires login' do
      session[:user_id] = nil

      put :update, { :general_law => nil }

      post_redirect = PostRedirect.get_last_post_redirect
      expect(response).to redirect_to(
        :controller => 'user',
        :action => 'signin',
        :token => post_redirect.token)
    end

    it 'finds the logged in user' do
      put :update, { :general_law => general_law_params }
      expect(assigns[:user]).to eql(@user)
    end

    it 'assigns the post paramters' do
      post :update, :general_law => general_law_params
      expect(assigns(:general_law)).to be_an_instance_of(GeneralLaw)
      expect(assigns(:general_law).domicile).to eq(general_law_params['domicile'])
    end

    it 'redirects to index on save' do
      GeneralLaw.any_instance.stub(:update_attributes).and_return(true)
      post :update, :general_law => general_law_params
      path = show_user_profile_path(:url_name => @user.url_name)
      expect(response).to redirect_to(path)
    end

    it 'contains flash message on save' do
      GeneralLaw.any_instance.stub(:update_attributes).and_return(true)
      post :update, :general_law => general_law_params
      expect(flash[:notice]).to_not be_blank
    end

    it 'renders edit on failure' do
      GeneralLaw.any_instance.stub(:update_attributes).and_return(false)
      post :update, :general_law => general_law_params
      expect(response).to render_template('edit')
    end

  end

end
