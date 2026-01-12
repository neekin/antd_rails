require "test_helper"

class Ant::UploadComponentTest < ViewComponent::TestCase
  test "renders file upload with default props" do
    render_inline(Ant::UploadComponent.new(name: "document"))

    assert_selector "div[data-controller='ant--upload']"
    assert_selector "input[type='file'][name='document']", visible: :all
    assert_text "Upload File"
  end

  test "renders image upload mode" do
    render_inline(Ant::UploadComponent.new(name: "avatar", mode: :image))

    assert_selector "input[type='file'][accept='image/*']", visible: :all
    assert_text "Upload Image"
  end

  test "renders with multiple file selection" do
    render_inline(Ant::UploadComponent.new(name: "files[]", multiple: true))

    assert_selector "input[type='file'][multiple]", visible: :all
  end

  test "renders disabled state" do
    render_inline(Ant::UploadComponent.new(name: "document", disabled: true))

    assert_selector "input[type='file'][disabled]", visible: :all
    assert_selector "button[disabled]"
  end

  test "renders with custom accept attribute" do
    render_inline(Ant::UploadComponent.new(name: "pdf", accept: ".pdf,.doc"))

    assert_selector "input[type='file'][accept='.pdf,.doc']", visible: :all
  end

  test "renders with max size value" do
    render_inline(Ant::UploadComponent.new(name: "document", max_size: 10))

    assert_selector "[data-ant--upload-max-size-value='10']"
  end

  test "renders with max count value" do
    render_inline(Ant::UploadComponent.new(name: "images[]", max_count: 5))

    assert_selector "[data-ant--upload-max-count-value='5']"
  end

  test "renders picture-card list type" do
    render_inline(Ant::UploadComponent.new(name: "gallery[]", mode: :image, list_type: :"picture-card"))

    assert_selector ".w-\\[104px\\].h-\\[104px\\]" # Upload button in picture card style
  end

  test "renders with hint text content" do
    render_inline(Ant::UploadComponent.new(name: "document")) do
      "Support for a single or bulk upload. Strictly prohibit from uploading company data."
    end

    assert_text "Support for a single or bulk upload"
  end

  test "renders with custom HTML class" do
    render_inline(Ant::UploadComponent.new(name: "document", class: "custom-upload"))

    assert_selector ".custom-upload"
  end

  test "sets correct data attributes for mode" do
    render_inline(Ant::UploadComponent.new(name: "document", mode: :file))

    assert_selector "[data-ant--upload-mode-value='file']"
  end

  test "renders file list container" do
    render_inline(Ant::UploadComponent.new(name: "document"))

    assert_selector "[data-ant--upload-target='fileList']"
  end

  test "renders hidden file input" do
    render_inline(Ant::UploadComponent.new(name: "document"))

    assert_selector "input.hidden[data-ant--upload-target='fileInput']", visible: :all
  end
end
