describe Crixel::Events do
  it "should create an event without arguments" do
    make_event_test(1)
  end

  it "should create an event with arguments" do
    make_event_test(2)
  end

    it "should create an event inside a class and use self as an argument" do
    make_event_test(3)
  end
end