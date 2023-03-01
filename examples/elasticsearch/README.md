We define the ES cluster,
- the vpc, the subnet, the name of the cluster, the route53 hostzoneID and DNS.
- the ES version, type of instance, number of instance. If dedicated masters or not, if AZ or not.
If volume size is specified it will use EBS. Otherwise it will use instance storage. Depends on the instance type if supported or not !
- number of shards and replicas. To create a lambda cleanup function and how old the data can be before being deleted

