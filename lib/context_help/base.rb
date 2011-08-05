module ContextHelp
  module Base
    @help_items = []
    @config = {
       :show_inline => false,
       :title_tag => 'h1',
       :title_class => 'help_title',
       :text_tag => 'span',
       :text_class => 'help_text',
       :exclude_tags => [:script, :link, :li],
       :exclude_models => [],
       :show_missing => false
    }

    def self.help_for(options)
      help_options = options[:context_help]
      help_options[:calculated_path] = self.help_path_for(help_options)
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
    def self.help_items
      @help_items
    end
    def self.config
      @config
    end
    def self.flush_items
      @help_items = []
    end
    def self.help_path_for(options,register=true)
      path = options[:path]
      return path if path.is_a?(String)

      ruta = nil
      if !options[:skip]
        if path[:model] and @config[:exclude_models].index(path[:model].to_sym).nil?
          ruta = 'context_help.models.'+path[:model].to_s.downcase
          ruta = ruta + '.attributes.'+ path[:attribute].to_s.downcase if (path[:attribute])
        elsif path[:tag] and @config[:exclude_tags].index(path[:tag].to_sym).nil?
          ruta = 'context_help.html.'+path[:tag].to_s.downcase
          ruta = ruta + '.' + path[:tag_options][:id].to_s if path[:tag_options][:id]
        elsif path[:custom]
          ruta = 'context_help.custom.'+options[:custom]
        end
      end
      if ruta
        self.register_item(options) if register
        return ruta if (I18n.t(ruta+'.title', :default => '') != '') or (Rails.env.development? and @config[:show_missing])
      end
      nil
    end
    def self.inline_help(options)
      options[:calculated_path] = self.help_path_for(options) if !options[:calculated_path]
      if !options[:skip] and options[:calculated_path] and (@config[:show_inline] or options[:show_inline])
        self.html_help(options)
      else
        ''
      end
    end

    private
    def self.html_help(options)
      "<#{@config[:title_tag]} class=\"#{@config[:title_class]}\">#{I18n.t(options[:calculated_path]+'.title')}</#{@config[:title_tag]}>
      <#{@config[:text_tag]} class=\"#{@config[:text_class]}\">#{I18n.t(options[:calculated_path]+'.text')}</#{@config[:text_tag]}>"
    end
    def self.register_item(options)
      found = false
      @help_items.each do |item|
        found = (item[:path] == options[:path])
        break if found
      end
      @help_items << options if not found
    end
  end
end
