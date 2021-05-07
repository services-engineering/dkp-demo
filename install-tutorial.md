# D2iQ Truck Tracking Demonstration Application

This tutorial was designed to be used with the DKP Hosted Test drive and assumes that the user has a provisioned Konvoy/Kommander cluster preconfigured and handed over.

In this tutorial we will be making use of key functions of D2iQ Kommander for deploying, and managing the lifecycle of, a complex IoT app comprised of microservices (stateless) and dataservice (stateful) components exposed to the outside world.

## Prerequisites:
- Access to Kommander/Konvoy connected environment
	- Kommander URL
	- Administrator User ID
	- Administrator Password
- `kubectl` configured on local desktop or some other host to access the cluster
- Access to the "Truck-Demo" GitHub Repository (this one)
	- https://github.com/mesosphere/dkp-demo/

## Log In to  Kommander with Provided Credentials at Provided URL
Kommander delivers visibility and management of any Kubernetes cluster, whether on-prem or cloud, regardless of distribution being used. Organizations can gain better control over existing deployments without service interruptions and create standardization around how new clusters are configured and used.

1.  In a supported browser, enter the provided URL for your Kommander Cluster
2.  Using the authentication mechanism specified in your instructions, log into the Kommander Cluster.
3.  This will bring you to the "Home Dashboard" screen in the "Global" Workspace


>  For more information on Kommander, please see the following link:<br>
>  https://docs.d2iq.com/dkp/kommander/latest/introducing-kommander/



## Navigate to _Default Workspace_
Workspaces give you the flexibility to represent your organization in a way that makes sense for your team and configuration.  For example, you can create separate workspaces for each department, product, or business function. Each workspace manages their own clusters and role-based permissions, while retaining an overall organization-level view of all clusters in operation.

1.  In the upper-left hand corner of the screen (just to the right of the _Kommander_ label) click the pull-down menu and select _Default Workspace_

> For more information on Workspaces in Kommander, please see the following link:<br>
> https://docs.d2iq.com/dkp/kommander/latest/workspaces/


## Create a Project for your Workload
A Project, in this context, refers to a central location (Kommander) that hosts and pushes common configurations to all Kubernetes clusters, or a pre-defined subset group under Kommander management. That pre-defined subset group of Kubernetes clusters is called a Project.

1.  On the left-hand "I-Frame" click _Projects_.  This will take you to the Projects for the selected Workspace.  
2.  In the middle of the screen, click _Create Project_ to create a new project.
3.  In the _Create Project_ screen, complete the following entries.
- Project Name: `truck-demo`
- ID/Namespace: `truck-demo` (this field will be revealed once you have entered the "Project Name" text box above.)
- Description: `whatever you want`
- In the _Clusters_ selection of the page, click _Manually Select Clusters_ and place your cursor in the _Select Cluster_ text box
- Select `local-cluster` to add this cluster to the below list of selected clusters.
- Click the _Create_ button in the upper right corner of the screen to create the project.

If everything is done properly, you will see a popup menu with "Success" and a green checkmark.  

- Click _Continue to Project_ in the popup window.

> For more information on Projects in Kommander, please see the following link:<br>
> https://docs.d2iq.com/dkp/kommander/latest/projects/


## Deploy Project Platform Services
Project Platform Services are services that you want to be deployed on all the Kubernetes clusters associated with the Project, in the corresponding namespace.

1.  If not already selected, click the _Platform Services_ tab in the _Projects > truck-demo_ window

2.  Click the button in the middle of the screen labeled _View Catalog_ to view the catalog of platform services.

This displays the list of default catalog platform services that are easily deployed.  We will use thes catalog items to deploy our Data Services.  Each Data service deploys in a similar way:

3. Deploy "Zookeeper"
	- Click the _Zookeeper_ entry
	- Review the provided page and select defaults by clicking _Deploy_
	- In the _Display Name_ textbox, enter `zookeeper` (case sensitive)
	- This will auto-populate the "ID" textbox with the same entry.
	- Accept all other default entries
	- Click _Deploy_ in the upper right hand corner to deploy and instance of Zookeeper

4. Deploy "Kafka"
	- Click _View Catalog_ on the right side of the _Platform Services_ tab.
	- Click the _Kafka_ entry
	- Review the provided page and select defaults by clicking _Deploy_
	- In the _Display Name_ textbox, enter `kafka` (case sensitive)
	- This will auto-populate the _ID_ textbox with the same entry.
	- Review configuration options but DO NOT make any additional changes.
	- Click _Deploy_ in the upper right hand corner to deploy and instance of Kafka

5. Deploy "Cassandra"
	- Click _View Catalog_ on the right side of the _Platform Services_ tab.
	- Click the _Cassandra_ entry
	- Review the provided page and select defaults by clicking _Deploy_
	- In the _Display Name_ textbox, enter `cassandra` (case sensitive)
	- This will auto-populate the _ID_ textbox with the same entry.
	- Review configuration options but DO NOT make any additional changes.
	- Click _Deploy_ in the upper right hand corner to deploy and instance of Cassandra

4.  Wait until all Three Data Services (Zookeeper, Kafka, Cassandra) are completely deployed.
	-  Run the following command in a Terminal to watch the pods deploy
	```
	watch kubectl get pods -n truck-demo
	```
	-  It will take a few minutes for the services to complete deploying, and Kafka will not start to deploy until Zookeeper is done deploying as Zookeeper is a dependency for Kafka. When there are three instances of Zookeeper, Kafka, and Cassandra, as shown below, you can move to the next step:

```
NAME                    READY   STATUS    RESTARTS   AGE                                                                                                  
cassandra-node-0        1/1     Running   0          7m5s                                                                                                
cassandra-node-1        1/1     Running   0          6m20s                                                                                                
cassandra-node-2        1/1     Running   0          4m58s                                                                                                
kafka-kafka-0           2/2     Running   0          8m21s                                                                                                
kafka-kafka-1           2/2     Running   0          7m43s                                                                                                
kafka-kafka-2           2/2     Running   0          7m9s                                                                                                 
zookeeper-zookeeper-0   1/1     Running   0          10m                                                                                                  
zookeeper-zookeeper-1   1/1     Running   0          10m                                                                                                  
zookeeper-zookeeper-2   1/1     Running   0          10m     
```        
5.  Exit the previous command:
	```
	ctrl-c
	```
	
> For more information on "Project Platform Services" in Kommander, please see the following link:<br>
> https://docs.d2iq.com/dkp/kommander/latest/projects/platform-services/


## Create your "Project ConfigMaps"
Project ConfigMaps can be created to make sure Kubernetes ConfigMaps are automatically created on all Kubernetes clusters associated with the Project, in the corresponding namespace.

For this exercise we will create 3 Key/Value Pairs under a single ConfigMap

1.  Click the _ConfigMaps_ tab in the _Projects >  truck-demo_ screen.
2.  Click the _Create ConfigMap_ button in the middle of the screen
3.  Fill in the _Create ConfigMap_ Screen

- ID (name): `dataservices`
- Description: `whatever you want`
- Under the "Data" a Key/Value pair for Kafka by clicking `Add Key Value` and adding mthe entries below:
	- Key: `Kafka` (case sensitive)
	- Value: `kafka-kafka-0.kafka-svc.truck-demo.svc.cluster.local:9093`
- Add a Key/Value for cassandra Cassandra by clicking "Add Key Value" and adding the entries below:
	- Key: `Cassandra` (case sensitive)
	- Value: `cassandra-node-0.cassandra-svc.truck-demo.svc.cluster.local:9042`
- And a Key/Value for the "Truck API" by clicking "Add Key Value" and adding the entries below:
	- Key: `API` (case sensitive)
	- Value: <URL for Kommander Web Page (https:// through .com)"

- Click _Create_ in the upper right hand corner of the screen to create the Project ConfigMap

> For more information on _Project ConfigMaps_ in Kommander, please see the following link:
> https://docs.d2iq.com/dkp/kommander/latest/projects/project-configmaps/


## Create Microservice "Project Deployment"
Kommander Projects can be configured with GitOps based Continuous Deployments for federation of your Applications to associated clusters of the project.

1.  In the _Projects > truck-demo_ page click the _Continuous Deployment (CD)_ tab

2.  Click the _Add GitOps Source_ button in the middle of the screen.

3.  Fill in the _Create GitOps Source_ fields as shown below:
-  ID (name): `truck-demo-microservices`
-  Repository URL: `https://github.com/mesosphere/dkp-demo/`
-  Branch/Tag: `main`
-  Path: 
-  Primary Git Secret: `None`

4.  Click `Save` in the upper right hand of the page to save the GitOps Source

5.  Watch/ensure that your pod deployments come up by entering the following kubectl command:
	```
	watch kubectl get pods -n truck-demo
	```

When you see a screen that looks like the following, your application has successfully been deployed:
```
➜  dkp18xdeployment k get pods -n truck-demo
NAME                                       READY   STATUS    RESTARTS   AGE
cassandra-node-0                           1/1     Running   0          18m
cassandra-node-1                           1/1     Running   0          18m
cassandra-node-2                           1/1     Running   0          16m
helm-controller-ddc49d745-qnxv4            1/1     Running   0          9m16s
kafka-kafka-0                              2/2     Running   0          17m
kafka-kafka-1                              2/2     Running   0          17m
kafka-kafka-2                              2/2     Running   0          16m
kustomize-controller-86f6d9c7f5-l85jx      1/1     Running   0          9m16s
notification-controller-76db5d5595-cdz8g   1/1     Running   0          9m16s
source-controller-5b9b95d7dc-wq7ph         1/1     Running   0          9m16s
truck-data-api-6b94f4d57f-pmm5d            1/1     Running   0          9m4s
truck-data-connector-64776c664c-86tx7      1/1     Running   0          9m4s
truck-data-generator-b495898c6-cxrjn       1/1     Running   3          9m4s
truck-data-generator-b495898c6-rkpmt       1/1     Running   3          9m4s
truck-demo-ui-fcc87d97-22s8f               1/1     Running   0          9m4s
zookeeper-zookeeper-0                      1/1     Running   0          19m
zookeeper-zookeeper-1                      1/1     Running   0          19m
zookeeper-zookeeper-2                      1/1     Running   0          19m
```

## Open Truck Demo Application UI

1.  To determine the public facing endpoint for the truck demo application, execute the following command:
	```
	kubectl get svc truck-demo-ui-svc -n ProjectNamespace
	```

	You will see a response similar to the following:
	```
	NAME                TYPE           CLUSTER-IP    EXTERNAL-IP                                                               PORT(S)        AGE
	truck-demo-ui-svc   LoadBalancer   10.0.25.160   af29fd5e9f5d640efbbfcede326aac0b-1185872992.us-west-2.elb.amazonaws.com   80:31997/TCP   12m
	```

2.  Copy the External IP (similar to `af29fd5e9f5d640efbbfcede326aac0b-1185872992.us-west-2.elb.amazonaws.com`), paste it into a new browser window and prepend it with `http://` if the page does not automatically load.  You should now be presented with the home page for the DKP Workshop - Electric Truck Tracking Application 

> Be patient, it can take up to 5 minutes foir AWS LoadBalancers and DNS to update themselves completely.

## Be a kid again... Play With Your Trucks.

1. You should see 3 trucks on the road going across England using different routes "Cannonball Run" style.

2. If they have completed already, you can delete the jobs and their associated pods 
	```
	kubectl delete jobs truck-1 -n truck-demo
	kubectl delete jobs truck-2 -n truck-demo
	kubectl delete jobs truck-3 -n truck-demo
	kubectl delete pods truck-1-XXXXX -n truck-demo
	kubectl delete pods truck-2-XXXXX -n truck-demo
	kubectl delete pods truck-3-XXXXX -n truck-demo
	```
3. ..and redeploy the jobs from the yaml in the repository:
	```
	kubectl apply -f https://raw.githubusercontent.com/mesosphere/dkp-demo/main/truck-data-generator-1.yaml
	kubectl apply -f https://raw.githubusercontent.com/mesosphere/dkp-demo/main/truck-data-generator-2.yaml
	kubectl apply -f https://raw.githubusercontent.com/mesosphere/dkp-demo/main/truck-data-generator-3.yaml
	```

That's it.  Now, any Kubernetes clusters that are added to this project will automatically have this entire application stack pushed to it.

