# frozen_string_literal: true

require 'singleton'

class Jim::Sprintf2
  include Singleton

  SPRINTF2_SUBSTITUTION_REGEX = /% *{(?<identifier>[_a-zA-Z]\w*)(\[ *(?<from>-?\d+) *((?<mode>\.\.|,) *(?<to>-?\d+)?)? *\])?}/

  def initialize
    @computed_dependencies = {}
    @computed_topologies = {}
  end

  def deep_substitute(format_string, **substitutions)
    graph = substitutions.transform_values do |value|
      compute_dependencies(value.to_s) & substitutions.keys
    end
    compute_topology(graph).each do |identifier|
      substitutions[identifier] = substitute(substitutions[identifier].to_s, **substitutions)
    end
    substitute(format_string, **substitutions)
  end

  def substitute(format_string, **substitutions)
    i = 0
    while i < format_string.length
      match = format_string.match(SPRINTF2_SUBSTITUTION_REGEX, i)
      break if match.nil?

      match_begin, match_end = match.offset(0)
      identifier = match[:identifier].to_sym
      if substitutions.key?(identifier)
        value = self.class.eval2(substitutions[identifier].to_s, match[:from]&.to_i, match[:mode], match[:to]&.to_i)
      else
        Jim::System.warn("KeyError: %{#{identifier}} not found, skipping substitution")
      end
      format_string = format_string[0, match_begin].to_s + value.to_s + format_string[match_end..].to_s
      i = match_begin + value.to_s.length
    end
    format_string
  end

  def self.deep_substitute(format_string, **substitutions) = instance.deep_substitute(format_string, **substitutions)
  def self.substitute(format_string, **substitutions) = instance.substitute(format_string, **substitutions)

  def compute_topology(graph)
    return @computed_topologies[graph] if @computed_topologies.key?(graph)

    original_graph = graph.dup.transform_values(&:dup)

    sorted_graph = []
    while (root_dependency = self.class.pop_root_dependency(graph))
      graph.each_value do |dependencies|
        dependencies.delete(root_dependency)
      end
      sorted_graph.push(root_dependency)
    end
    Jim::System.warn('SubstitutionError: Ignoring cyclic dependency substitutions') unless graph.empty?

    @computed_topologies[original_graph] = sorted_graph
  end

  def compute_dependencies(format)
    return @computed_dependencies[format] if @computed_dependencies.key?(format)

    @computed_dependencies[format] = format.scan(SPRINTF2_SUBSTITUTION_REGEX).map(&:first).uniq
  end

  private_class_method

  def self.pop_root_dependency(graph) = graph.delete(graph.find { |_, value| value.empty? }&.first)

  def self.eval2(value, from, mode, to)
    return value if from.nil?
    return value[from] if mode.nil?
    return (to.nil? ? value[from,] : value[from, to]).to_s if mode == ','

    (to.nil? ? value[from..] : value[from..to]).to_s
  end
end
