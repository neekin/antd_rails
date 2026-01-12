module AntHelper
  def ant_button(label = nil, type: :default, **options, &block)
    render Ant::ButtonComponent.new(label: label, type: type, **options), &block
  end

  def ant_card(title: nil, extra: nil, **options, &block)
    render Ant::CardComponent.new(title: title, extra: extra, **options), &block
  end

  def ant_tag(label = nil, color: :default, **options, &block)
    render Ant::TagComponent.new(label: label, color: color, **options), &block
  end

  def ant_input(name: nil, value: nil, type: :text, placeholder: nil, **options)
    render Ant::InputComponent.new(name: name, value: value, type: type, placeholder: placeholder, **options)
  end

  def ant_select(name: nil, options: [], selected: nil, disabled: false, placeholder: "Please select",
                 multiple: false, searchable: false, loading: false, max_tag_count: nil, **html_options)
    render Ant::SelectComponent.new(
      name: name,
      options: options,
      selected: selected,
      disabled: disabled,
      placeholder: placeholder,
      multiple: multiple,
      searchable: searchable,
      loading: loading,
      max_tag_count: max_tag_count,
      **html_options
    )
  end

  def ant_tabs(default: nil, **options, &block)
    render Ant::TabsComponent.new(default: default, **options), &block
  end

  def ant_table(collection, sticky_header: false, paginate: nil, loading: false,
                empty_text: "No Data", row_selection: nil, **options, &block)
    component = Ant::TableComponent.new(
      collection,
      sticky_header: sticky_header,
      paginate: paginate,
      loading: loading,
      empty_text: empty_text,
      row_selection: row_selection,
      **options
    )
    block.call(component) if block_given?
    render component
  end

  def ant_pagination(current_page: 1, total_count: 0, per_page: 10, **options)
    render Ant::PaginationComponent.new(current_page: current_page, total_count: total_count, per_page: per_page, **options)
  end

  def ant_modal(title: nil, id: nil, open: false, **options, &block)
    render Ant::ModalComponent.new(title: title, id: id, open: open, **options), &block
  end

  def ant_calendar(value: nil, mode: "month", fullscreen: true, selectable: false,
                  disabled_date: nil, events: [], show_header: true,
                  show_today_button: true, locale: "en", **options)
    render Ant::CalendarComponent.new(
      value: value,
      mode: mode,
      fullscreen: fullscreen,
      selectable: selectable,
      disabled_date: disabled_date,
      events: events,
      show_header: show_header,
      show_today_button: show_today_button,
      locale: locale,
      **options
    )
  end

  def ant_switch(name: nil, checked: false, disabled: false, loading: false,
                 size: :default, checked_text: nil, unchecked_text: nil, **options)
    render Ant::SwitchComponent.new(
      name: name,
      checked: checked,
      disabled: disabled,
      loading: loading,
      size: size,
      checked_text: checked_text,
      unchecked_text: unchecked_text,
      **options
    )
  end

  def ant_radio(name:, value:, checked: false, disabled: false, size: :default, **options, &block)
    render Ant::RadioComponent.new(
      name: name,
      value: value,
      checked: checked,
      disabled: disabled,
      size: size,
      **options
    ), &block
  end

  def ant_checkbox(name:, value: "1", checked: false, disabled: false, indeterminate: false,
                   size: :default, **options, &block)
    render Ant::CheckboxComponent.new(
      name: name,
      value: value,
      checked: checked,
      disabled: disabled,
      indeterminate: indeterminate,
      size: size,
      **options
    ), &block
  end

  def ant_date_picker(name: nil, value: nil, placeholder: "Select date", disabled: false, **html_options)
    render Ant::DatePickerComponent.new(name: name, value: value, placeholder: placeholder, disabled: disabled, **html_options)
  end

  def ant_transfer(name: nil, options: [], selected: [], left_title: "Source", right_title: "Target", disabled: false, **html_options)
    render Ant::TransferComponent.new(
      name: name,
      options: options,
      selected: selected,
      left_title: left_title,
      right_title: right_title,
      disabled: disabled,
      **html_options
    )
  end

  def ant_upload(name:, mode: :file, accept: nil, multiple: false, max_size: nil,
                 disabled: false, list_type: :text, max_count: nil, **html_options, &block)
    render Ant::UploadComponent.new(
      name: name,
      mode: mode,
      accept: accept,
      multiple: multiple,
      max_size: max_size,
      disabled: disabled,
      list_type: list_type,
      max_count: max_count,
      **html_options
    ), &block
  end

  def ant_image(src:, alt: "", width: nil, height: nil, preview: false,
                fallback: nil, placeholder: nil, **html_options)
    render Ant::ImageComponent.new(
      src: src,
      alt: alt,
      width: width,
      height: height,
      preview: preview,
      fallback: fallback,
      placeholder: placeholder,
      **html_options
    )
  end

  def ant_empty(description: "No Data", image: :default, **html_options, &block)
    render Ant::EmptyComponent.new(
      description: description,
      image: image,
      **html_options
    ), &block
  end

  def ant_badge(count: 0, dot: false, show_zero: false, max: 99,
                color: nil, status: nil, text: nil, offset: nil, **html_options, &block)
    render Ant::BadgeComponent.new(
      count: count,
      dot: dot,
      show_zero: show_zero,
      max: max,
      color: color,
      status: status,
      text: text,
      offset: offset,
      **html_options
    ), &block
  end

  # Form builder for Ant Design components
  def ant_form_for(record, options = {}, &block)
    options[:builder] = AntFormBuilder
    options[:html] ||= {}
    options[:html][:class] = [ options[:html][:class], "space-y-4" ].compact.join(" ")

    form_for(record, options, &block)
  end

  def ant_form_with(**options, &block)
    options[:builder] = AntFormBuilder
    options[:html] ||= {}
    options[:html][:class] = [ options[:html][:class], "space-y-4" ].compact.join(" ")

    form_with(**options, &block)
  end

  # Notification helper - renders notification component
  def ant_notification(message:, description: nil, type: "info", duration: 4500,
                       placement: "topRight", show_icon: true, closable: true, **options)
    render Ant::NotificationComponent.new(
      message: message,
      description: description,
      type: type,
      duration: duration,
      placement: placement,
      show_icon: show_icon,
      closable: closable,
      **options
    )
  end

  # Message helper - renders message component
  def ant_message(message:, type: "info", duration: 3000, show_icon: true, **options)
    render Ant::MessageComponent.new(
      message: message,
      type: type,
      duration: duration,
      show_icon: show_icon,
      **options
    )
  end
end
