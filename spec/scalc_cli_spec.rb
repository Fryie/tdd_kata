require 'spec_helper'
require 'pathname'

root = Pathname.new(__FILE__).parent.parent
ENV['PATH'] = "#{root.join('bin').to_s}#{File::PATH_SEPARATOR}#{ENV['PATH']}"

describe "scalc cli application" do
  
  it 'adds the numbers' do
    run_interactive "scalc '1,2,3'"
    close_input
    it_should_contain_output "The result is 6"
  end

  it 'prompts for a new input' do
    run_interactive "scalc '1,2,3'"
    close_input
    it_should_contain_output "Another input please"
  end

  it 'calculates the result for a new input' do
    run_interactive "scalc '1,2,3'"
    type '2,3'
    close_input
    it_should_contain_output "The result is 5"
  end

  it 'exits cleanly when the input line is empty' do
    run_interactive "scalc '1,2,3'"
    type ''
    it_should_have_exit_status 0
  end

end

def it_should_contain_output(output)
  assert_partial_output output, all_output
end

def it_should_have_exit_status(status)
  assert_exit_status status
end
