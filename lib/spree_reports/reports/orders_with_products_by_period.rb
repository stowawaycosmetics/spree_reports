module SpreeReports
  module Reports
    class OrdersWithProductsByPeriod < SpreeReports::Reports::Base

      attr_accessor :params, :data
      attr_accessor :currencies, :currency, :stores, :store, :group_by_list, :group_by, :states, :state, :months, :date_start

      def initialize(params)
        @params = params
        setup_params
        get_data
        build_response
      end

      def setup_params
        # ?start=xx&end=xx
        @currencies = Spree::Order.select('currency').distinct.map { |c| c.currency }
        @currency = @currencies.include?(params[:currency]) ? params[:currency] : @currencies.first

        @stores = Spree::Store.all.map { |store| [store.name, store.id] }
        @stores << ["all", "all"]
        @store = @stores.map{ |s| s[1].to_s }.include?(params[:store]) ? params[:store] : @stores.first[1]

        @date_start = Date.parse(params[:start]).strftime("%Y-%m-%d")
        @date_end = Date.parse(params[:end]).strftime("%Y-%m-%d")

      end

      def get_data

        @line_items = Spree::LineItem.includes(:order).where("created_at > ?", @date_start).where("created_at < ?", @date_end)

      end

      def build_response
        @data = @line_items.map do  |l|
          {
            date: l.created_at,
            sku: l.variant.sku,
            shipping_price: "",
            discounts: l.promo_total,
            unit_price: l.cost_price,
            revenue: l.cost_price - l.promo_total,
            order: l.order.number
          }

        end
      end

      def to_csv

        CSV.generate(headers: true, col_sep: ";") do |csv|
          ""

        end

      end

      def csv_filename
        ""
      end

    end
  end
end
