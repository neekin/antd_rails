require "test_helper"

class Ant::DatePickerComponentTest < ViewComponent::TestCase
  test "renders date picker with default props" do
    render_inline(Ant::DatePickerComponent.new(name: "birthday"))

    assert_selector "div[data-controller='ant--date-picker']"
    assert_selector "input[type='hidden'][name='birthday']", visible: :all
    assert_selector "button[data-ant--date-picker-target='trigger']"
    assert_text "Select date"
  end

  test "renders with value" do
    render_inline(Ant::DatePickerComponent.new(name: "birthday", value: "2026-01-12"))

    assert_selector "input[type='hidden'][value='2026-01-12']", visible: :all
    assert_text "2026-01-12"
  end

  test "renders disabled" do
    render_inline(Ant::DatePickerComponent.new(name: "birthday", disabled: true))

    assert_selector "input[disabled]", visible: :all
    assert_selector "button[disabled]"
    assert_selector "button.cursor-not-allowed"
  end

  test "renders with custom HTML options" do
    render_inline(Ant::DatePickerComponent.new(name: "birthday", class: "custom-date-picker"))

    assert_selector "div.custom-date-picker"
  end
end
