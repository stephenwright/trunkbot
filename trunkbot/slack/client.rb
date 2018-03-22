require 'slack-ruby-client'
require 'pp'

module Trunkbot
  module Slack
    class Client

      def initialize(bot)
        @bot = bot
        @client = ::Slack::RealTime::Client.new

        @client.on :hello do
          puts "Connected '#{@client.self.name}' to '#{@client.team.name}' [https://#{@client.team.domain}.slack.com]."
        end

        @client.on :message do |data|
          receive_message(data)
        end
      end

      def start
        @client.start!
      end

    private

      def receive_message(data)
        #puts "data:"
        #pp data

        # ignore bot message
        return if data.subtype == 'bot_message'
        # ignore messages posted by self
        return if data.user == @client.self.id

        if data.subtype == 'message_changed'
          text = data.message.text
        elsif data.text.nil?
          return
        else
          text = data.text
        end

        input = nil
        if !@client.ims[data.channel].nil?
          #direct message
          input = text
        else
          msg = ::Slack::Messages::Formatting.unescape(text)
          puts "message received: #{msg}"

          case msg
          when /^(@#{@client.self.id}|!)(.+)/
            input = $2
          end
        end

        process_message(input, data.user, data.channel) if !input.nil?
      end

      def process_message(msg, user, channel)
        puts "processing: #{channel}.#{user} - #{msg}"
        out = @bot.process(msg)
        @client.web_client.chat_postMessage(channel: channel, text: out, as_user: true)
      end

    end
  end
end
