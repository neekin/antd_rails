module Ant
  class ButtonComponent < ViewComponent::Base
    def initialize(label: nil, type: :default, **html_options)
      @label = label
      @type = type
      @html_options = html_options
    end

    def classes
      base_classes = "inline-flex items-center justify-center px-[15px] py-[4px] text-[14px] rounded-[6px] transition-all cursor-pointer font-normal h-[32px] border"
      
      type_classes = case @type
      when :primary
        "bg-[#1677ff] text-white border-[#1677ff] hover:bg-[#4096ff] hover:border-[#4096ff] active:bg-[#0958d9] active:border-[#0958d9]"
      else
        "bg-white text-[rgba(0,0,0,0.88)] border-[#d9d9d9] hover:text-[#4096ff] hover:border-[#4096ff] active:text-[#0958d9] active:border-[#0958d9]"
      end

      "#{base_classes} #{type_classes} #{@html_options[:class]}"
    end
  end
end