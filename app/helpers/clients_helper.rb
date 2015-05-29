module ClientsHelper

  def full_name(contact_detail)
    "#{contact_detail.first_name} #{contact_detail.last_name}"
  end

  def location(client)
    "#{client.address_city}, #{country_name(client.address_country_code)}"
  end

end
