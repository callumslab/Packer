# Creating Base Windows AMI with Packer

- Install packer (www.packer.io)
- Download the content of this directory to the packer machine.
- Ensure the variables of the packer template 'PackerInstance.json' are up to date.
- From this directory, run: packer build PackerInstance.json

# Notes

## Debugging

Packer can be run with the -debug flag, don't assume that because you've pressed enter after seeing 'Press enter to continue.' that it's actually continuing, to often need to wait a lot of minutes for it to be ready to progress (at which point pressing enter again will trigger packer to continue).

## Using WinRM with SSL

There is a PackerInstanceSsl.template file, I've not yet got this working.

The following blogs may assist with doing this:
- http://jen20.com/2015/04/02/windows-amis-without-the-tears.html
- http://www.hurryupandwait.io/blog/understanding-and-troubleshooting-winrm-connection-and-authentication-a-thrill-seekers-guide-to-adventure
