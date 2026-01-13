module Ant
  class ModalComponent < ViewComponent::Base
    renders_one :footer

    def initialize(
      title: nil,
      id: nil,
      open: false,
      width: nil,
      size: :middle,
      closable: true,
      mask_closable: true,
      centered: false,
      ok_text: "OK",
      cancel_text: "Cancel",
      confirm_loading: false,
      destroy_on_close: false,
      **html_options
    )
      @title = title
      @id = id || "modal-#{SecureRandom.hex(4)}"
      @open = open
      @size = size
      @width = width || default_width
      @closable = closable
      @mask_closable = mask_closable
      @centered = centered
      @ok_text = ok_text
      @cancel_text = cancel_text
      @confirm_loading = confirm_loading
      @destroy_on_close = destroy_on_close
      @html_options = html_options
    end

    private

    def default_width
      case @size
      when :small then "400px"
      when :large then "800px"
      else "520px" # middle
      end
    end
  end
end
