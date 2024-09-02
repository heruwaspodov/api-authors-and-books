# frozen_string_literal: true

module Transactions
  class WithdrawService < ApplicationServices
    def initialize(current_user, params)
      @current_user = current_user
      @target_wallet_id = params[:target_wallet_id]
      @amount = params[:amount].to_i
    end

    def call
      decrease_balance_target
      record_withdraw
    end

    private

    def decrease_balance_target
      wallet = Wallet.find(@target_wallet_id)
      wallet.balance = wallet.balance - @amount
      wallet.save
    end

    def record_withdraw
      Withdraw.create(
        created_by_id: @current_user.id,
        source_wallet_id: @target_wallet_id,
        target_wallet_id: @target_wallet_id,
        amount: @amount
      )
    end
  end
end
