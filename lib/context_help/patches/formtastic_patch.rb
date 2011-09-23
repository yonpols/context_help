module ContextHelp
  class SemanticFormBuilder < Formtastic::SemanticFormBuilder
    def inputs(*args, &block)
      title = field_set_title_from_args(*args)
      html_options = args.extract_options!

      help_options = ContextHelp::Helpers.merge_options({:context_help => {:path => {:tag => 'fieldset', :tag_options => html_options}}}, html_options)
      help_options[:context_help][:title] = title if help_options[:context_help][:path][:tag]

      help = ContextHelp::Base.help_for(help_options)
      super *(args<<help_options), &block
    end
    def input(method, options = {})   
      options = ContextHelp::Helpers.merge_options({:context_help => {:path => {:model => model_name.to_sym, :attribute=> method.to_sym}}}, options || {})
      #options[:label_html] ||= {}
      #options[:label_html][:context_help] = options[:context_help]
      super method, options
    end
    def radio_input(method, options)
      options[:label] = localized_string(method, options[:label], :label) || humanized_attribute_name(method)
      ContextHelp::Base.help_for(options) 
      super method, options
    end
    def legend_tag(method, options = {})
      if options[:label] == false
        Formtastic::Util.html_safe("")
      else
        text = localized_string(method, options[:label], :label) || humanized_attribute_name(method)
        text += required_or_optional_string(options.delete(:required))
        text = Formtastic::Util.html_safe(text)
        template.content_tag :legend, template.label_tag(nil, text, options), :class => :label
      end
    end
  end
end
