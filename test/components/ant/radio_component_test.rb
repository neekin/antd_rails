require "test_helper"

class Ant::RadioComponentTest < ViewComponent::TestCase
  test "renders radio with default props" do
    render_inline(Ant::RadioComponent.new(name: "test", value: "option1")) do
      "Option 1"
    end

    assert_selector "label[data-controller='ant--radio']"
    assert_selector "input[type='radio']"
    assert_selector "input[name='test']"
    assert_selector "input[value='option1']"
    assert_text "Option 1"
  end

  test "renders checked radio" do
    render_inline(Ant::RadioComponent.new(
      name: "test",
      value: "option1",
      checked: true
    )) do
      "Option 1"
    end

    assert_selector "input[checked]"
  end

  test "renders disabled radio" do
    render_inline(Ant::RadioComponent.new(
      name: "test",
      value: "option1",
      disabled: true
    )) do
      "Option 1"
    end

    assert_selector "input[disabled]"
    assert_selector "label.opacity-50"
    assert_selector "label.cursor-not-allowed"
  end

  test "renders different sizes" do
    render_inline(Ant::RadioComponent.new(
      name: "test",
      value: "option1",
      size: :small
    )) do
      "Small"
    end
    assert_selector "span.w-4.h-4"

    render_inline(Ant::RadioComponent.new(
      name: "test",
      value: "option1",
      size: :default
    )) do
      "Default"
    end
    assert_selector "span.w-4.h-4" # Both sizes are w-4 h-4 according to component code
  end

  test "renders with custom HTML options" do
    render_inline(Ant::RadioComponent.new(
      name: "test",
      value: "option1",
      class: "custom-class"
    )) do
      "Option 1"
    end

    assert_selector "label.custom-class"
  end
end
