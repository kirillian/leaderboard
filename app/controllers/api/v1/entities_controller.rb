module API
  module V1
    class EntitiesController < APIController
      include EntitiesBase

      respond_to :json
    end
  end
end
