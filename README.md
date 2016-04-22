# Creating Base Windows AMI with Packer

- Install packer (www.packer.io)
- Download the content of this directory to the packer machine.
- Ensure the variables of the packer template 'PackerInstance.json' are up to date.
- From this directory, run: packer build PackerInstance.json

# Notes


## Debugging

Packer can be run with the -debug flag, don't assume that because you've pressed enter after seeing 'Press enter to continue.' that it's actually continuing, to often need to wait a lot of minutes for it to be ready to progress (at which point pressing enter again will trigger packer to continue).