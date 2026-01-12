# frozen_string_literal: true

module Ant
  class CalendarComponent < ViewComponent::Base
    attr_reader :value, :mode, :fullscreen, :selectable, :disabled_date, :events,
                :show_header, :show_today_button, :locale, :html_options

    def initialize(
      value: nil,
      mode: "month",
      fullscreen: true,
      selectable: false,
      disabled_date: nil,
      events: [],
      show_header: true,
      show_today_button: true,
      locale: "en",
      **html_options
    )
      @value = value || Date.today
      @mode = mode
      @fullscreen = fullscreen
      @selectable = selectable
      @disabled_date = disabled_date
      @events = events
      @show_header = show_header
      @show_today_button = show_today_button
      @locale = locale
      @html_options = html_options
    end

    private

    def calendar_classes
      [
        "ant-calendar",
        "bg-white rounded-lg border border-gray-200",
        fullscreen ? "p-6" : "p-4",
        html_options[:class]
      ].compact.join(" ")
    end

    def calendar_data_attributes
      attrs = []
      attrs << "data-ant--calendar-mode-value=\"#{mode}\""
      attrs << "data-ant--calendar-selectable-value=\"#{selectable}\""
      attrs << "data-ant--calendar-locale-value=\"#{locale}\""
      attrs << "data-ant--calendar-value-value=\"#{value.iso8601}\"" if value
      attrs << "data-ant--calendar-events-value='#{events.to_json}'" if events.any?
      attrs.join(" ").html_safe
    end

    def weekday_names
      locale == "zh" ? %w[日 一 二 三 四 五 六] : %w[Sun Mon Tue Wed Thu Fri Sat]
    end

    def render_month_days
      start_of_month = value.beginning_of_month
      end_of_month = value.end_of_month
      start_day = start_of_month.wday

      html = ""

      # Previous month days
      start_day.times do |i|
        prev_date = start_of_month - (start_day - i)
        html += render_day_cell(prev_date, outside_month: true)
      end

      # Current month days
      (1..end_of_month.day).each do |day|
        current_date = Date.new(value.year, value.month, day)
        html += render_day_cell(current_date)
      end

      # Next month days
      remaining = 42 - (start_day + end_of_month.day)
      remaining.times do |i|
        next_date = end_of_month + (i + 1)
        html += render_day_cell(next_date, outside_month: true)
      end

      html.html_safe
    end

    def render_day_cell(date, outside_month: false)
      is_today = date == Date.today
      is_selected = selectable && date == value
      is_disabled = disabled_date && disabled_date.call(date)
      has_events = events.any? { |e| e[:date] == date }

      cell_classes = [
        "relative min-h-[80px] p-2 rounded-lg border border-transparent transition-all cursor-pointer",
        outside_month ? "text-gray-300 bg-gray-50" : "text-gray-900 hover:border-blue-300 hover:bg-blue-50",
        is_today ? "ring-2 ring-blue-500" : "",
        is_selected ? "bg-blue-100 border-blue-500" : "",
        is_disabled ? "opacity-50 cursor-not-allowed hover:border-transparent hover:bg-transparent" : ""
      ].compact.join(" ")

      action_attr = selectable && !is_disabled ? ' data-action="click->ant--calendar#selectDate"' : ""

      content_tag(:div, class: cell_classes, data: { date: date.iso8601 }, **parse_action_attr(action_attr)) do
        day_html = content_tag(:div, date.day, class: "text-sm font-medium #{is_today ? 'text-blue-600' : ''}")
        events_html = has_events ? render_event_indicators(date) : ""
        (day_html + events_html).html_safe
      end
    end

    def parse_action_attr(action_attr)
      return {} if action_attr.blank?
      { action: "click->ant--calendar#selectDate" }
    end

    def render_event_indicators(date)
      day_events = events.select { |e| e[:date] == date }

      content_tag(:div, class: "mt-1 space-y-1") do
        html = ""
        day_events.first(3).each do |event|
          html += content_tag(:div, event[:title],
            class: "text-xs px-1 py-0.5 rounded truncate #{event_color_class(event[:color])}")
        end

        if day_events.size > 3
          html += content_tag(:div, "+#{day_events.size - 3} more", class: "text-xs text-gray-500")
        end

        html.html_safe
      end
    end

    def event_color_class(color)
      colors = {
        "blue" => "bg-blue-100 text-blue-700",
        "green" => "bg-green-100 text-green-700",
        "red" => "bg-red-100 text-red-700",
        "yellow" => "bg-yellow-100 text-yellow-700",
        "purple" => "bg-purple-100 text-purple-700"
      }
      colors[color] || "bg-gray-100 text-gray-700"
    end

    def render_month_cell(month_num)
      date = Date.new(value.year, month_num, 1)
      is_current = month_num == value.month

      content_tag(:div,
        class: [
          "p-4 text-center rounded-lg border transition-all cursor-pointer",
          is_current ? "bg-blue-100 border-blue-500 text-blue-700" : "border-gray-200 hover:border-blue-300 hover:bg-blue-50"
        ].join(" "),
        data: { action: "click->ant--calendar#selectMonth", month: month_num }
      ) do
        date.strftime("%B")
      end
    end
  end
end
