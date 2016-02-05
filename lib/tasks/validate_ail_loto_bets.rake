namespace :ail_loto do
  desc "Validates Ail Loto bets every 16 minutes"
  	task :validate_ail_loto_bets => :environment do
  	  loto_obj = AilLotoController.new
      loto_obj.validate_payment_notifications
  	end
end
