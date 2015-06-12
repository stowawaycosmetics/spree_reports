Spree::Admin::ReportsController.class_eval do
  before_filter :spree_reports_setup, only: [:index]

  def orders_by_period
    @report = SpreeReports::Reports::OrdersByPeriod.new(params)
    respond_to do |format|
      format.html
      format.csv {
        return head :unauthorized unless SpreeReports.csv_export
        send_data @report.to_csv, filename: @report.csv_filename, type: "text/csv"
      }
    end
  end

  def orders_with_products_by_period
    @report = SpreeReports::Reports::OrdersWithProductsByPeriod.new(params)
    respond_to do |format|
      format.html
      format.csv {
        return head :unauthorized unless SpreeReports.csv_export
        send_data @report.to_csv, filename: @report.csv_filename, type: "text/csv"
      }
    end
  end

  def sales_tax_by_month
    @report = SpreeReports::Reports::SalesTaxByMonth.new(params)
    respond_to do |format|
      format.html
      format.csv {
        return head :unauthorized unless SpreeReports.csv_export
        send_data @report.to_csv, filename: @report.csv_filename, type: "text/csv"
      }
    end
  end

  def user_accounts
    @report = SpreeReports::Reports::UserAccounts.new(params)
    respond_to do |format|
      format.html
      format.csv {
        return head :unauthorized unless SpreeReports.csv_export
        send_data @report.to_csv, filename: @report.csv_filename, type: "text/csv"
      }
    end
  end

  def sold_products
    @report = SpreeReports::Reports::SoldProducts.new(params)
    respond_to do |format|
      format.html
      format.csv {
        return head :unauthorized unless SpreeReports.csv_export
        send_data @report.to_csv, filename: @report.csv_filename, type: "text/csv"
      }
    end
  end

  protected

  def spree_reports_setup
    SpreeReports.reports.each do |report|
      Spree::Admin::ReportsController.add_available_report! report
    end
  end

end
