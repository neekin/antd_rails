module Ant
  class TableComponent < ViewComponent::Base
    def initialize(collection, sticky_header: false, paginate: nil, **html_options)
      @collection = collection
      @sticky_header = sticky_header
      @paginate = paginate
      @html_options = html_options
      @columns = []
    end

    def column(header, sticky: nil, **html_options, &block)
      @columns << { 
        header: header, 
        sticky: sticky, 
        html_options: html_options, 
        block: block 
      }
    end

    def before_render
      # 如果用户没有定义任何列，且集合中有数据，则自动生成列
      if @columns.empty? && @collection.present?
        generate_columns_from_sample(@collection.first)
      end
    end

    private

    def generate_columns_from_sample(sample)
      keys = extract_keys(sample)

      keys.each do |key|
        # 自动生成列：
        # 1. Header: 将 key 转为 Human Readable 格式 (e.g., :created_at -> "Created At")
        # 2. Block: 动态获取值
        column(key.to_s.humanize) do |record|
          extract_value(record, key)
        end
      end
    end

    def extract_keys(sample)
      if sample.respond_to?(:attributes) # ActiveRecord
        sample.attributes.keys
      elsif sample.is_a?(Hash)
        sample.keys
      elsif sample.respond_to?(:members) # Struct
        sample.members
      else
        []
      end
    end

    def extract_value(record, key)
      if record.is_a?(Hash)
        record[key] || record[key.to_s] || record[key.to_sym]
      else
        record.public_send(key) rescue nil
      end
    end
  end
end
