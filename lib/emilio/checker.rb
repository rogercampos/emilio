module Emilio
  class Checker
    def self.check_emails
      # Make sure we use a compatible Time format, otherwise TMail will
      # not be able to parse the email timestamp.
      old_time_format = Time::DATE_FORMATS[:default]
      Time::DATE_FORMATS[:default] = '%m/%d/%Y %H:%M'


      begin
        # make a connection to imap account
        imap = Net::IMAP.new(Emilio.host, Emilio.port, true)
        imap.login(Emilio.username, Emilio.password)

        # select which mailbox to process
        imap.select(Emilio.mailbox)

        # get all emails in that mailbox that have not been deleted
        imap.uid_search(["NOT", "DELETED"]).each do |uid|
          # fetches the straight up source of the email for tmail to parse
          source = imap.uid_fetch(uid, ['RFC822']).first.attr['RFC822']

          Emilio.parser.classify.constantize.receive(source)

          # Optionally assign it some label
          imap.uid_copy(uid, Emilio.add_label) if Emilio.add_label

          # Delete it from Inbox (Gmail Archive)
          imap.uid_store(uid, "+FLAGS", [:Deleted])
        end

        # expunge removes the deleted emails
        imap.expunge
        imap.logout
        imap.disconnect

      # NoResponseError and ByeResponseError happen often when imap'ing
      rescue Net::IMAP::NoResponseError => e
        Emilio.logger.error("No response: #{e}")
      rescue Net::IMAP::ByeResponseError => e
        Emilio.logger.error("Bye response: #{e}")
      rescue => e
        Emilio.logger.error(e.message)
        Emilio.logger.error(e.backtrace.join("\n"))
      end

      Time::DATE_FORMATS[:default] = old_time_format
      nil
    end
  end
end
