require 'rest-client'
require 'pry'

class Leaderboard

  def self.index(size=10, offset=0)
    @result = RestClient.get root_url, params: { size: size, offset: offset }, accept: :json
  end

  def self.create(name, score)
    @result = RestClient.post root_url, { name: name, score: score }.to_json, content_type: :json, accept: :json
  end

  def self.destroy(name)
    @result = RestClient.delete [root_url,name].join("/"), accept: :json
  end

  def self.show(name)
    @result = RestClient.get [root_url,name].join("/"), accept: :json
  end

  protected

    def self.root_url
      "http://localhost:3000/api/v1/"
    end
end

binding.pry

sleep(1)
