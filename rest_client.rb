require 'rest-client'
require 'pry'

class Leaderboard

  def self.list
    @result = RestClient.get root_url, accept: :json
  end

  def self.add_score(name, score)
    @result = RestClient.post root_url, { name: name, score: score }.to_json, content_type: :json, accept: :json
  end

  def self.delete_entity(name)
    @result = RestClient.delete root_url, { name: name }, accept: :json
  end

  def self.get_entity(name)
    @result = RestClient.get root_url, { name: name }, accept: :json
  end

  protected

    def self.root_url
      "http://localhost:3000/api/v1/"
    end
end

binding.pry

Leaderboard.list
