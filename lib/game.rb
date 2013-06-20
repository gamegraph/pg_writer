module PgWriter
  class Game
    def initialize json
      @h = JSON[json]
    end

    def gamedate
      dparts = @h.fetch('date').split('-').map(&:to_i)
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

    def valid?
      @h.is_a?(Hash) && @h.length == 4
    end
  end
end
