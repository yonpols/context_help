module ContextHelp
  class SemanticFormBuilder < Formtastic::SemanticFormBuilder
    def input(method, options = {})
      options[:wrapper_html] = { :context_help => { :path => {:model => model_name.to_s.downcase.to_sym, :attribute=> method.to_s.downcase.to_sym} } }.merge(options[:wrapper_html] || {})
      html = super
    end
  end
end

=begin
module Formtastic
  module SemanticFormHelper
    def semantic_form_for_with_context_help_semantic_form_for(record_or_name_or_array, *args, &proc)
      case record_or_name_or_array
      when String, Symbol
        object_name = record_or_name_or_array
      when Array
        object = record_or_name_or_array.last
        object_name = ActionController::RecordIdentifier.singular_class_name(object)
      else
        object = record_or_name_or_array
        object_name = ActionController::RecordIdentifier.singular_class_name(object)
      end
      options = args.extract_options!
      options[:help_path] ||= ContextHelp::Base.help_path_for(:model => object_name)
      semantic_form_for_without_context_help_semantic_form_for(record_or_name_or_array, *(args << options), &proc)
    end

    alias_method_chain :semantic_form_for, :context_help_semantic_form_for
  end
end
=end
