def format_hash(hash)
  hash.to_a.
    sort_by(&:first).map do |key, value| 
      "%25s: %s\n" % [ key.gsub(/^HTTP_/, ""), value.inspect ] 
    end.
    join
end

Application = proc do |env|
  headers, process_env = env.partition do |k,v| k =~ /^HTTP_/ end

  [
    200, 
    { 'Content-Type' => 'text/plain' }, 
    [
      "\n# Headers\n\n",
      format_hash(headers),
      "\n# process environment\n\n",
      format_hash(ENV),
      "\n# Fork me on github\n\n",
      "https://github.com/radiospiel/inspector"
    ]
  ]
end

run Application
