require 'slack-ruby-client'

module Trunkbot
  module Slack
    class Client

      def initialize(bot)
        @bot = bot

        @client = ::Slack::RealTime::Client.new

        @client.on :hello do
          puts "Successfully connected, welcome '#{@client.self.name}' to the '#{@client.team.name}' team at https://#{@client.team.domain}.slack.com."
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
        puts "data: #{data}"

        return if data.subtype == 'bot_message'

        msg = ::Slack::Messages::Formatting.unescape(data.text)
        puts "message received: #{msg}"

        input = nil
        if !@client.ims[data.channel].nil?
          #direct message
          input = data.text
        else
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
        @client.web_client.chat_postMessage channel: channel, text: out
      end

    end
  end
end
