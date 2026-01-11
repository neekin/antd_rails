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
      # 1. Escape HTML entities to prevent XSS
      formatted = h(code)
      
      # 2. Fix over-escaped quotes for better readability in code blocks
      # <pre> handles ' and " fine, we don't need to escape them as entities usually.
      formatted = formatted.gsub("&#39;", "'").gsub("&quot;", '"')

      # 3. Highlight ERB tags
      formatted = formatted.gsub(/&lt;%(=)?/, '<span class="text-purple-400">&lt;%\1</span>')
      formatted = formatted.gsub(/%&gt;/, '<span class="text-purple-400">%&gt;</span>')
      
      # 4. Highlight Comments (simple implementation)
      formatted = formatted.gsub(/(&lt;!--.+?--&gt;)/, '<span class="text-gray-500 italic">\1</span>') # HTML comments
      formatted = formatted.gsub(/(#.+)$/, '<span class="text-gray-500 italic">\1</span>') # Ruby comments

      raw(formatted)
    end
  end
end