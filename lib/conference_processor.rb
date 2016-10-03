require 'twilio-ruby'
require_relative 'sample_conference_data'
require_relative '../config/initializers/rabbit_feed'

module ConferenceProcessor
  class CallLog

    def self.call_command(to_number)
      @@client ||= Twilio::REST::Client.new SampleConferenceData::TWILIO_ACCOUNT_SID, SampleConferenceData::TWILIO_AUTH_TOKEN

      @@client.account.calls.create(
        :url => "#{SampleConferenceData::NGROK_ADDRESS}/call_joined",
        :to =>  to_number,
        :from => SampleConferenceData::TWILIO_NUMBER,
        :status_callback => "#{SampleConferenceData::NGROK_ADDRESS}/status_changed",
        :status_callback_event => ['initiated','ringing','answered','completed']
      )

    end

    def self.handle_call_request(params)
      call_command("client:#{SampleConferenceData::WORKER_ID}")
    end
  end
  class Conference     # def call_joined
    #   puts 'Call joined...'
    # end

    def self.status_changed(status)
      puts "status changed: #{status}"
      #binding.pry
      if status["call_status"] == "in-progress" && status["called"] == "client:#{SampleConferenceData::WORKER_ID}"
        #Call second leg
        puts 'Second call leg...'
        CallLog.call_command SampleConferenceData::CUSTOMER_NUMBER
      end
    end
  end
end
