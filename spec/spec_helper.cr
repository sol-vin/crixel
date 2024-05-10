require "spec"
require "../src/crixel"

macro make_event_test(x)
  ({{ run("../tests/event#{x}.cr").stringify }} =~ /OK/).should_not be_nil
end

SUCCESS = "!!!!!!!OK!!!!!!!"
FAILURE = "!!!!!!!FAIL!!!!!!!"
