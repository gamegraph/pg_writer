require_relative 'log'
require_relative 'db'
require_relative 'game'
require_relative 'msg_queues'

module PgWriter
  class Main
    include Log

    def initialize
      @qs = MsgQueues.new
      @db = DB.new
    end

    def run
      while true do
        @qs.poll_games do |msg|
          log "game: #{msg.body}"
          process_game Game.new(msg.body)
        end
        log "going to sleep: poll stopped returning messages"
        sleep 60
      end
    end

    private

    def process_game g
      if g.valid?
        @db.insert_game(g)
      else
        log 'skip: invalid game'
      end
    end
  end
end

$stdout.sync = true
PgWriter::Main.new.run
