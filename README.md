# elb-vpc
 WHAT WILL BE THE RESULTS??
        
        1) It will create a  VPC
        2) It will create 4 subnets 2 private 2 public
        3) It will create a route table , IG, EIP,NAT and a SG 
        4) It will create one RDS in private subnet
        5) It will create one elb and one server , which will come under elb
        6) Server will install nginx
        7) outputs.tf will give you the dns of elb
        8) If everything's well you should be able to see nginx default page , if you hit the elb dns.

Prerequisites:
1) AWS cli should be configured with your access and secret keys
2) aws - ami is choosen to be us-east-1 , kindly configure the same region
3) you should at least have 1 pem  key created by your user
4) install terraform



Steps:
1) Clone the repository
2) terraform init
3) terraform apply 
        a) It will ask for key-name, kindly give the name of the pem key, created by your user
        b) after checking all the modules, It will ask for confirmation , you will have to enter 'yes' and, rest is done  by terraform
