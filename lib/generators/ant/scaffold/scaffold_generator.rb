require "rails/generators"
require "rails/generators/rails/scaffold/scaffold_generator"
require "rails/generators/active_record"

module Ant
  module Generators
    class ScaffoldGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers
      include Rails::Generators::Migration

      source_root File.expand_path("templates", __dir__)

      # Required by Rails::Generators::Migration
      def self.next_migration_number(dirname)
        ActiveRecord::Generators::Base.next_migration_number(dirname)
      end

      argument :attributes, type: :array, default: [], banner: "field:type field:type"

      class_option :orm, type: :string, default: "active_record"
      class_option :skip_routes, type: :boolean, default: false
      class_option :skip_migration, type: :boolean, default: false

      def initialize(args, *options)
        super
        parse_attributes!
      end

      def create_model_file
        template "model.rb.tt", File.join("app/models", "#{file_name}.rb")
      end

      def create_migration_file
        return if options[:skip_migration]

        migration_template "migration.rb.tt", File.join("db/migrate", "create_#{table_name}.rb")
      end

      def create_controller_file
        template "controller.rb.tt", File.join("app/controllers", "#{controller_file_name}_controller.rb")
      end

      def create_views
        available_views.each do |view|
          template "views/#{view}.html.erb.tt", File.join("app/views", controller_file_path, "#{view}.html.erb")
        end
      end

      def add_resource_route
        return if options[:skip_routes]

        route "resources :#{plural_table_name}"
      end

      private

      def available_views
        %w[index show new edit _form]
      end

      def controller_file_path
        plural_table_name
      end

      def controller_file_name
        plural_table_name
      end

      def parse_attributes!
        self.attributes = (attributes || []).map do |attr|
          # 如果已经是 GeneratedAttribute 对象，直接使用
          # 否则解析字符串
          if attr.is_a?(Rails::Generators::GeneratedAttribute)
            attr
          else
            Rails::Generators::GeneratedAttribute.parse(attr)
          end
        end
      end

      def singular_name
        file_name
      end

      def human_name
        singular_name.humanize
      end

      def singular_route_name
        singular_table_name
      end

      def index_helper
        plural_table_name
      end

      def controller_class_name
        "#{class_name.pluralize}Controller"
      end

      def route_url
        plural_table_name
      end
    end
  end
end
