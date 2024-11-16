# frozen_string_literal: true

def create_dclass(hash)
  Class.new do
    hash.each_key do |key|
      attr_accessor key.to_sym
    end

    define_method(:initialize) do
      hash.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    define_method(:info) do
      "#{@name} - #{@artistName}"
    end
  end
end
