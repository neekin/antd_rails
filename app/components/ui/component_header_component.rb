module Ui
  class ComponentHeaderComponent < ViewComponent::Base
    def initialize(title:, description:, when_to_use: [])
      @title = title
      @description = description
      @when_to_use = when_to_use
    end
  end
end
