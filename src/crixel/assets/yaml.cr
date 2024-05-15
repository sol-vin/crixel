require "yaml"

class Crixel::Assets::YAML < Crixel::Asset
  getter name : String
  property yaml : ::YAML::Any

  def initialize(@name, @yaml)
  end
end

module Crixel::Assets
  @@yamls = {} of String => YAML

  add_consumer do |path, io, size|
    extension = Path.new(path).extension.downcase
    if extension.upcase[1..] == "YAML"
      content = io.gets_to_end
      add_yaml YAML.new(path, ::YAML.parse(content))
      true
    else
      false
    end
  end

  def self.add_yaml(yaml : YAML)
    if @@yamls[yaml.name]?
      emit Asset::Changed, @@yamls[yaml.name], yaml
      @@yamls[yaml.name].yaml = yaml.yaml
    else
      @@yamls[yaml.name] = yaml
    end
  end

  def self.get_yaml(name)
    @@yamls[name]
  end

  def self.get_yaml?(name)
    @@yamls[name]?
  end
end
