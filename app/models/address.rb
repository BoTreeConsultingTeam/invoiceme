class Address < ActiveRecord::Base
  belongs_to :client

  validates :street_1, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :country_code, presence: true
  validates :pincode, presence: true
  validates :pincode, zipcode: { country_code_attribute: :country_code }

  def country_name
    country = ISO3166::Country[country_code]
    if country.present?
      return country.translations[I18n.locale.to_s] || country.name
    else
      return ''
    end
  end

end
