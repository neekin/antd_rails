require "test_helper"

class Ant::TagComponentTest < ViewComponent::TestCase
  test "renders tag with default props" do
    render_inline(Ant::TagComponent.new) do
      "Default"
    end

    assert_selector "span.inline-flex", text: "Default"
    assert_selector "span.bg-\\[\\#f5f5f5\\]" # default color
    assert_selector "span.border-\\[\\#d9d9d9\\]"
  end

  test "renders colored tags" do
    colors = [ :success, :processing, :error, :warning, :default ]

    colors.each do |color|
      render_inline(Ant::TagComponent.new(color: color)) do
        "Tag"
      end
      assert_selector "span.inline-flex"
    end
  end

  test "renders success tag" do
    render_inline(Ant::TagComponent.new(color: :success)) do
      "Success"
    end

    assert_selector "span.bg-\\[\\#f6ffed\\]"
    assert_selector "span.text-\\[\\#52c41a\\]"
    assert_selector "span.border-\\[\\#b7eb8f\\]"
  end

  test "renders processing tag" do
    render_inline(Ant::TagComponent.new(color: :processing)) do
      "Processing"
    end

    assert_selector "span.bg-\\[\\#e6f7ff\\]"
    assert_selector "span.text-\\[\\#1677ff\\]"
    assert_selector "span.border-\\[\\#91d5ff\\]"
  end

  test "renders error tag" do
    render_inline(Ant::TagComponent.new(color: :error)) do
      "Error"
    end

    assert_selector "span.bg-\\[\\#fff2f0\\]"
    assert_selector "span.text-\\[\\#ff4d4f\\]"
    assert_selector "span.border-\\[\\#ffccc7\\]"
  end

  test "renders with label parameter" do
    render_inline(Ant::TagComponent.new(label: "Label Tag", color: :warning))

    assert_selector "span", text: "Label Tag"
    assert_selector "span.bg-\\[\\#fffbe6\\]"
  end

  test "renders with custom HTML options" do
    render_inline(Ant::TagComponent.new(class: "custom-class")) do
      "Custom"
    end

    assert_selector "span.custom-class"
    assert_text "Custom"
  end
end
