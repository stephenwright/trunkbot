module Trunkbot
  module Irc
    class Client
      attr_accessor :socket, :running, :bot

      def initialize ( bot )
        @bot = bot
      end

      # main loop
      def start
        @running = true
        connect

        while @running
          begin
            ready = select( [@socket], nil, nil, 300 )
            raise Trunkbot::Irc::ConnectionTimeout 'connection to server has timed out' if ready.nil?
            next unless ready

            # Handle messages received through the socket
            if ready[0].include? @socket then
              raise Trunkbot::Irc::SocketDisconnect 'disconnected from server' if @socket.eof
              receive_message( @socket.gets )
            end

          rescue StandardError => e
            self.log.error "error: #{e.message}"
            connect
          end
        end
      end

    protected

      def log
        Trunkbot::Irc.config.logger
      end

      def log_file ( msg, chan=@chan )
        f = File.open( "log/#{chan.sub('#','')}.#{Date.today}.log", "a" )
        f.write( "[#{Time.now.strftime('%H:%M:%S')}] #{msg}\n" )
        f.close
      end

      def log_db ( usr, trg, msg )
        irc_message = IrcMessage.new
        irc_message.name = usr
        irc_message.receiver = trg
        irc_message.text = msg
        irc_message.save
      end

      def log_raw ( msg )
        f = File.open( "log/raw.#{Date.today}.log", "a" )
        f.write( "[#{Time.now.strftime('%H:%M:%S')}] #{msg}\n" )
        f.close
      end

      # Initialize connection to IRC server
      def connect
        self.log.trace '[ connect ]'

        self.log.info "#{Trunkbot::Irc.config.host}:#{Trunkbot::Irc.config.port}"

        @socket = TCPSocket.open( Trunkbot::Irc.config.host, Trunkbot::Irc.config.port )

        if Trunkbot::Irc.config.pass
          send "PASS #{Trunkbot::Irc.config.pass}"
        end

        send "NICK #{Trunkbot::Irc.config.nick}"
        send "USER TrunkBot toad trunkbit.com work"
        send "PRIVMSG NickServ :identify #{Trunkbot::Irc.config.pass}" if Trunkbot::Irc.config.pass

        join Trunkbot::Irc.config.chan unless Trunkbot::Irc.config.chan.nil? || Trunkbot::Irc.config.chan.empty?
      end

      # Push messages to the server
      def send ( msg )
        self.log.info "--> #{msg}\n"
        @socket.send "#{msg}\n", 0
      end

      # out --------------------------------------------------------------------------------------------

      # Join specified channel
      def join ( chan )
        send "JOIN #{chan}"
      end

      # Send a message to a channel or user
      def privmsg ( to, msg )
        send "PRIVMSG #{to} :#{msg}"
      end

      # Kick a user from the target channel
      def kick ( chn, usr, msg )
        send "KICK #{chn} #{usr} :#{msg}"
      end

      # Invite a user to target channel
      def invite ( usr, chn )
        send "INVITE #{usr} #{chn}"
      end

      def quit
        send "QUIT :powering down..."
      end

      # in ---------------------------------------------------------------------------------------------

      # Receive messages sent from the server
      def receive_message ( msg )
        msg.strip!
        if /^PING :(.+)$/i =~ msg # Reply to PINGs to keep the connection alive
          send "PONG :#{$1}"
          #self.log.trace "ping received at [#{Time.now.strftime('%H:%M:%S')}] \n"

        else
          self.log.info "<-- #{msg}\n"
          self.log_raw msg

          # Messages from Server should come as follows:
          # :<nick>!<userName>@<userDomain> <action> <action-specific-parameters>
          process_message $1, $2, $3 if msg =~ /^:(.+?)\s(.+?)\s(.*)/
        end
      end

      # Process message received from the server
      def process_message ( source, action, params )
        self.log.trace "[ process_message #{source} #{action} #{params} ]"

        usr = source.split('!')[0] # Pull nick from "nick!user@domain"
        chn = params.split(' ')[0] # Channel specific actions have channel name as 1st parameter

        case action
        when 'PRIVMSG'
          /(.+?)\s:(.+)/.match(params)
          trg = $1
          msg = $2
          self.log_file "#{trg}.#{usr}:#{msg}", trg
          action_msg msg, usr, trg

        when /(\d\d\d)/ # Three digit code
          action_code $1

        when 'JOIN' # :<channel>
          chn.sub!(/^:/, '')
          self.log_file "#{usr} JOIN #{chn}", chn
          send "PRIVMSG #{chn} :Hello #{usr}" if usr != Trunkbot::Irc.config.nick

        when 'KICK' # <channel> <target> :<msg>
          prm = params.split(" ", 3)
          trg = prm[1]
          msg = prm[2]
          self.log_file "#{usr} KICK #{chn} #{trg} #{msg}", chn

        when 'TOPIC' # <channel> :<topic>
          self.log_file "#{usr} TOPIC #{params}", chn

        when 'INVITE' # <target> :<chan>
          prm = params.split(" ", 2)
          trg = prm[0];
          chn = prm[1].sub(/^:/, '')
          join chn
          self.log_file "#{usr} INVITE #{trg} :#{chn}"

        when 'QUIT'
        when 'PART'
        when 'NICK'
        when 'MODE'
        end
      end

      # Handle server codes
      def action_code ( code )
        case code
          # Names List
          when 353 # namelist
          when 366 # end of /names

          # Message Of The Day
          when 375 # MOTD start
          when 372 # MOTD line
          when 376 # MOTD end
        end
      end

      # Handle PRIVMSG
      def action_msg ( msg, usr, trg )
        self.log.trace "[ action_msg ]"

        begin
          log_db(usr, trg, msg)
        rescue Exception => e
          puts e.message
          puts e.backtrace.inspect
        end

        # don't respond to messages sent by this client
        return if usr == Trunkbot::Irc.config.nick

        if trg == Trunkbot::Irc.config.nick
          # direct message to bot
          do_cmd msg, usr, usr
        elsif msg =~ /^(#{Trunkbot::Irc.config.nick}[:,]?\s?|!)(.+)/
          # message in channel addressed to bot
          do_cmd $2, usr, trg
        end
      end

      # process commends sent to this client
      def do_cmd ( msg, from, trg )
        self.log.trace "[ do_cmd #{msg} ]"
        if /(.+?)>\s?(#?\w+)$/ =~ msg
            self.log.debug "[ Directed Command; cmd:#{$1}, trg:#{$2} ]"
          msg = $1
          trg = $2
        end
        out = @bot.process msg
        out.split("\n").each {|line| privmsg trg, line; sleep(0.5); }
      end
    end
  end
end
