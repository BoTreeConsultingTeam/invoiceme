module InvoicesHelper
  def get_items
    Item.all.map{ |item|[item.name,item.id]}
  end

  def get_clients
    current_user.company.clients.map{ |client|[client.name,client.id]}
  end

  def get_address(invoice)
    if invoice.address.present?
      "#{invoice.address.street_1} #{invoice.address.street_2}, <br/>#{invoice.address.city}, #{invoice.address.state}, <br/>#{invoice.address.pincode.to_s}".html_safe
    else
      " "
    end
  end
end