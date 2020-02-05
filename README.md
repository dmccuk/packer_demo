## Packer demo (Introduction to packer)

Follow along to create your own AMI image in EC2.

 * **If you use this code, it will cost you some AWS Dollars:**
 
 ## Requirements:

 * install awscli and use this to hold you AWS ACCESS & SECRET keys
 * You'll need to install Packer (https://www.packer.io/downloads.html)
 * This demo was performed on a Ubuntu 18.04.3 LTS
 * Linux packages required (install these): git wget unzip
 * Clone the REPO: git clone https://github.com/dmccuk/packer_demo.git

## commands:
````
Commands:
$ mkdir packer
$ cd packer
$ wget https://releases.hashicorp.com/packer/1.5.1/packer_1.5.1_linux_amd64.zip
$ unzip packer_1.5.1_linux_amd64.zip
$ sudo mv packer /usr/local/bin/
$ packer
Usage: packer [--version] [--help] <command> [<args>]

Available commands are:
    build       build image(s) from template
    console     creates a console for testing variable interpolation
    fix         fixes templates from old versions of packer
    inspect     see components of a template
    validate    check that a template is valid
    version     Prints the Packer version

$ git clone https://github.com/dmccuk/packer_demo.git
Cloning into 'packer_demo'...
remote: Enumerating objects: 17, done.
remote: Counting objects: 100% (17/17), done.
remote: Compressing objects: 100% (15/15), done.
remote: Total 17 (delta 4), reused 7 (delta 1), pack-reused 0
Unpacking objects: 100% (17/17), done.
Checking connectivity... done.

$ cd packer_demo/
$ ls -al
total 28
drwxrwxr-x 3 vagrant vagrant 4096 Feb  5 15:42 .
drwxrwxr-x 3 vagrant vagrant 4096 Feb  5 15:42 ..
-rw-rw-r-- 1 vagrant vagrant  211 Feb  5 15:42 example.sh
drwxrwxr-x 8 vagrant vagrant 4096 Feb  5 15:42 .git
-rw-rw-r-- 1 vagrant vagrant 1153 Feb  5 15:42 image1.json
-rw-rw-r-- 1 vagrant vagrant 4353 Feb  5 15:42 README.md
````

## example .json file

Create a file called images1.json and copy the contents below into it:

````
{
    "variables": {
        "aws_access_key": "{{env `AWS_ACCESS_KEY_ID`}}",
        "aws_secret_key": "{{env `AWS_SECRET_ACCESS_KEY`}}",
        "region":         "us-east-1"
    },
    "builders": [
        {
            "access_key": "{{user `aws_access_key`}}",
            "ami_name": "LondonIAC-packer-aws-demo-{{timestamp}}",
            "instance_type": "t2.micro",
            "region": "{{user `region`}}",
            "secret_key": "{{user `aws_secret_key`}}",
            "source_ami_filter": {
              "filters": {
              "virtualization-type": "hvm",
              "name": "ubuntu/images/*ubuntu-xenial-16.04-amd64-server-*",
              "root-device-type": "ebs"
              },
              "owners": ["099720109477"],
              "most_recent": true
            },
            "ssh_username": "ubuntu",
            "type": "amazon-ebs"
        }
    ],
    "provisioners": [
        {
            "type": "shell",
            "inline":[
                "ls -al /home/ubuntu",
                "df"
            ]
        },
        {
            "type": "shell",
            "script": "./example.sh"
        }
    ]
}
````

  * Update the region (default is eu-east-1)
  * Give it a base AMI image name. Default is ubuntu Xenial:
    * ("name": "ubuntu/images/*ubuntu-xenial-16.04-amd64-server-*",)
  * Enter the AWS keys or just use awscli to manage them for you.

## Build script

Create a file called example.sh with this contents:

````
#!/bin/bash
set -x # see all output

# upgrade step
sudo apt update -yq # update the repos
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -yq # upgrade the OS
sudo apt install git nginx -yq # install git and nginx

# setup application
sudo mv /var/www/html /var/www/_html_orig
sudo git clone https://github.com/dmccuk/webapp1.git /var/www/html # clone our application in GIT
sudo systemctl enable nginx # enable nginx
````

## First build

Now all we need to do is run the following command:

````
$ packer build image1.json
````

Check the output. At the end you should see something like this:

````
==> Builds finished. The artifacts of successful builds are:
--> amazon-ebs: AMIs were created:
us-east-1: ami-078042f4aa5654a94
````

Let build with our new AMI image and see if it worked!

  * So just a straight build in the AWS console (search for you AMI-ID). This could just as easily be built using Terraform.
  * Make sure that for the demo, you open up port 80 for all incoming connections.
  * Once the VM is up, hit the IP address in a browser. Be prepared for webpage retro heaven 😊

That’s it.

Have fun and enjoy.

After running the above example, your AWS account now has an AMI associated with it. AMIs are stored in S3 by Amazon, so unless you want to be charged about $0.01 per month, you'll probably want to remove it. Remove the AMI by first deregistering it on the AWS AMI management page. Next, delete the associated snapshot on the AWS snapshot management page.

More info here:
https://www.packer.io/intro/getting-started/build-image.html#managing-the-image


Follow us on Linkedin:
https://www.linkedin.com/company/londoniac
