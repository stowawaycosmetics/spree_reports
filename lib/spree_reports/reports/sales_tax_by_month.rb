module SpreeReports
  module Reports
    class SalesTaxByMonth < SpreeReports::Reports::Base

      attr_accessor :params, :data, :orders
      attr_accessor :currencies, :currency, :stores, :store, :months, :date_start

      def initialize(params)
        @params = params
        setup_params
        get_data
        build_response
      end

      def setup_params
        @date_start = Date.parse(params[:start]).strftime("%Y-%m-%d")
        @date_end = Date.parse(params[:end]).strftime("%Y-%m-%d")
      end

      def get_data
        @orders = Spree::Order.includes(:ship_address).where("created_at > ?", @date_start).where("created_at < ?", @date_end).where("additional_tax_total > 0")
        @data_tmp = @orders.map { |order| [order.created_at.to_date, order.number, order.ship_address.state.name, order.ship_address.zipcode, order.total, order.additional_tax_total.to_s.to_f]}
      end

      def build_response
        @data = @data_tmp.map do |item|
          {
            date: item[0],
            order_number: item[1],
            state: item[2],
            zip_code: item[3],
            total: item[4],
            sales_tax: item[5]
          }
        end
      end

      def csv_filename
        "sales_tax_by_month.csv"
      end

    end
  end
end
