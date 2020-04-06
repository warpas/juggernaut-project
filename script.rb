require_relative 'Toggl'
include Toggl
require 'json'

toggl = Toggl::Timer.new()

puts "toggl = #{toggl}"
puts "toggl.to_json = #{toggl.to_json}"
toggl.print_config

toggl.authorize
