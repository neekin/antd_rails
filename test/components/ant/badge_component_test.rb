require "test_helper"

class Ant::BadgeComponentTest < ViewComponent::TestCase
  def test_basic_badge
    render_inline(Ant::BadgeComponent.new(count: 5))

    assert_selector "span", text: "5"
  end

  def test_badge_with_children
    render_inline(Ant::BadgeComponent.new(count: 10)) do
      "Notifications"
    end

    assert_text "Notifications"
    assert_selector "span", text: "10"
  end

  def test_badge_with_max_value
    render_inline(Ant::BadgeComponent.new(count: 100, max: 99))

    assert_selector "span", text: "99+"
  end

  def test_badge_dot
    render_inline(Ant::BadgeComponent.new(dot: true)) do
      "Notifications"
    end

    assert_text "Notifications"
    assert_selector "span.w-1\\.5.h-1\\.5"
  end

  def test_badge_show_zero
    render_inline(Ant::BadgeComponent.new(count: 0, show_zero: true))

    assert_selector "span", text: "0"
  end

  def test_badge_hide_zero_by_default
    render_inline(Ant::BadgeComponent.new(count: 0))

    assert_no_selector "span.absolute"
  end

  def test_badge_with_custom_color
    render_inline(Ant::BadgeComponent.new(count: 5, color: :blue))

    assert_selector "span.bg-\\[\\#1677ff\\]"
  end

  def test_badge_status
    render_inline(Ant::BadgeComponent.new(status: :success, text: "Success"))

    assert_text "Success"
    assert_selector "span.bg-\\[\\#52c41a\\]"
  end

  def test_badge_status_processing
    render_inline(Ant::BadgeComponent.new(status: :processing, text: "Processing"))

    assert_text "Processing"
    assert_selector "span.animate-pulse"
  end
end
