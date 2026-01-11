module Ant
  class PaginationComponent < ViewComponent::Base
    def initialize(current_page: 1, total_count: 0, per_page: 10, param_name: :page, per_page_param_name: :per_page, show_size_changer: true, **html_options)
      @current_page = current_page.to_i
      @total_count = total_count.to_i
      @per_page = per_page.to_i
      @param_name = param_name
      @per_page_param_name = per_page_param_name
      @show_size_changer = show_size_changer
      @html_options = html_options
      
      @total_pages = (@total_count.to_f / @per_page).ceil
      @total_pages = 1 if @total_pages < 1
    end

    def render?
      @total_count > 0
    end

    private

    def page_link(page)
      helpers.url_for(
        helpers.request.query_parameters.merge(@param_name => page, @per_page_param_name => @per_page)
      )
    end
    
    # 页容量切换链接（用于 Select 选项）
    # 当切换 per_page 时，通常重置为第 1 页
    def per_page_link(size)
      helpers.url_for(
        helpers.request.query_parameters.merge(@param_name => 1, @per_page_param_name => size)
      )
    end
  end
end
