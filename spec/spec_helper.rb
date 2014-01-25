require 'rspec'
require 'aruba'
require 'aruba/api'

include Aruba::Api

# require all lib files
Dir.glob("#{File.dirname(__FILE__)}/../lib/**/*.rb") do |file|
  require file
end
