# RabbitMQ Cluster Helm chart (uses RabbitMQ Cluster Operator)

This chart deploys a RabbitMQ cluster on Kubernetes using the [RabbitMQ cluster operator](https://github.com/rabbitmq/cluster-operator)
and (optionally) [RabbitMQ Messaging Topology Operator](https://github.com/rabbitmq/messaging-topology-operator).

You need to have Cluster Operator installed in order to use this chart. Messaging Topology Operator is optional
if you want to use the _definitions.json_ file to configure the cluster instead of the [Messaging Topology CRDs](https://www.rabbitmq.com/kubernetes/operator/using-topology-operator.html).

## Default values and their rationale
The default values of this chart are tuned for cluster stability instead of raw performance and were consulted with RabbitMQ
developers on their Slack channel. They should be good for a production cluster, but if you want to make changes,
you can specify the configuration overrides by providing `.Values.rabbitmq.additionalConfig`.

### Limiting memory usage
Correct management of memory used by RabbitMQ is crucial to proper cluster operation. By default, RabbitMQ stores
message bodies in both RAM and persistent storage. This improves performance at the cost of potentially ever-increasing
memory usage when incoming traffic is larger than outgoing traffic.

A scenario when consumers do not keep up with the pace of publishers will eventually lead to the memory alarm being
triggered, which is a serious condition resulting in all publisher connections to the cluster being stopped.
Furthermore, if your publishers use the same connection for publishing and consumption
([a default behavior of Spring Boot AMQP](https://docs.spring.io/spring-amqp/reference/html/#separate-connection)),
there is a chance of deadlocking your cluster, where no messages can be published and consumed.

For this reason, this chart will configure the cluster to not store message bodies in RAM, which greatly minimizes
the risk of triggering a memory alarm and reduces the overall memory requirements of your cluster.
You might have heard about [lazy queues](https://www.rabbitmq.com/lazy-queues.html), which is exactly this feature.
However, this chart also enables the same functionality for [Quorum Queues](https://www.rabbitmq.com/quorum-queues.html),
whereas lazy queues only work for Classic Queues.

This chart also lowers the amount of RAM used by Quorum Queues by reducing the maximum size of WAL file kept in memory
from default the 512 MiB to 64 MiB.
Quorum Queues are more memory-heavy than [Mirrored Classic Queues](https://www.rabbitmq.com/ha.html) by design, so using
a lot of them could quickly deplete your cluster's available memory. With this change using Quorum Queues should
less taxing for the cluster.

### HA policy
This chart provides a default HA policy for Classic Queues to match Quorum Queues' behavior in that regard.
If you create a Classic Queue, it will automatically be mirrored to the majority of the nodes.
Keep in mind that replication of Classic Queues will be removed in RabbitMQ 4.0, as Quorum Queues are a recommended
way of achieving message replication in RabbitMQ.

### Partition handling strategy
This chart sets the cluster partition handling strategy to `pause-minority`, which prioritizes partition tolerance and
data consistency over availability.
You can read more about it [here](https://www.rabbitmq.com/partitions.html#automatic-handling).

## Development
The initial version of this project was developed at [Telematics Technologies sp. z o.o.](https://www.telematicstechnologies.com/en), however it is currently independently managed and maintained by Krzysztof Wencel.

To make a contribution to this project, please follow the instructions given in the [CONTRIBUTING.md](CONTRIBUTING.md) file.

## License
The project is available under the [Apache License, Version 2.0](LICENSE).
