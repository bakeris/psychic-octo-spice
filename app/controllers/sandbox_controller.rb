class SandboxController < ApplicationController

  def patron_client
    uri = URI("https://sports4africa.com/testUSSD/getSport")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    headers = {
      'Content-Type' => "application/xml"
    }

    #sess.headers['Content-Type'] = 'application/xml'
    body = %Q[<?xml version="1.0" encoding="UTF-8"?>
              <ServicesPSQF>
	              <SportRequest>
		              <TransactionID>#{Digest::SHA1.hexdigest([DateTime.now.iso8601(6), rand].join).hex.to_s[0..18]}</TransactionID>
                  <Language>FR</Language>
	              </SportRequest>
              </ServicesPSQF>]

    #resp = sess.post("/testUSSD/getSport", body, {"Content-Type" => "application/xml"})

    response = http.post(uri.path, body, headers)

    render text: response.body
  end

end
