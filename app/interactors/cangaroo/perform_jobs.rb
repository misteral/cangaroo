module Cangaroo
  class PerformJobs
    include Cangaroo::Log
    include Interactor

    def call
      context.json_body.each do |type, payloads|
        payloads.each { |payload| enqueue_jobs(type, payload) }
      end
    end

    private

    def enqueue_jobs(type, payload)
      initialize_jobs(type, payload).each do |job|
        if job.perform?
          log.info 'Enqueue job:', enqueued_job: job.class.to_s
          job.enqueue
        else
          log.info 'Skip job:', skipped_job: job.class.to_s
        end
      end
    end

    def initialize_jobs(type, payload)
      context.jobs.map do |klass|
        klass.new(
          source_connection: context.source_connection,
          vendor: context.vendor,
          type: type,
          payload: payload
        )
      end
    end
  end
end
