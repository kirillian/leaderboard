require 'rest-client'
require 'pry'
require 'benchmark'

class Leaderboard
  def self.index(size = 10, offset = 0)
    @result = RestClient.get root_url, params: { size: size, offset: offset }, accept: :json
  end

  def self.create(name, score)
    @result = RestClient.post root_url, { name: name, score: score }.to_json,
                              content_type: :json, accept: :json
  end

  def self.destroy(name)
    @result = RestClient.delete [root_url, name].join('/'), accept: :json
  end

  def self.show(name)
    @result = RestClient.get [root_url, name].join('/'), accept: :json
  end

  def self.root_url
    'http://localhost:3000/api/v1/'
  end
end

def make_random_request
  send(:"make_#{random_choice}_request")
end

def all_choices
  [:index, :create, :destroy, :show]
end

def change_choices
  [:create, :destroy]
end

def random_choice
  change_choices[rand(0..1)]
end

def make_index_request
  Leaderboard.index(rand(1..100), rand(0..9))
rescue RestClient::ResourceNotFound
  true
end

def make_create_request
  Leaderboard.create("Name#{rand(1..100)}", rand(1..100))
end

def make_destroy_request
  Leaderboard.destroy("Name#{rand(1..100)}")
rescue RestClient::ResourceNotFound
  true
end

def make_show_request
  Leaderboard.show("Name#{rand(1..100)}")
rescue RestClient::ResourceNotFound
  true
end

Benchmark.bm do |benchmark|
  benchmark.report { 1000.times { |_| make_random_request } }
end
