require 'pry'
# Define the event routing (if consuming)
EventRouting do
  accept_from('page_server') do
    event('browser_call_request') do |event|
      puts 'Browser call request received...'
      #binding.pry
      ConferenceProcessor::CallLog.handle_call_request(event.payload)
    end
  end
  accept_from('twilio_req_handler') do
    # event('call_joined') do |event|
    #   ConferenceProcessor::Conference.call_joined
    # end
    event('status_changed') do |event|
      puts event.payload
      #binding.pry
      ConferenceProcessor::Conference.status_changed event.payload
    end
  end
end
