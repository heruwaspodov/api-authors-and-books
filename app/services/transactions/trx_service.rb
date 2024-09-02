# frozen_string_literal: true

module Transactions
  class TrxService < ApplicationServices
    def initialize(current_user, params)
      @current_user = current_user
      @source_wallet_id = params[:source_wallet_id]
      @target_wallet_id = params[:target_wallet_id]
      @amount = params[:amount].to_i
    end

    def call
      credit
      debet unless @source_wallet_id == @target_wallet_id
    end

    private

    def credit
      increase_balance_target
      record_credit
    end

    def debet
      decrease_balance_source
      record_debet
    end

    def increase_balance_target
      wallet = Wallet.find(@target_wallet_id)
      wallet.balance = @amount + wallet.balance
      wallet.save
    end

    def record_credit
      Credit.create(
        created_by_id: @current_user.id,
        source_wallet_id: @source_wallet_id,
        target_wallet_id: @target_wallet_id,
        amount: @amount
      )
    end

    def decrease_balance_source
      wallet = Wallet.find(@source_wallet_id)
      wallet.balance = wallet.balance - @amount
      wallet.save
    end

    def record_debet
      Debet.create(
        created_by_id: @current_user.id,
        source_wallet_id: @source_wallet_id,
        target_wallet_id: @target_wallet_id,
        amount: @amount
      )
    end
  end
end
