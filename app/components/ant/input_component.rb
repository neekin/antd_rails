module Ant
  class InputComponent < ViewComponent::Base
    def initialize(name: nil, value: nil, type: :text, placeholder: nil, **html_options)
      @name = name
      @value = value
      @type = type
      @placeholder = placeholder
      @html_options = html_options
    end

    def classes
      "w-full px-[11px] py-[4px] text-[14px] text-gray-900 bg-white border border-[#d9d9d9] rounded-[6px] 
       hover:border-[#4096ff] 
       focus:border-[#4096ff] focus:ring-2 focus:ring-[#4096ff]/20 focus:outline-none 
       placeholder-gray-400 transition-all #{@html_options[:class]}"
    end
  end
end