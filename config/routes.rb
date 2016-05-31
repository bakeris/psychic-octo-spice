Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

  devise_for :administrators, controllers: {
    sessions: 'administrators/sessions',
    registrations: 'administrators/registrations',
    passwords: 'administrators/passwords',
    confirmations: 'administrators/confirmations'
  }

  devise_scope :administrator do
    root 'administrators/sessions#new'
  end

  get "/dashboard" => 'home#index', as: :dashboard

  # Administration
  get '/administrators/list' => 'administrators#list', as: :list_administrators

  # Liste des civilités
  get '/6ba041bf35229938ba869a7a9c59f3a0/api/civility/list' => 'civilities#api_list'

  # Liste des genres
  get '/6ba041bf35229938ba869a7a9c59f3a0/api/sex/list' => 'sexes#api_list'

  # Création, gestion et connexion des comptes
  get '/6ba041bf35229938ba869a7a9c59f3a0/api/users/account/create/:civility_id/:sex_id/:pseudo/:firstname/:lastname/:email/:password/:password_confirmation/:msisdn/:birthdate/:creation_mode' => 'users#api_create', :constraints => {:email => /.*/}
  get '/6ba041bf35229938ba869a7a9c59f3a0/api/users/account/enable/:confirmation_token' => 'users#api_enable_account'
  get '/6ba041bf35229938ba869a7a9c59f3a0/api/users/account/reset_password/:parameter' => 'users#api_reset_password'
  get '/6ba041bf35229938ba869a7a9c59f3a0/api/users/account/reset_password_activation/:reset_password_token/:password/:password_confirmation' => 'users#api_reset_password_activation'
  get '/6ba041bf35229938ba869a7a9c59f3a0/api/users/account/update/:id/:civility_id/:sex_id/:pseudo/:firstname/:lastname/:email/:msisdn/:birthdate' => 'users#api_update', :constraints => {:email => /.*/}
  get '/6ba041bf35229938ba869a7a9c59f3a0/api/users/account/email/login/:email/:password' => 'users#api_email_login', :constraints => {:email => /.*/}
  get '/6ba041bf35229938ba869a7a9c59f3a0/api/users/account/msisdn/login/:msisdn/:password' => 'users#api_msisdn_login'
  get '/6basdf4414dffsf8ba869a7a9c59f3a0/api/users/account/logout/:connection_id' => 'users#api_logout', :constraints => {:connection_id => /.*/}

  #---------------------LUDWIN---------------------

  # Prise d'informations relatives aux paris
  get '/6ba041bf35229938ba869a7a9c59f3a0/api/query_bet/:uuid/:bet_code/:bet_modifier/:selector1/:selector2/:repeats/:special_count/:normal_count/:entries' => 'query_bets#query_bet'

  # Return all prematch data
  get '/spc/api/0790f43181/prematch_data/list' => 'ludwin_api#api_list_prematch_data'

  # Return all live data
  get '/spc/api/0790f43182/live_data/list' => 'ludwin_api#api_list_live_data'

  # Return all prematch data as delta
  get '/spc/api/4441f43181/prematch_data_delta/list' => 'ludwin_api#api_list_prematch_data_delta'

  # Return all live data as delta
  get '/spc/api/4441f43182/live_data_delta/list' => 'ludwin_api#api_list_live_data_delta'

  # List all sports
  get '/spc/api/882198a635/sports' => 'ludwin_api#api_list_sports'

  # List a specific sport
  get '/spc/api/8b812ab067/sport/:sport_code' => 'ludwin_api#api_show_sport'

  # List all tournaments for a specific sport
  get '/spc/api/eba26f36c5/tournaments/:sport_code' => 'ludwin_api#api_list_tournaments'

  # List a specific tournament
  get '/spc/api/78ff5c89f0/tournament/:tournament_code/:sport_code' => 'ludwin_api#api_show_tournament'

  # List all bets - The Draw node is missing
  get '/spc/api/b33dcbd3f9/bets' => 'ludwin_api#api_list_bets'

  # List a specific bet - Is returning an empty response
  get '/spc/api/156dfc6a3b/bet/:bet_code' => 'ludwin_api#api_show_bet'

  # Sell a coupon
  post '/spc/api/6d3782c78d/coupon/sell/:gamer_id/:paymoney_account_number/:password' => 'ludwin_api#api_sell_coupon'

  post '/spc/api/6d3782c78d/m_coupon/sell/:gamer_id/:paymoney_account_number/:password' => 'ludwin_api#api_m_sell_coupon'
  post '/spc/api/6o412c78d/system_bet/place/:gamer_id/:paymoney_account_number/:password' => 'ludwin_api#api_system_bet_placement'

  post '/spc/api/6d3782c78d/m_coupon/sell/:gamer_id/:paymoney_account_number/:password/:begin_date' => 'ludwin_api#api_m_sell_coupon'

  # Cancel a sold coupon
  get '/spc/api/6d3782c78d/coupon/cancel/:ticket_id' => 'ludwin_api#api_cancel_coupon'

  # Payment notification request
  post '/spc/api/8679903191/coupon/payment/notification' => 'ludwin_api#api_coupon_payment_notification'

  # Check coupon status
  get '/spc/api/e5c89f9add/coupon/status/:transaction_id' => 'ludwin_api#api_coupon_status'

  # Display the list of bets of a gamer
  get '/spc/api/47855ddf93/gamer/bets/list/:gamer_id' => 'ludwin_api#api_gamer_bets'

  # Sandbox
  get '/sandbox/patron' => 'sandbox#patron_client'

  # Last request log
  get '/spc/api/log/last_request' => 'ludwin_api#api_last_request_log'

  # Terminal status
  get '/spc/terminals/status' => 'ludwin_api#terminals_status'

  # Free terminals
  get '/spc/terminals/free' => 'ludwin_api#free_terminals'

  #---------------------LUDWIN---------------------

  #---------------------AIL PMU---------------------

  # List available draws
  get '/ail/pmu/api/d269f9c92e/draws' => 'ail_pmu#api_get_draws'

  # Query a bet
  post '/ail/pmu/api/3c9342cf06/bet/query' => 'ail_pmu#api_query_bet'

  # Place a bet
  post '/ail/pmu/api/dik749742e/bet/place/:gamer_id/:paymoney_account_number/:password' => 'ail_pmu#api_place_bet'

  # Acknowledge the placement of a bet
  get '/ail/pmu/api/4a66c58e95/bet/place/acknowledge/:transaction_id/:paymoney_account_number' => 'ail_pmu#api_acknowledge_bet'

  # Cancel a bet
  get '/ail/pmu/api/73b451b673/bet/cancel/:transaction_id' => 'ail_pmu#api_cancel_bet'

  # Acknowledge the cancellation of a bet
  get '/ail/pmu/api/8c8a869c38/bet/cancel/acknowledge/:transaction_id' => 'ail_pmu#api_acknowledge_cancel'

  # Refund a bet
  get '/ail/pmu/api/2f9aa57098/bet/refund/:transaction_id' => 'ail_pmu#api_refund_bet'

  # Acknowledge the refund of a bet
  get '/ail/pmu/api/8cedf69c38/bet/refund/acknowledge/:transaction_id' => 'ail_pmu#api_acknowledge_refund'

  # Display a bet details
  get '/ail/pmu/api/rfc4159c38/bet/details/:transaction_id' => 'ail_pmu#api_bet_details'

  # Display the list of bets of a gamer
  get '/ail/pmu/api/66307a2f93/gamer/bets/list/:gamer_id' => 'ail_pmu#api_gamer_bets'

  # Validate winning transaction
  post '/ail/pmu/api/66378514493/transaction/validate' => 'ail_pmu#api_validate_transaction'

  # Last request log
  get '/ail/pmu/api/log/last_request' => 'ail_pmu#api_last_request_log'

  get '/ail/pmu/api/ddf8dffrz3/transaction/validate_payment_notifications' => 'ail_pmu#validate_payment_notifications'

  #---------------------AIL PMU---------------------

  #---------------------AIL Loto---------------------

  # List available draws
  get '/ail/loto/api/48e266c970/draws' => 'ail_loto#api_get_draws'

  # Query a bet
  post '/ail/loto/api/74df15df06/bet/query' => 'ail_loto#api_query_bet'

  # Query a bet
  post '/ail/loto/api/852142cf06/bet/query' => 'ail_loto#api_query_bet'

  # Place a bet
  post '/ail/loto/api/96455396dc/bet/place/:gamer_id/:paymoney_account_number/:password' => 'ail_loto#api_place_bet'

  # Acknowledge the placement of a bet
  get '/ail/loto/api/ddfd5882ab/bet/place/acknowledge/:transaction_id/:paymoney_account_number' => 'ail_loto#api_acknowledge_bet'

  # Cancel a bet
  get '/ail/loto/api/ead345db03/bet/cancel/:transaction_id' => 'ail_loto#api_cancel_bet'

  # Acknowledge the cancellation of a bet
  get '/ail/loto/api/8c8a759c38/bet/cancel/acknowledge/:transaction_id' => 'ail_loto#api_acknowledge_cancel'

  # Refund a bet
  get '/ail/loto/api/ecafdce143/bet/refund/:transaction_id' => 'ail_loto#api_refund_bet'

  # Acknowledge the refund of a bet
  get '/ail/loto/api/7415f69c38/bet/refund/acknowledge/:transaction_id' => 'ail_loto#api_acknowledge_refund'

  # Display a bet details
  get '/ail/loto/api/r74d1cfr38/bet/details/:transaction_id' => 'ail_loto#api_bet_details'

  # Display the list of bets of a gamer
  get '/ail/loto/api/068c592ec4/gamer/bets/list/:gamer_id' => 'ail_loto#api_gamer_bets'

  # Validate winning transaction
  post '/ail/loto/api/66378dffrz3/transaction/validate' => 'ail_loto#api_validate_transaction'

  #get '/ail/loto/api/66378dffrz3/transaction/validate_payment_notifications' => 'ail_loto#validate_payment_notifications'

  # Last request log
  get '/ail/loto/api/log/last_request' => 'ail_loto#api_last_request_log'

  #---------------------AIL Loto---------------------

  #---------------------EPPL---------------------
  # Place a bet
  ##get '/eppl/api/36e25e6bfd/bet/place/:game_id/:transaction_amount/:begin_date' => 'eppl#api_place_bet'

  # Charge account
<<<<<<< HEAD
 ##get '/eppl/api/345gb26bfd/account/load/:gamer_id/:paymoney_account_number/:password/:transaction_amount' => 'eppl#charge_eppl_account'
=======
  ##get '/eppl/api/345gb26bfd/account/load/:gamer_id/:paymoney_account_number/:password/:transaction_amount' => 'eppl#charge_eppl_account'
>>>>>>> 784d539be5b65c5d745bf6cee318448213a06726

  #get '/eppl/bet/validate' => 'eppl#periodically_validate_bet'

  #get 'eppl/api/87eik741fd/earning/pay/:transaction_id' => 'eppl#api_pay_earning'

  # Transfer
  ##get '/eppl/api/87eik741fd/earning/transfer/:paymoney_account_number/:transaction_amount' => 'eppl#api_transfer_earning'

  # Recharge eppl account
  ##get '/eppl/api/ok478j41fd/account/reload/:transaction_amount' => 'eppl#api_recharge_eppl_account'
  #---------------------EPPL---------------------

  #---------------------CM3---------------------

  # Get session
  get "/cm3/api/efc7e3eaee/current_session/get" => 'cm#api_current_session'

  # Get program
  get "/cm3/api/94be19034e/program/get/:program_id" => 'cm#api_get_program'

  # Get race
  get "/cm3/api/ac031f75b1/get_race/:program_id/:race_id" => 'cm#api_get_race'

  # Get bet
  get "/cm3/api/ac031f75b1/bet/get/:bet_id" => 'cm#api_get_bet'

  # Get results
  get "/cm3/api/5abdc31c5e/results/get/:program_id/:race_id" => 'cm#api_get_results'

  # Get dividends
  get "/cm3/api/50801acbde/dividends/get/:program_id/:race_id" => 'cm#api_get_dividends'

  # Evaluate game
  post "/cm3/api/0cad36b144/game/evaluate/:program_id/:race_id" => 'cm#api_evaluate_game'

  # Sell ticket
  post "/cm3/api/98d24611fd/ticket/sell/:gamer_id/:paymoney_account_number/:password/:begin_date/:end_date" => 'cm#api_sell_ticket'

  # Cancel ticket
  get "/cm3/api/90823b007f/ticket/cancel/:serial_number" => 'cm#api_cancel_ticket'

  # Get winnings
  get "/cm3/api/8d9cc87b7b/race/winners/:program_id/:race_id" => 'cm#api_get_winners'

  # Pos sale balance
  get "/api/a1b43b7d1b/pos_balance/get/:game_token/:pos_id/:session_id" => 'deposits#api_get_pos_sale_balance'
  post "/api/a1b43b7d1b/pos_balance/get/:game_token/:pos_id/:session_id" => 'deposits#api_get_pos_sale_balance'

  # Vendor balance
  get "/api/4839f1cb04/deposit/on_hold/:game_token/:pos_id" => 'deposits#api_get_daily_balance'
  post "/api/4839f1cb04/deposit/on_hold/:game_token/:pos_id" => 'deposits#api_get_daily_balance'

  # Make a deposit
  get "/api/3ae7e2f1b1/deposit/:game_token/:pos_id/:paymoney_account_number/:agent/:sub_agent/:date/:amount" => 'deposits#api_proceed_deposit'
  post "/api/3ae7e2f1b1/deposit/:game_token/:pos_id/:paymoney_account_number/:agent/:sub_agent/:date/:amount" => 'deposits#api_proceed_deposit'

  # Notify session
  get "/api/dc4741d1b1/notifySession" => 'cm#api_notify_session'
  post "/api/dc4741d1b1/notifySession" => 'cm#api_notify_session'

  # Notify program
  get "/api/dc4741d1b1/notifyProgram" => 'cm#api_notify_program'
  post "/api/dc4741d1b1/notifyProgram" => 'cm#api_notify_program'

  # Notify race
  get "/api/dc4741d1b1/notifyRace" => 'cm#api_notify_race'
  post "/api/dc4741d1b1/notifyRace" => 'cm#api_notify_race'

  # Display the list of bets of a gamer
  get '/cm3/api/yhf74493/gamer/bets/list/:gamer_id' => 'cm#api_gamer_bets'

  # Administration
  get '/administrator/gamers' => 'gamers#index', as: :gamers
  get '/administrator/gamer/profile/:gamer_id' => 'gamers#profile', as: :gamer_profile

  get '/administrator/gamer/loto/:gamer_id' => 'gamers#loto_bets', as: :gamer_loto_bets
  get '/administrator/gamer/loto/bet_details/:bet_id' => 'gamers#loto_bet_details', as: :gamer_loto_bet_details
  post '/administrator/gamer/loto/bet/search' => 'gamers#loto_bet_search', as: :gamer_loto_bet_search
  get '/administrator/gamer/loto/bet/search' => 'gamers#index'

  get '/administrator/gamer/pmu_plr/:gamer_id' => 'gamers#pmu_plr_bets', as: :gamer_pmu_plr_bets
  get '/administrator/gamer/pmu_plr/bet_details/:bet_id' => 'gamers#pmu_plr_bet_details', as: :gamer_pmu_plr_bet_details
  post '/administrator/gamer/pmu_plr/bet/search' => 'gamers#pmu_plr_bet_search', as: :gamer_pmu_plr_bet_search
  get '/administrator/gamer/pmu_plr/bet/search' => 'gamers#index'

  get '/administrator/gamer/spc/:gamer_id' => 'gamers#spc_bets', as: :gamer_spc_bets
  get '/administrator/gamer/spc/bet_details/:bet_id' => 'gamers#spc_bet_details', as: :gamer_spc_bet_details
  post '/administrator/gamer/spc/bet/search' => 'gamers#spc_bet_search', as: :gamer_spc_bet_search
  get '/administrator/gamer/spc/bet/search' => 'gamers#index'

  get '/administrator/gamer/cm3/:gamer_id' => 'gamers#cm_bets', as: :gamer_cm_bets
  get '/administrator/gamer/cm3/bet_details/:bet_id' => 'gamers#cm_bet_details', as: :gamer_cm_bet_details
  post '/administrator/gamer/cm3/bet/search' => 'gamers#cm_bet_search', as: :gamer_cm_bet_search
  get '/administrator/gamer/cm3/bet/search' => 'gamers#index'

  get '/administrator/gamer/eppl/:gamer_id' => 'gamers#eppl_bets', as: :gamer_eppl_bets
  get '/administrator/gamer/eppl/bet_details/:bet_id' => 'gamers#eppl_bet_details', as: :gamer_eppl_bet_details
  post '/administrator/gamer/eppl/bet/search' => 'gamers#eppl_bet_search', as: :gamer_eppl_bet_search
  get '/administrator/gamer/eppl/bet/search' => 'gamers#index'

  get '/administrator/loto/bets' => 'gamers#list_loto_bets', as: :list_loto_bets
  post '/administrator/loto/bets/search' => 'gamers#list_loto_bet_search', as: :list_loto_bet_search

  get '/administrator/pmu_plr/bets' => 'gamers#list_pmu_plr_bets', as: :list_pmu_plr_bets
  post '/administrator/pmu_plr/bets/search' => 'gamers#list_pmu_plr_bet_search', as: :list_pmu_plr_bet_search

  get '/administrator/spc/bets' => 'gamers#list_spc_bets', as: :list_spc_bets
  post '/administrator/spc/bets/search' => 'gamers#list_spc_bet_search', as: :list_spc_bet_search

  get '/administrator/cm/bets' => 'gamers#list_cm_bets', as: :list_cm_bets
  post '/administrator/cm/bets/search' => 'gamers#list_cm_bet_search', as: :list_cm_bet_search

  get '/administrator/eppl/bets' => 'gamers#list_eppl_bets', as: :list_eppl_bets
  post '/administrator/list/eppl/bets/search' => 'gamers#list_eppl_bet_search', as: :list_eppl_bet_search

  get '/administrator/loto/winners_on_hold' => 'gamers#loto_winners_on_hold', as: :loto_winners_on_hold
  get '/administrator/loto/winners_on_hold/validate/:bet_id' => 'gamers#validate_on_hold_loto_winner', as: :validate_on_hold_loto_winner

   get '/administrator/loto/winners' => 'gamers#loto_winners', as: :loto_winners

  get '/administrator/pmu_plr/winners_on_hold' => 'gamers#pmu_plr_winners_on_hold', as: :pmu_plr_winners_on_hold
  get '/administrator/pmu_plr/winners_on_hold/validate/:bet_id' => 'gamers#validate_on_hold_pmu_plr_winner', as: :validate_on_hold_pmu_plr_winner

  get '/administrator/pmu_plr/winners' => 'gamers#pmu_plr_winners', as: :pmu_plr_winners

  get '/administrator/spc/winners_on_hold' => 'gamers#spc_winners_on_hold', as: :spc_winners_on_hold
  get '/administrator/spc/winners_on_hold/validate/:bet_id' => 'gamers#validate_on_hold_spc_winner', as: :validate_on_hold_spc_winner

  get '/administrator/spc/winners' => 'gamers#spc_winners', as: :spc_winners

  get '/administrator/cm/winners_on_hold' => 'gamers#cm_winners_on_hold', as: :cm_winners_on_hold
  get '/administrator/cm/winners_on_hold/validate/:bet_id' => 'gamers#validate_on_hold_cm_winner', as: :validate_on_hold_cm_winner

  get '/administrator/cm/winners' => 'gamers#cm_winners', as: :cm_winners

  get '/administrator/profile/new' => 'profiles#index', as: :new_profile
  get '/administrator/profile/edit/:profile_id' => 'profiles#edit', as: :edit_profile
  post '/administrator/profile/update/:profile_id' => 'profiles#update', as: :update_profile
  get '/administrator/profile/delete/:profile_id' => 'profiles#delete', as: :delete_profile
  post '/administrator/profile/create' => 'profiles#create', as: :create_profile
  get '/administrator/profile/create' => 'profiles#index'
  get '/administrator/profiles/list' => 'profiles#list', as: :list_profiles
  get '/administrator/profile/rights/:profile_id' => 'profiles#profile_rights', as: :profile_rights
  get '/administrator/profile/habilitation/enable/:profile_id/:habilitation' => 'profiles#enable_habilitation', as: :enable_habilitation_right
  get '/administrator/profile/habilitation/disable/:profile_id/:habilitation' => 'profiles#disable_habilitation', as: :disable_habilitation_right
  get '/administrator/profile/game/habilitation/enable/:profile_id/:habilitation' => 'profiles#enable_game_habilitation', as: :enable_game_habilitation_right
  get '/administrator/profile/game/habilitation/disable/:profile_id/:habilitation' => 'profiles#disable_game_habilitation', as: :disable_game_habilitation_right
  get '/administrator/edit/:administrator_id' => 'administrators#edit_administrator', as: :edit_admin
  post '/administrator/update' => 'administrators#update_administrator', as: :update_admin
  get '/administrator/delete/:administrator_id' => 'administrators#delete_administrator', as: :delete_admin
  get '/administrator/roles/management' => 'administrators#roles_management', as: :roles_management
  post '/administrator/roles/set' => 'administrators#set_administrator_role', as: :set_administrator_role

  # Excel export
  get '/administrator/gamers/list/export' => 'gamers#export_gamers_list', as: :export_gamers_list

  get '/administrator/loto/winners/on_hold/export' => 'gamers#export_loto_winners_on_hold', as: :export_loto_winners_on_hold
  get '/administrator/loto/winners/export' => 'gamers#export_loto_winners', as: :export_loto_winners

  get '/administrator/pmu_plr/winners/on_hold/export' => 'gamers#export_pmu_plr_winners_on_hold', as: :export_pmu_plr_winners_on_hold
  get '/administrator/pmu_plr/winners/export' => 'gamers#export_pmu_plr_winners', as: :export_pmu_plr_winners

  get '/administrator/pmu_alr/winners/on_hold/export' => 'gamers#export_cm_winners_on_hold', as: :export_pmu_alr_winners_on_hold
  get '/administrator/pmu_alr/winners/export' => 'gamers#export_cm_winners', as: :export_pmu_alr_winners

  get '/administrator/spc/winners/on_hold/export' => 'gamers#export_spc_winners_on_hold', as: :export_spc_winners_on_hold
  get '/administrator/spc/winners/export' => 'gamers#export_spc_winners', as: :export_spc_winners

  get "users/administrators/disable/:administrator_id" => "administrators#disable_administrator_account", as: :disable_administrator_account
  get "users/administrators/enable/:administrator_id" => "administrators#enable_administrator_account", as: :enable_administrator_account

  # Deposit
  #get '/api/86d13843ed59e5207c68e864564/deposit/:account_number/:transaction_amount' => 'accounts#api_deposit', :constraints => {:transaction_amount => /(\d+(.\d+)?)/}

  # Deposits
  #get "/api/8c240bd95c/fee/check/:amount" => 'accounts#deposit_fee'
  #post "/api/8c240bd95c/fee/check/:amount" => 'accounts#deposit_fee'

  # Pos sale balance
  get "/api/a1b43b7d1b/pos_balance/get/:game_token/:pos_id/:session_id" => 'deposits#api_get_pos_sale_balance'
  post "/api/a1b43b7d1b/pos_balance/get/:game_token/:pos_id/:session_id" => 'deposits#api_get_pos_sale_balance'

  # Vendor balance
  get "/api/4839f1cb04/deposit/on_hold/:game_token/:pos_id" => 'deposits#api_get_daily_balance'
  post "/api/4839f1cb04/deposit/on_hold/:game_token/:pos_id" => 'deposits#api_get_daily_balance'

  # Make a deposit
  get "/api/3ae7e2f1b1/deposit/:game_token/:pos_id/:paymoney_account_number/:agent/:sub_agent/:date/:amount/:merchant_pos/:fee" => 'deposits#api_proceed_deposit', :constraints => {:fee => /(\d+(.\d+)?)/}

  # SF Make a deposit
  get "/api/rff741v1b1/deposit/:game_token/:pos_id/:paymoney_account_number/:agent/:sub_agent/:date/:amount/:merchant_pos/:fee" => 'deposits#api_sf_proceed_deposit', :constraints => {:fee => /(\d+(.\d+)?)/}

  get "utest" => "users#ut_test"

  # Payment notification
  #post '/cm3/api/dfg7fvb3191/payment/notification' => 'ludwin_api#api_coupon_payment_notification'
  #---------------------CM3---------------------

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
  get '*rogue_url', :to => 'errors#routing'
  post '*rogue_url', :to => 'errors#routing'
end
