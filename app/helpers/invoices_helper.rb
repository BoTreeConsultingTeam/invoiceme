module InvoicesHelper
  def get_items
    Item.all.map{ |item|[item.name,item.id]}
  end

  def get_clients
    current_user.company.clients.map{ |client|[client.name,client.id]}
  end

  def formatted_address(record)
    if record.address.present?
      simple_format("#{record.address.street_1} #{record.address.street_2}, \n#{record.address.city}, #{record.address.state}, \n#{record.address.pincode.to_s}")
    else
      " "
    end
  end

  def is_pdf_view?
    ['pdf_generation', 'create', 'update'].include?(action_name)
  end

  def invoice_total_formatted(invoice)
    "#{invoice.currency_code.upcase} #{number_with_precision(invoice.total_amount, precision: 2)}"
  end
end