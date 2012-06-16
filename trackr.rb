require "uri"
require "redis"

module Trackr
  def self.track(path)
  end
end

$redis = begin
  url = ENV["REDISTOGO_URL"]
  url ||= "redis://127.0.0.1:6379/" if ENV["RACK_ENV"] == "development"

  if url
    uri = URI.parse(url)
    Redis.new :scheme => "redis",
              :host => uri.host,
              :port => uri.port,
              :path => nil,
              :timeout => 5.0,
              :password => uri.password,
              :db => uri.path.sub(/^\//, "").to_i
  end
end

if $redis

module Trackr
  def self.track(path)
    requests = $redis.incr "requests"
    per_path = $redis.incr path
    [ per_path, requests ]
  end
end

end
