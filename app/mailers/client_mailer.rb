class ClientMailer < ActionMailer::Base
  default from: "pragati.doshi@botreeconsulting.com"

  def send_email(client,pdfkit,invoice,user)
    @client = client
    @invoice = invoice
    @user = user
    attachments["#{client.name}_#{Time.now.strftime("%m%d_%Y")}.pdf"] = pdfkit
    mail(to: @client.contact_details.first.email, subject: "[#{user.company.name}] Invoice #{invoice.invoice_number.to_s} of #{invoice.currency_code.upcase} #{invoice.total_amount} for #{client.name}")
  end

  def send_email_payment(client,invoice,user)
    @client = client
    @invoice = invoice
    @user = user
    mail(to: @client.contact_details.first.email, subject: "[#{user.company.name}] has received your payment for invoice #{invoice.invoice_number.to_s}")
  end
end