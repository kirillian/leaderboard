require 'rails_helper'
require 'support/active_record_helpers'
require 'support/matchers/memoize_matchers'

describe ScoreSaver do
  describe 'Instance Methods' do
    subject { ScoreSaver.new(params) }
    let(:params) { { name: name, score: value } }
    let(:name) { 'name' }
    let(:value) { 'value' }

    describe '#initialize' do
      it 'assigns name and value' do
        expect(subject.name).to eq name
        expect(subject.value).to eq value
      end
    end

    describe '#entity' do
      it 'is an Entity' do
        expect(subject.entity).to be_a Entity
      end

      it 'memoizes score' do
        expect(subject.entity).to be_memoized_as(:entity)
      end
    end

    describe '#score' do
      it 'is a Score' do
        expect(subject.score).to be_a Score
      end

      it 'memoizes score' do
        expect(subject.score).to be_memoized_as(:score)
      end
    end

    describe '#save' do
      let(:error_message) { 'error' }

      it 'calls save!' do
        expect(subject).to receive(:save!)
        subject.save
      end

      it 'returns false when an error is raised' do
        expect(subject).to receive(:save!).and_raise(error_message)
        expect(subject.save).to be false
      end
    end

    describe '#save!' do
      it 'calls entity.save! and score.save! within an ActiveRecord::Base.transaction block' do
        within_active_record_transaction_block do
          expect(subject.entity).to receive(:save!)
          expect(subject.score).to receive(:save!)
        end

        subject.save!
      end

      it 'enqueues an UpdateEntityLatestScoreJob' do
        expect { subject.save! }.to enqueue_a(UpdateEntityLatestScoreJob)
      end
    end
  end
end
