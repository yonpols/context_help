module ContextHelp
  module Base
    @help_items = []
    @config = {
       :show_inline => false,
       :title_tag => 'h1',
       :title_class => 'help_title',
       :text_tag => 'span',
       :text_class => 'help_text',
       :level_classes => {
         :model => 'help_level_1',
         :model_attribute => 'help_level_2',
         :html => {
           :default => 'help_level_2',

           :form => 'help_level_1',
           :fieldset => 'help_level_2',
         },
         :custom => 'help_level_3'
       },
       :exclude_tags => [:script, :link, :li],
       :exclude_models => [],
       :show_missing => false,
       :link_to_object => false,
       :link_to_help => false
    }

    def self.help_items
      @help_items
    end
    def self.config
      @config
    end
    def self.flush_items
      @help_items = []
    end

    def self.help_for(options)
      help_options = options[:context_help]
      self.help_path_for(help_options)
      self.inline_help(help_options)
    end
    def self.context_help(&block)
      help = ''
      @help_items.each do |item|
        item[:calculated_path] = self.help_path_for(item, false) if !item[:calculated_path]
        if block_given?
          help += yield(item)
        elsif !item[:skip] and item[:calculated_path]
          help += self.html_help(item)
        end
      end
      help.strip
    end
    def self.inline_help(options)
      return '' if options[:skip] or !options[:calculated_path]
      if options[:inline_help_builder].is_a?(Proc) 
        options[:inline_help_builder].call(options)
      elsif options[:show_inline]
        self.html_help(options)
      else
        ''
      end
    end
    def self.help_path_for(options,register=true)
      path = options[:path]
      return path if path.is_a?(String)

      ruta = nil
      if !options[:skip]
        if path[:model] and @config[:exclude_models].index(path[:model].to_sym).nil?
          ruta = 'context_help.models.'+Helpers.model_name(path[:model])
          options[:pre_level_class] = @config[:level_classes][:model]
          
          if (path[:attribute])
            ruta = ruta + '.attributes.'+ path[:attribute].to_s.underscore
            options[:pre_level_class] = @config[:level_classes][:model_attribute]
          end  
        elsif path[:custom]
          ruta = 'context_help.custom.'+path[:custom]
          options[:pre_level_class] = @config[:level_classes][:custom]
        elsif path[:tag] and @config[:exclude_tags].index(path[:tag].to_sym).nil?
          ruta = 'context_help.html.'+path[:tag].to_s.downcase
          ruta = ruta + '.' + path[:tag_options][:id].to_s if path[:tag_options][:id]
          
          if @config[:level_classes][:html].include?(path[:tag])
            options[:pre_level_class] = @config[:level_classes][:html][path[:tag]]
          else
            options[:pre_level_class] = @config[:level_classes][:html][:default]
          end
        end
      end
      if ruta              
        options[:calculated_path] = ruta
        self.register_item(options) if register
        return options[:calculated_path]
      end
      nil
    end
    def self.html_help(options)
      if options[:help_builder].is_a?(Proc) 
        options[:help_builder].call(options)
      elsif options[:calculated_path]
        title = Helpers.get_title(options)
        text = Helpers.get_text(options)
        return '' if (title.nil? || text.nil?) and !(Rails.env.development? and @config[:show_missing])

        html = "<#{options[:title_tag]} id=\"#{options[:item_id]}\" class=\"#{options[:title_class]} #{options[:level_class]}\">#{title}</#{options[:title_tag]}>
        <#{options[:text_tag]} class=\"#{options[:text_class]} #{options[:level_class]}\">#{text}</#{options[:text_tag]}>"
        html += self.link_to_object(options)
        html
      end
    end
    def self.link_to_help(options)  
      if options[:link_to_help_builder].is_a?(Proc)
        options[:link_to_help_builder].call(options)
      elsif options[:link_to_help] and options[:calculated_path]
        title = Helpers.get_title(options)
        return '' if title.nil?
        "<a href=\"##{options[:item_id]}\" id=\"#{options[:item_id]}_object\" class=\"context_help_link_to_help\">help</a>"
      else
        ''
      end
    end
    def self.link_to_object(options)  
      if options[:link_to_object_builder].is_a?(Proc)
        options[:link_to_object_builder].call(options)
      elsif options[:link_to_object]
        "<a href=\"#link_to_help_#{options[:item_id]}\">help</a>"
      else
        ''
      end
    end
    def self.register_item(options)
      def self.get_option(name, options)
        return @config[name] if options[:calculated_path].nil?
        value = I18n.t(options[:calculated_path]+'.'+name.to_s, :default => {})
        if value.is_a?(Hash)
          @config[name]
        else
          value
        end
      end
      found = false
      @help_items.each do |item|
        found = (item[:calculated_path] == options[:calculated_path])
        break if found
      end
      if not found
        options[:show_inline] ||= get_option(:show_inline, options)
        options[:title_tag] ||= get_option(:title_tag, options)
        options[:title_class] ||= get_option(:title_class, options)
        options[:text_tag] ||= get_option(:text_tag, options)
        options[:text_class] ||= get_option(:text_class, options)
        options[:link_to_object] ||= get_option(:link_to_object, options)
        options[:link_to_help] ||= get_option(:link_to_help, options)
        options[:level_class] ||= I18n.t(options[:calculated_path]+'.level_class', :default => (options[:pre_level_class] || 'help_level_1'))
        options[:link_to_help_builder] ||= @config[:link_to_help_builder]
        options[:link_to_object_builder] ||= @config[:link_to_object_builder]
        options[:inline_help_builder] ||= @config[:inline_help_builder]
        options[:help_builder] ||= @config[:help_builder]
        
        options[:item_id] = "context_help_item_#{(@help_items.length+1).to_s}"
        @help_items << options 
      end
    end 
  end

  module Helpers
    def self.is_visible(options)
      return false if options[:calculated_path].nil?
      return false if self.get_text(options,false).nil?
      true
    end
    def self.get_title(options)
      title = options[:title] || I18n.t(options[:calculated_path]+'.title', :default => {})
      if (title.nil? or title.is_a?(Hash)) 
        title = nil
        if options[:path][:model]
          begin
            model_class = model_name(options[:path][:model]).classify.constantize
            if options[:path][:attribute] then
              title = model_class.human_attribute_name(options[:path][:attribute].to_s) rescue I18n.t(options[:calculated_path]+'.title')
            else
              title = model_class.human_name
            end
          rescue
            title = I18n.t(options[:calculated_path]+'.title')
          end
        else
          title = I18n.t(options[:calculated_path]+'.title') if Rails.env.development? and ContextHelp::Base.config[:show_missing]
        end
      else
        if title.start_with?('t.')
          title = I18n.t title[2, title.length]
        elsif title.start_with?('I18n.')
          title = I18n.t title[5, title.length]
        end
      end
      title
    end
    def self.get_text(options,missing=true)
      text = options[:text] || I18n.t(options[:calculated_path]+'.text', :default => {})
      if (text.nil? or text.is_a?(Hash)) 
        if missing and Rails.env.development? and ContextHelp::Base.config[:show_missing]
          I18n.t(options[:calculated_path]+'.text')
        else
          nil
        end
      else
        text
      end
    end
    def self.model_name(model)
      model = model.to_s.underscore
      if model =~ /^[a-z][a-z0-9_]*\[[a-z][a-z0-9_]*_attributes\]/
        model.match(/^[a-z][a-z0-9_]*\[([a-z][a-z0-9_]*)_attributes\]/)[1].singularize
      else
        model
      end
    end
    def self.merge_options(base, added)
      if base.is_a?(Hash) and added.is_a?(Hash)
        added.each do |key,value|
          base[key.to_sym] = self.merge_options(base[key.to_sym], value)
        end
        return base
      else
        return base || added
      end
    end
  end
end
