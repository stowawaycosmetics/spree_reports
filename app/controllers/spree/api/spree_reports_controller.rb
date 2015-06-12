module Spree
  module Api
    class SpreeReportsController < Spree::Api::BaseController
      before_filter :requires_admin

      def orders_by_period
        @report = SpreeReports::Reports::OrdersByPeriod.new(params)
        render json: @report.data
      end

      def user_accounts
        @report = SpreeReports::Reports::UserAccounts.new(params)
        render json: @report.data
      end

      def sales_tax_by_month
        @report = SpreeReports::Reports::SalesTaxByMonth.new(params)
        render json: @report.data
      end

      def orders_with_products_by_period
        @report = SpreeReports::Reports::OrdersWithProductsByPeriod.new(params)
        render json: @report.data
      end

      def sold_products
        @report = SpreeReports::Reports::SoldProducts.new(params)
        render json: @report.data
      end

      private
        def requires_admin
          return if @current_user_roles.include?(SpreeReports.api_user_role)
          unauthorized and return
        end

    end
  end
end
