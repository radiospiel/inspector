# coding: utf-8
require "sinatra"

if development?
  require "sinatra/reloader"
  also_reload 'lib/**/*'
end

require_relative "./trackr"

helpers do
  def format_hash(hash)
    hash.keys.sort.
      map do |key, value| [ key, hash[key] ] end.
      map do |key, value| "%25s: %s\n" % [ key, value.inspect ] end.
      join
  end
end

get(/./) do
  content_type "text/plain"

  lines = []
  lines << "# Headers\n"
  lines << format_hash(headers)

  lines << "# Environment\n"
  lines << format_hash(request.env.select { |k,v| k[0] == k[0].upcase })

  lines << "# process environment\n"
  lines << format_hash(ENV)

  lines << "# Fork me on github\n"
  lines << "https://github.com/radiospiel/inspector"

  per_path, requests = Trackr.track(request.path) 
  
  lines << ""
  lines << "# Visited: #{per_path}/#{requests} times"
  lines.join("\n")
end
