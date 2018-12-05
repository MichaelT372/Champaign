# frozen_string_literal: true

puts 'Seeding...'

# Forms
%w[en fr de es].each do |locale|
  DefaultFormBuilder.find_or_create(locale: locale)
end

# Liquid Markup
LiquidMarkupSeeder.seed
