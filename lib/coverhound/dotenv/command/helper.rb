module Coverhound::Dotenv
  module Command
    module Helper
      module_function

      RED    = "\x1B[0;31m".freeze
      YELLOW = "\x1B[0;33m".freeze
      RESET  = "\x1B[0m".freeze

      def warn(string)
        STDERR.puts "#{YELLOW}#{string}#{RESET}"
      end

      def abort(string)
        abort "#{RED}#{string}#{RESET}"
      end
    end
  end
end
