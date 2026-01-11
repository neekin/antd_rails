require "test_helper"

class Ant::InputComponentTest < ViewComponent::TestCase
  test "renders input with default props" do
    render_inline(Ant::InputComponent.new(name: "test"))

    assert_selector "input[type='text']"
    assert_selector "input[name='test']"
    assert_selector "input.border-\\[\\#d9d9d9\\]"
    assert_selector "input.px-\\[11px\\]"
  end

  test "renders with placeholder" do
    render_inline(Ant::InputComponent.new(name: "test", placeholder: "Enter text"))

    assert_selector "input[placeholder='Enter text']"
  end

  test "renders with value" do
    render_inline(Ant::InputComponent.new(name: "test", value: "Test Value"))

    assert_selector "input[value='Test Value']"
  end

  test "renders disabled input via HTML options" do
    render_inline(Ant::InputComponent.new(name: "test", disabled: true))

    assert_selector "input[disabled]"
  end

  test "renders different input types" do
    %w[text password email number tel url].each do |type|
      render_inline(Ant::InputComponent.new(name: "test", type: type))
      assert_selector "input[type='#{type}']"
    end
  end

  test "renders with custom HTML options" do
    render_inline(Ant::InputComponent.new(
      name: "test",
      class: "custom-class",
      data: { controller: "input" }
    ))

    assert_selector "input.custom-class"
    assert_selector "input[data-controller='input']"
  end

  test "renders with hover and focus styles" do
    render_inline(Ant::InputComponent.new(name: "test"))

    assert_selector "input.hover\\:border-\\[\\#4096ff\\]"
    assert_selector "input.focus\\:border-\\[\\#4096ff\\]"
  end
end
