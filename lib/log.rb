module PgWriter
  module Log
    VERBOSE = ENV.fetch('VERBOSE') == 'true'

    def log txt
      puts txt if VERBOSE
    end
  end
end
