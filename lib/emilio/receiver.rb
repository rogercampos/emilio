module Emilio
  class Receiver < ActionMailer::Base
    def receive(email)
      @email = email
      @html = false
      @attachments = email.attachments
      @sender = email.from.to_s

      if email.multipart?
        if email.html_part.present?
          ic = Iconv.new('utf-8', email.html_part.charset)
          @body = ic.iconv(email.html_part.body.to_s)
          @html = true
        else
          ic = Iconv.new('utf-8', email.text_part.charset)
          @body = ic.iconv(email.text_part.body.to_s)
        end
      else
        ic = Iconv.new('utf-8', email.charset)
        @body = ic.iconv(email.body.to_s)
      end
      @subject = ic.iconv(email.subject)
      Emilio.logger.info("Parsed email [#{email.subject}] from [#{email.from}]")

      parse_email
    end

    protected
    def parse_email
    end
  end
end
