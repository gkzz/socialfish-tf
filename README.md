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

## Execute "sudo shutdown -r now", if you'd like to change hostname
# ec2 $ sudo shutdown -r now

ec2 $ python3 SocialFish.py youruser yourpassword
```


## Technology Used

## Usage

## Notes