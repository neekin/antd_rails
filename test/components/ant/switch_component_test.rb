require "test_helper"

class Ant::SwitchComponentTest < ViewComponent::TestCase
  test "renders switch with default props" do
    render_inline(Ant::SwitchComponent.new(name: "test"))

    assert_selector "div[data-controller='ant--switch']"
    assert_selector "input[type='hidden'][name='test']", visible: :all
    assert_selector "button[role='switch']"
    assert_selector "button.bg-\\[rgba\\(0\\,0\\,0\\,0\\.25\\)\\]" # unchecked background
  end

  test "renders checked switch" do
    render_inline(Ant::SwitchComponent.new(name: "test", checked: true))

    assert_selector "input[type='hidden'][value='1']", visible: :all
    assert_selector "button.bg-\\[\\#1677ff\\]" # checked background
    assert_selector "button[aria-checked='true']"
  end

  test "renders disabled switch" do
    render_inline(Ant::SwitchComponent.new(name: "test", disabled: true))

    assert_selector "input[disabled]", visible: :all
    assert_selector "button[disabled]"
    assert_selector "button.opacity-40"
    assert_selector "button.cursor-not-allowed"
  end

  test "renders with checked and unchecked text" do
    render_inline(Ant::SwitchComponent.new(
      name: "test",
      checked_text: "On",
      unchecked_text: "Off"
    ))

    assert_text "Off"

    render_inline(Ant::SwitchComponent.new(
      name: "test2",
      checked: true,
      checked_text: "On",
      unchecked_text: "Off"
    ))

    assert_text "On"
  end

  test "renders loading switch" do
    render_inline(Ant::SwitchComponent.new(name: "test", loading: true))

    assert_selector "button[disabled]"
    assert_selector "svg.animate-spin"
    assert_selector "button.opacity-40"
  end

  test "renders different sizes" do
    render_inline(Ant::SwitchComponent.new(name: "small", size: :small))
    assert_selector "button.h-\\[16px\\]"
    assert_selector "button.min-w-\\[28px\\]"

    render_inline(Ant::SwitchComponent.new(name: "default", size: :default))
    assert_selector "button.h-\\[22px\\]"
    assert_selector "button.min-w-\\[44px\\]"
  end

  test "renders with custom HTML options" do
    render_inline(Ant::SwitchComponent.new(
      name: "test",
      class: "custom-class"
    ))

    assert_selector "div.custom-class"
  end
end
