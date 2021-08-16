# Edge GitOps DKP Truck Efficiency Demonstration

This Branch includes every YAML that should get deployed to an Edge Cluster.
Please make sure, that the central data cluster is ready.

## Prerequirements

* Access to Kommander/Konvoy connected environment
  * Kommander URL
  * Administrator User ID
  * Administrator Password
* `kubectl` configured on local desktop or some other host to access the cluster
* Access to the "Truck-Demo" GitHub Repository (this one)
  * <https://github.com/mesosphere/dkp-demo/>

## Log In to  Kommander with Provided Credentials at Provided URL

Kommander delivers visibility and management of any Kubernetes cluster, whether on-prem or cloud, regardless of distribution being used. Organizations can gain better control over existing deployments without service interruptions and create standardization around how new clusters are configured and used.

1. In a supported browser, enter the provided URL for your Kommander Cluster
2. Using the authentication mechanism specified in your instructions, log into the Kommander Cluster.
3. This will bring you to the "Home Dashboard" screen in the "Global" Workspace

> For more information on Kommander, please see the following link:
> <https://docs.d2iq.com/dkp/kommander/latest/introducing-kommander/>

## Create a Workspace: _Edge Clusters_

Workspaces give you the flexibility to represent your organization in a way that makes sense for your team and configuration.  For example, you can create separate workspaces for each department, product, or business function. Each workspace manages their own clusters and role-based permissions, while retaining an overall organization-level view of all clusters in operation.

1. In the left navigation click on Workspaces. Next, click on _Create Workspace_. This will show you the form to create a new workspace. Please provide a name like _Edge Clusters_ and click on Submit.

> For more information on Workspaces in Kommander, please see the following link:<br>
> <https://docs.d2iq.com/dkp/kommander/latest/workspaces><br>

> Advanced: *Another way to create a workspace is to use a yaml file, provided in the folder: Kommander Automation. To use it, please make sure you are conntected via kubectl to your Kommander Cluster. For creating, please use: `kubectl apply -f "edge-cluster-workspace.yaml`"*

## Create a Project for your Workload

A Project, in this context, refers to a central location (Kommander) that hosts and pushes common configurations to all Kubernetes clusters, or a pre-defined subset group under Kommander management. That pre-defined subset group of Kubernetes clusters is called a Project.

1. On the left-hand "I-Frame" click _Projects_.  This will take you to the Projects for the selected Workspace.  
2. In the middle of the screen, click _Create Project_ to create a new project.
3. In the _Create Project_ screen, complete the following entries.

* Project Name: `Edge Workloads`
* ID/Namespace: `edge-workloads` (this field will be revealed once you have entered the "Project Name" text box above.)
* Description: `whatever you want`
* In the _Clusters_ selection of the page, click _Manually Select Clusters_ and place your cursor in the _Select Cluster_ text box.
* Select `k0s-cluster` to add this cluster to the below list of selected clusters.
* Click the _Create_ button in the upper right corner of the screen to create the project.

If everything is done properly, you will see a popup menu with "Success" and a green checkmark.  

* Click _Continue to Project_ in the popup window.

> For more information on Projects in Kommander, please see the following link:<br>
> <https://docs.d2iq.com/dkp/kommander/latest/projects/>

> Advanced: *Another way to create a project is to use a yaml file, provided in the folder: Kommander Automation. To use it, please make sure you are conntected via kubectl to your Kommander Cluster. For creating, please use: `kubectl apply -f "edge-cluster-project.yaml`*

## Create your "Project ConfigMaps"

Project ConfigMaps can be created to make sure Kubernetes ConfigMaps are automatically created on all Kubernetes clusters associated with the Project, in the corresponding namespace.

For this exercise we will create one Key/Value Pair under a single ConfigMap

1. Click the _ConfigMaps_ tab in the _Projects >  truck-demo_ screen.
2. Click the _Create ConfigMap_ button in the middle of the screen
3. Fill in the _Create ConfigMap_ Screen

* ID (name): `data-endpoints`
* Description: `This ConfigMap contains the Kafka Endpoint that will be used to stream the data from the Edge Cluster to the central data cluster.`
* Under the "Data" a Key/Value pair for Kafka by clicking `Add Key Value` and adding mthe entries below:
  * Key: `Kafka` (case sensitive)
  * Value: `https://traefik-lb-address:9093`

* Click _Create_ in the upper right hand corner of the screen to create the Project ConfigMap

> For more information on _Project ConfigMaps_ in Kommander, please see the following link:<br>
> <https://docs.d2iq.com/dkp/kommander/latest/projects/project-configmaps/>

> Advanced: *Another way to create a configmap in a project is to use a yaml file, provided in the folder: Kommander Automation. To use it, please make sure to add the Traefik LoadBalancer Address of your central data cluster and that you are conntected via kubectl to your Kommander Cluster. For creating, please use: `kubectl apply -f "edge-cluster-configmap.yaml`*

## Create Edge Microservices "Project Deployment"

Kommander Projects can be configured with GitOps based Continuous Deployments for federation of your Applications to associated clusters of the project.

1. In the _Projects > Edge Workloads_ page click the _Continuous Deployment (CD)_ tab

2. Click the _Add GitOps Source_ button in the middle of the screen.

3. Fill in the _Create GitOps Source_ fields as shown below:

* ID (name): `edge-demo-microservices`
* Repository URL: `https://github.com/mesosphere/dkp-demo/`
* Branch/Tag: `edge`
* Path:
* Primary Git Secret: `None`

4. Click `Save` in the upper right hand of the page to save the GitOps Source

5. Watch/ensure that your pod deployments come up by entering the following kubectl command:

```
watch kubectl get pods -n edge-workloads
```

When you see a screen that looks like the following, your application has successfully been deployed:
```
➜  kubectl get pods -n edge-workloads
NAME                                       READY   STATUS    RESTARTS   AGE
helm-controller-ddc49d745-qnxv4            1/1     Running   0          9m16s
kustomize-controller-86f6d9c7f5-l85jx      1/1     Running   0          9m16s
notification-controller-76db5d5595-cdz8g   1/1     Running   0          9m16s
source-controller-5b9b95d7dc-wq7ph         1/1     Running   0          9m16s
truck-data-api-6b94f4d57f-pmm5d            1/1     Running   0          9m4s
truck-data-generator-b495898c6-cxrjn       1/1     Running   3          9m4s
truck-data-generator-b495898c6-rkpmt       1/1     Running   3          9m4s
truck-data-generator-b495898c6-usfdt       1/1     Running   3          9m4s
```

That's it.  Now, any Edge Clusters like (like k0s) that are added to this project will automatically have this entire application stack pushed to it.