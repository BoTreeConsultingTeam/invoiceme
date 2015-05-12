module ClientsHelper

  def name(contact_detail)
    contact_detail.first_name+' '+contact_detail.last_name
  end

  def location(client)
    client.address_city.to_s+' '+country_name(client.address_country_code).to_s
  end

end
