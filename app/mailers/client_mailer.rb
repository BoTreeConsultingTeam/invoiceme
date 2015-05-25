class ClientMailer < ActionMailer::Base
  default from: "pragati.doshi@botreeconsulting.com"

  def send_email(pdfkit,invoice,user)
    @client = invoice.client
    @invoice = invoice
    @user = user
    attachments["#{@client.name}_#{Time.now.strftime("%m%d%Y")}.pdf"] = pdfkit
    mail(to: @client.contact_details.first.email, subject: "[#{user.company.name}] Invoice #{invoice.invoice_number} of #{invoice.currency_code.upcase} #{invoice.total_amount} for #{@client.name}")
  end
end