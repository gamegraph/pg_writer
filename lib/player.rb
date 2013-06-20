module PgWriter
  class Player
    def initialize json
      @h = JSON[json]
    end

    def kgs_un
      @h.fetch('kgs_username')
    end

    def valid?
      @h.is_a?(Hash) && @h.has_key?('kgs_username')
    end
  end
end
