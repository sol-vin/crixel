macro install_events(base_event_name = Event, default_events_collection = Events)
  # Base class for events. NOT TO BE INHERITED BY ANYTHING UNLESS YOU REALLY NEED TO, use the `event` macro instead. HERE BE DRAGONS!
  abstract class ::{{base_event_name}}
    def initialize
      raise "Event should never be initialized!"
    end
  end

  # Namespace for holding all the `{{base_event_name}}`s. 
  module ::{{default_events_collection}}
  end

  # Creates a new event
  macro event(event_name, *args)
    \{% raise "event_name should be a Path" unless event_name.is_a? Path %}
    
    # Check if the event_name is a global path, if it is lets remove the `::{{default_events_collection}}` bit and use its full name
    \{% prepended_path = "::{{default_events_collection}}::" %}
    \{% if event_name.global? %}
      \{% prepended_path = "" %}
    \{% end %}

    \{% full_name = "#{prepended_path.id}#{event_name.id}".id %}

    # Create our event class
    class \{{full_name}} < ::{{base_event_name}}
      # Callbacks tied to this event, all of them will be called when triggered
      @@callbacks = [] of \{{full_name}}::Callback

      # Types of the arguments for the event
      ARG_TYPES = {
        \{% for arg in args %}
          "\{{arg.var.id}}" => \{{(arg.type.is_a? Self) ? @type : arg.type}},
        \{% end %}
      } of String => Object.class

      # Adds the block to the callbacks
      def self.add_callback(&block : \{{full_name}}::Callback)
        @@callbacks << block
      end

      # Triggers all the callbacks
      def self.trigger(\{{args.map {|a| a.var}.splat}}) : Nil
        @@callbacks.each(&.call(\{{args.map {|a| a.var}.splat}}))
      end
    end

    # Alias for the callback.
    alias \{{full_name}}::Callback = Proc(\{{(args.map {|arg| (arg.type.is_a? Self) ? @type : arg.type }).splat}}\{% if args.size > 0 %}, \{% end %}Nil)
  end

  # Includes an event to the classes instances
  macro attach(event_name)
    \{% prepended_path = "::{{default_events_collection}}::" %}
    \{% if event_name.global? %}
      \{% prepended_path = "" %}
    \{% end %}
    \{% full_name = parse_type("#{prepended_path.id}#{event_name.id}") %}

    
    \{% if args = parse_type("#{full_name}::ARG_TYPES").resolve? %}
      @%callbacks_\{{event_name.id.underscore}} = [] of \{{full_name}}::Callback

      def on_\{{full_name.names.last.underscore}}(&block : \{{full_name}}::Callback)
        @%callbacks_\{{event_name.id.underscore}} << block
      end

      \{% arg_types = [] of MacroId%}
      \{% args.each { |k,v| arg_types << "#{k.id} : #{v}".id }%}

      def emit_\{{full_name.names.last.underscore}}(\{{arg_types.splat}})
        # Call object specific callbacks
        @%callbacks_\{{event_name.id.underscore}}.each(&.call(\{{args.keys.map {|a| a.id }.splat}}))
        # Call event callbacks 
        \{{full_name}}.trigger(\{{args.keys.map {|a| a.id }.splat}})
      end
    \{% else %}
      \{% raise "Path was unable to be resolved!" %}
    \{% end %}
  end

  # Defines a global event callback
  macro on(event_name, &block)
    \{% prepended_path = "::{{default_events_collection}}::" %}
    \{% if event_name.global? %}
      \{% prepended_path = "" %}
    \{% end %}
    \{% full_name = "#{prepended_path.id}#{event_name.id}".id %}

    \{% raise "event_name should be a Path" unless event_name.is_a? Path %}
    raise "Incorrect arguments for block" unless \{{block.args.size}} == \{{full_name}}::ARG_TYPES.size

    \{{full_name}}.add_callback do \{% if block.args.size > 0 %}|\{{block.args.splat}}|\{% end %}
      \{{ block.body }}
      nil
    end
  end

  # Emits a global event callback
  macro emit(event_name, *args)
    # TODO: DO args checks
    # - Does the event exist?
    # - Is the arg the proper type?
    # - Can arg be cast into the proper type?
    \{% prepended_path = "::{{default_events_collection}}::" %}
    \{% if event_name.global? %}
      \{% prepended_path = "" %}
    \{% end %}
    \{% full_name = "#{prepended_path.id}#{event_name.id}".id %}

    \{{full_name}}.trigger(\{{args.splat}})
  end
end