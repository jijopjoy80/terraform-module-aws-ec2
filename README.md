# module usage
```
module "http-instances"{
  source  = "jijopjoy80/aws-ec2/module"
  version = "<Specify the version you want to use>"
  instancecount=4
  ami="ami-053b0d53c279acc90"
  }
```
# Available Variables
```
vpcCidr
subnet1aCidr
subnet1bCidr
subnet1cCidr
imageId
instanceType
machineCount
allowSshAccessCidr
```

# Available Outputs
```
publicIP
arn
```
