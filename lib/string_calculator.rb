require 'calculator_logger'
require 'calculator_service'

class StringCalculator

  DEFAULT_DELIMITER = /[,\n]/

  class << self
    def add(string)
      sum = string.empty? ? 0 : parse(string).inject(:+)
      log(sum) 
      sum
    end

    private
    def parse(string)
      lines = string.split("\n")

      if lines.first.start_with?("//")
        delimiter = parse_delimiter lines.first[2..-1]
        number_string = lines[1..-1].join("\n")
      else
        delimiter = DEFAULT_DELIMITER
        number_string = string
      end

      parse_numbers(delimiter, number_string)
    end

    def parse_delimiter(delimiter_string)
      if delimiter_string =~ /^\[.*\]$/
        parse_multiple_delimiters(delimiter_string).join('|')
      else
        delimiter_string
      end
    end

    def parse_numbers(delimiter, number_string)
      numbers = number_string.split(/#{delimiter}/).map(&:to_i)
      negatives = numbers.select { |n| n < 0 }
      raise "negatives not allowed: #{negatives}" if negatives.any?
      numbers.reject { |n| n > 1000 }
    end

    def parse_multiple_delimiters(delimiters)
      delimiters.scan(/\[[^\]]*\]/).map do |delimiter|
        Regexp.escape(delimiter[1..-2])
      end
    end

    def log(message)
      begin
        CalculatorLogger.write(message)
      rescue Exception => e
        CalculatorService.notify(e.message)
      end

      puts message
    end

  end

end
