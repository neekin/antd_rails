module Ant
  class TabsComponent < ViewComponent::Base
    renders_many :items, "TabItemComponent"

    def initialize(default: nil, **html_options)
      @default = default
      @html_options = html_options
    end

    class TabItemComponent < ViewComponent::Base
      attr_reader :label, :id

      def initialize(label:, id:)
        @label = label
        @id = id
      end

      def call
        content
      end
    end
  end
end