require 'aws/sqs'

module PgWriter
  class MsgQueues
    def initialize
      sqs = AWS::SQS.new aws_cred
      @gq = sqs.queues.named('gagra_games')
    end

    def poll_games
      @gq.poll(poll_opts) { |msg| yield msg }
    end

    private

    def aws_cred
      {
        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
      }
    end

    def poll_opts
      {:batch_size => 10, :idle_timeout => 3}
    end
  end
end
