# Building SocialFish with Terraform

<img src="/docs/img/socialfish_demo.png" alt="socialfish_demo" style="max-width:5%;">

Special Thanks to

- [UndeadSec/SocialFish](https://github.com/UndeadSec/SocialFish)

- [Getting latest Ubuntu AMI with Terraform](https://www.andreagrandi.it/2017/08/25/getting-latest-ubuntu-ami-with-terraform/)

- [TerraformでVPC・EC2インスタンスを構築してssh接続する - Qiita](https://qiita.com/kou_pg_0131/items/45cdde3d27bd75f1bfd5)


## TL; DR

```
local $ git clone 
local $ terraform init

## Edit terraform.tfvars

local $ terraform apply

ec2 $ . init.sh

ec2 $ python3 SocialFish.py youruser yourpassword
```


## Technology Used

```
ec2 $ cat SocialFish/requirements.txt
requests==2.20.0
PyLaTeX==1.3.0
python-nmap
qrcode==6.1
Flask==1.0.2
colorama==0.4.1
Flask_Login==0.4.1
nmap==0.0.1
python-secrets
ubuntu@web:~/SocialFish$ 
```

## Notes

- Display directory tree
  - on local
```
local $ tree -I docs
.
├── describe_images.sh
├── LICENSE
├── main.tf
├── output.tf
├── provider.tf
├── README.md
├── terraform.tfstate
├── terraform.tfstate.backup
├── terraform.tfvars
├── terraform.tfvars.tmpl
├── user_data.sh
├── vars.tf
└── vpc.tf

0 directories, 13 files
```

  - on Amazon EC2
```
ubuntu@web:~$ tree -L 2
.
├── SocialFish
│   ├── CODE_OF_CONDUCT.md
│   ├── CONTRIBUTING.md
│   ├── LICENSE
│   ├── README.md
│   ├── SocialFish.py
│   ├── __init__.py
│   ├── core
│   ├── images
│   ├── requirements.txt
│   └── templates
└── init.sh

4 directories, 8 files
ubuntu@web:~$

```


- Check AMI ID
  - of ubuntu18.04
```
local $ bash describe_images.sh -u
get ami id of ubuntu18.04
--------------------------------------------------------------------------------------------------------
|                                            DescribeImages                                            |
+--------------------+---------------------------------------------------------------------------------+
|  Architecture      |  x86_64                                                                         |
|  CreationDate      |  2020-07-16T20:04:57.000Z                                                       |
|  Description       |  Canonical, Ubuntu, 18.04 LTS, amd64 bionic image build on 2020-07-16           |
|  EnaSupport        |  True                                                                           |
|  Hypervisor        |  xen                                                                            |
|  ImageId           |  ami-097b5c97a02fdf8f0                                                          |
|  ImageLocation     |  099720109477/ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-20200716   |
|  ImageType         |  machine                                                                        |
|  Name              |  ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-20200716                |
|  OwnerId           |  099720109477                                                                   |
|  PlatformDetails   |  Linux/UNIX                                                                     |
|  Public            |  True                                                                           |
|  RootDeviceName    |  /dev/sda1                                                                      |
|  RootDeviceType    |  ebs                                                                            |
|  SriovNetSupport   |  simple                                                                         |
|  State             |  available                                                                      |
|  UsageOperation    |  RunInstances                                                                   |
|  VirtualizationType|  hvm                                                                            |
+--------------------+---------------------------------------------------------------------------------+
||                                         BlockDeviceMappings                                        ||
|+-----------------------------------------------------+----------------------------------------------+|
||  DeviceName                                         |  /dev/sda1                                   ||
||  VirtualName                                        |                                              ||
|+-----------------------------------------------------+----------------------------------------------+|
|||                                                Ebs                                               |||
||+---------------------------------------------+----------------------------------------------------+||
|||  DeleteOnTermination                        |  True                                              |||
|||  Encrypted                                  |  False                                             |||
|||  SnapshotId                                 |  snap-0dcbcdc17b9907997                            |||
|||  VolumeSize                                 |  8                                                 |||
|||  VolumeType                                 |  gp2                                               |||
||+---------------------------------------------+----------------------------------------------------+||
||                                         BlockDeviceMappings                                        ||
|+---------------------------------------------------+------------------------------------------------+|
||  DeviceName                                       |  /dev/sdb                                      ||
||  VirtualName                                      |  ephemeral0                                    ||
|+---------------------------------------------------+------------------------------------------------+|
||                                         BlockDeviceMappings                                        ||
|+---------------------------------------------------+------------------------------------------------+|
||  DeviceName                                       |  /dev/sdc                                      ||
||  VirtualName                                      |  ephemeral1                                    ||
|+---------------------------------------------------+------------------------------------------------+|
local $
```

  - of Amazon Linux2
```
local $ describe_images.sh -l
get ami id of amazon linux2
----------------------------------------------------------------------------
|                              DescribeImages                              |
+---------------------+----------------------------------------------------+
|  Architecture       |  x86_64                                            |
|  CreationDate       |  2020-06-23T06:09:26.000Z                          |
|  Description        |  Amazon Linux 2 AMI 2.0.20200617.0 x86_64 HVM gp2  |
|  EnaSupport         |  True                                              |
|  Hypervisor         |  xen                                               |
|  ImageId            |  ami-06ad9296e6cf1e3cf                             |
|  ImageLocation      |  amazon/amzn2-ami-hvm-2.0.20200617.0-x86_64-gp2    |
|  ImageOwnerAlias    |  amazon                                            |
|  ImageType          |  machine                                           |
|  Name               |  amzn2-ami-hvm-2.0.20200617.0-x86_64-gp2           |
|  OwnerId            |  137112412989                                      |
|  PlatformDetails    |  Linux/UNIX                                        |
|  Public             |  True                                              |
|  RootDeviceName     |  /dev/xvda                                         |
|  RootDeviceType     |  ebs                                               |
|  SriovNetSupport    |  simple                                            |
|  State              |  available                                         |
|  UsageOperation     |  RunInstances                                      |
|  VirtualizationType |  hvm                                               |
+---------------------+----------------------------------------------------+
||                           BlockDeviceMappings                          ||
|+------------------------------------+-----------------------------------+|
||  DeviceName                        |  /dev/xvda                        ||
|+------------------------------------+-----------------------------------+|
|||                                  Ebs                                 |||
||+--------------------------------+-------------------------------------+||
|||  DeleteOnTermination           |  True                               |||
|||  Encrypted                     |  False                              |||
|||  SnapshotId                    |  snap-09775bee95bb729cd             |||
|||  VolumeSize                    |  8                                  |||
|||  VolumeType                    |  gp2                                |||
||+--------------------------------+-------------------------------------+||
local $
```