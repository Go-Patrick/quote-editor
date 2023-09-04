class CleanQuoteJob < ApplicationJob
  queue_as :default

  def perform
    Quote.left_joins(:line_items).where(line_items: { id: nil }).destroy_all
  end
end
