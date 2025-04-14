# frozen_string_literal: true

def protect_setters(*methods)
  methods.each do |method_name|
    safe_method = "#{method_name}_unsafe".to_sym
    alias_method safe_method, method_name
    send(:private, safe_method)

    define_method(method_name) do |*args, **kwargs|
      send(safe_method, *args, **kwargs)
      self
    rescue StandardError => e
      Jim::System.warn("Error in method `#{method_name}`:\n#{e.message}")
      self
    end
  end
end

UNDEFINED = Object.new.freeze
