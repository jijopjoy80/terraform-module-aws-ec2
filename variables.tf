variable "vpcCidr" {
  type = string
  default = "10.10.0.0/16"
}

variable "subnet1aCidr" {
  type = string
  default = "10.10.1.0/24"
}

variable "subnet1bCidr" {
  type = string
  default = "10.10.2.0/24"  
}

variable "subnet1cCidr" {
  type = string
  default = "10.10.3.0/24"  
}

variable "imageId" {
  type = string
  default = "ami-0cfe39d5e0c8e331a"
}

variable "instanceType" {
  type = string
  default = "t3.micro"
}

variable "machineCount" {
  type = string
  default = 4
}

variable "allowSshAccessCidr" {
  type = string
  default = "0.0.0.0/0"
}
