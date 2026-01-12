# frozen_string_literal: true

require "test_helper"

module Ant
  class NotificationComponentTest < ViewComponent::TestCase
    def test_renders_basic_notification
      render_inline(Ant::NotificationComponent.new(
        message: "Test Message",
        description: "Test Description"
      ))

      assert_selector ".ant-notification-notice"
      assert_selector ".ant-notification-notice-message", text: "Test Message"
      assert_selector ".ant-notification-notice-description", text: "Test Description"
    end

    def test_renders_notification_types
      %w[success info warning error].each do |type|
        render_inline(Ant::NotificationComponent.new(
          message: "Test",
          type: type
        ))

        assert_selector ".ant-notification-notice-#{type}"
      end
    end

    def test_renders_notification_with_icon
      render_inline(Ant::NotificationComponent.new(
        message: "Test",
        show_icon: true
      ))

      assert_selector ".ant-notification-notice-icon"
    end

    def test_renders_notification_without_icon
      render_inline(Ant::NotificationComponent.new(
        message: "Test",
        show_icon: false
      ))

      assert_no_selector ".ant-notification-notice-icon"
    end

    def test_renders_notification_with_close_button
      render_inline(Ant::NotificationComponent.new(
        message: "Test",
        closable: true
      ))

      assert_selector ".ant-notification-notice-close"
    end

    def test_renders_notification_without_close_button
      render_inline(Ant::NotificationComponent.new(
        message: "Test",
        closable: false
      ))

      assert_no_selector ".ant-notification-notice-close"
    end

    def test_notification_data_attributes
      render_inline(Ant::NotificationComponent.new(
        message: "Test",
        duration: 5000,
        placement: "topLeft"
      ))

      assert_selector "[data-controller='ant--notification']"
      assert_selector "[data-ant--notification-duration-value='5000']"
      assert_selector "[data-ant--notification-placement-value='topLeft']"
    end
  end
end
