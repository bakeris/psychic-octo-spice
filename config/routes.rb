Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'errors#routing'

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

  #---------------------LUDWIN---------------------

  # Prise d'informations relatives aux paris
  get '/6ba041bf35229938ba869a7a9c59f3a0/api/query_bet/:uuid/:bet_code/:bet_modifier/:selector1/:selector2/:repeats/:special_count/:normal_count/:entries' => 'query_bets#query_bet'

  # Return all prematch data
  get '/spc/api/0790f43181/prematch_data/list' => 'ludwin_api#api_list_prematch_data'

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

  # Last request log
  get '/ail/loto/api/log/last_request' => 'ail_pmu#api_last_request_log'

  #---------------------AIL Loto---------------------

  #---------------------EPPL---------------------
  get '/eppl/api/36e25e6bfd/bet/place/:gamer_id/:paymoney_account_number/:password/:transaction_amount' => 'eppl#api_place_bet'

  get 'eppl/api/87eik741fd/earning/pay/:transaction_id' => 'eppl#api_pay_earning'
  #---------------------EPPL---------------------

  #---------------------CM3---------------------

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
