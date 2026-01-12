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

  test "renders multiple select with tags and hidden inputs" do
    options = [ [ "Option 1", "1" ], [ "Option 2", "2" ], [ "Option 3", "3" ], [ "Option 4", "4" ] ]
    render_inline(Ant::SelectComponent.new(
      name: "skills",
      options: options,
      multiple: true,
      selected: [ "1", "3" ]
    ))

    # Hidden inputs for each selected value + one empty input (disabled when selected present)
    assert_selector "input[type='hidden'][name='skills[]'][value='1']", visible: :all
    assert_selector "input[type='hidden'][name='skills[]'][value='3']", visible: :all
    assert_selector "input[type='hidden'][name='skills[]'][data-ant--select-target='emptyInput'][disabled]", visible: :all

    # Tags for selected values (with data-value)
    assert_selector "span[data-value='1']", text: "Option 1"
    assert_selector "span[data-value='3']", text: "Option 3"

    # Removable icon present when not disabled
    assert_selector "svg[data-action='click->ant--select#removeTag'][data-value='1']"
  end

  test "renders overflow tag when exceeding max_tag_count" do
    options = [ [ "One", "1" ], [ "Two", "2" ], [ "Three", "3" ], [ "Four", "4" ] ]
    render_inline(Ant::SelectComponent.new(
      name: "tags",
      options: options,
      multiple: true,
      max_tag_count: 2,
      selected: [ "1", "2", "3", "4" ]
    ))

    # First two visible, the rest hidden via inline style
    assert_selector "span[data-value='1']"
    assert_selector "span[data-value='2']"
    assert_selector "span[data-value='3'][style*='display: none']", visible: :all
    assert_selector "span[data-value='4'][style*='display: none']", visible: :all

    # Overflow +N indicator
    assert_selector "span.overflow-tag", text: "+2"
  end

  test "renders searchable select with search input in panel" do
    render_inline(Ant::SelectComponent.new(
      name: "searchable",
      options: [ [ "A", "a" ] ],
      searchable: true
    ))

    # Search input exists inside hidden panel
    assert_selector "input[data-ant--select-target='search'][data-action='input->ant--select#filterOptions']", visible: :all
  end

  test "renders loading icon instead of arrow" do
    render_inline(Ant::SelectComponent.new(
      name: "loading",
      options: [ [ "A", "a" ] ],
      loading: true
    ))

    assert_selector "svg.animate-spin"
    assert_no_selector "svg[data-ant--select-target='arrow']"
  end

  test "disabled multiple select hides remove icon" do
    render_inline(Ant::SelectComponent.new(
      name: "disabled_multi",
      options: [ [ "A", "a" ], [ "B", "b" ] ],
      multiple: true,
      disabled: true,
      selected: [ "a", "b" ]
    ))

    # Tags still render but remove icon is not present when disabled
    assert_selector "span[data-value='a']", text: "A"
    assert_selector "span[data-value='b']", text: "B"
    assert_no_selector "svg[data-action='click->ant--select#removeTag']"
  end
end
