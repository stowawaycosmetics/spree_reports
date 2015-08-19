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

        @stores = Spree::Store.pluck(:name, :id)
        @stores << %w(all all)

        @store = @stores.map{ |s| s[1].to_s }.include?(params[:store]) ? params[:store] : @stores.first[1]

        @date_start = Date.parse(params[:start]).strftime('%Y-%m-%d')
        @date_end = Date.parse(params[:end]).strftime('%Y-%m-%d')

      end

      def get_data
        @line_items = Spree::LineItem
                          .includes( :order, :variant, {assembly_variants: :variant})
                          .where(created_at: @date_start..@date_end)
      end

      def build_response
        parts = []

        @data = @line_items.map do  |l|
          parts << l.assembly_variants.map{|av| present_part(l, av.variant)} unless l.assembly_variants.empty?

          {
            date: l.created_at,
            sku: l.variant.sku,
            shipping_price: "",
            discounts: l.promo_total,
            unit_price: l.cost_price,
            revenue: (l.cost_price || 0) - (l.promo_total || 0),
            order: l.order.number,
          }
        end

        @data.concat parts
      end

      def present_part(line_item, item)
        {
            date: item.updated_at,
            sku: item.sku,
            shipping_price: "",
            discounts: line_item.promo_total,
            unit_price: item.cost_price,
            revenue: item.cost_price,
            order: line_item.order.number
        }
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
