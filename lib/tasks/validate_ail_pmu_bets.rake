namespace :ail_pmu do
  desc "Validates Ail PMU bets every 16 minutes"
  	task :validate_ail_pmu_bets => :environment do
  	  pmu_obj = AilPmuController.new
      pmu_obj.validate_payment_notifications
  	end
end
