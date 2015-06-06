require 'rails_helper'

class EntityConcernsTestController < ApplicationController
  include Concerns::EntityConcerns
end

describe Concerns::EntityConcerns do
  describe 'Singleton Methods' do
    subject { EntityConcernsTestController.new }

    describe '#score_saver_params' do
      let(:params_with_extra_keys) { params_with_allowed_keys.merge(key: 'value', another_key: 1234) }
      let(:params_with_allowed_keys) { ActionController::Parameters.new(name: 'name', score: 10) }

      it 'filters out all params other than name and score' do
        expect(subject.score_saver_params(params_with_extra_keys)).to eq(params_with_allowed_keys)
      end

      it 'does NOT filter out name or score' do
        expect(subject.score_saver_params(params_with_extra_keys)).to include(:name, :score)
      end
    end

    describe '#search_params' do
      let(:params_with_extra_keys) { params_with_allowed_keys.merge(key: 'value', another_key: 1234) }
      let(:params_with_allowed_keys) { ActionController::Parameters.new(size: 6, offset: 11) }
      let(:params_with_new_values) { ActionController::Parameters.new(size: 12, offset: 2) }
      let(:params_with_no_new_values) { subject.default_search_params }
      let(:params_with_no_values) { ActionController::Parameters.new({}) }

      it 'filters out all params other than size and offset' do
        expect(subject.search_params(params_with_extra_keys)).to eq(params_with_allowed_keys)
      end

      it 'does NOT filter out size or offset' do
        expect(subject.search_params(params_with_allowed_keys)).to include(:size, :offset)
      end

      it 'overwrites default_search_params with new values when given in params' do
        expect(subject.search_params(params_with_new_values)).to eq(params_with_new_values)
      end

      it 'equals default_search_params when none given in params' do
        expect(subject.search_params(params_with_no_values)).to eq(subject.default_search_params)
      end

      it 'equals default_search_params when values match default_search_params' do
        expect(subject.search_params(params_with_no_new_values)).to eq(subject.default_search_params)
      end
    end

    describe '#default_search_params' do
      it 'returns a HashWithIndifferentAccess' do
        expect(subject.default_search_params).to be_a ActionController::Parameters
      end

      it 'returns the default values of size: 10 and offset: 0' do
        expect(subject.default_search_params[:size]).to eq 10
        expect(subject.default_search_params[:offset]).to eq 0
      end
    end
  end
end
