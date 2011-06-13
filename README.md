Emilio
======

With Emilio you can parse external emails sent to your application using the
IMAP protocol.


Usage
=====

Once configured, you can do:

    Emilio::Checker.check_emails

To issue an IMAP connection to your server and fetch the new emails to be
parsed.


Configuration
-------------

You must setup Emilio in order to provide your IMAP server settings and your
credentials, among other optional stuff:

    Emilio.configure do |config|
      config.host = "imap.gmail.com"
      config.port = 993
      config.username = "your@username.com"
      config.password = "password"

      config.add_label = "processed"
      config.mailbox = "Inbox"
      config.scheduler = :delayed_job
      config.run_every = 10.minutes

      config.parser = :my_parser
    end

This is recommended to be inside an initializer, something like
`config/initializers/emilio.rb` will do the job. The first configuration
options are very self explanatory, host and account credentials.

- `add_label` is an optional label which you already must have in your GMail
  account, that will be applied to each processed email. I'm talking here
  about *labels* but this will apply to *folders* in other non-gmail providers
  too.

- `mailbox` is the name of the mailbox you want to parse emails from. By
  default it's "Inbox", but it can be personalized to anything if you want to
  choose which specific emails have to be parsed. This can be acomplished
  simply by adding filters in your email account that moves the selected
  emails into the *parsing* folder. In GMail this can be a label name too.

- `scheduler` is the name of the scheduler you want to use to perform
  recurring email checkings. By now Emilio ships with a :delayed_job
  integration but more can be added in the future.

- `run_every` is the amount of time between recurring checks, if you're using
  a scheduler.

- `parser` is the class name of your parser, and it's a requirment. More in
  the next paragraph...


Your parser class
-----------------

In order to do things with the emails your application receive, you must setup
a class to do the parsing stuff, something like:

    class MyParser < Emilio::Receiver
      def parse
        # Find a reference in the subject or sender
        reference = find_a_reference_in(@subject, @sender)

        # Do stuff
        Message.create! :text => @body, :author => @sender
      end
    end

Your class must inherit from `Emilio::Receiver` and implement a `parse`
method, or if you like to do things the hard way you could also use a regular
ActionMailer class:

    class MyParser < ActionMailer::Base
      def receive(email)
        # email is a TMail object
      end
    end

The `Emilio::Receiver` class will make things a little easier for you,
providing the following instance variables you can use in `parse`:

- @email: The TMail object representing the original email.
- @html: true or false.
- @attachments: Simply a shortcut to @email.attachments
- @sender: The sender of the email, same as @email.from
- @body: The body of the email correctly encoded as UTF-8.
- @subject: Subject encoded as UTF-8.

As you can see `Emilio::Receiver` doesn't make a lot of work, but it solves
some encoding issues.


Schedulers
----------

The schedulers are meant to cover the necessity of a recurring email checking
system. You can run `Emilio::Checker.check_emails` to do the job, but you
probably want to run it every 5 minutes or so, to keep you app up to date.

If you want you can run your own solution, maybe with a Cron entry (the
awesome gem [Whenever](https://github.com/javan/whenever) makes a great job
dealing with cron) but I've found that loading the entire application stack
every 5 minutes in my VPS shared host with 512 of RAM is overkilling.

This is why I've come up with this solution taking advantage of the also
excellent DelayedJob, using jobs that make the checking some time in the
future (making use of the :run_at option) and then re-enqueuing themselves.

While by now there is only delayed_job integration, the schedulers
arquitecture is flexible enough to allow an easy implementation of another
solutions like Resque, etc...
