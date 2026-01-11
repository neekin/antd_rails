module Ui
  class ExampleComponent < ViewComponent::Base
    def initialize(title:, code:, description: nil, language: :erb)
      @title = title
      @code = code
      @description = description
      @language = language
    end

    private

    def highlight_erb(code)
      # 简单的语法高亮：将 <% %> 包裹在紫色中，将 # 注释包裹在灰色中
      formatted = h(code)
      
      # Highlight ERB tags
      formatted = formatted.gsub(/&lt;%(=)?/, '<span class="text-purple-400">&lt;%\1</span>')
      formatted = formatted.gsub(/%&gt;/, '<span class="text-purple-400">%&gt;</span>')
      
      # Highlight Comments (simple implementation)
      formatted = formatted.gsub(/(#.+)$/, '<span class="text-gray-500 italic">\1</span>')

      raw(formatted)
    end
  end
end
