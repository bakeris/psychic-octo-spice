class CmController < ApplicationController
  @@user_name = "ngser@lonaci"
  @@password = "lemotdepasse"
  @@notification_url = "https://142.11.15.18:11111"

  def ensure_login
    if session[:connection_id].blank?
      body = %Q[<?xml version='1.0' encoding='UTF-8'?>
                <loginRequest>
                  <username>#{@@user_name}</username>
                  <password>#{@@password}<password>
                  <notificationUrl>#{@@notification_url}</notificationUrl>
                </loginRequest>]
      send_request(body, "http://office.cm3.work:27000/login")

      connection_id = (nokogiri_response.xpath('//loginResponse').at('connectionId').content rescue nil)
    end
  end

  def send_request(body, url)
    @request_result = nil
    @response_code = nil

    request = Typhoeus::Request.new(url, body: body, followlocation: true, method: :get, headers: {'Content-Type'=> "text/xml"})

    request.on_complete do |response|
      if response.success?
        @request_result = response.body rescue nil
      else
        @response_code = response.code rescue nil
      end
    end

    request.run
  end

end
