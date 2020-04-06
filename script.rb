require_relative 'Toggl'
include Toggl
require 'json'

toggl = Toggl::Timer.new()

puts "Result"
puts "toggl = #{toggl}"
puts "toggl.to_json = #{toggl.to_json}"
puts "toggl.api_token = #{toggl.api_token}"
