module ActionView
  module Helpers
    module FormHelper
      def fields_for_with_context_help_fields_for(record_or_name_or_array, *args, &block)
        case record_or_name_or_array
        when String, Symbol
          object_name = record_or_name_or_array
        else
          object_name = ActionController::RecordIdentifier.singular_class_name(record_or_name_or_array)
        end

        options = ContextHelp::Base.merge_options({:context_help => {:path => {:model => object_name.to_sym} } }, args.last.is_a?(::Hash)? args.last : {})
        help = ContextHelp::Base.help_for(options)
        help + fields_for_without_context_help_fields_for(record_or_name_or_array, *args, &block)
      end       
      def label_with_context_help_label(object_name, method, text = nil, options = {})
        help_options = ContextHelp::Base.merge_options({:context_help => {:path => {:model => object_name.to_sym, :attribute=> method.to_sym}}}, options)
        ContextHelp::Base.help_for(help_options)
        link_to_help = ContextHelp::Base.link_to_help(help_options[:context_help])
        label_without_context_help_label(object_name, method, text.to_s + link_to_help, options)
      end
      def text_field_with_context_help_text_field(object_name, method, options = {})
        help_options = ContextHelp::Base.merge_options({:context_help => {:path => {:model => object_name.to_sym, :attribute=> method.to_sym}}}, options)
        help = ContextHelp::Base.help_for(help_options)
        text_field_without_context_help_text_field(object_name, method, options) + help
      end
      def password_field_with_context_help_password_field(object_name, method, options = {})
        help_options = ContextHelp::Base.merge_options({:context_help => {:path => {:model => object_name.to_sym, :attribute=> method.to_sym}}}, options)
        help = ContextHelp::Base.help_for(help_options)
        password_field_without_context_help_password_field(object_name, method, options) + help
      end
      def hidden_field_with_context_help_hidden_field(object_name, method, options = {})
        help_options = ContextHelp::Base.merge_options({:context_help => {:path => {:model => object_name.to_sym, :attribute=> method.to_sym}}}, options)
        help = ContextHelp::Base.help_for(help_options)
        hidden_field_without_context_help_hidden_field(object_name, method, options) + help
      end
      def file_field_with_context_help_file_field(object_name, method, options = {})
        help_options = ContextHelp::Base.merge_options({:context_help => {:path => {:model => object_name.to_sym, :attribute=> method.to_sym}}}, options)
        help = ContextHelp::Base.help_for(help_options)
        file_field_without_context_help_file_field(object_name, method, options) + help
      end
      def text_area_with_context_help_text_area(object_name, method, options = {})
        help_options = ContextHelp::Base.merge_options({:context_help => {:path => {:model => object_name.to_sym, :attribute=> method.to_sym}}}, options)
        help = ContextHelp::Base.help_for(help_options)
        text_area_without_context_help_text_area(object_name, method, options) + help
      end
      def check_box_with_context_help_check_box(object_name, method, options = {}, checked_value = "1", unchecked_value = "0")
        help_options = ContextHelp::Base.merge_options({:context_help => {:path => {:model => object_name.to_sym, :attribute=> method.to_sym}}}, options)
        help = ContextHelp::Base.help_for(help_options)
        check_box_without_context_help_check_box(object_name, method, options, checked_value, unchecked_value) + help
      end
      def radio_button_with_context_help_radio_button(object_name, method, tag_value, options = {})
        help_options = ContextHelp::Base.merge_options({:context_help => {:path => {:model => object_name.to_sym, :attribute=> method.to_sym}}}, options)
        help = ContextHelp::Base.help_for(help_options)
        radio_button_without_context_help_radio_button(object_name, method, tag_value, options) +help
      end

      alias_method_chain :fields_for, :context_help_fields_for
      alias_method_chain :label, :context_help_label
      alias_method_chain :text_field, :context_help_text_field
      alias_method_chain :password_field, :context_help_password_field
      alias_method_chain :hidden_field, :context_help_hidden_field
      alias_method_chain :file_field, :context_help_file_field
      alias_method_chain :text_area, :context_help_text_area
      alias_method_chain :check_box, :context_help_check_box
      alias_method_chain :radio_button, :context_help_radio_button
    end
  end
end