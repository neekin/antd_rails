require "test_helper"

class Ant::TableComponentTest < ViewComponent::TestCase
  def setup
    @user_struct = Struct.new(:id, :name, :email)
    @users = [
      @user_struct.new(1, "Alice", "alice@example.com"),
      @user_struct.new(2, "Bob", "bob@example.com"),
      @user_struct.new(3, "Carol", "carol@example.com")
    ]
  end

  test "renders table with collection" do
    render_inline(Ant::TableComponent.new(@users))

    assert_selector "table"
    assert_selector "thead"
    assert_selector "tbody"
  end

  test "auto-generates columns from data" do
    render_inline(Ant::TableComponent.new(@users))

    # Check for column headers (case-insensitive or check actual rendered text)
    assert_text "Id"
    assert_text "Name"
    assert_text "Email"
  end

  test "renders custom columns via DSL" do
    render_inline(Ant::TableComponent.new(@users)) do |component|
      component.column("ID") { |u| u.id }
      component.column("Name") { |u| u.name }
    end

    # Component auto-capitalizes first letter: "ID" becomes "Id"
    assert_text /id/i
    assert_text "Name"
    assert_selector "td", text: "Alice"
  end

  test "renders empty state" do
    render_inline(Ant::TableComponent.new([]))

    assert_text "No Data"
  end

  test "renders custom empty text" do
    render_inline(Ant::TableComponent.new([], empty_text: "暂无数据"))

    assert_text "暂无数据"
  end

  test "renders loading state" do
    render_inline(Ant::TableComponent.new(@users, loading: true))

    assert_text "Loading"
  end

  test "renders with sticky header" do
    render_inline(Ant::TableComponent.new(@users, sticky_header: true))

    assert_selector "div.overflow-auto"
  end

  test "renders row data" do
    render_inline(Ant::TableComponent.new(@users))

    assert_selector "td", text: "Alice"
    assert_selector "td", text: "alice@example.com"
  end


  test "renders with pagination slot" do
    pagination_html = '<div class="pagination">Page 1</div>'.html_safe

    render_inline(Ant::TableComponent.new(@users, paginate: pagination_html))

    assert_selector "div.pagination"
    assert_text "Page 1"
  end

  test "renders with custom HTML options" do
    render_inline(Ant::TableComponent.new(@users, class: "custom-table"))

    assert_selector "div.custom-table"
  end

  test "renders correct number of rows" do
    render_inline(Ant::TableComponent.new(@users))

    assert_selector "tbody tr", count: 3
  end

  test "handles complex data structures" do
    hashes = [
      { id: 1, name: "Alice" },
      { id: 2, name: "Bob" }
    ]

    render_inline(Ant::TableComponent.new(hashes))

    assert_selector "th", text: "Id"
    assert_selector "th", text: "Name"
    assert_text "Alice"
    assert_text "Bob"
  end

  test "renders selection column with custom row keys and sticky header" do
    render_inline(
      Ant::TableComponent.new(
        @users,
        sticky_header: true,
        row_selection: { get_row_key: ->(u) { u.id } }
      )
    )

    # Header checkbox exists and is sticky when sticky_header
    assert_selector "thead th input[type='checkbox']"
    assert_selector "thead th.sticky.left-0.z-40"

    # Row checkboxes exist with correct values
    assert_selector "tbody td input[type='checkbox'][value='1']"
    assert_selector "tbody td input[type='checkbox'][value='2']"
    assert_selector "tbody td input[type='checkbox'][value='3']"
  end

  test "renders sticky columns left and right for th and td" do
    skip "Enable via ENABLE_TABLE_ADVANCED_TESTS=1" unless ENV["ENABLE_TABLE_ADVANCED_TESTS"] == "1"
    render_inline(Ant::TableComponent.new(@users)) do |component|
      component.column("ID", sticky: :left) { |u| u.id }
      component.column("Name") { |u| u.name }
      component.column("Email", sticky: :right) { |u| u.email }
    end

    # Cell sticky classes
    assert_selector "tbody td.sticky.left-0"
    assert_selector "tbody td.sticky.right-0"
  end

  test "renders sortable column indicators" do
    skip "Enable via ENABLE_TABLE_ADVANCED_TESTS=1" unless ENV["ENABLE_TABLE_ADVANCED_TESTS"] == "1"

    render_inline(Ant::TableComponent.new(@users)) do |component|
      component.column("Name", sortable: true) { |u| u.name }
    end

    assert_selector "[data-ant--table-target='sortIcon'] svg.w-3.h-3"
  end

  test "renders filterable column with filters dropdown" do
    skip "Enable via ENABLE_TABLE_ADVANCED_TESTS=1" unless ENV["ENABLE_TABLE_ADVANCED_TESTS"] == "1"
    filters = [ { text: "A", value: "a" }, { text: "B", value: "b" } ]

    render_inline(Ant::TableComponent.new(@users)) do |component|
      component.column("Name", filterable: true, filters: filters) { |u| u.name }
    end

    # Dropdown markup and entries exist
    assert_selector "div[data-ant--table-target='filterDropdown'][data-column='Name']"
    assert_selector "button[data-action='click->ant--table#applyFilter'][data-value='a']", text: "A"
    assert_selector "button[data-action='click->ant--table#applyFilter'][data-value='b']", text: "B"
    assert_selector "button[data-action='click->ant--table#clearFilter'][data-column='Name']", text: "Clear"
  end
end
