require 'ruby_event_store/mappers/pipeline_mapper'

class ToYAMLEventMapper < RubyEventStore::Mappers::PipelineMapper
  attr_reader :serializer

  def initialize(serializer: YAML, _events_class_remapping: {})
    self.serializer = serializer
  end

  def event_to_serialized_record(domain_event)
    serializer.dump(domain_event)
  end

  def serialized_record_to_event(record)
    serializer.load(record)
  end

  private

  attr_writer :serializer
end
