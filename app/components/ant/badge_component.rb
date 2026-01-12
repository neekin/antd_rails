module Ant
  class BadgeComponent < ViewComponent::Base
    def initialize(count: 0, dot: false, show_zero: false, max: 99,
                   color: nil, status: nil, text: nil, offset: nil, **html_options)
      @count = count.to_i
      @dot = dot
      @show_zero = show_zero
      @max = max
      @color = color
      @status = status
      @text = text
      @offset = offset
      @html_options = html_options
    end

    def container_classes
      base = "inline-flex relative"
      [ base, @html_options[:class] ].compact.join(" ")
    end

    def badge_classes
      if @status
        "inline-flex items-center gap-2"
      else
        base = "absolute flex items-center justify-center text-white text-xs font-medium"
        base += " rounded-full"
        base += " #{badge_size_classes}"
        base += " #{badge_position_classes}"
        base += " #{badge_color_classes}"
        base
      end
    end

    def badge_size_classes
      if @dot
        "w-1.5 h-1.5"
      elsif display_count.length <= 2
        "min-w-5 h-5 px-1.5"
      else
        "min-w-6 h-5 px-2"
      end
    end

    def badge_position_classes
      return "" if @status

      if @offset
        "top-0 right-0 transform translate-x-1/2 -translate-y-1/2"
      else
        "top-0 right-0 transform translate-x-1/2 -translate-y-1/2"
      end
    end

    def badge_color_classes
      return "" if @status

      if @color
        case @color.to_sym
        when :blue
          "bg-[#1677ff]"
        when :green
          "bg-[#52c41a]"
        when :red
          "bg-[#ff4d4f]"
        when :yellow
          "bg-[#faad14]"
        when :orange
          "bg-[#fa8c16]"
        when :purple
          "bg-[#722ed1]"
        when :cyan
          "bg-[#13c2c2]"
        when :magenta
          "bg-[#eb2f96]"
        else
          "bg-[#{@color}]"
        end
      else
        "bg-[#ff4d4f]"
      end
    end

    def status_dot_classes
      base = "inline-block w-1.5 h-1.5 rounded-full"

      color = case @status&.to_sym
      when :success
        "bg-[#52c41a]"
      when :processing
        "bg-[#1677ff] animate-pulse"
      when :error
        "bg-[#ff4d4f]"
      when :warning
        "bg-[#faad14]"
      when :default
        "bg-[#d9d9d9]"
      else
        "bg-[#d9d9d9]"
      end

      "#{base} #{color}"
    end

    def display_count
      return "" if @dot || @status
      return "" if @count <= 0 && !@show_zero

      if @count > @max
        "#{@max}+"
      else
        @count.to_s
      end
    end

    def show_badge?
      return true if @status
      return true if @dot
      @count > 0 || @show_zero
    end

    def badge_style
      return nil unless @offset && !@status

      right_offset, top_offset = @offset
      "right: #{right_offset}px; top: #{top_offset}px;"
    end
  end
end
