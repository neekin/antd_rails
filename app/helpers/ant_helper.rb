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

  def ant_calendar(date: Date.today, fullscreen: true, **options)
    render Ant::CalendarComponent.new(date: date, fullscreen: fullscreen, **options)
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
end
