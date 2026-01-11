module Ant
  class CalendarComponent < ViewComponent::Base
    def initialize(date: Date.today, fullscreen: true, **html_options)
      @date = date
      @fullscreen = fullscreen
      @html_options = html_options
    end
  end
end