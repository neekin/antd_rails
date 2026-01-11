require "test_helper"

class Ant::CalendarComponentTest < ViewComponent::TestCase
  test "renders calendar with default props" do
    render_inline(Ant::CalendarComponent.new)

    # Just verify basic structure renders without errors
    assert_selector "div.grid" # calendar grid exists
  end

  test "renders current month and year" do
    render_inline(Ant::CalendarComponent.new)

    current_date = Date.today
    assert_text current_date.strftime("%B %Y")
  end

  test "renders weekday headers" do
    render_inline(Ant::CalendarComponent.new)

    # Check for abbreviated weekday names (Su, Mo, etc.)
    assert_text "Su"
    assert_text "Mo"
  end

  test "renders day cells" do
    render_inline(Ant::CalendarComponent.new)

    # Should render day numbers (at least 1-31)
    assert_text "1"
    assert_text "15"
  end

  test "renders with custom HTML options" do
    render_inline(Ant::CalendarComponent.new(class: "custom-calendar"))

    assert_selector "div.custom-calendar"
  end
end
