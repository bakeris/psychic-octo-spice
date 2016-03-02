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
      @loto_bets = AilLoto.where("gamer_id = '#{@gamer.uuid}' AND placement_acknowledge IS TRUE").order("created_at DESC")
    end
  end

  def loto_bet_details
    @bet = AilLoto.find_by_id(params[:bet_id])
    if @bet.blank?
      flash[:error] = "Ce pari n'existe pas"
      redirect_to gamers_path
    else
      @gamer = User.find_by_uuid(@bet.gamer_id)
    end
  end

end
