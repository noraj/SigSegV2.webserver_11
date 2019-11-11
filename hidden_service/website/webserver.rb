require 'sinatra'
require 'net/http'
require 'addressable'
include ERB::Util

configure do
  set :public_folder, 'public'
  set :views, 'views'
  set :bind, '0.0.0.0'
  set :port, 9999
  set :environment, :production
  #disable :protection
end

get '/' do
  @content = 'ask for url=http://domain in a GET request, PS: flag is on localhost port 10000'
  unless params['url'].nil?
    begin
      p3 = URI.parse(URI.encode(params['url']))
    rescue URI::InvalidURIError
      p3 = URI.parse(URI.encode('void'))
    end
    
    blacklisted_hosts = ['127.0.0.1', 'localhost', 'hiddenservice']
    if p3.host.nil? || p3.port.nil?
      @content = 'invalid url'
    elsif blacklisted_hosts.include?(p3.host)
      @content = 'host forbidden'
    elsif p3.port == 10000
      @content = 'port forbidden'
    elsif p3.scheme == 'file'
      @content = 'protocol forbidden'
    else
      p1 = Addressable::URI.parse(params['url'])
      path = '/'
      path = p1.path unless p1.path.nil? || p1.path.empty?
      begin
        res = Net::HTTP.get_response(p1.host, path, p1.port)
        case res
        when Net::HTTPSuccess then
          @content = res.body
        when Net::HTTPRedirection then
          @content = "#{res.code} #{res.message} #{res['location']}"
        else
          @content = "#{res.code} #{res.message}"
        end
      rescue SocketError
        @content = 'invalid socket'
      end
    end
  end
  erb :index
end
