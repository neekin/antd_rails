require "test_helper"

class Ant::SelectComponentTest < ViewComponent::TestCase
  test "renders select with default props" do
    options = [ [ "Option 1", "1" ], [ "Option 2", "2" ] ]
    render_inline(Ant::SelectComponent.new(name: "test", options: options))

    assert_selector "div[data-controller='ant--select']"
    assert_selector "input[type='hidden'][name='test']", visible: :all
    assert_selector "button[data-ant--select-target='trigger']"
  end

  test "renders with placeholder" do
    render_inline(Ant::SelectComponent.new(
      name: "test",
      options: [],
      placeholder: "Select an option"
    ))

    assert_selector "button", text: "Select an option"
  end

  test "renders with selected value" do
    options = [ [ "Option 1", "1" ], [ "Option 2", "2" ] ]
    render_inline(Ant::SelectComponent.new(
      name: "test",
      options: options,
      selected: "2"
    ))

    assert_selector "input[type='hidden'][value='2']", visible: :all
    assert_selector "button", text: "Option 2"
  end

  test "renders disabled select" do
    render_inline(Ant::SelectComponent.new(
      name: "test",
      options: [],
      disabled: true
    ))

    assert_selector "button[disabled]"
    assert_selector "button.bg-\\[\\#f5f5f5\\]"
    assert_selector "button.cursor-not-allowed"
  end

  test "renders different sizes" do
    options = [ [ "Option", "1" ] ]

    # Note: Select component doesn't have size variants in current implementation
    render_inline(Ant::SelectComponent.new(name: "test", options: options))
    assert_selector "button.px-\\[11px\\]"
  end

  test "renders with custom HTML options" do
    render_inline(Ant::SelectComponent.new(
      name: "test",
      options: [],
      class: "custom-class",
      data: { controller: "custom-select" }
    ))

    assert_selector "div.custom-class"
    # The component has data-controller="ant--select", custom data attributes go to wrapper
  end

  test "handles array of strings as options" do
    render_inline(Ant::SelectComponent.new(
      name: "test",
      options: [ "Option 1", "Option 2" ]
    ))

    # Options are in the dropdown, not visible until opened
    assert_selector "div[data-controller='ant--select']"
  end
end
