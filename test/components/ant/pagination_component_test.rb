require "test_helper"

class Ant::PaginationComponentTest < ViewComponent::TestCase
  # Note: Pagination component requires request context and routes for URL generation
  # These tests skip actual rendering and just test the component initialization

  test "calculates total pages correctly" do
    component = Ant::PaginationComponent.new(
      current_page: 1,
      total_count: 95,
      per_page: 10
    )

    assert_equal 10, component.instance_variable_get(:@total_pages)
  end

  test "handles empty result set" do
    component = Ant::PaginationComponent.new(
      current_page: 1,
      total_count: 0,
      per_page: 10
    )

    assert_equal 1, component.instance_variable_get(:@total_pages)
    assert_not component.render?
  end

  test "calculates with custom per_page" do
    component = Ant::PaginationComponent.new(
      current_page: 1,
      total_count: 100,
      per_page: 20
    )

    assert_equal 5, component.instance_variable_get(:@total_pages)
  end

  test "stores current page" do
    component = Ant::PaginationComponent.new(
      current_page: 3,
      total_count: 100,
      per_page: 10
    )

    assert_equal 3, component.instance_variable_get(:@current_page)
  end

  test "should render when has data" do
    component = Ant::PaginationComponent.new(
      current_page: 1,
      total_count: 100,
      per_page: 10
    )

    assert component.render?
  end

  test "handles exact page boundary" do
    component = Ant::PaginationComponent.new(
      current_page: 1,
      total_count: 100,
      per_page: 10
    )

    assert_equal 10, component.instance_variable_get(:@total_pages)
  end
end
