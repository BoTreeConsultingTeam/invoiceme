module TaxesHelper
  def get_taxes
    Tax.all.map{ |tax|[tax.name,tax.id]}
  end
end
