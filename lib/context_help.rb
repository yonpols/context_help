require 'context_help/patches/tag_helper_patch'
require 'context_help/patches/form_helper_patch'
require 'context_help/patches/formtastic_patch'
require "context_help/version"
require 'context_help/base'

Formtastic::SemanticFormHelper.builder = ContextHelp::SemanticFormBuilder if defined?(Formtastic)
