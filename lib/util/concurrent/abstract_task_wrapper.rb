class AbstractTaskWrapper
  def call
    catch(:done) do
      loop do
        ActiveSupport::Notifications.instrument('pipeline.task_wrapper.loop', name: name) do
          do_work
        rescue ApplicationError => e
          Rails.logger.error "#{e.message}\n#{e.backtrace}"
          next
        end
      end
    end
  end

  private

  attr_accessor :task, :name
end
