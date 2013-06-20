module PgWriter
  class Game
    def initialize json
      @h = JSON[json]
    end

    def gamedate
      dparts = @h.fetch('gamedate').split('-')
      raise 'Invalid date' if dparts.length != 3
      Date.new *dparts
    end

    def result
      @h.fetch('result').downcase[0]
    end

    def white
      @h.fetch 'white'
    end

    def black
      @h.fetch 'black'
    end
  end
end
