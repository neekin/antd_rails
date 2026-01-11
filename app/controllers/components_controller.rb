class ComponentsController < ApplicationController
  layout "components"

  def show
    @component_name = params[:component]
    # 安全检查：防止渲染任意文件
    valid_components = %w[button tag input select card table tabs modal calendar switch radio checkbox table_demo]

    unless valid_components.include?(@component_name)
      raise ActionController::RoutingError.new("Component Not Found")
    end

    render @component_name
  end

  # Table 交互示例
  def table_demo
    @sort_column = params[:sort_column]
    @sort_direction = params[:sort_direction]
    @filter_role = params[:filter_Role]
    @filter_status = params[:filter_Status]

    # 模拟数据
    user_struct = Struct.new(:id, :name, :role, :status, :email)
    @users = [
      user_struct.new(1, "Alice Wang", "Developer", :success, "alice@example.com"),
      user_struct.new(2, "Bob Chen", "Designer", :processing, "bob@example.com"),
      user_struct.new(3, "Carol Liu", "Manager", :success, "carol@example.com"),
      user_struct.new(4, "David Zhang", "Developer", :error, "david@example.com"),
      user_struct.new(5, "Eve Li", "Designer", :success, "eve@example.com"),
      user_struct.new(6, "Frank Wu", "Developer", :processing, "frank@example.com"),
      user_struct.new(7, "Grace Xu", "Manager", :success, "grace@example.com"),
      user_struct.new(8, "Henry Zhou", "Designer", :error, "henry@example.com")
    ]

    # 应用筛选
    @users = @users.select { |u| u.role == @filter_role } if @filter_role.present?
    @users = @users.select { |u| u.status.to_s == @filter_status } if @filter_status.present?

    # 应用排序
    if @sort_column.present? && @sort_direction != "none"
      @users = @users.sort_by do |user|
        value = user.send(@sort_column.downcase.to_sym)
        value.is_a?(Symbol) ? value.to_s : value
      end
      @users.reverse! if @sort_direction == "descend"
    end

    render "table_demo"
  end
end
