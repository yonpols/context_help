module ContextHelp
  class SemanticFormBuilder < Formtastic::SemanticFormBuilder
    def inputs(*args, &block)
      title = field_set_title_from_args(*args)
      html_options = args.extract_options!
      help_options = ContextHelp::Base.merge_options({:context_help => {:path => {:tag => 'fieldset', :tag_options => html_options}}}, html_options)
      help_options[:context_help][:title] = title if help_options[:context_help][:path][:tag]
      help = ContextHelp::Base.help_for(help_options)
      super *(args<<help_options), &block
    end
    def input(method, options = {})   
      options = ContextHelp::Base.merge_options({:context_help => {:path => {:model => model_name.to_sym, :attribute=> method.to_sym}}}, options || {})
      html = super
    end
    def legend_tag(method, options = {})
      if options[:label] == false
        Formtastic::Util.html_safe("")
      else
        text = localized_string(method, options[:label], :label) || humanized_attribute_name(method)
        text += required_or_optional_string(options.delete(:required))
        text = Formtastic::Util.html_safe(text)
        text += ContextHelp::Base.link_to_help(options[:context_help])
        template.content_tag :legend, template.label_tag(nil, text, :for => nil), :class => :label
      end
    end
  end
end
