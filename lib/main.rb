require_relative 'log'
require_relative 'db'
require_relative 'game'
require_relative 'player'
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
        @qs.poll_players do |msg|
          log "player: #{msg.body}"
          process_player Player.new(msg.body)
        end
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

    def process_player p
      if p.valid?
        @db.insert_player(p)
      else
        log 'skip: invalid player'
      end
    end
  end
end

$stdout.sync = true
PgWriter::Main.new.run
