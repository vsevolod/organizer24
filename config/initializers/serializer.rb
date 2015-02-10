ActiveSupport.on_load(:active_model_serializers) do
  ActiveModel::Serializer.root = false
  ActiveModel::ArraySerializer.root = false

  #ActiveModel::Serializer.config.adapter = :json_api
end
