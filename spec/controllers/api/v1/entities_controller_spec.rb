require 'rails_helper'
require 'support/matchers/request_code_matchers'

describe API::V1::EntitiesController do
  render_views

  describe 'Actions' do
    describe 'index' do
      context 'no params' do
        it 'returns JSON' do
          get :index, format: :json

          expect(parse_json(response.body)).to_not be nil
        end

        it 'returns status OK' do
          get :index, format: :json

          expect(response).to be_status :ok
        end
      end

      context 'valid size and offset params' do
        let(:params) { { size: 10, offset: 0 } }

        it 'returns JSON' do
          get :index, { format: :json }.merge(params)

          expect(parse_json(response.body)).to_not be nil
        end

        it 'returns status OK' do
          get :index, { format: :json }.merge(params)

          expect(response).to be_status :ok
        end

        it 'never returns more objects that are requested in size' do
          (1..11).map { |i| Entity.create(name: "Name#{i}", latest_score: i) }

          get :index, { format: :json }.merge(params)

          expect(response.body).to have_json_size(10)
        end

        it 'returns objects offset by the offset parameter' do
          entities = (1..11).map { |i| Entity.create(name: "Name#{i}", latest_score: 100 - i) }

          get :index, { format: :json }.merge(size: 2, offset: 5)

          expect(response.body).to include_json(entities[5].to_json).excluding(:rank, :score, :latest_score)
          expect(response.body).to include_json(entities[6].to_json).excluding(:rank, :score, :latest_score)
        end
      end

      context 'size too large' do
        let(:params) { { size: 101, offset: 0 } }

        it 'returns nothing' do
          get :index, { format: :json }.merge(params)

          expect(parse_json(response.body)).to be nil
        end

        it 'returns status BAD REQUEST' do
          get :index, { format: :json }.merge(params)

          expect(response).to be_status :bad_request
        end
      end

      context 'offset out of range' do
        let(:params) { { size: 10, offset: 2 } }

        it 'returns nothing' do
          get :index, { format: :json }.merge(params)

          expect(parse_json(response.body)).to be nil
        end

        it 'returns status NOT FOUND' do
          get :index, { format: :json }.merge(params)

          expect(response).to be_status :not_found
        end
      end
    end

    describe 'show' do
      let!(:entity) { Entity.create(name: 'Name', latest_score: 10) }

      context 'entity is found' do
        it 'returns JSON' do
          get :show, name: entity.name, format: :json

          expect(parse_json(response.body)).to_not be nil
        end

        it 'returns status OK' do
          get :show, name: entity.name, format: :json

          expect(response).to be_status :ok
        end

        it 'returns the score and rank of the entity' do
          get :show, name: entity.name, format: :json

          expect(response.body).to have_json_path('score')
          expect(response.body).to have_json_path('rank')
        end
      end

      context 'entity is NOT found' do
        it 'returns nothing' do
          get :show, name: 'wrong_name', format: :json

          expect(parse_json(response.body)).to be nil
        end

        it 'returns status NOT FOUND' do
          get :show, name: 'wrong_name', format: :json

          expect(response).to be_status :not_found
        end
      end
    end

    describe 'create' do
      context 'Score Saver successfully saves' do
        let(:params) { { name: 'Name', score: 10 } }

        it 'returns nothing' do
          post :create, { format: :json }.merge(params)

          expect(parse_json(response.body)).to be nil
        end

        it 'returns status OK' do
          post :create, { format: :json }.merge(params)

          expect(response).to be_status :ok
        end
      end

      context 'Score Saver fails to save successfully' do
        let(:params) { { score: 10 } }

        it 'returns nothing' do
          post :create, { format: :json }.merge(params)

          expect(parse_json(response.body)).to be nil
        end

        it 'returns status INTERNAL SERVER ERROR' do
          post :create, { format: :json }.merge(params)

          expect(response).to be_status :internal_server_error
        end
      end
    end

    describe 'destroy' do
      let!(:entity) { Entity.create(name: 'Name', latest_score: 10) }

      context 'Entity is not found' do
        let(:params) { { name: 'wrong name' } }

        it 'returns nothing' do
          delete :destroy, { format: :json }.merge(params)

          expect(parse_json(response.body)).to be nil
        end

        it 'returns status NOT FOUND' do
          delete :destroy, { format: :json }.merge(params)

          expect(response).to be_status :not_found
        end
      end

      context 'Entity is found' do
        context 'Entity successfully destroyed' do
          let(:params) { { name: entity.name } }

          it 'returns nothing' do
            delete :destroy, { format: :json }.merge(params)

            expect(parse_json(response.body)).to be nil
          end

          it 'returns status OK' do
            delete :destroy, { format: :json }.merge(params)

            expect(response).to be_status :ok
          end
        end

        context 'Entity is not destroyed' do
          before(:each) do
            allow(Entity).to receive(:find_by).and_return(entity)
            allow(entity).to receive(:destroy).and_return(false)
          end

          let(:params) { { name: entity.name } }

          it 'returns nothing' do
            delete :destroy, { format: :json }.merge(params)

            expect(parse_json(response.body)).to be nil
          end

          it 'returns status INTERNAL SERVER ERROR' do
            delete :destroy, { format: :json }.merge(params)

            expect(response).to be_status :internal_server_error
          end
        end
      end
    end
  end
end
