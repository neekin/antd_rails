require "test_helper"

class AntFormBuilderTest < ActionView::TestCase
  setup do
    @user = Struct.new(:name, :email, :role, :birthday, :active, :persisted?, keyword_init: true).new(
      name: "John Doe",
      email: "john@example.com",
      role: "admin",
      birthday: Date.new(1990, 1, 1),
      active: true,
      persisted?: true
    )

    # Mock errors
    def @user.errors
      @errors ||= ActiveModel::Errors.new(self)
    end

    def @user.model_name
      ActiveModel::Name.new(self.class, nil, "User")
    end
  end

  test "renders form with ant components" do
    output = ant_form_for(@user, url: "/users/1") do |f|
      f.input(:name)
    end

    assert_match /ant-input/, output
    assert_match /user\[name\]/, output
    assert_match /John Doe/, output
  end

  test "input field with errors shows error class and message" do
    @user.errors.add(:email, "can't be blank")

    output = ant_form_for(@user, url: "/users/1") do |f|
      f.input(:email)
    end

    assert_match /border-red-500/, output
    assert_match /can't be blank/, output
  end

  test "select field renders with selected value" do
    output = ant_form_for(@user, url: "/users/1") do |f|
      f.select(:role, [ [ "Admin", "admin" ], [ "User", "user" ] ])
    end

    assert_match /ant-select/, output
    assert_match /user\[role\]/, output
  end

  test "date_picker field renders with value" do
    output = ant_form_for(@user, url: "/users/1") do |f|
      f.date_picker(:birthday)
    end

    assert_match /ant-date-picker/, output
    assert_match /user\[birthday\]/, output
    assert_match /1990-01-01/, output
  end

  test "checkbox field renders with checked state" do
    output = ant_form_for(@user, url: "/users/1") do |f|
      f.checkbox(:active, label: "Active")
    end

    assert_match /ant-checkbox/, output
    assert_match /user\[active\]/, output
  end

  test "submit button renders with default label" do
    output = ant_form_for(@user, url: "/users/1") do |f|
      f.submit
    end

    assert_match /ant-button/, output
    assert_match /type="submit"/, output
  end

  test "submit button renders with custom label" do
    output = ant_form_for(@user, url: "/users/1") do |f|
      f.submit("Save Changes")
    end

    assert_match /Save Changes/, output
  end

  test "transfer field renders with selected values" do
    def @user.permissions
      [ "view", "edit" ]
    end

    output = ant_form_for(@user, url: "/users/1") do |f|
      f.transfer(:permissions, options: [ [ "View", "view" ], [ "Edit", "edit" ], [ "Delete", "delete" ] ])
    end

    assert_match /ant-transfer/, output
    assert_match /user\[permissions\]/, output
  end
end
