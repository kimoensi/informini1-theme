# -*- encoding : utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do

    describe :user_status do

      it 'has a user_status attribute' do
        user = User.new(:user_status => 'PM')
        expect(user.user_status).to eq('PM')
      end

      it 'can be set' do
        user = User.new(:user_status => 'PM')
        user.user_status = 'PP'
        expect(user.user_status).to eq('PP')
      end

      it 'must be set' do
        user = User.new(:user_status => nil)
        expect(user).to have(1).error_on(:user_status)
      end

    end

    describe :user_address do

      it 'has a user_address attribute' do
        user = User.new(:user_address => 'Tunis')
        expect(user.user_address).to eq('Tunis')
      end

      it 'can be set' do
        user = User.new(:user_address => 'Tunis')
        user.user_address = 'Tunis'
        expect(user.user_address).to eq('Tunis')
      end


    end

    describe :name do

        it 'is valid with a first name and last name' do
            user = User.new(:name => 'Test User')
            expect(user).to have(0).errors_on(:name)
        end

        it 'is invalid with just a first name' do
            user = User.new(:name => 'Test')
            expect(user).to have(1).errors_on(:name)
        end

        it 'should give a descriptive error message if just a first name is entered' do
            user = User.new(:name => 'Test')
            expected_message = 'Please enter your full name - it is required by law when making a request'
            user.errors_on(:name).should == [expected_message]
        end

        it 'should give a general message if field is blank' do
            user = User.new
            expected_message = 'Please enter your name'
            user.errors_on(:name).should == [expected_message]
        end
    end

end