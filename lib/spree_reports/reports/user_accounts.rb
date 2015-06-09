module SpreeReports
  module Reports
    class UserAccounts < SpreeReports::Reports::Base

      attr_accessor :params, :data, :orders
      attr_accessor :currencies, :currency, :stores, :store, :months, :date_start

      def initialize(params)
        @params = params
        setup_params
        get_data
        build_response
      end

      def setup_params
          @users = Spree::User.all.includes(:orders)
      end

      def get_data
        @data_tmp = @users.map { |user| [user.email, user.has_ordered, user.created_at.to_date.to_s]}
      end

      def build_response
        @data = @data_tmp.map do |item|
          {
            email: item[0],
            has_ordered: item[1],
            created: item[2]
          }
        end
      end


      def csv_filename
        "user_accounts.csv"
      end

    end
  end
end
