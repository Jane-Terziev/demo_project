require 'command_serializer'

Rails.application.config.active_job.custom_serializers << CommandSerializer
