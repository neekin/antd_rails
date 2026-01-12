module Ant
  class SwitchComponent < ViewComponent::Base
    def initialize(name: nil, checked: false, disabled: false, loading: false,
                   size: :default, checked_text: nil, unchecked_text: nil, label: nil, **html_options)
      @name = name
      @checked = checked
      @disabled = disabled
      @loading = loading
      @size = size # :default or :small
      @checked_text = checked_text
      @unchecked_text = unchecked_text
      @label = label
      @html_options = html_options
    end

    def switch_classes
      base = "relative inline-flex items-center rounded-full transition-colors duration-200 cursor-pointer"

      size_classes = case @size
      when :small
        "h-[16px] min-w-[28px]"
      else
        "h-[22px] min-w-[44px]"
      end

      state_classes = if @disabled || @loading
        "opacity-40 cursor-not-allowed"
      elsif @checked
        "bg-[#1677ff]"
      else
        "bg-[rgba(0,0,0,0.25)]"
      end

      "#{base} #{size_classes} #{state_classes}"
    end

    def handle_classes
      base = "absolute bg-white rounded-full shadow-sm transition-all duration-200"

      size_classes = case @size
      when :small
        "w-[12px] h-[12px]"
      else
        "w-[18px] h-[18px]"
      end

      position = if @checked
        case @size
        when :small
          "translate-x-[14px]"
        else
          "translate-x-[24px]"
        end
      else
        "translate-x-[2px]"
      end

      "#{base} #{size_classes} #{position}"
    end

    def text_classes
      base = "text-white text-[12px] font-medium select-none"

      padding = case @size
      when :small
        @checked ? "pl-[6px] pr-[16px]" : "pl-[16px] pr-[6px]"
      else
        @checked ? "pl-[9px] pr-[24px]" : "pl-[24px] pr-[9px]"
      end

      "#{base} #{padding}"
    end
  end
end
