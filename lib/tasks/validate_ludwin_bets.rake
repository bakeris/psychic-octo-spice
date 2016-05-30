namespace :spc do
  desc "Validates SportCash bets every 60 minutes"
  	task :validate_ludwin_bets => :environment do
  	  spc_obj = LudwinApiController.new
      spc_obj.periodically_validate_bet
  	end
end
