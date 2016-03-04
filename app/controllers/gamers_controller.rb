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

  def loto_bet_search
    @gamer = User.find_by_uuid(params[:uuid])
    @begin_date = params[:begin_date]
    @end_date = params[:end_date]
    @status = params[:status_id]
    @min_amount = params[:min_amount]
    @max_amount = params[:max_amount]

    if @gamer.blank?
      redirect_to gamers_path
    else
      params[:begin_date] = @begin_date
      params[:end_date] = @end_date
      params[:status_id] = @status
      params[:min_amount] = @min_amount
      params[:max_amount] = @max_amount

      set_loto_search_params

      @loto_bets = AilLoto.where("#{@sql_begin_date} #{@sql_begin_date.blank? ? '' : 'AND'} #{@sql_end_date} #{@sql_end_date.blank? ? '' : 'AND'} #{@sql_status} #{@sql_status.blank? ? '' : 'AND'} #{@sql_min_amount} #{@sql_min_amount.blank? ? '' : 'AND'} #{@sql_max_amount} #{@sql_max_amount.blank? ? '' : 'AND'} gamer_id = '#{@gamer.uuid}' AND placement_acknowledge IS TRUE")
      flash[:success] = "#{@loto_bets.count} Résultat(s) trouvé(s)."
    end
  end

  def pmu_plr_bets
    @gamer = User.find_by_id(params[:gamer_id])

    if @gamer.blank?
      flash[:error] = "Cet utilisateur n'existe pas"
      redirect_to gamers_path
    else
      @pmu_plr_bets = AilPmu.where("gamer_id = '#{@gamer.uuid}' AND placement_acknowledge IS TRUE").order("created_at DESC")
    end
  end

  def pmu_plr_bet_details
    @bet = AilPmu.find_by_id(params[:bet_id])
    if @bet.blank?
      flash[:error] = "Ce pari n'existe pas"
      redirect_to gamers_path
    else
      @gamer = User.find_by_uuid(@bet.gamer_id)
    end
  end

  def pmu_plr_bet_search
    @gamer = User.find_by_uuid(params[:uuid])
    @begin_date = params[:begin_date]
    @end_date = params[:end_date]
    @status = params[:status_id]
    @min_amount = params[:min_amount]
    @max_amount = params[:max_amount]

    if @gamer.blank?
      redirect_to gamers_path
    else
      params[:begin_date] = @begin_date
      params[:end_date] = @end_date
      params[:status_id] = @status
      params[:min_amount] = @min_amount
      params[:max_amount] = @max_amount

      set_pmu_plr_search_params

      @pmu_plr_bets = AilPmu.where("#{@sql_begin_date} #{@sql_begin_date.blank? ? '' : 'AND'} #{@sql_end_date} #{@sql_end_date.blank? ? '' : 'AND'} #{@sql_status} #{@sql_status.blank? ? '' : 'AND'} #{@sql_min_amount} #{@sql_min_amount.blank? ? '' : 'AND'} #{@sql_max_amount} #{@sql_max_amount.blank? ? '' : 'AND'} gamer_id = '#{@gamer.uuid}' AND placement_acknowledge IS TRUE")
      flash[:success] = "#{@pmu_plr_bets.count} Résultat(s) trouvé(s)."
    end
  end

  def spc_bets
    @gamer = User.find_by_id(params[:gamer_id])

    if @gamer.blank?
      flash[:error] = "Cet utilisateur n'existe pas"
      redirect_to gamers_path
    else
      @spc_bets = Bet.where("gamer_id = '#{@gamer.uuid}' AND validated IS TRUE").order("created_at DESC")
    end
  end

  def spc_bet_details
    @bet = Bet.find_by_id(params[:bet_id])
    if @bet.blank?
      flash[:error] = "Ce pari n'existe pas"
      redirect_to gamers_path
    else
      @gamer = User.find_by_uuid(@bet.gamer_id)
    end
  end

  def spc_bet_search
    @gamer = User.find_by_uuid(params[:uuid])
    @begin_date = params[:begin_date]
    @end_date = params[:end_date]
    @status = params[:status_id]
    @min_amount = params[:min_amount]
    @max_amount = params[:max_amount]

    if @gamer.blank?
      redirect_to gamers_path
    else
      params[:begin_date] = @begin_date
      params[:end_date] = @end_date
      params[:status_id] = @status
      params[:min_amount] = @min_amount
      params[:max_amount] = @max_amount

      set_spc_search_params

      @spc_bets = Bet.where("#{@sql_begin_date} #{@sql_begin_date.blank? ? '' : 'AND'} #{@sql_end_date} #{@sql_end_date.blank? ? '' : 'AND'} #{@sql_status} #{@sql_status.blank? ? '' : 'AND'} #{@sql_min_amount} #{@sql_min_amount.blank? ? '' : 'AND'} #{@sql_max_amount} #{@sql_max_amount.blank? ? '' : 'AND'} gamer_id = '#{@gamer.uuid}' AND validated IS TRUE")
      flash[:success] = "#{@spc_bets.count} Résultat(s) trouvé(s)."
    end
  end

  private
    def set_loto_search_params
      @sql_begin_date = ""
      @sql_end_date = ""
      @sql_status = ""
      @sql_min_amount = ""
      @sql_max_amount = ""

      unless @begin_date.blank?
        @sql_begin_date = "created_at > '#{@begin_date}'"
      end
      unless @end_date.blank?
        @sql_end_date = "created_at < '#{@end_date}'"
      end
      unless @status.blank?
        @sql_status = "bet_status = '#{@status}'"
      end
      unless @min_amount.blank?
        @sql_min_amount = "CAST((COALESCE(earning_amount,'0')) AS INTEGER) > #{@min_amount.to_i}"
      end
      unless @max_amount.blank?
        @sql_max_amount = "CAST((COALESCE(earning_amount,'0')) AS INTEGER) < #{@max_amount.to_i}"
      end
    end

    def set_pmu_plr_search_params
      @sql_begin_date = ""
      @sql_end_date = ""
      @sql_status = ""
      @sql_min_amount = ""
      @sql_max_amount = ""

      unless @begin_date.blank?
        @sql_begin_date = "created_at > '#{@begin_date}'"
      end
      unless @end_date.blank?
        @sql_end_date = "created_at < '#{@end_date}'"
      end
      unless @status.blank?
        @sql_status = "bet_status = '#{@status}'"
      end
      unless @min_amount.blank? || @min_amount = 0
        @sql_min_amount = "CAST((COALESCE(earning_amount,'0')) AS INTEGER) > #{@min_amount.to_i}"
      end
      unless @max_amount.blank?
        @sql_max_amount = "CAST((COALESCE(earning_amount,'0')) AS INTEGER) < #{@max_amount.to_i}"
      end
    end

    def set_spc_search_params
      @sql_begin_date = ""
      @sql_end_date = ""
      @sql_status = ""
      @sql_min_amount = ""
      @sql_max_amount = ""

      unless @begin_date.blank?
        @sql_begin_date = "created_at > '#{@begin_date}'"
      end
      unless @end_date.blank?
        @sql_end_date = "created_at < '#{@end_date}'"
      end
      unless @status.blank?
        @sql_status = "bet_status = '#{@status}'"
      end
      unless @min_amount.blank?
        @sql_min_amount = "CAST((COALESCE(win_amount,'0')) AS INTEGER) > #{@min_amount.to_i}"
      end
      unless @max_amount.blank?
        @sql_max_amount = "CAST((COALESCE(win_amount,'0')) AS INTEGER) < #{@max_amount.to_i}"
      end
    end

end
