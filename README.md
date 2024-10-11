# A certificate authority for your home

This is a small collection of bash-scripts to create a certificate authority for your home network.

Getting started:

## Prerequisites

* `openssl` needs to be installed
* `bash` needs to be installed
* Depending on how you want to install your certificates, you might need `ssh`, `sudo` or other tools
 
## Clone the repository

Git clone ..., you know the drill

**All commands must be run in the root directory of this repository.**

## Edit the configuration

Rename the file `microca-config.example.sh` to `microca-config.sh`.
Edit `microca-config.sh` and adjust the variables to your liking

Run the script `bin/init.sh` to generate directories and the root certificate.
Import the root-certificate to all browsers and machines that need it.

## Add a site

If you want to create a server certificate with common name "www.example.com" create 
a file `./sites/www.example.com.v3.ext` containing the X509V3 extension values for this certificate.
This includes the subject alternative name and other values. Have a look at [sites-example](sites-example) for details.

For each file "sites/*.v3.ext", one certificate will be generated. Keys are stored in the `./private` directory. Certificates
are stored in the `./certs` directory.

You can also provide a script `./sites/www.example.com.install.sh` to install the certificates on the server. This script 
will be called as `./sites/www.example.com.install.sh <key-file> <certificate-file>`

Run the following command:

```bash
bin/update-sites.sh
```

This will generate all keys and certificates and run the install-scripts.


## Credits

I collected the necessary information from [Armin Reiter's blog](https://arminreiter.com/2022/01/create-your-own-certificate-authority-ca-using-openssl/).

Another article can be found on [deliciousbrain](https://deliciousbrains.com/ssl-certificate-authority-for-local-https-development/)

## Other tools

* https://github.com/jsha/minica - I didn't try this tool, because I did not want to install `golang` on my Raspberry PI.  
* https://github.com/paultag/minica: This is the one that is installed when you run `apt install minica` on Ubuntu. I tried
  it but discarded it, because the expiry date of certificate could not be customized. I want longer expiry for the CA root.
* https://github.com/FiloSottile/mkcert - I saw this too late and haven't tried it


## Root Certificates in Chrome on Linux

When you use Chrome or derivatives of Chrome on Linux, it does not help to put the certificate into the folder
`/usr/local/share/ca-certificates` and run `update-certificates`.
You have to open [chrome://settings/certificates](chrome://settings/certificates), go to the Authorities Tab and import it there.