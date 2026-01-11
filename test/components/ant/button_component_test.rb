require "test_helper"

class Ant::ButtonComponentTest < ViewComponent::TestCase
  test "renders button with default props" do
    render_inline(Ant::ButtonComponent.new) do
      "Click me"
    end

    assert_selector "button", text: "Click me"
    assert_selector "button.inline-flex"
    assert_selector "button.bg-white" # default type
    assert_selector "button.border-\\[\\#d9d9d9\\]"
  end

  test "renders primary button" do
    render_inline(Ant::ButtonComponent.new(type: :primary)) do
      "Primary"
    end

    assert_selector "button.bg-\\[\\#1677ff\\]"
    assert_selector "button.text-white"
    assert_selector "button.border-\\[\\#1677ff\\]"
  end

  test "renders with label parameter" do
    render_inline(Ant::ButtonComponent.new(label: "Labeled Button"))

    assert_selector "button", text: "Labeled Button"
    assert_selector "button span", text: "Labeled Button"
  end

  test "renders with custom HTML options" do
    render_inline(Ant::ButtonComponent.new(data: { action: "click" }, class: "custom-class")) do
      "Custom"
    end

    assert_selector "button[data-action='click']"
    assert_selector "button.custom-class"
  end

  test "renders with disabled attribute via HTML options" do
    render_inline(Ant::ButtonComponent.new(disabled: true)) do
      "Disabled"
    end

    assert_selector "button[disabled]"
  end
end
