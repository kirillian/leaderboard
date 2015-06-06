require 'rails_helper'
require 'support/matchers/request_code_matchers'

describe EntitiesController do
  describe 'Actions' do
    describe 'index' do
      context 'no params' do
        it 'returns status OK' do
          get :index

          expect(response).to be_status :ok
        end
      end

      context 'valid size and offset params' do
        let(:params) { { size: 10, offset: 0 } }

        it 'returns status OK' do
          get :index, params

          expect(response).to be_status :ok
        end

        it 'never returns more objects that are requested in size' do
          (1..11).map { |i| Entity.create(name: "Name#{i}", latest_score: i) }

          get :index, params

          expect(assigns(:entities).size).to be 10
        end

        it 'returns objects offset by the offset parameter' do
          entities = (1..11).map { |i| Entity.create(name: "Name#{i}", latest_score: 100 - i) }

          get :index, size: 2, offset: 5

          expect(assigns(:entities).map(&:object)).to include(entities[5], entities[6])
        end
      end

      context 'size too large' do
        let(:params) { { size: 101, offset: 0 } }

        it 'returns status BAD REQUEST' do
          get :index, params

          expect(response).to be_status :bad_request
        end
      end

      context 'offset out of range' do
        let(:params) { { size: 10, offset: 2 } }

        it 'returns status NOT FOUND' do
          get :index, params

          expect(response).to be_status :not_found
        end
      end
    end
  end
end
