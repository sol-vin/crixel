require "json"


class Crixel::Assets::JSON < Crixel::Asset
  getter name : String
  property json : ::JSON::Any

  def initialize(@name, @json)
  end
end

module Crixel::Assets
  @@jsons = {} of String => JSON

  add_consumer do |path, io, size|
    extension = Path.new(path).extension.downcase
    if extension.upcase[1..] == "JSON"
      content = io.gets_to_end
      add_json JSON.new(path, ::JSON.parse(content))
      true
    else
      false
    end
  end

  def self.add_json(json : JSON)
    if @@jsons[json.name]?
      emit Asset::Changed, @@jsons[json.name], json
      @@jsons[json.name].json = json.json
    else
      @@jsons[json.name] = json
    end
  end

  def self.get_json(name)
    @@jsons[name]
  end

  def self.get_json?(name)
    @@jsons[name]?
  end
end
