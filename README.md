# terraform-lb-autoscaling
Creating wordpress and mysql rds in private subnet and making them publicly accessible through ALB and autoscaling.

Steps for making wordpress in private Ec2 and accesssing it publicly through ALB and autoscaling it
1) Configure the AWS provider. Provide aws region and access_key and secret_key.
2) Create AWS VPC.
3) Create two Public subnets and internet gateway. Create Route table for public subnet and mention internet gateway id in route table so that it can access internet.
4) Create two route table association table and attach both public subnet to it.
5) Make Elastic IP and allocate eip to  nat-gateway which will be created in public subnet.
6)  Create two Private subnets. Create Route table for private subnet and associate nat-gateway with it.
7) Create route table association table and attach both private subnet with it.
8) Create Private instance in private subnet and provide security group and key-pair to it.
9) Create One public Instance in public subnet . It will be used as bastion host to configure wordpress in  private ec2 instance.
10) Create one Mysql RDS and provide both private subnet in subnet_ids as rds require atleast two subnets to get created.
11)Create Security group for Mysql rds which allow 3306 and 22 port for ingress.
12)Take SSH of bastion host and from bastion host take SSH of private ec2 instance by copying private key of private ec2 instance in bastion host then changing its permission to 400  then using it for SSH.
13) In Private instance, install packages of httpd, php-gd, php, php-mysql, php-bcmath php-cli php-common php-dba php-devel php-embedded php-enchant php-gd -y
  # amazon-linux-extras install -y php7.2
14) Start the httpd and php-fpm service and enable it.
15) wget http://wordpress.org/latest.tar.gz and extract the contents.
     # tar xzvf latest.tar.gz
16) Copy the all extracted content of wordpress to /var/www/html/  .
    # rsync -avP wordpress/ /var/www/html/
17) Give 777 permission to wordpress directory.
    # chmod -R 777 wordpress
18) Give ownership of all files to apache user.
   # chown -R apache:apache /var/www/html/*
19) Restart the apache and php-fpm service.
20) Take Login of bastion host and install mysql package in it.
21)  Using bastion host take login of mysql RDS and create database named "wordpress" in it.
   # mysql -h host_name(endpoint of rds) -u username -p database_name
 22) Create Application Load balancer and provide public subnets in subnets field. Create security group for the ALB for incoming request on port 80 .
23)  Create Target group and provide "target_group_arn" and "target_id" of instance
which is to be attached to target group.
24) Create ALb listener which will listen on port 80 of "HTTP" Protocol and set the default action type to "forward".
25) Create ALB listener rule and set action type to "forward" on " target_group_arn" and in condition, path_pattern will look for values "/" .
26) Take DNS hostname of ALB, put "/wordpress" after it and ping on browser.
 27) Wordpress will ask for the mysql db_name, username, password, db_host. Put all the required credentials from mysql rds which you specified during rds creation.
28) You will be asked to provide username and password for wordpress.
29) Create AMI of the private instance where wordpress is installed and working.
30) Create Autoscaling, first create launch configuration. Provide previously created AMI id in "image_id" and provide "key_name" and security group used in private ec2.
31) Create Autoscaling_group defining "min_size", "max_size",  "target_group_arns", "health_check_grace_period", "health_check_type".
32) Create autoscaling_policy for adding instance and removing instance during CPU load up and down.
33) Create cloudwatch_metric_alarm describing when will autoscaling will trigger and what actions will they be performing in what situation for adding and removing instance.

