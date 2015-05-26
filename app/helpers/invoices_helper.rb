module InvoicesHelper
  def get_items
    Item.all.map{ |item|[item.name,item.id]}
  end

  def get_clients
    current_user.company.clients.map{ |client|[client.name,client.id]}
  end

  def get_address(invoice)
    if invoice.address.present?
      "#{invoice.address.street_1} #{invoice.address.street_2}, \n#{invoice.address.city}, #{invoice.address.state}, \n#{invoice.address.pincode.to_s}"
    else
      " "
    end
  end

  def get_address_first(client)
    if client.address.present?
      "#{client.address.street_1} #{client.address.street_2}, \n#{client.address.city}, #{client.address.state}, \n#{client.address.pincode.to_s}"
    else
      " "
    end
  end

  def is_pdf_view?
    ['pdf_generation', 'create', 'update'].include?(action_name)
  end
end