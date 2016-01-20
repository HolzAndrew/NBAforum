require 'bundler/setup'
require 'pg'
require 'pry'
require 'sinatra/base'

require_relative "server"

run Forum::Server