class ComponentsController < ApplicationController
  layout "components"

  def show
    @component_name = params[:component]
    # 安全检查：防止渲染任意文件
    valid_components = %w[button tag input select card table tabs modal calendar]
    
    unless valid_components.include?(@component_name)
      raise ActionController::RoutingError.new('Component Not Found')
    end
    
    render @component_name
  end
end