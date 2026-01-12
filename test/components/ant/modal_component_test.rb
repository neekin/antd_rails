require "test_helper"

class Ant::ModalComponentTest < ViewComponent::TestCase
  test "renders modal with default props" do
    render_inline(Ant::ModalComponent.new(title: "Modal Title")) do
      "Modal content"
    end

    assert_selector "div[data-controller='ant--modal']"
    assert_selector "div.hidden" # initially hidden
    assert_text "Modal Title"
    assert_text "Modal content"
  end

  test "renders modal structure" do
    render_inline(Ant::ModalComponent.new(title: "Test")) do
      "Content"
    end

    # Backdrop (check for fixed positioning and background)
    assert_selector "div.fixed.inset-0", minimum: 1

    # Modal content
    assert_selector "div.bg-white.rounded-lg"

    # Close button
    assert_selector "button[data-action*='close']"
  end

  test "renders with custom width" do
    render_inline(Ant::ModalComponent.new(title: "Test", width: "800px")) do
      "Content"
    end

    # Width should be applied as inline style
    assert_selector "div.bg-white[style*='800px']"
  end

  test "renders open modal when open is true" do
    render_inline(Ant::ModalComponent.new(title: "Open Modal", open: true)) do
      "Content"
    end

    # Root container should not have 'hidden' and should mark open value true
    assert_selector "div[data-controller='ant--modal'][data-ant--modal-open-value='true']"
    assert_no_selector "div.hidden[data-controller='ant--modal']"

    # Backdrop has closeByBackdrop action wiring
    assert_selector "div[data-ant--modal-target='backdrop'][data-action='click->ant--modal#closeByBackdrop']"
  end

  test "renders footer slot" do
    render_inline(Ant::ModalComponent.new(title: "Test")) do |component|
      component.with_footer do
        "<button>Cancel</button><button>OK</button>".html_safe
      end
      "Content"
    end

    assert_selector "button", text: "Cancel"
    assert_selector "button", text: "OK"
  end

  test "renders with custom HTML options" do
    render_inline(Ant::ModalComponent.new(
      title: "Test",
      id: "custom-modal"
    )) do
      "Content"
    end

    assert_selector "div[id='custom-modal']"
  end

  test "modal has correct z-index" do
    render_inline(Ant::ModalComponent.new(title: "Test")) do
      "Content"
    end

    assert_selector "div.z-50"
  end
end
