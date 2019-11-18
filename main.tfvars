## profile IBS #############
aws_iam_role_ecsservice_name = "ECSServiceRole"
ec2_lc_ecs_iam_role_profile = "EC2RoleforECS"
ecsTaskExecutionRoleName = "ECSTaskRole"

####################################
#EC2 Instance config for ECS Cluster
ec2_instance_type = "m5.large"  # 2vcpu 4GB RAM
ec2_instance_type_ihg="m5.large"
ec2_instance_type_logstash="m5.large"
ec2_instance_type_docdb = "db.r5.large"
###########################

#### EC2 Instance Limit per clusters######
min_size_search = 2 # 3 ss + 3 mds
min_size_jmeter = 0
min_size_ihg = 1
min_size_logstash = 2

max_size_search = 30 # 20 ss + 10 mds
max_size_jmeter=12
max_size_ihg=10
max_size_logstash = 3

#TODO: Valdate task scaling
#### Contaniner Limits #################
taskdefinition_count_search=1
taskdefinition_count_mds=1
taskdefinition_count_searchcache=1
taskdefinition_count_cdsclient=1
taskdefinition_count_jmeter=0

####################################
docker_tag_search ="staging"
docker_tag_mds ="staging"
docker_tag_searchcache ="staging"
docker_tag_cdsclient ="staging"
####################################

jenkinsname = "jenkins"
jenkins_context = "jenkins"
jenkins_container_port = "8080"
####################################
terraformname = "terraform"
terraform_context = "terraform"
healthcheckendpoint ="swagger-ui.html"
##########################
documentdbusername="dgneoadmin"
elasticache_username ="dgneomaster"
postgres_username = "dgneomaster"
##########################
ec2_instance_type_jmeter="c5.xlarge"
###########################
bastion_count=1
##########################
#Autoscaling EC2 Count ###########
desired_capacity_jmeter=5
//desired_capacity_ihg=1
//desired_capacity_dgneo=3
desired_capacity_logstash=2
##################################
#IHG params
###########################
trigger_oneoff_script="firstrunagain"
golddbip="10.210.3.10"

#### Autoscaling target CPU percent########
target_cpu_percent=70