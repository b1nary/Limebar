require 'open-uri'
require 'json'

class GEO
  @@ip = nil
  @@location = nil
  @@timezone = nil

  @@ip_timeout = 0
  @@location_timeout = 0
  @@timezone_timeout = 0

  def self.ip
    if @@ip.nil? || @@ip_timeout+(60*60) < Time.now.to_i
      @@ip = open(IP_API_URL).read.chomp.strip
      @@ip_timeout = Time.now.to_i
    end
    @@ip
  end

  def self.location
    if @@location.nil? || @@location_timeout+(60*60) < Time.now.to_i
      @@location = JSON.parse(open("http://ip-api.com/json").read.chomp)
      @@location_timeout = Time.now.to_i
    end
    @@location
  end

  def self.timezone
    if @@timezone.nil? || @@timezone_timeout+(60*60) < Time.now.to_i
      @@timezone = JSON.parse(open("http://api.timezonedb.com/v2/get-time-zone?key=#{TIMEZONEDB_API_KEY}&format=json&by=position&lat=#{self.location["lat"]}&lng=#{self.location["lon"]}").read.chomp)
      @@timezone_timeout = Time.now.to_i
    end
    @@timezone
  end
end
