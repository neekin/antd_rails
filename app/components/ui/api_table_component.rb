module Ui
  class ApiTableComponent < ViewComponent::Base
    def initialize
      @rows = []
    end

    def row(property, description, type, default = "-")
      @rows << { property: property, description: description, type: type, default: default }
    end
  end
end
