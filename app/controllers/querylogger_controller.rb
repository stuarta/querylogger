require 'net/http'
class QueryloggerController < ApplicationController
  skip_before_action :verify_authenticity_token
  def submit
    Rails.logger.debug params.inspect
    uri = URI('http://services.mythtv.org/channel-icon/submit')
    forward_request(uri, params)
  end
  def lookup
    Rails.logger.debug params.inspect
    uri = URI('http://alcor.mythtv.org/channel-icon/lookup')
    forward_request(uri, params)
  end
  def search
    Rails.logger.debug params.inspect
    uri = URI('http://alcor.mythtv.org/channel-icon/search')
    forward_request(uri, params)
  end
  def findmissing
    Rails.logger.debug params.inspect
    uri = URI('http://alcor.mythtv.org/channel-icon/findmissing')
    forward_request(uri, params)
  end
  def forward_request(uri, params)
    req = Net::HTTP::Post.new(uri)
    req.set_form_data(params)
    if (request.headers['Accept'] == "application/json")
      puts "JSON wanted"
    end
    req['Accept'] = request.headers['Accept']
    req['Host'] = "services.mythtv.org"
    req['User-Agent'] = request.headers['User-Agent']
    req['X-Real-IP'] = request.headers['X-Real-IP']
    req['X-Forwarded-For'] = request.headers['X-Forwarded-For']
    req['X-Forwarded-Host'] = request.headers['X-Forwarded-Host']
    req['X-Forwarded-Server'] = request.headers['X-Forwarded-Server']
    @res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end
    puts "=== Response Body Start ==="
    puts "#{@res.body}"
    puts "===  Response Body End  ==="
    respond_to do |format|
      format.text { render "response" }
      format.json { render json: @res.body }
      format.html { render text: @res.body }
    end
  end
end
