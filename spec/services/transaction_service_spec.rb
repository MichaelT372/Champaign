# frozen_string_literal: true

require 'rails_helper'

describe TransactionService do
  before do
    # Braintree one off transactions
    %w[USD CAD AUD NZD GBP EUR CHF].each do |currency|
      create_list :payment_braintree_transaction, 2, amount: 100, currency: currency, created_at: Date.today
    end

    # Braintree one off transactions from 2 months ago
    %w[USD CAD AUD NZD GBP EUR CHF].each do |currency|
      create_list :payment_braintree_transaction, 2, amount: 100, currency: currency, created_at: 2.months.ago
    end

    # GoCadless one off transactions
    create_list :payment_go_cardless_transaction, 2, amount: 100, currency: 'EUR', created_at: Date.today

    # GoCadless one off transactions from 2 months ago
    create_list :payment_go_cardless_transaction, 2, amount: 100, currency: 'EUR', created_at: 2.months.ago
  end

  describe '.count_braintree' do
    let!(:sum_of_all_transactions) { %w[USD CAD AUD NZD GBP EUR CHF].reduce({}) { |h, c| h.merge(c => 400.to_d) } }
    let!(:sum_of_recent_transactions) { %w[USD CAD AUD NZD GBP EUR CHF].reduce({}) { |h, c| h.merge(c => 200.to_d) } }

    it 'counts all braintree transactions grouped by currency' do
      totals = TransactionService.count_braintree
      expect(totals).to include sum_of_all_transactions
    end

    it 'excludes subscriptions' do
      totals = TransactionService.count_braintree
      %w[USD CAD AUD NZD GBP EUR CHF].each do |currency|
        create :payment_braintree_transaction, :with_subscription, amount: 100, currency: currency
      end
      expect(totals).to include sum_of_all_transactions
    end

    it 'accepts a date range' do
      totals = TransactionService.count_braintree 1.month.ago..Date.today
      expect(totals).to include sum_of_recent_transactions
    end
  end

  describe '.count_go_cardless' do
    it 'counts all gocardless transactions grouped by currency' do
      totals = TransactionService.count_go_cardless
      expect(totals).to include('EUR' => 400.to_d)
    end

    it 'excludes subscriptions' do
      %w[AUD GBP EUR].each do |currency|
        FactoryBot.create :payment_go_cardless_transaction, :with_subscription, amount: 100, currency: currency
      end
      totals = TransactionService.count_go_cardless
      expect(totals).to include('EUR' => 400.to_d)
    end

    it 'accepts a date range' do
      totals = TransactionService.count_go_cardless 1.month.ago..Date.today
      expect(totals).to include('EUR' => 200.to_d)
    end
  end

  describe '.count' do
    it 'aggregates GoCardless and Braintree transactions' do
      totals = TransactionService.count
      expected = { 'EUR' => 800.to_d, 'AUD' => 400.to_d }
      expect(totals).to include expected
    end
  end

  describe '.count_in_usd' do
    it 'converts .count totals to USD and returns a total' do
      totals = TransactionService.count_in_usd
      expect(totals).to be_within(5).of(30.00)
    end
  end
end
