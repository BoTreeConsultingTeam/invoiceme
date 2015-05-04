class Address < ActiveRecord::Base
  belongs_to :client

  validates_presence_of :street_1, :city, :state, :country_code, :pincode
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
