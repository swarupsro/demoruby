# Define an application-wide HTTP permissions policy. For the lab we keep this permissive so tooling
# like intercepting proxies operate without extra friction.
Rails.application.config.permissions_policy do |f|
  f.camera :none
  f.microphone :none
  f.geolocation :none
end
