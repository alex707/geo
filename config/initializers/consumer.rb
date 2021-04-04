channel = RabbitMq.consumer_channel
queue = channel.queue('geo', durable: true)

# manual_ack: true - вручную обновление подтверждение обраб сообщения
# (после того, как успешного вызовем rpc процедуру на стороне ads,
#   обновим объявление, нам придёт ответ, и вот тогда уведомим реббит, что событие успешно обработалось)
queue.subscribe(manual_ack: true) do |delivery_info, properties, payload|
  payload = JSON(payload)
  coordinates = Geocoder.geocode(payload['city_name'])

  if coordinates.present?
    client = AdsService::RpcClient.fetch
    client.update_coordinates(payload['id'], coordinates)

    # блочим тред, чтобы дождаться, что объявление в ads успешно обновилось
    # используя @local.synchronize и последующий wait
  end

  # фиксация сообщения как успешно выполненного
  channel.ack(delivery_info.delivery_tag)
end

# возможно реализовать отдельный класс консъюмера, и его зарегистрировать,
#   но всё равно придётся вызывать метод колбэка,
#   пожтому лучше для такго использовать sneakers - в стиле sidekiq спроектировать консъюмеры
