require 'twilio-ruby'



module ConferenceProcessor
  class CallLog

    def call_command(to_number)
      @client.account.calls.create(
        :url => "#{SampleConferenceData::NGROK_ADDRESS}/call_joined",
        :to =>  to_number,
        :from => SampleConferenceData::TWILIO_NUMBER,
        :status_callback => "#{SampleConferenceData::NGROK_ADDRESS}/status_changed",
        :status_callback_event => ['initiated','ringing','answered','completed']
      )
end
    def handle_call_request(params)
      call_command("client:#{SampleConferenceData::WORKER_ID}")
    end
  end
  class Conference
    # def call_joined
    #   puts 'Call joined...'
    # end

    def status_changed(params)
      if params["CallStatus"] == "in-progress" && params["Called"] == "client:#{SampleConferenceData::WORKER_ID}"
        #Call second leg
        call_command SampleConferenceData::CUSTOMER_NUMBER
      end
    end
  end
end
