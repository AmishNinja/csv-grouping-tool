# Entrypoint file for the program

require 'optparse'
require_relative 'lib/runner'

def parse_opts
  opts = {}
  OptionParser.new do |opt|
    opt.banner = "Usage: ruby main.rb -f <filename> -m <matching_type>"

    opt.on("-f", "--file FILENAME", "Path to input CSV") { |f| opts[:file] = f }
    opt.on("-m", "--match TYPE", "Matching type: email, phone, or email_or_phone") do |type|
      unless %w[email phone email_or_phone].include?(type)
        raise OptionParser::InvalidArgument, "Invalid match type: #{type}"
      end
      opts[:match_type] = type.to_sym
    end
    opt.on("-h", "--help", "Show this help message") { puts opt; exit }
  end.parse!
  opts
end

begin
  opts = parse_opts
  Runner.run(**opts)
rescue OptionParser::MissingArgument
  STDERR.puts "Missing required options. Run with --help"
  exit 1
rescue OptionParser::InvalidArgument => e
  STDERR.puts "#{e.message}. Run with --help"
  exit 1
end
