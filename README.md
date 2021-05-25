

##  Overview:
This setup will deploy a web application (https://hello.chirag.tr-talent.de) which leverages the aws kubernetes environment.

##  Setup:
I have tried to keep the setup bare minimum to efficiantly run the required components.
1. The `Terraform` setup contains the configuration for VPC, Subnets, Bashion, ECR and S3.
2. the rest of the setup has been done utilizing `Kops` to create the kubernetes cluster and on top of it, we deployed our docker image through AWS ECR.
3. The private subnets are used to house the control plane and worker nodes and public one can be used for the bashion host to further manage the kubernetes environment.
4. SSL offloading is done on the Loabbalancer using the domain certificate (created with ACM)


------------

##  Requirements:
```
1. Terraform Version: v0.14.11
2. Utilized Base Image: nginx:latest
3. SSH Private key for both master/node and bashion are shared via email.
4. Used AWS region - eu-central-1
```


------------


#### Steps used to deploy it from scratch -

`(I). Base Infra with Terraform: `
Created the base infrastructure that includes VPC, Subnets, route tables, EIP, NAT GW, IGW.
This will make use of the VPC module I have created in the modules/ dir.
```
$terraform init && terraform apply
```
`(II). Create kubernetes infra with KOPS using the existing VPC configuration: ` (hashed out original ids)

```
 1. kops create cluster \
   --name chirag.tr-talent.de \
   --cloud aws \
   --networking weave \
   --master-zones eu-central-1a  \
   --zones eu-central-1a,eu-central-1b  \
   --master-size t2.large  \
   --master-count 1  \
   --node-size t2.medium  \
   --node-count 2  \
   --ssh-public-key ~/.ssh/id_rsa.pub \
   --state s3://config-bucket-kops  \
   --topology private  \
   --vpc vpc-xx  \
   --subnets subnet-##,subnet-##  \
   --utility-subnets subnet-#,subnet-##
   
2. Make sure to add the existing egress (nat gateways) for private subnets using the below command and save the file
kops edit cluster chirag.tr-talent.de

3. kops update cluster --name chirag.tr-talent.de --yes --admin
(This could take 10-20 min to initialize the cluster)

4. verify if the control plane and nodes are ready
$kops validate cluster --wait 10m
```


`(III). Build and push the image to ECR -`

Make sure you have docker running on your system.

```
1. $docker build -t tr-talent
2. $docker tag tr-talent 572629984572.dkr.ecr.eu-central-1.amazonaws.com/tr_dev
##loging to ecr for temp token
3. $aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 572629984572.dkr.ecr.eu-central-1.amazonaws.com
4. $docker push 572629984572.dkr.ecr.eu-central-1.amazonaws.com/tr_dev:latest
```

`(IV). Deployment -`
kubectl apply -f deployment.yml
kubectl create -f service.yml
(check for the external name for nginx-lb)
kubectl get svc
Once the dns record for LB is ready, use it as a target and create a CNAME(hello.chirag.tr-talent.de)
wait for 5 min for the DNS propogation.
Test the setup with the below domain:
```
$curl https://hello.chirag.tr-talent.de
```

`(IV). Destroy the infrastructure -`
```
1. $kops delete cluster hello.chirag.tr-talent.de --yes

2. Note: make sure to exclude the tf state bucket during the initial destroy incase the files are important
$terraform destroy
```
Done!!


##### References:
The nginx.conf and mime.types are pulled with few modifications from the h5bp Nginx boilerplate project at
https://github.com/h5bp/server-configs-nginx
------------



