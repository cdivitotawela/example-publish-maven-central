# Example Publish to Maven Central
This is an example of publishing Java package to Maven Central. This example use the new Portal where publish is performed
using the Central publish API. 


## GPG Key Generation
Create gpg key pair with following command. Use a passphrase to protect the key.
```sh
# Generate key
gpg --gen-key

# List key and verify key has been created and note the key id
gpg --list-keys

# Distribute public key. Following servers can be used to distribute the keys
# keyserver.ubuntu.com keys.openpgp.org pgp.mit.edu
gpg --keyserver keyserver.ubuntu.com --send-keys <keyId>

# Verify key has been sent to the keyservers with following command
gpg --keyserver keyserver.ubuntu.com --recv-keys <keyId>

# If the ring has multiple keys it is neccessary to specify the secret key when signing
# So list the secret keys and make a note of the key id
gpg --list-secret-keys
```


## Sign Artifacts
Each artifact need to be signed using the gpg key. Following command is used get the signature in a separate file
This creates the <artifact>.asc file with the signature.
```sh
# Create signature for the artifact in separate file (-b option to create separate file)
gpg -ab --local-user <secret key id> <artifact>
```
