module InvoicesHelper
  def get_items
    Item.all.map{ |item|[item.name,item.id]}
  end

  def get_clients
    current_user.company.clients.map{ |client|[client.name,client.id]}
  end

  def get_address(invoice)
    if invoice.address.present?
      "#{invoice.address.street_1} #{invoice.address.street_2}, #{invoice.address.city}, #{invoice.address.state}, #{invoice.address.pincode.to_s}"
    else
      " "
    end
  end
end