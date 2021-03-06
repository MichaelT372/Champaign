# frozen_string_literal: true

# == Schema Information
#
# Table name: plugins_thermometers
#
#  id         :integer          not null, primary key
#  active     :boolean          default(FALSE)
#  offset     :integer
#  ref        :string
#  title      :string
#  type       :string           default("ActionsThermometer"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  page_id    :integer
#
# Indexes
#
#  index_plugins_thermometers_on_page_id  (page_id)
#
# Foreign Keys
#
#  fk_rails_...  (page_id => pages.id)
#

class Plugins::DonationsThermometer < Plugins::Thermometer
  belongs_to :page, touch: true

  def current_progress
    return 0 if fundraising_goal.zero?

    total_donations / fundraising_goal * 100
  end

  def liquid_data(_supplemental_data = {})
    attributes.merge(
      percentage: current_progress,
      total_donations: currencies_hash(current_total),
      goals: goals_hash(fundraising_goal)
    )
  end

  private

  def currencies_hash(amount)
    # Get a hash with amount converted into all supported currencies.
    # Transform values from arrays of amounts to single amounts (e.g. GBP: [10] to GBP: 10)
    ::Donations::Currencies.for([amount]).to_hash.map { |k, v| [k, ::Donations::Utils.round(v).first] }.to_h
  end

  def goals_hash(amount)
    ::Donations::Currencies.for([amount]).to_hash
      .map { |k, v| [k, ::Donations::Utils.round_fundraising_goals(v).first] }.to_h
  end

  def fundraising_goal
    page.campaign.blank? ? page.fundraising_goal : page.campaign.fundraising_goal
  end

  def total_donations
    page.campaign.blank? ? page.total_donations : page.campaign.total_donations
  end

  def current_total
    offset + total_donations
  end
end
