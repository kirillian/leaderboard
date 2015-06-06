require 'rails_helper'

describe UpdateEntityLatestScoreJob do
  describe 'Instance Methods' do
    let(:score_saver) { ScoreSaver.new(name: name, score: value) }

    subject { UpdateEntityLatestScoreJob.new }

    let(:entity) { score_saver.entity }
    let(:name) { 'test' }
    let(:value) { 12 }

    describe '.perform' do
      it 'Updates the latest_score on the given entity' do
        score_saver.save!

        subject.perform(entity.id)

        entity.reload

        expect(entity.latest_score).to eq value
      end
    end
  end
end
