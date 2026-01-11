# frozen_string_literal: true

module Ant
  class CheckboxComponent < ViewComponent::Base
    def initialize(
      name:,
      value: "1",
      checked: false,
      disabled: false,
      indeterminate: false,
      size: :default,
      **options
    )
      @name = name
      @value = value
      @checked = checked
      @disabled = disabled
      @indeterminate = indeterminate
      @size = size
      @options = options
    end

    private

    def checkbox_classes
      base = "inline-flex items-center cursor-pointer group"
      base += " opacity-50 cursor-not-allowed" if @disabled
      base += " #{@options[:class]}" if @options[:class]
      base
    end

    def input_data_attributes
      attrs = []
      attrs << "data-ant--checkbox-target=\"input\""
      attrs << "data-ant--checkbox-indeterminate-value=\"#{@indeterminate}\""

      # 合并所有 action
      actions = [ "change->ant--checkbox#handleChange" ]
      if @options[:data] && @options[:data][:action]
        actions << @options[:data][:action]
      end
      attrs << "data-action=\"#{actions.join(' ')}\""

      # 添加其他 data 属性（排除 action）
      if @options[:data]
        @options[:data].each do |key, value|
          next if key.to_s == "action"
          attrs << "data-#{key.to_s.dasherize}=\"#{value}\""
        end
      end

      attrs.join(" ").html_safe
    end

    def box_classes
      size_class = @size == :small ? "w-4 h-4" : "w-4 h-4"

      base = "#{size_class} rounded border-2 flex items-center justify-center transition-all duration-200"

      if @disabled
        base += " border-gray-300 bg-gray-100"
      else
        base += " border-gray-300 group-hover:border-[#1677ff]"
      end

      base
    end

    def checkmark_classes
      "text-white text-xs flex items-center justify-center opacity-0 scale-50 transition-all duration-200"
    end

    def label_classes
      size_class = @size == :small ? "text-sm" : "text-base"

      base = "#{size_class} transition-colors duration-200"

      if @disabled
        base += " text-gray-400"
      else
        base += " text-gray-700"
      end

      base
    end

    def checkmark_svg
      <<~SVG.html_safe
        <svg viewBox="64 64 896 896" focusable="false" fill="currentColor" width="1em" height="1em">
          <path d="M912 190h-69.9c-9.8 0-19.1 4.5-25.1 12.2L404.7 724.5 207 474a32 32 0 00-25.1-12.2H112c-6.7 0-10.4 7.7-6.3 12.9l273.9 347c12.8 16.2 37.4 16.2 50.3 0l488.4-618.9c4.1-5.1.4-12.8-6.3-12.8z"></path>
        </svg>
      SVG
    end

    def indeterminate_svg
      <<~SVG.html_safe
        <svg viewBox="0 0 16 16" focusable="false" fill="currentColor" width="0.75em" height="0.75em">
          <rect x="2" y="7" width="12" height="2" rx="1"/>
        </svg>
      SVG
    end
  end
end
