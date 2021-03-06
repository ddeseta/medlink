require 'spec_helper'

describe Order do

  before :each do
    FactoryGirl.create :user,   pcv_id: 'USR'
    FactoryGirl.create :supply, shortcode: 'BND', name: 'Bandages'
    FactoryGirl.create :supply, shortcode: 'SND', name: 'Second thing'
  end

  context 'from text' do

    let(:data) { { pcvid: 'USR', loc: 'LOC', shortcode: 'BND',
      phone: '555-123-4567' } }

    subject { Order.create_from_text data }

    it { should be_a_kind_of Order }

    its(:email) { should match /user\d+@example.com/ }
    its(:phone) { should eq '555-123-4567'     }

    it 'raises on invalid pcvid' do
      expect do
        data[:pcvid] = 'NON'
        Order.create_from_text data
      end.to raise_error /unrecognized pcvid/i
    end

    it 'with invalid shortcode' do
      expect do
        data[:shortcode] = 'NON'
        Order.create_from_text data
      end.to raise_error  /unrecognized shortcode/i
    end

  end

  # -----

  context 'from web' do
    let(:data) { {
      email: 'custom@example.com',
      phone: 'N/A',
      requests_attributes: [{
        supply_id: Supply.first.id,
        dose:      '10mg'
      }, {
        supply_id: Supply.last.id,
        quantity:  5
      }]
    } }

    subject { FactoryGirl.create :order, data }
    after(:each) { subject.destroy }

    it { should be_a_kind_of Order }
    it { should_not be_fulfilled   }

    it 'can list its supplies' do
      expect( subject.supplies ).to eq ['Bandages', 'Second thing']
    end

    it 'requires unique supply items' do
      expect do
        a = FactoryGirl.create :order,
          email: 'custom@example.com',
          phone: 'N/A',
          requests_attributes: [{
            supply_id: Supply.first.id,
            dose:      '10mg'
          }, {
            supply_id: Supply.first.id,
            quantity:  5
          }]
        binding.pry
      end.to raise_error /suppl.*unique/i
    end

    it 'rejects duplicates' do
      # Sequences generate different Users if we don't do this:
      d = data.merge user_id: User.first.id

      expect do
        Order.create! d
        Order.create! d
      end.to raise_error /duplicate/i
    end

    its(:email) { should eq 'custom@example.com' }
    its(:phone) { should eq 'N/A'                }

    context 'when valid' do
      it { should be_valid }

      it 'can generate a confirmation message' do
        expect( subject.confirmation_message ).to match /has been received/
      end
    end

    context 'when invalid' do
      before(:each) { subject.user = nil }

      it { should_not be_valid }

      it 'can generate an error message' do
        expect( subject.confirmation_message ).to match /pcv id/i
      end
    end

  end

end
