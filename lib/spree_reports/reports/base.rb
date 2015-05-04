module SpreeReports
  module Reports
    class Base
      
      def excluded_user_ids
        users = []

        if SpreeReports.excluded_roles && SpreeReports.excluded_roles.any?
          users += Spree::User.joins(:spree_roles).where("spree_roles.name": SpreeReports.excluded_roles).pluck(:id)
        end

        if SpreeReports.excluded_users && SpreeReports.excluded_users.any?
          users += Spree::User.where(email: SpreeReports.excluded_users).pluck(:id)
        end
        
        users.uniq
      end
      
    end
  end
end




