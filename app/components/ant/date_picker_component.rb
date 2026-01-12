module Ant
  class DatePickerComponent < ViewComponent::Base
    attr_reader :name, :value, :placeholder, :disabled

    def initialize(name: nil, value: nil, placeholder: "Select date", disabled: false, **html_options)
      @name = name
      @value = normalize_value(value)
      @placeholder = placeholder
      @disabled = disabled
      @html_options = html_options
      @date = parse_date(@value) || Date.today
    end

    def display_text
      @value.present? ? @value : @placeholder
    end

    private

    def normalize_value(val)
      return nil if val.nil? || val == ""
      case val
      when Date
        val.strftime("%Y-%m-%d")
      when Time, DateTime
        val.to_date.strftime("%Y-%m-%d")
      else
        val.to_s
      end
    end

    def parse_date(val)
      return nil unless val.present?
      Date.parse(val) rescue nil
    end
  end
end
