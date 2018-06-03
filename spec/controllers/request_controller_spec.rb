# -*- encoding : utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RequestController do

    def post_status(status)
        post :describe_state, :incoming_message => { :described_state => status },
                              :id => @info_request.id,
                              :last_info_request_event_id => @info_request.last_event_id_needing_description
    end


    describe 'after a successful status update by the request owner' do

        before do
            @info_request = FactoryGirl.create(:info_request)
            session[:user_id] = @info_request.user.id
        end

        context 'when status is updated to "deadline_extended"' do

            it 'should redirect to the request url' do
                post_status('deadline_extended')
                response.should redirect_to("/request/#{@info_request.url_title}")
            end

            it 'should show a notice' do
                post_status('deadline_extended')
                expected = "<p>Thank you! Hopefully your wait isn't too long.</p>"
                flash[:notice].should match(expected)
            end
        end

    end
end
