module Ant
  class SelectComponent < ViewComponent::Base
    def initialize(name: nil, options: [], selected: nil, disabled: false, placeholder: "Please select", **html_options)
      @name = name
      @options = normalize_options(options)
      @selected = selected || @options.first&.last # Default to first value if none selected
      @disabled = disabled
      @placeholder = placeholder
      @html_options = html_options
    end
    
    def selected_label
      found = @options.find { |label, value| value.to_s == @selected.to_s }
      found ? found.first : @placeholder
    end

    private

    def normalize_options(options)
      # Handle ["A", "B"] -> [["A", "A"], ["B", "B"]]
      # Handle [["L", "V"]] -> [["L", "V"]]
      options.map do |opt|
        if opt.is_a?(Array)
          [opt.first, opt.last]
        else
          [opt, opt]
        end
      end
    end
  end
end
