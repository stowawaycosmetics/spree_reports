# spree_reports

## Awesome reports for Spree

- dead simple to install
- customizable and easy understandable reports
- data output: Html Table, Chart, CSV, JSON
- grouped data: per day/week/month/year
- spree multi store and multi currency capable
- API: Get all data via JSON in realtime (analytics, dashboards, …)
- simple configuration for your needs

## Installation

Gemfile

    gem 'spree_reports'


`bundle`, restart your server and visit your reports in Spree (/admin/reports). You will see a list of new reports spree_reports added here. Per Spree default only the „sales total“ report exists.

## Report List

- Orders per Period
- Orders per Payment Type (TODO)
- Orders per Value Range (TODO)

## Configuration

The defaults are usually fine, but you can override them in an initializer. At least have a look at the country specific settings like `time_zone` and `week_start`.

`initializers/spree_reports.rb`

    # reports to show
    SpreeReports.reports = [
      :orders_by_period,
      :orders_by_payment_type,
      :orders_by_value_range
    ]
    
    # Time Zone: see http://api.rubyonrails.org/classes/ActiveSupport/TimeZone.html
    SpreeReports.time_zone = "Pacific Time (US & Canada)"
    
    # Week Start Day: :mon or :sun
    SpreeReports.week_start = :mon 
    
    # Reports CSV exportable? true|false
    SpreeReports.csv_export = true
    
    # available months selection in reports
    SpreeReports.report_months = %w{1 3 6 12 24 36 48 all}
    
    # default months for reports
    SpreeReports.default_months = 3
    
    # default API user role to check, when accessing reports via API
    SpreeReports.api_user_role = "admin"
    
    # default date formats
    SpreeReports.date_formats = {
      year: "%Y",
      month: "%m.%Y",
      week: "%W/%Y",
      day: "%m.%d.%y"
    }
    
    # e.g. override the day date_format
    SpreeReports.date_formats[:day] = "%d.%m.%y"


### API

To get data via the API, just copy the Permalink URL displayed at the bottom of each report and change the url from „admin/reports“ to „api/spree_reports“. Now you get the same data you can download on the report as CSV as JSON (you can use the same params here). Just append your spree user API token as url parameter or as request header as described here: https://guides.spreecommerce.com/api/summary.html

**Example**
    
    # Permalink
    http://localhost:3000/admin/reports/orders_by_period?group_by=week
    
    # API URL
    http://localhost:3000/api/spree_reports/orders_by_period?group_by=week&token=YOUR_KEY_HERE

## Requirements

- spree_core 2.2
- ruby 2

**Note about spree 2.2**
_spree\_reports_ depends on the Spree::Store model which is new in 2.3. If you use spree 2.2, have a look at the [multi-domain gem](https://github.com/spree-contrib/spree-multi-domain/tree/2-2-stable) to make it work.