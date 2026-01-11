module Ant
  class TagComponent < ViewComponent::Base
    def initialize(label: nil, color: :default, **html_options)
      @label = label
      @color = color
      @html_options = html_options
    end

    def classes
      base_classes = "inline-flex items-center px-2 py-0.5 rounded text-xs font-medium border mr-2 whitespace-nowrap transition-colors"
      
      color_classes = case @color.to_sym
      when :success # Green
        "bg-[#f6ffed] border-[#b7eb8f] text-[#52c41a]"
      when :processing, :blue # Blue
        "bg-[#e6f7ff] border-[#91d5ff] text-[#1677ff]"
      when :error, :red # Red
        "bg-[#fff2f0] border-[#ffccc7] text-[#ff4d4f]"
      when :warning, :orange # Orange
        "bg-[#fffbe6] border-[#ffe58f] text-[#faad14]"
      else # Default Gray
        "bg-[#f5f5f5] border-[#d9d9d9] text-[rgba(0,0,0,0.88)]"
      end

      "#{base_classes} #{color_classes} #{@html_options[:class]}"
    end
  end
end