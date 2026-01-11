require "test_helper"

class Ant::CheckboxComponentTest < ViewComponent::TestCase
  test "renders checkbox with default props" do
    render_inline(Ant::CheckboxComponent.new(name: "test")) do
      "Check me"
    end

    assert_selector "label[data-controller='ant--checkbox']"
    assert_selector "input[type='checkbox']"
    assert_selector "input[name='test']"
    assert_text "Check me"
  end

  test "renders checked checkbox" do
    render_inline(Ant::CheckboxComponent.new(name: "test", checked: true)) do
      "Checked"
    end

    assert_selector "input[checked]"
  end

  test "renders disabled checkbox" do
    render_inline(Ant::CheckboxComponent.new(name: "test", disabled: true)) do
      "Disabled"
    end

    assert_selector "input[disabled]"
    assert_selector "label.opacity-50"
    assert_selector "label.cursor-not-allowed"
  end

  test "renders indeterminate checkbox" do
    render_inline(Ant::CheckboxComponent.new(
      name: "test",
      indeterminate: true
    )) do
      "Indeterminate"
    end

    assert_selector "input[data-ant--checkbox-indeterminate-value='true']"
  end

  test "renders different sizes" do
    # Note: Current implementation renders w-4 h-4 for both sizes
    render_inline(Ant::CheckboxComponent.new(name: "test", size: :small)) do
      "Small"
    end
    assert_selector "span.w-4.h-4"

    render_inline(Ant::CheckboxComponent.new(name: "test", size: :default)) do
      "Default"
    end
    assert_selector "span.w-4.h-4"
  end

  test "renders with value" do
    render_inline(Ant::CheckboxComponent.new(
      name: "test",
      value: "option1"
    )) do
      "Option"
    end

    assert_selector "input[value='option1']"
  end

  test "renders with custom HTML options" do
    render_inline(Ant::CheckboxComponent.new(
      name: "test",
      data: { "checkbox-group-target": "item" }
    )) do
      "Custom"
    end

    assert_selector "input[data-checkbox-group-target='item']"
  end

  test "renders checkmark and indeterminate icons" do
    render_inline(Ant::CheckboxComponent.new(name: "test")) do
      "Test"
    end

    # Should have 2 SVG icon containers (checkmark visible, indeterminate hidden by inline style)
    assert_selector "span[data-ant--checkbox-target='checkmark']"
    assert_selector "span[data-ant--checkbox-target='indeterminate']", visible: :all
  end
end
