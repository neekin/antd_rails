module Ant
  class CardComponent < ViewComponent::Base
    def initialize(title: nil, extra: nil, **html_options)
      @title = title
      @extra = extra
      @html_options = html_options
    end
  end
end