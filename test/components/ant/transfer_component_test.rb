require "test_helper"

class Ant::TransferComponentTest < ViewComponent::TestCase
  test "renders transfer with default props" do
    options = [ [ "User", "u" ], [ "Admin", "a" ], [ "Guest", "g" ] ]
    render_inline(Ant::TransferComponent.new(name: "roles", options: options, selected: [ "a" ]))

    assert_selector "div[data-controller='ant--transfer']"
    # Hidden input for selected
    assert_selector "input[type='hidden'][name='roles[]'][value='a']", visible: :all

    # Left/Right panels with counts
    assert_text "Source (2)"
    assert_text "Target (1)"

    # Right panel contains selected label
    assert_text "Admin"
  end

  test "renders with titles and disabled state" do
    options = [ "A", "B", "C" ]
    render_inline(Ant::TransferComponent.new(name: "items", options: options, selected: [], left_title: "Left", right_title: "Right", disabled: true))

    assert_text "Left (3)"
    assert_text "Right (0)"
    assert_selector "button[disabled]", count: 2
  end

  test "renders with custom HTML options" do
    render_inline(Ant::TransferComponent.new(name: "k", options: [], class: "custom-transfer"))

    assert_selector "div.custom-transfer"
  end
end
