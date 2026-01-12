# frozen_string_literal: true

require "test_helper"

module Ant
  class MessageComponentTest < ViewComponent::TestCase
    def test_renders_basic_message
      render_inline(Ant::MessageComponent.new(content: "Test Message"))

      assert_selector ".ant-message-notice"
      assert_selector ".ant-message-content-text", text: "Test Message"
    end

    def test_renders_message_types
      %w[success info warning error loading].each do |type|
        render_inline(Ant::MessageComponent.new(
          content: "Test",
          type: type
        ))

        assert_selector ".ant-message-#{type}"
      end
    end

    def test_renders_message_with_icon
      render_inline(Ant::MessageComponent.new(
        content: "Test",
        show_icon: true
      ))

      assert_selector ".ant-message-icon"
    end

    def test_renders_message_without_icon
      render_inline(Ant::MessageComponent.new(
        content: "Test",
        show_icon: false
      ))

      assert_no_selector ".ant-message-icon"
    end

    def test_message_data_attributes
      render_inline(Ant::MessageComponent.new(
        content: "Test",
        duration: 5000
      ))

      assert_selector "[data-controller='ant--message']"
      assert_selector "[data-ant--message-duration-value='5000']"
    end

    def test_renders_loading_message_with_spinner
      render_inline(Ant::MessageComponent.new(
        content: "Loading...",
        type: "loading"
      ))

      assert_selector ".animate-spin"
    end
  end
end
