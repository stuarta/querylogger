require 'net/http'
class QueryloggerController < ApplicationController
  skip_before_action :verify_authenticity_token
  def submit
    forward_request("submit", params)
  end
  def lookup
    forward_request("lookup", params)
  end
  def search
    forward_request("search", params)
  end
  def findmissing
    forward_request("findmissing", params)
  end
  def forward_request(uri, params)
    Rails.logger.debug params.inspect
    remoteip = (!request.headers['X-Real-IP'].nil?) ? request.headers['X-Real-IP'] : request.env['REMOTE_ADDR']
    uri = URI('http://alcor.mythtv.org/channel-icon/' + uri)
    req = Net::HTTP::Post.new(uri)
    req.set_form_data(params)
    req['Accept'] = request.headers['Accept']
    req['Host'] = "services.mythtv.org"
    req['User-Agent'] = request.headers['User-Agent'] + '; ' + remoteip
    req['X-Real-IP'] = request.headers['X-Real-IP']
    req['X-Forwarded-For'] = request.headers['X-Forwarded-For']
    req['X-Forwarded-Host'] = request.headers['X-Forwarded-Host']
    req['X-Forwarded-Server'] = request.headers['X-Forwarded-Server']
    @res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end
    Rails.logger.debug "=== Response Body Start ==="
    Rails.logger.debug "#{@res.body}"
    Rails.logger.debug "===  Response Body End  ==="
    respond_to do |format|
      format.text { render "response" }
      format.json { render json: @res.body }
      format.html { render text: @res.body }
    end
  end
end
