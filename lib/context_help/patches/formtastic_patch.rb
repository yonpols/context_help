module ContextHelp
  class SemanticFormBuilder < Formtastic::SemanticFormBuilder
    def input(method, options = {})   
      options[:wrapper_html] = { :context_help => { :path => {:model => model_name.to_sym, :attribute=> method.to_sym} } }.merge(options[:wrapper_html] || {})
      html = super
    end
  end
end
