module Ant
  class PaginationComponent < ViewComponent::Base
    def initialize(
      current_page: 1,
      total_count: 0,
      per_page: 10,
      param_name: :page,
      per_page_param_name: :per_page,
      show_size_changer: true,
      show_quick_jumper: false,
      show_total: true,
      simple: false,
      size: :default,
      page_size_options: [ 10, 20, 50, 100 ],
      **html_options
    )
      @current_page = current_page.to_i
      @total_count = total_count.to_i
      @per_page = per_page.to_i
      @param_name = param_name
      @per_page_param_name = per_page_param_name
      @show_size_changer = show_size_changer
      @show_quick_jumper = show_quick_jumper
      @show_total = show_total
      @simple = simple
      @size = size
      @page_size_options = page_size_options
      @html_options = html_options

      @total_pages = (@total_count.to_f / @per_page).ceil
      @total_pages = 1 if @total_pages < 1

      # 计算显示范围
      @start_index = (@current_page - 1) * @per_page + 1
      @end_index = [ @current_page * @per_page, @total_count ].min
    end

    def render?
      @total_count > 0
    end

    # 生成显示的页码数组（带省略号）
    def page_items
      return (1..@total_pages).to_a if @total_pages <= 7

      items = []

      # 始终显示第一页
      items << 1

      if @current_page <= 4
        # 当前页在前面
        items += (2..5).to_a
        items << :ellipsis
        items << @total_pages
      elsif @current_page >= @total_pages - 3
        # 当前页在后面
        items << :ellipsis
        items += ((@total_pages - 4)..@total_pages).to_a
      else
        # 当前页在中间
        items << :ellipsis
        items += ((@current_page - 1)..(@current_page + 1)).to_a
        items << :ellipsis
        items << @total_pages
      end

      items
    end

    def size_classes
      case @size
      when :small
        "text-xs"
      else
        "text-sm"
      end
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
