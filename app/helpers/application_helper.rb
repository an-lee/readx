# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def pretty_price(price)
    case price.to_f
    when 1000..Float::INFINITY
      format('%.1f', price)
    when 100..1000
      format('%.2f', price)
    when 1..100
      format('%.3f', price)
    when 0.1..1
      format('%.4f', price)
    when 0.0001..1
      format('%.5f', price)
    when 0...0.0001
      format('%.6f', price)
    end
  end
end
