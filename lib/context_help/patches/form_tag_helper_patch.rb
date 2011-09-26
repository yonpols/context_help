module ActionView
  module Helpers
    module FormTagHelper
      def form_tag_with_context_help_form_tag(url_for_options = {}, options = {}, *parameters_for_url, &block)
        help_options = ContextHelp::Helpers.merge_options({:context_help => {:path => {:tag => :form, :tag_options => options.dup}}}, options)
        ContextHelp::Base.help_for(help_options)
        form_tag_without_context_help_form_tag(url_for_options, options, *parameters_for_url, &block)        
      end
      def label_tag_with_context_help_label_tag(name, text = nil, options = {})
        help_options = ContextHelp::Helpers.merge_options({:context_help => {:path => {:tag => :label, :tag_options => options.dup}}}, options)
        text ||= name.to_s.humanize
        text = text + ContextHelp::Base.help_for(help_options)
        
        options.delete('context_help')
        label_tag_without_context_help_label_tag name, text, options
      end
      
      alias_method_chain :form_tag, :context_help_form_tag
      alias_method_chain :label_tag, :context_help_label_tag
    end
  end
end
