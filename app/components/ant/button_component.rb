module Ant
  class ButtonComponent < ViewComponent::Base
    def initialize(
      label: nil,
      type: :default,
      size: :middle,
      danger: false,
      ghost: false,
      disabled: false,
      loading: false,
      block: false,
      debounce: 0,
      throttle: 0,
      href: nil,
      **html_options
    )
      @label = label
      @type = type
      @size = size
      @danger = danger
      @ghost = ghost
      @disabled = disabled
      @loading = loading
      @block = block
      @debounce = debounce
      @throttle = throttle
      @href = href
      @html_options = html_options
    end

    def classes
      base_classes = "inline-flex items-center justify-center rounded-[6px] transition-all cursor-pointer font-normal border"

      # Size classes
      size_classes = case @size
      when :small
        "px-[7px] py-0 text-[14px] h-[24px]"
      when :large
        "px-[15px] py-[6.4px] text-[16px] h-[40px]"
      else # :middle
        "px-[15px] py-[4px] text-[14px] h-[32px]"
      end

      # Type and danger classes
      type_classes = if @danger
        case @type
        when :primary
          if @ghost
            "bg-transparent text-[#ff4d4f] border-[#ff4d4f] hover:text-[#ff7875] hover:border-[#ff7875]"
          else
            "bg-[#ff4d4f] text-white border-[#ff4d4f] hover:bg-[#ff7875] hover:border-[#ff7875] active:bg-[#d9363e] active:border-[#d9363e]"
          end
        when :text
          "bg-transparent text-[#ff4d4f] border-transparent hover:bg-[rgba(0,0,0,0.06)]"
        when :link
          "bg-transparent text-[#ff4d4f] border-transparent hover:text-[#ff7875]"
        when :dashed
          "bg-white text-[#ff4d4f] border-dashed border-[#ff4d4f] hover:text-[#ff7875] hover:border-[#ff7875]"
        else # :default
          if @ghost
            "bg-transparent text-[#ff4d4f] border-[#ff4d4f] hover:text-[#ff7875] hover:border-[#ff7875]"
          else
            "bg-white text-[#ff4d4f] border-[#d9d9d9] hover:text-[#ff7875] hover:border-[#ff7875]"
          end
        end
      else
        case @type
        when :primary
          if @ghost
            "bg-transparent text-[#1677ff] border-[#1677ff] hover:text-[#4096ff] hover:border-[#4096ff]"
          else
            "bg-[#1677ff] text-white border-[#1677ff] hover:bg-[#4096ff] hover:border-[#4096ff] active:bg-[#0958d9] active:border-[#0958d9]"
          end
        when :text
          "bg-transparent text-[rgba(0,0,0,0.88)] border-transparent hover:bg-[rgba(0,0,0,0.06)]"
        when :link
          "bg-transparent text-[#1677ff] border-transparent hover:text-[#4096ff]"
        when :dashed
          "bg-white text-[rgba(0,0,0,0.88)] border-dashed border-[#d9d9d9] hover:text-[#4096ff] hover:border-[#4096ff]"
        else # :default
          if @ghost
            "bg-transparent text-[rgba(0,0,0,0.88)] border-white hover:border-[#4096ff] hover:text-[#4096ff]"
          else
            "bg-white text-[rgba(0,0,0,0.88)] border-[#d9d9d9] hover:text-[#4096ff] hover:border-[#4096ff] active:text-[#0958d9] active:border-[#0958d9]"
          end
        end
      end

      # Block button
      block_class = @block ? "w-full" : ""

      # Disabled state
      disabled_class = (@disabled || @loading) ? "opacity-60 cursor-not-allowed" : ""

      "#{base_classes} #{size_classes} #{type_classes} #{block_class} #{disabled_class} #{@html_options[:class]}".strip
    end

    def data_attributes
      attrs = {}

      if @debounce > 0 || @throttle > 0 || @loading
        attrs[:controller] = "ant--button"
        attrs[:action] = "click->ant--button#handleClick"
        attrs["ant--button-debounce-value"] = @debounce if @debounce > 0
        attrs["ant--button-throttle-value"] = @throttle if @throttle > 0
        attrs["ant--button-loading-value"] = @loading
      end

      # Merge with existing data attributes
      (@html_options[:data] || {}).merge(attrs)
    end

    def tag_name
      @href ? :a : :button
    end

    def tag_attributes
      attrs = @html_options.merge(
        class: classes,
        data: data_attributes
      )

      if @href
        attrs[:href] = @href
      else
        attrs[:disabled] = (@disabled || @loading)
        attrs[:type] ||= "button"
      end

      attrs
    end
  end
end
