module InvoicesHelper
  def get_items
    Item.all.map{ |item|[item.name,item.id]}
  end

  def get_clients
    current_user.company.clients.map{ |client|[client.name,client.id]}
  end

  def get_address(client)
    if client.address.present?
      simple_format("#{client.address.street_1} #{client.address.street_2}, \n#{client.address.city}, #{client.address.state}, \n#{client.address.pincode.to_s}")
    else
      " "
    end
  end

  def is_pdf_view?
    ['pdf_generation', 'create', 'update'].include?(action_name)
  end

  def get_total_amount(invoice)
    "#{invoice.currency_code.upcase} #{number_with_precision(invoice.total_amount, precision: 2)}"
  end
end