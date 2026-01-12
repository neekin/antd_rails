require "test_helper"

class Ant::EmptyComponentTest < ViewComponent::TestCase
  test "renders with default props" do
    render_inline(Ant::EmptyComponent.new)

    assert_selector "svg" # Default empty image
    assert_text "No Data"
  end

  test "renders with custom description" do
    render_inline(Ant::EmptyComponent.new(description: "No items found"))

    assert_text "No items found"
  end

  test "renders without description when blank" do
    render_inline(Ant::EmptyComponent.new(description: ""))

    assert_no_selector "p"
  end

  test "renders with default image" do
    render_inline(Ant::EmptyComponent.new(image: :default))

    assert_selector "svg"
    assert_selector "ellipse[fill='#F5F5F7']" # Part of default SVG
  end

  test "renders with simple image" do
    render_inline(Ant::EmptyComponent.new(image: :simple))

    assert_selector "svg"
    assert_selector "ellipse[fill='#f5f5f5']" # Part of simple SVG
  end

  test "renders with custom image URL" do
    render_inline(Ant::EmptyComponent.new(image: "https://example.com/empty.png"))

    assert_selector "img[src='https://example.com/empty.png']"
    assert_selector "img[alt='Empty']"
  end

  test "renders with action button in content block" do
    render_inline(Ant::EmptyComponent.new(description: "No data")) do
      "<button>Create New</button>".html_safe
    end

    assert_selector "button", text: "Create New"
  end

  test "renders with custom HTML class" do
    render_inline(Ant::EmptyComponent.new(class: "custom-empty"))

    assert_selector ".custom-empty"
  end

  test "applies correct container classes" do
    render_inline(Ant::EmptyComponent.new)

    assert_selector ".flex.flex-col.items-center.justify-center"
  end

  test "renders content block when provided" do
    render_inline(Ant::EmptyComponent.new) do
      "<div class='actions'>Actions here</div>".html_safe
    end

    assert_selector ".actions", text: "Actions here"
  end
end
