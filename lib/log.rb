module PgWriter
  module Log
    def log txt
      puts txt if PgWriter::VERBOSE
    end
  end
end
