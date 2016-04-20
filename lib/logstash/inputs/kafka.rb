# encoding: utf-8
require "logstash-input-kafka_jars.rb"
require "logstash/inputs/base"
require "logstash/namespace"
require 'java'


class LogStash::Inputs::Kafka < LogStash::Inputs::Base
  config_name "kafka"

  # If undefined, Logstash will complain, even if codec is unused.
  default :codec, "plain"

  public
  def register
    @consumer = create_consumer
    @consumer.subscribe(java.util.Arrays.asList("test"));
  end # def register

  def run(queue)
    # we can abort the loop if stop? becomes true
    while !stop?
      records = @consumer.poll(100)
      for record in records do
        event = LogStash::Event.new("message" => record.value.to_s)
        decorate(event)
        queue << event
      end
    end # loop
  end # def run

  def stop
    # nothing to do in this case so it is not necessary to define stop
    # examples of common "stop" tasks:
    #  * close sockets (unblocking blocking reads/accepts)
    #  * cleanup temporary files
    #  * terminate spawned threads
  end

  private
  def create_consumer
    props = java.util.Properties.new
    props.put("bootstrap.servers", "localhost:9092")
    props.put("group.id", "logstash")
    props.put("enable.auto.commit", "true")
    props.put("auto.commit.interval.ms", "1000")
    props.put("session.timeout.ms", "30000")
    props.put("key.deserializer", "org.apache.kafka.common.serialization.StringDeserializer")
    props.put("value.deserializer", "org.apache.kafka.common.serialization.StringDeserializer")

    org.apache.kafka.clients.consumer.KafkaConsumer.new(props)
  end

end # class LogStash::Inputs::Kafka
