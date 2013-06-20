require 'aws/sqs'

module PgWriter
  class MsgQueues
    def initialize
      sqs = AWS::SQS.new aws_cred
      @pq = sqs.queues.named('gagra_players')
      @gq = sqs.queues.named('gagra_games')
    end

    def poll_players
      @pq.poll(batch_size: 10, idle_timeout: 3) { |msg| yield msg }
    end

    def deq_games
      @gq.receive_messages(limit: 10) { |msg| yield msg }
    end

    private

    def aws_cred
      {
        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
      }
    end
  end
end
