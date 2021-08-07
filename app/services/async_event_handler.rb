class AsyncEventHandler < ApplicationJob
  def call(_event); end

  def perform(serialized_event)
    call(DemoProject::Container.resolve('events.publisher').mapper.serialized_record_to_event(serialized_event))
  end
end
