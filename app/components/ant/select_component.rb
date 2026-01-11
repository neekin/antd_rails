module Ant
  class SelectComponent < ViewComponent::Base
    def initialize(name: nil, options: [], selected: nil, disabled: false, placeholder: "Please select",
                   multiple: false, searchable: false, loading: false, max_tag_count: nil, **html_options)
      @name = name
      @options = normalize_options(options)
      @selected = normalize_selected(selected, multiple)
      @disabled = disabled
      @placeholder = placeholder
      @multiple = multiple
      @searchable = searchable
      @loading = loading
      @max_tag_count = max_tag_count
      @html_options = html_options
    end

    def selected_label
      return @placeholder if @selected.empty?

      if @multiple
        # For multiple selection, return count or placeholder
        "#{@selected.size} selected"
      else
        found = @options.find { |label, value| value.to_s == @selected.first.to_s }
        found ? found.first : @placeholder
      end
    end

    def selected_tags
      return [] unless @multiple

      @selected.map do |val|
        found = @options.find { |label, value| value.to_s == val.to_s }
        found ? { label: found.first, value: val } : nil
      end.compact
    end

    def visible_tag_count
      return selected_tags.size unless @max_tag_count && @max_tag_count > 0
      [ @max_tag_count, selected_tags.size ].min
    end

    def overflow_count
      return 0 unless @multiple && @max_tag_count && @selected.size > @max_tag_count
      @selected.size - @max_tag_count
    end

    def is_selected?(value)
      @selected.include?(value.to_s)
    end

    private

    def normalize_options(options)
      # Handle ["A", "B"] -> [["A", "A"], ["B", "B"]]
      # Handle [["L", "V"]] -> [["L", "V"]]
      options.map do |opt|
        if opt.is_a?(Array)
          [ opt.first, opt.last ]
        else
          [ opt, opt ]
        end
      end
    end

    def normalize_selected(selected, multiple)
      if multiple
        Array(selected).map(&:to_s)
      else
        selected ? [ selected.to_s ] : (@options.first ? [ @options.first.last.to_s ] : [])
      end
    end
  end
end
