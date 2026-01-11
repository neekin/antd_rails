require "test_helper"

class Ant::TabsComponentTest < ViewComponent::TestCase
  test "renders tabs with default props" do
    render_inline(Ant::TabsComponent.new) do |component|
      component.with_item(label: "Tab 1", id: "tab1") { "Content 1" }
      component.with_item(label: "Tab 2", id: "tab2") { "Content 2" }
    end

    assert_selector "div[data-controller='ant--tabs']"
    assert_selector "div[data-ant--tabs-target='tab']", count: 2
    assert_text "Tab 1"
    assert_text "Tab 2"
  end

  test "renders with default active tab" do
    render_inline(Ant::TabsComponent.new(default: "tab2")) do |component|
      component.with_item(label: "Tab 1", id: "tab1") { "Content 1" }
      component.with_item(label: "Tab 2", id: "tab2") { "Content 2" }
    end

    assert_selector "div.text-\\[\\#1677ff\\]", text: "Tab 2"
    assert_selector "div.border-\\[\\#1677ff\\]", text: "Tab 2"
  end

  test "renders with tab content" do
    render_inline(Ant::TabsComponent.new) do |component|
      component.with_item(label: "Tab 1", id: "tab1") do
        "Content 1"
      end
      component.with_item(label: "Tab 2", id: "tab2") do
        "Content 2"
      end
    end

    assert_selector "div[data-ant--tabs-target='panel']", count: 2
    assert_text "Content 1"
    assert_text "Content 2"
  end

  test "renders with custom HTML options" do
    render_inline(Ant::TabsComponent.new(class: "custom-tabs")) do |component|
      component.with_item(label: "Tab 1", id: "tab1") { "Content" }
    end

    assert_selector "div.custom-tabs"
  end
end
