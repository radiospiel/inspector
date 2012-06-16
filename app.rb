# coding: utf-8
require "sinatra"

if development?
  require "sinatra/reloader"
  also_reload 'lib/**/*'
end

get(/./) do
  content_type "text/plain"
  
  env = request.env
  
  env.keys.sort.
    map do |key, value| [ key, env[key] ] end.
    map do |key, value| "%25s: %s\n" % [ key, value.inspect ] end
end

