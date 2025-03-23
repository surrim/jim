# frozen_string_literal: true

def Jim.setter(method_name, &block)
  define_method(method_name) do |*args, **kwargs|
    instance_exec(*args, **kwargs, &block) if block
    self
  rescue StandardError => e
    Jim::System.warn("Error in method `#{method_name}`:\n#{e.message}")
    self
  end
end
