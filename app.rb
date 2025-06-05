require 'bundler/setup'
require 'nokogiri'
require 'rack'
require 'rspec'

puts "Nokogiri version: #{Nokogiri::VERSION}"

app = Proc.new do |env|
  ['200', {'Content-Type' => 'text/html'}, ['Hello from Rack!']]
end

Rack::Handler::WEBrick.run app, Port: 3000