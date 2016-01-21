require 'bundler/setup'
require 'pg'
require 'pry'
require 'sinatra/base'
require 'redcarpet'

require_relative "server"

run Forum::Server