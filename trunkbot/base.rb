# This file is the base include for all commands

root_path = File.expand_path('../', File.dirname(__FILE__))
$LOAD_PATH.unshift(root_path) unless $LOAD_PATH.include?(root_path)

require 'rubygems'

require 'lib/db'

require 'trunkbot'
require 'trunkbot/model/image'
require 'trunkbot/model/irc_message'
require 'trunkbot/model/note'

