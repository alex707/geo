module RabbitMq
  extend self

  @mutex = Mutex.new

  def connection
    @mutex.synchronize do
      @connection ||= Bunny.new.start
    end
  end

  def channel
    Thread.current[:rabbitmq_channel] ||= connection.create_channel
  end

  # канал для потребеления (канал для по публикации и потребления лучше держать раздельно)
  def consumer_channel
    Thread.current[:rabbitmq_consumer_channel] ||=
      connection.create_channel(
        nil,
        Settings.rabbitmq.consumer_pool
      )
    # Settings.rabbitmq.consumer_pool - число входящих запросов, которое можно обработать единовременно

    # вообще, из-за global interpreteur lock не сможет работать одновременно,
    # но из-за того, что все треды работают с сетью
    #   (все предыдущие треды будут в режиме ожидания IO,
    #     т.к. выполняют rpc вызов в ads по обновлению записи advertisement)
    # а если предыдущий тред в режиме ожидания IO, то ruby станет выполнять следующий тред.
    # т.о. от многопоточности мы получим выйгрыщ даже с учётом наличия глобальной блокировки в руби.
  end
end
