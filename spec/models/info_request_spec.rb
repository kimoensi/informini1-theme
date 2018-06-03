# -*- encoding : utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe InfoRequest do

    def date_from_sent(info_request, days)
        Holiday.due_date_from(info_request.date_initial_request_last_sent_at,
                              days,
                              AlaveteliConfiguration::working_or_calendar_days)
    end

    before do
        @info_request = FactoryGirl.create(:info_request)
    end

    describe :extension_days do

        it 'should be 10' do
            @info_request.extension_days.should == 10
        end

    end

    describe :reply_late_after_days do

        it 'should be 10 more days if the authority has asked for an extension' do
            # from test.yml
            @info_request.reply_late_after_days.should == 20
            @info_request.set_described_state 'deadline_extended'
            @info_request.reply_late_after_days.should == 30
        end

    end

    describe :reply_very_late_after_days do

        it 'should be 10 more days if the authority has asked for an extension' do
            # from test.yml
            @info_request.reply_very_late_after_days.should == 40
            @info_request.set_described_state 'deadline_extended'
            @info_request.reply_very_late_after_days.should == 50
        end
    end

    describe :has_extended_deadline? do

        it 'should be true if the status is "deadline_extended"' do
            @info_request.log_event("status_update", {})
            @info_request.set_described_state('deadline_extended')
            @info_request.has_extended_deadline?.should be_true
        end

        it 'should be true if the status has been "deadline_extended"' do
            @info_request.log_event("status_update", {})
            @info_request.set_described_state('deadline_extended')
            @info_request.log_event("status_update", {})
            @info_request.set_described_state('waiting_response')
            @info_request.has_extended_deadline?.should be_true
        end

    end

    describe :calculate_status do

        after do
            Time.unstub!(:now)
        end

        it "is waiting_response on due date (20 working or cal days after request sent)" do
            Time.stub!(:now).and_return(date_from_sent(@info_request, 20))
            @info_request.calculate_status.should == 'waiting_response'
        end

        it "is overdue a day after due date (21 working or cal days after request sent)" do
            Time.stub!(:now).and_return(date_from_sent(@info_request, 21))
            @info_request.calculate_status.should == 'waiting_response_overdue'
        end

        it "is still overdue 40 working or cal days after request sent" do
            Time.stub!(:now).and_return(date_from_sent(@info_request, 40))
            @info_request.calculate_status.should == 'waiting_response_overdue'
        end

        it "is very overdue 41 working days after request sent" do
            Time.stub!(:now).and_return(date_from_sent(@info_request, 41))
            @info_request.calculate_status.should == 'waiting_response_very_overdue'
        end

        context 'when the deadline has been extended' do

            before do
                @info_request.set_described_state("deadline_extended")
            end

            it "is deadline_extended on due date (30 working or cal days after request sent)" do
                Time.stub!(:now).and_return(date_from_sent(@info_request, 30))
                @info_request.calculate_status.should == 'deadline_extended'
            end

            it "is overdue a day after due date (31 working or cal days after request sent)" do
                Time.stub!(:now).and_return(date_from_sent(@info_request, 31))
                @info_request.calculate_status.should == 'waiting_response_overdue'
            end

            it "is still overdue 50 working or cal days after request sent" do
                Time.stub!(:now).and_return(date_from_sent(@info_request, 50))
                @info_request.calculate_status.should == 'waiting_response_overdue'
            end

            it "is very overdue 51 working days after request sent" do
                Time.stub!(:now).and_return(date_from_sent(@info_request, 51))
                @info_request.calculate_status.should == 'waiting_response_very_overdue'
            end
        end

    end

    describe :enumerate_states do

        it 'should include "deadline_extended"' do
            InfoRequest.enumerate_states.include?('deadline_extended').should be_true
        end

    end

    describe :get_status_description do

        it 'should return "Deadline extended." for status "deadline_extended"' do
            InfoRequest.get_status_description('deadline_extended').should == 'Deadline extended.'
        end

    end

    describe :date_response_required_by do

        it 'should be 10 working days later if the authority has asked for an extension' do
            expected_due_date = date_from_sent(@info_request, AlaveteliConfiguration::reply_late_after_days)
            @info_request.date_response_required_by.should == expected_due_date
            @info_request.set_described_state 'deadline_extended'
            expected_extended_date = date_from_sent(@info_request, @info_request.reply_late_after_days)
            @info_request.date_response_required_by.should == expected_extended_date
        end
    end
end
