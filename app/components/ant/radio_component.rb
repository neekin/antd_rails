# frozen_string_literal: true

module Ant
  class RadioComponent < ViewComponent::Base
    def initialize(
      name:,
      value:,
      checked: false,
      disabled: false,
      size: :default,
      **options
    )
      @name = name
      @value = value
      @checked = checked
      @disabled = disabled
      @size = size
      @options = options
    end

    private

    def radio_classes
      base = "inline-flex items-center cursor-pointer group"
      base += " opacity-50 cursor-not-allowed" if @disabled
      base += " #{@options[:class]}" if @options[:class]
      base
    end

    def circle_classes
      size_class = @size == :small ? "w-4 h-4" : "w-4 h-4"

      base = "#{size_class} rounded-full border flex items-center justify-center transition-all duration-200"

      if @disabled
        base += " border-gray-300 bg-gray-100"
      else
        base += " border-[#d9d9d9] bg-white group-hover:border-[#1677ff]"
      end

      base
    end

    def dot_classes
      # 选中时的内部圆点应该占外圈的 50%，即 16px 的圆圈内部是 8px 的圆点
      size_class = @size == :small ? "w-2 h-2" : "w-2 h-2"

      "#{size_class} rounded-full bg-[#1677ff] opacity-0 scale-0 transition-all duration-200"
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
  end
end
