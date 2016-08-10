# DeployArchive
This script can be used to convert an XCode archive build to an IPA and automatically deploy it to a connected device.

## Prerequisites
The following tools must be installed on the system:
* libimobiledevice (http://www.libimobiledevice.org/)
* ios-deploy (https://github.com/phonegap/ios-deploy)

## Usage
First, use XCode to create an archive build of your project. 

After the archive has been built, run this script in the root of your project directory without any arguments.

This script will automatically detect the most recent XCode archive build on your system and get the necessary project information from your project directory.

## Limitations
This script only works if you execute it in the project directory of the project that corresponds to the most recent archive build.
If you run it in a different project directory, you will get the following error message:
`2016-08-10 16:42:26.991 ios-deploy[97736:2386984] [ !! ] Error 0xe8008016: The entitlements specified in your application’s Code Signing Entitlements file do not match those specified in your provisioning profile. AMDeviceSecureInstallApplication(0, device, url, options, install_callback, 0)`
