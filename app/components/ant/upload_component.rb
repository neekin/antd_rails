module Ant
  class UploadComponent < ViewComponent::Base
    def initialize(name:, mode: :file, accept: nil, multiple: false, max_size: nil,
                   disabled: false, list_type: :text, max_count: nil, **html_options)
      @name = name
      @mode = mode # :file or :image
      @accept = accept || default_accept
      @multiple = multiple
      @max_size = max_size # in MB
      @disabled = disabled
      @list_type = list_type # :text, :picture, :picture-card
      @max_count = max_count
      @html_options = html_options
    end

    def default_accept
      case @mode
      when :image
        "image/*"
      else
        nil
      end
    end

    def upload_button_text
      case @mode
      when :image
        "Upload Image"
      else
        "Upload File"
      end
    end

    def upload_icon
      case @mode
      when :image
        picture_icon
      else
        upload_file_icon
      end
    end

    def picture_icon
      <<~SVG.html_safe
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
        </svg>
      SVG
    end

    def upload_file_icon
      <<~SVG.html_safe
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12" />
        </svg>
      SVG
    end

    def container_classes
      base = "inline-block"
      classes = [ base, @html_options[:class] ]
      classes.compact.join(" ")
    end

    def is_picture_card?
      @list_type == :"picture-card"
    end
  end
end
