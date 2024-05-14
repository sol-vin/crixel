module Crixel::Input::IBase
  abstract def poll(total_time : Time::Span, elapsed_time : Time::Span) : Nil
end
