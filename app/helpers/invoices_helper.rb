module InvoicesHelper
  def get_items
    Item.all.map{ |item|[item.name,item.id]}
  end

  def get_clients
    current_user.company.clients.map{ |client|[client.name,client.id]}
  end

  def date_for_display(date)
    if date.nil?
      Date.today.strftime("%m/%d/%Y")
    else
      date.strftime("%m/%d/%Y")
    end
  end

  def calculate_total(invoice)
    total = 0.00
    invoice.line_items.each do |line_item|
      total = total + line_item.line_total.to_f
    end
    total
  end
end
