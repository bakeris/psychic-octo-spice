class GamersController < ApplicationController

  layout "administrator"

  def index
    @class_gamers = "active"
    @gamers = User.all.order("created_at DESC")

    @total_gamers = @gamers.count
    @confirmed_accounts = @gamers.where("confirmed_at IS NOT NULL").count
    @unconfirmed_accounts = @gamers.where("confirmed_at IS NULL").count
  end

  def profile
    @gamer = User.find_by_id(params[:gamer_id])

    if @gamer.blank?
      flash[:error] = "Cet utilisateur n'existe pas"
      redirect_to gamers_path
    else
      @pmu_plr_bets_count = AilPmu.where("gamer_id = '#{@gamer.uuid}'").count
      @loto_bets_count = AilLoto.where("gamer_id = '#{@gamer.uuid}'").count
      @sport_cash_bets_count = Bet.where("gamer_id = '#{@gamer.uuid}'").count
      @cm_bets_count = Cm.where("punter_id = '#{@gamer.uuid}'").count
    end
  end

  def loto_bets
    @gamer = User.find_by_id(params[:gamer_id])

    if @gamer.blank?
      flash[:error] = "Cet utilisateur n'existe pas"
      redirect_to gamers_path
    else
      @loto_bets = AilLoto.where("gamer_id = '#{@gamer.uuid}' AND placement_acknowledged IS TRUE").order_created_at desc
    end
  end

end
