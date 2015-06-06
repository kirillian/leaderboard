require 'rails_helper'
require 'support/matchers/delegate_matchers'

describe EntityDecorator do
  describe 'Instance Methods' do
    subject { entity.decorate }
    let(:entity) { Entity.new(name: 'name') }

    it 'delegates score to Entity#latest_score' do
      expect(subject).to delegate(:score).to(:object).as(:latest_score)
    end
  end
end
