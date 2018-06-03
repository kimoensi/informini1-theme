# -*- encoding : utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do

    describe :terms do

      it 'requires the terms to be accepted to be valid' do
        user = FactoryGirl.build(:user, :terms => '0')
        expect(user).to_not be_valid
      end

      it 'is valid if the terms are accepted' do
        user = FactoryGirl.build(:user, :terms => '1')
        expect(user).to be_valid
      end

      it 'does not validate on update' do
        user = FactoryGirl.create(:user)
        user.terms = false
        expect(user).to be_valid
      end

      it 'does not allow a nil terms parameter' do
         user = User.new(:terms => nil)
         expect(user).to have(1).error_on(:terms)
      end

    end

    describe :identity_card_number do

      it 'has an identity_card_number attribute' do
        user = User.new(:identity_card_number => '123-456789-1234A')
        expect(user.identity_card_number).to eq('123-456789-1234A')
      end

      it 'can be set' do
         user = User.new
         user.identity_card_number = '123-456789-1234A'
         expect(user.identity_card_number).to eq('123-456789-1234A')
      end

      it 'is not valid if no identity_card_number is present' do
        expect(User.new).to have(1).error_on(:identity_card_number)
      end

      it 'does not allow an invalid format' do
          user = User.new
          user.identity_card_number = 'ABCD1234xyz'
          expect(user).to have(1).error_on(:identity_card_number)
      end

      it 'allows a valid format' do
          user = User.new
          user.identity_card_number = '123-456789-1234A'
          expect(user).to have(0).errors_on(:identity_card_number)
      end

    end

    describe 'updating identity_card_number' do

      before(:each) do
        @user = FactoryGirl.create(:user)
      end

      it "creates a censor rule for the user's identity card number" do
        expect(@user.censor_rules.where(:text => '201-180954-0009J')).to have(1).item
      end

      it 'creates another censor rule when the user changes identity card number' do
        @user.update_attribute(:identity_card_number, '201-180954-0009Z')
        expect(@user.censor_rules.where(:text => '201-180954-0009J')).to have(1).item
        expect(@user.censor_rules.where(:text => '201-180954-0009Z')).to have(1).item
      end

      it 'does not duplicate censor rules' do
        @user.update_attribute(:identity_card_number, @user.identity_card_number)
        expect(@user.censor_rules.where(:text => '201-180954-0009J')).to have(1).item
      end

      it 'creates the censor rule with a replacement message' do
        expect(@user.censor_rules.last.replacement).to eql('REDACTED')
      end

      it 'creates the censor rule with the THEME_NAME as the author' do
        expect(@user.censor_rules.last.last_edit_editor).to eql(THEME_NAME)
      end

      it 'creates the censor rule with a generic comment' do
        comment = 'Updated automatically after_save'
        expect(@user.censor_rules.last.last_edit_comment).to eql(comment)
      end

    end

    describe :general_law do

      before(:each) do
        @user_attrs = { :name => 'Rob Smith',
                        :email => 'rob@localhost',
                        :password => 'insecurepassword',
                        :identity_card_number => '123-456789-1234A' }
      end

      it 'has associated general law information' do
        user = User.new(@user_attrs)
        user.build_general_law(FactoryGirl.attributes_for(:general_law))
        expect(user.general_law.domicile).to eq('Nicaragua')
      end

      it 'requires the general law information' do
        expect(User.new(@user_attrs)).to have(1).error_on(:general_law)
      end

      it 'validates the general law when validated' do
        user = User.new(@user_attrs)
        user.build_general_law
        user.valid?
        expect(user.general_law.errors).to have_at_least(1).item
      end

      it 'accepts nested attributes for general law' do
        params = @user_attrs.merge(:general_law_attributes => FactoryGirl.attributes_for(:general_law))
        expect(User.new(params).general_law.domicile).to eq('Nicaragua')
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
