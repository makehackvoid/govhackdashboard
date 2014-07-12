require 'instagram'

require 'dotenv'
Dotenv.load

# Instagram Client ID from http://instagram.com/developer
Instagram.configure do |config|
  config.client_id = ENV['INSTAGRAM_CLIENT_ID'] 
end

tag = "govhack"

SCHEDULER.every '1m', :first_in => 0 do |job|
  photos = Instagram.tag_recent_media(tag)
  if photos
    photos.map! do |photo|
      { photo: "#{photo.images.standard_resolution.url}" }
    end    
  end
  send_event('instadash', photos: photos)
end