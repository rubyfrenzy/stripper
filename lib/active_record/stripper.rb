module ActiveRecord
  module Stripper
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def stripper(fields = [])
        fields = Array(fields)
        return if fields.empty?
        return if self.included_modules.include?(Stripper::InstanceMethods)
        __send__ :include, Stripper::InstanceMethods
        
        cattr_accessor :fields_that_get_stripped
        
        self.fields_that_get_stripped = fields

        class_eval do
          before_validation :strip_fields
        end
      end
    end
    
    module InstanceMethods
      
      protected
      
      def strip_fields
        self.class.fields_that_get_stripped.each{|f| self[f].strip! unless self[f].nil? }
      end
    end
  end
end
