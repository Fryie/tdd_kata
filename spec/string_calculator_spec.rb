require 'spec_helper'

describe StringCalculator do

  describe '#add' do

    before do
      CalculatorLogger.stub :write
      CalculatorService.stub :notify
      StringCalculator.stub :puts
    end

    context 'adding' do
      let(:result) { StringCalculator.add(@input) }

      it 'returns 0 for the empty string' do
        @input = ''
        expect(result).to eq 0
      end

      it 'returns the number for a single number' do
        @input = '12'
        expect(result).to eq 12
      end

      it 'returns the sum for two numbers' do
        @input = '12,3'
        expect(result).to eq 15
      end

      it 'returns the sum for 10 numbers' do
        @input = '1,2,3,4,5,6,7,8,9,10'
        expect(result).to eq 55
      end

      it 'handles newlines as well' do
        @input = "1\n2,3"
        expect(result).to eq 6
      end

      it 'supports custom delimiters' do
        @input = "//;\n1;2"
        expect(result).to eq 3
      end

      it 'throws an error with a negative number' do
        @input = '-1'
        expect { result }.to raise_error /negatives not allowed/
      end

      it 'mentions the number in the error' do
        @input = '-1'
        expect { result }.to raise_error /-1/
      end

      it 'mentions all negative numbers in the error' do
        @input = '-1,5,-9'
        expect { result }.to raise_error /-1.*-9/
      end

      it 'ignores numbers bigger than 1000' do
        @input = '8,1000,1001'
        expect(result).to eq 1008
      end

      it 'handles delimiters with brackets' do
        @input = "//[***]\n1***2***2"
        expect(result).to eq 5
      end

      it 'handles multiple delimiters' do
        @input = "//[*][%]\n1*2%3"
        expect(result).to eq 6
      end

      it 'also works with multiple multi-character delimiters' do
        @input = "//[!!][wq]\n1wq2!!3"
        expect(result).to eq 6
      end

      it 'works with a lot of special characters in delimiters' do
        @input = "//[()][^][\\]\n1()2^3\\4"
        expect(result).to eq 10
      end
    end

    context 'logging' do

      it 'logs the sum with a logger' do
        StringCalculator.add("1,2,3")
        expect(CalculatorLogger).to have_received(:write).with 6
      end

      it 'also logs when given an empty string' do
        StringCalculator.add("")
        expect(CalculatorLogger).to have_received(:write).with 0
      end

      it 'notifes a service if an exception occurs in the logging' do
        CalculatorLogger.stub(:write) do
          raise "message"
        end
        StringCalculator.add("1,2")
        expect(CalculatorService).to have_received(:notify).with "message"
      end

      it 'logs to the console as well' do
        StringCalculator.add("1,2,3")
        expect(StringCalculator).to have_received(:puts).with 6
      end

    end

  end

end
