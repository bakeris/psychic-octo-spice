namespace :eppl do
  desc "Validates Eppl bets every 17 minutes"
  	task :validate_bets => :environment do
  	  eppl_obj = EpplController.new
      eppl_obj.periodically_validate_bet
  	end
end
