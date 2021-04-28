# GitOps DKP Demo

This branch was created to roll-out the truck efficiency demo. It is meant to show how easy it is to use DKP.

## Prerequirements

* Create a [Kommander Project](https://docs.d2iq.com/dkp/kommander/1.4/projects/)
* Install [Platform Services](https://docs.d2iq.com/dkp/kommander/1.4/projects/platform-services/)
  * Zookeeper (ID: zookeeper)
  * Install Kafka (ID: kafka)
  * Install Cassandra (ID: cassandra)
* Create a [ConfigMap](https://docs.d2iq.com/dkp/kommander/1.4/projects/project-configmaps/) with the name "dataservices", the following key value pairs and replace ***ProjectNamespace*** with your Project Namespace:
  * Kafka=kafka-kafka-0.kafka-svc.***ProjectNamespace***.svc.cluster.local:9093
  * Cassandra=cassandra-node-0.cassandra-svc.***ProjectNamespace***.svc.cluster.local:9042
  
## Installation

To create the resources needed like the api's, a frontend and the data generator we will simply use [Kommander Project Deployments](https://docs.d2iq.com/dkp/kommander/1.3/projects/project-deployments/). You will find all the Kubernetes manifests in this repository. As this repo is Public you won't need a Git Secret. You just need to specify a name, the Repository URL and a branch. That's all? **Yes**.

What will be installed?

![Demo](https://github.com/jlnhnng/gitops-demo/blob/demo/Truck-Efficiency.png?raw=true)

* Python API
  * The Python Api receives data from the trucks and writes every update into Kafka.
* Node API
  * The Node Api reads data from Kafka, publishes a WebSocket with live data and writes updates to Cassandra.
* Angular UI
  * The UI shows a live map of the trucks.
* Data Generator
  * The Generator is a dummy truck. It creates data that is produced by a truck, driving from A to B on 3 different routes in one country. There are two modes: 'Specific' or 'Random'. If the mode is 'Specific' the values specified are used. If the mode is 'Random' the specified values will be ignored and will be set randomly. The default value is set to random.

If you want to check the changes in the namespace you can use:

``` bash
watch kubectl get po -n ProjectNamespace
```

*Please replace ***ProjectNamespace*** with your Project Namespace.*

## Usage

As soon as everything is up, please use:

``` bash
kubectl get svc truck-demo-ui-svc -n ProjectNamespace
```

*Please replace ***ProjectNamespace*** with your Project Namespace.*

You will find a Loadbalancer Address. Please visit <https://LoadBalancerAddress.us-west-2.elb.amazonaws.com/> and use your LoadBalancer address instead of ***LoadBalancerAddress***.

### Create more trucks

One truck is one pod. The pod will restart after the truck finished (or had to stop unplanned) the drive. If you want to create more please scale the deployment:

``` bash
kubectl scale --replicas=5 deploy/truck-data-generator -n ProjectNamespace
```

### Advanced

If you want to play around and would like to see GitOps in action, please feel free to fork this repository, adjust your GitOps Source, change a value in the repository and see the changes getting rolled out to you Project Namespace automatically.
