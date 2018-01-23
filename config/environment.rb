# Set up gems listed in the Gemfile.
# See: http://gembundler.com/bundler_setup.html
#      http://stackoverflow.com/questions/7243486/why-do-you-need-require-bundler-setup
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])

# Require gems we care about
require 'rubygems'

require 'uri'
require 'pathname'

require 'json'
require 'csv'

# Debugger
require 'pry'

# AWS
require 'aws-sdk'

require 'sinatra'
require 'sinatra/reloader' if development?

require 'erb'

# Some helper constants for path-centric logic
APP_ROOT = Pathname.new(File.expand_path('../../', __FILE__))

# APP_NAME = APP_ROOT.basename.to_s
APP_NAME = [APP_ROOT.basename.to_s, 'app', 'app.rb'].join('/')

configure do
  # By default, Sinatra assumes that the root is the file that calls the configure block.
  # Since this is not the case for us, we set it manually.
  set :root, APP_ROOT.to_path
  # See: http://www.sinatrarb.com/faq.html#sessions
  enable :sessions
  set :session_secret, ENV['SESSION_SECRET'] || 'this is a secret shhhhh'

  # Set the views to
  set :views, File.join(Sinatra::Application.root, "app", "views")

  set :public_folder, File.join(Sinatra::Application.root, "app", "public")
end

# Set up the controllers
# Dir[APP_ROOT.join('app', 'controllers', '*.rb')].each { |file| require file }

# Load main application file
require [APP_ROOT, 'app', 'app.rb'].join('/')

# Load Service Objects
Dir[APP_ROOT.join('app', 'services', '*.rb')].each { |file| require file }
