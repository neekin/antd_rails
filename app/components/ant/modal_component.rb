module Ant
  class ModalComponent < ViewComponent::Base
    renders_one :footer

    def initialize(title: nil, id: nil, open: false, width: "520px", **html_options)
      @title = title
      @id = id
      @open = open
      @width = width
      @html_options = html_options
    end
  end
end
