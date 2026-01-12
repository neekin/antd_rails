require "test_helper"

class Ant::ImageComponentTest < ViewComponent::TestCase
  test "renders basic image" do
    render_inline(Ant::ImageComponent.new(src: "https://example.com/image.jpg"))

    assert_selector "img[src='https://example.com/image.jpg']"
    assert_selector "img[loading='lazy']"
  end

  test "renders with alt text" do
    render_inline(Ant::ImageComponent.new(src: "image.jpg", alt: "Test image"))

    assert_selector "img[alt='Test image']"
  end

  test "renders with custom width and height" do
    render_inline(Ant::ImageComponent.new(src: "image.jpg", width: 300, height: 200))

    assert_match /width:\s*300px/, rendered_content
    assert_match /height:\s*200px/, rendered_content
    render_inline(Ant::ImageComponent.new(src: "image.jpg", preview: true))

    assert_selector "[data-controller='ant--image']"
    assert_selector "img[data-ant--image-target='image']"
    assert_selector "[data-action*='click->ant--image#preview']"
  end

  test "renders preview icon overlay when preview enabled" do
    render_inline(Ant::ImageComponent.new(src: "image.jpg", preview: true))

    assert_selector "svg" # Preview icon
  end

  test "renders without preview controller when preview disabled" do
    render_inline(Ant::ImageComponent.new(src: "image.jpg", preview: false))

    assert_no_selector "[data-controller='ant--image']"
  end

  test "renders with custom placeholder" do
    render_inline(Ant::ImageComponent.new(
      src: "image.jpg",
      placeholder: "https://example.com/placeholder.jpg"
    ))

    assert_selector "img[data-placeholder='https://example.com/placeholder.jpg']"
  end

  test "renders with custom fallback" do
    render_inline(Ant::ImageComponent.new(
      src: "image.jpg",
      fallback: "https://example.com/fallback.jpg"
    ))

    assert_selector "img[data-fallback='https://example.com/fallback.jpg']"
  end

  test "renders with default placeholder when not provided" do
    render_inline(Ant::ImageComponent.new(src: "image.jpg"))

    assert_selector "img[data-placeholder*='data:image/svg+xml']"
  end

  test "renders with default fallback when not provided" do
    render_inline(Ant::ImageComponent.new(src: "image.jpg"))

    assert_selector "img[data-fallback*='data:image/svg+xml']"
  end

  test "renders with custom HTML class" do
    render_inline(Ant::ImageComponent.new(src: "image.jpg", class: "custom-image"))

    assert_selector ".custom-image"
  end

  test "renders with error handler when preview enabled" do
    render_inline(Ant::ImageComponent.new(src: "image.jpg", preview: true))

    assert_selector "img[data-action*='error->ant--image#handleError']"
  end
end
