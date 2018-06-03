# -*- encoding : utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GeneralLaw do

  describe :date_of_birth do

    it 'has a date_of_birth attribute' do
      general_law = GeneralLaw.new(:date_of_birth => Date.parse('2014-01-02'))
      expect(general_law.date_of_birth).to eq(Date.parse('2014-01-02'))
    end

    it 'can be set' do
      general_law = GeneralLaw.new(:date_of_birth => Date.parse('2014-01-02'))
      general_law.date_of_birth = Date.parse('1980-08-24')
      expect(general_law.date_of_birth).to eq(Date.parse('1980-08-24'))
    end

    it 'must be set' do
      general_law = GeneralLaw.new(:date_of_birth => nil)
      expect(general_law).to have(1).error_on(:date_of_birth)
    end

    it 'must be a date' do
      general_law = GeneralLaw.new(:date_of_birth => 'yesterday')
      expect(general_law).to have(1).error_on(:date_of_birth)
    end

    it 'must be in the past' do
      general_law = GeneralLaw.new(:date_of_birth => Date.tomorrow)
      expect(general_law).to have(1).error_on(:date_of_birth)
    end

  end

  describe :marital_status do

    it 'has a marital_status attribute' do
      general_law = GeneralLaw.new(:marital_status => 'single')
      expect(general_law.marital_status).to eq('single')
    end

    it 'can be set' do
      general_law = GeneralLaw.new(:marital_status => 'single')
      general_law.marital_status = 'married'
      expect(general_law.marital_status).to eq('married')
    end

    it 'must be set' do
      general_law = GeneralLaw.new(:marital_status => nil)
      expect(general_law).to have(1).error_on(:marital_status)
    end

  end

  describe :occupation do

    it 'has a occupation attribute' do
      general_law = GeneralLaw.new(:occupation => 'programmer')
      expect(general_law.occupation).to eq('programmer')
    end

    it 'can be set' do
      general_law = GeneralLaw.new(:occupation => 'programmer')
      general_law.occupation = 'designer'
      expect(general_law.occupation).to eq('designer')
    end

    it 'must be set' do
      general_law = GeneralLaw.new(:occupation => nil)
      expect(general_law).to have(1).error_on(:occupation)
    end

  end

  describe :domicile do

    it 'has a domicile attribute' do
      general_law = GeneralLaw.new(:domicile => 'Cardiff')
      expect(general_law.domicile).to eq('Cardiff')
    end

    it 'can be set' do
      general_law = GeneralLaw.new(:domicile => 'Cardiff')
      general_law.domicile = 'London'
      expect(general_law.domicile).to eq('London')
    end

    it 'must be set' do
      general_law = GeneralLaw.new(:occupation => nil)
      expect(general_law).to have(1).error_on(:occupation)
    end

  end

  describe :age do

    it 'calculates age from date of birth' do
      Date.stub!(:today).and_return(Date.parse('2010-06-01'))
      general_law = GeneralLaw.new(:date_of_birth => Date.parse('2007-04-01'))
      expect(general_law.age).to eq(3)
    end

  end

  describe :display_attributes do

    it 'strips the attributes of internal information' do
      general_law = FactoryGirl.build(:general_law)
      expected = { :date_of_birth => Date.yesterday,
                   :occupation => 'programmer',
                   :domicile => 'Nicaragua',
                   :marital_status => 'single' }.with_indifferent_access
      expect(general_law.display_attributes).to eql(expected)
    end

  end

end
