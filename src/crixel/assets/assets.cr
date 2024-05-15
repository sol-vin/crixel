module Crixel::Assets
  alias ConsumerCallback = Proc(String, IO, Int32, Bool)

  @@consumers : Array(ConsumerCallback) = [] of ConsumerCallback

  event Unload
  event PreSetup
  event Setup
  event PostSetup

  on(Crixel::Started) { setup }
  on(Crixel::Close) { unload }

  # Tracks when an asset has been destroyed

  def self.add_consumer(&block : ConsumerCallback)
    @@consumers << block
  end

  def self.run_consumers(path : String, io : IO, size : Int) : Bool
    @@consumers.any? do |consumer|
      consumer.call(path, io, size)
    end
  end

  def self.setup
    emit PreSetup
    emit Setup
    emit PostSetup
  end

  def self.load(path : String, io : IO, size : Int32) : Bool
    raise "Cannot load before window is initialized: Try running asset loading methods from an `on Crixel::Assets::Setup` callback" unless Crixel.started?
    run_consumers(path, io, size)
  end

  def self.load_from_path(filename : String)
    File.open(filename) do |file|
      load(filename, file, file.size.to_i32)
    end
  end

  def self.load_folder(dir)
    Dir.glob("**").each do |name|
      if File.directory? name
        load_folder(Path.new(dir, name).to_s)
      else
        load_from_path(Path.new(dir, name).to_s)
      end
    end
  end

  def self.unload
    emit Unload
  end
end

class Crixel::Asset
  event Destroyed, me : self
  event Changed, me : self, to : self
end
