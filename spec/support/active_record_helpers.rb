def within_active_record_transaction_block(&block)
  expect(ActiveRecord::Base).to receive(:transaction).and_wrap_original { |m, *args, &active_record_transaction_block|
    block.call
    active_record_transaction_block.call(args)
  }
end
