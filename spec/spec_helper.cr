require "spec"

SUCCESS = "OKOKOKOKOKOKOKOKOKOKOK"
FAILURE = "FAILFAILFAILFAILFAILFAIL"

macro make_test(name)
  output = {{ (run "../tests/#{name.id}.cr", SUCCESS, FAILURE).stringify }}
  puts output if output.nil?
  (output =~ /#{SUCCESS}/).should_not be_nil
end
