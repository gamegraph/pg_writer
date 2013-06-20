require 'pg'
require 'uri'

module PgWriter
  class DB
    include Log

    def initialize
      @conn = PG.connect connect_hash db_uri
    end

    def insert_game g
      @conn.exec_params '
        insert into games (kgs_un_w, kgs_un_b, gamedate, result)
        values ($1, $2, $3, $4)',
        [g.white, g.black, g.gamedate, g.result]
    end

    def insert_player p
      begin
        @conn.exec_params 'insert into players (kgs_un) values ($1)', [p.kgs_un]
        log "inserted: #{p.kgs_un}"
      rescue PG::Error => e
        if e.message.to_s.include? 'violates unique constraint'
          log "skip duplicate player: #{p.kgs_un}"
        else
          raise e
        end
      end
    end

    private

    def connect_hash uri
      {
        host: uri.host,
        dbname: uri.path[1..-1],
        user: uri.user,
        password: uri.password
      }
    end

    def db_uri
      URI.parse ENV['DATABASE_URL']
    end
  end
end
