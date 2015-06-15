module InvoicesHelper

  def get_items
    Item.all.map{ |item|[item.name,item.id]}
  end

  def get_clients
    current_user.company.clients.map{ |client|[client.name,client.id]}
  end

  def is_pdf_view?
    ['pdf_generation', 'create', 'update'].include?(action_name)
  end

  def invoice_total_formatted(invoice)
    "#{invoice.currency_code.upcase} #{number_with_precision(invoice.total_amount, precision: 2)}"
  end

  def line_total_calculation(invoice)
    number_with_precision(invoice.total_amount+((invoice.total_amount.to_f*invoice.discount.to_f)/100.00), precision: 2)
  end

  def get_taxes_parent
    Tax.where(:parent_id => nil).map{ |tax|[tax.name,tax.id]}
  end

  def get_taxes_data
    Tax.all
  end

  def get_invoice(id)
    Invoice.find(id)
  end
end