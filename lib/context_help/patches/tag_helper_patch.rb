module ActionView
  module Helpers
    module TagHelper
      def tag_with_context_help_tag(name, options = {}, open = false, escape = true)
        help_options = { :context_help => { :path => {:tag => name.to_sym, :tag_options => options} } }.merge(options)
        help = ContextHelp::Base.help_for(help_options)
        tag_without_context_help_tag(name, options, open, escape) + help
      end
      def content_tag_with_context_help_content_tag(name, content_or_options_with_block = nil, options = {}, escape = true, &block)
        help_options = { :context_help => { :path => {:tag => name.to_sym, :tag_options => options} } }.merge(options)
        help = ContextHelp::Base.help_for(help_options)
        html = content_tag_without_context_help_content_tag(name, content_or_options_with_block, options, escape, &block) + help
      end

      alias_method_chain :tag, :context_help_tag
      alias_method_chain :content_tag, :context_help_content_tag
    end
  end
end