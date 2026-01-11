require "test_helper"

class Ant::CardComponentTest < ViewComponent::TestCase
  test "renders card with default props" do
    render_inline(Ant::CardComponent.new) do
      "Card content"
    end

    assert_selector "div.border"
    assert_selector "div.rounded-lg"
    assert_selector "div.bg-white"
    assert_text "Card content"
  end

  test "renders with title" do
    render_inline(Ant::CardComponent.new(title: "Card Title")) do
      "Content"
    end

    assert_selector "div.font-medium", text: "Card Title"
    assert_selector "div.border-b" # Has header border
    assert_text "Content"
  end

  test "renders with extra action" do
    render_inline(Ant::CardComponent.new(
      title: "Title",
      extra: "More"
    )) do
      "Body content"
    end

    assert_text "Title"
    assert_text "More"
    assert_selector "div.text-blue-500", text: "More"
  end

  test "renders with custom HTML options" do
    render_inline(Ant::CardComponent.new(class: "custom-card")) do
      "Content"
    end

    assert_selector "div.custom-card"
    assert_text "Content"
  end

  test "renders without header when no title or extra" do
    render_inline(Ant::CardComponent.new) do
      "Just content"
    end

    assert_no_selector "div.border-b" # No header border
    assert_text "Just content"
  end

  test "renders content in padded area" do
    render_inline(Ant::CardComponent.new(title: "Title")) do
      "Body text"
    end

    assert_selector "div.p-6", text: "Body text"
  end
end
