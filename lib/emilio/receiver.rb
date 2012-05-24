module Emilio
  class Receiver < ActionMailer::Base
    def receive(email)
      @email = email
      @html = false
      @attachments = email.attachments
      @sender = email.from.to_s

      @body = if email.multipart?
        if email.html_part.present?
          @html = true
          email.html_part
        else
          email.text_part
        end
      else
        ic = Iconv.new('utf-8', email.charset)
        email
      end.body.to_s.encode("utf-8")

      @subject = email.subject.encode
      Emilio.logger.info("Parsed email [#{@subject}] from [#{@sender}]")

      parse
    end

  protected
    def parse
    end
  end
end
