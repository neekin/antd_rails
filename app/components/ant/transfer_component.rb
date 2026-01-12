module Ant
  class TransferComponent < ViewComponent::Base
    def initialize(name: nil, options: [], selected: [], left_title: "Source", right_title: "Target", disabled: false, **html_options)
      @name = name
      @options = normalize_options(options)
      @selected = Array(selected).map(&:to_s)
      @left_title = left_title
      @right_title = right_title
      @disabled = disabled
      @html_options = html_options
    end

    def left_items
      @options.reject { |(_label, value)| @selected.include?(value.to_s) }
    end

    def right_items
      @options.select { |(_label, value)| @selected.include?(value.to_s) }
    end

    private

    def normalize_options(options)
      options.map { |opt| opt.is_a?(Array) ? [ opt.first, opt.last.to_s ] : [ opt, opt.to_s ] }
    end
  end
end
