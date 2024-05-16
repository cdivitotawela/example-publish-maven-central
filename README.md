# Example Publish to Maven Central
This is an example of publishing Java package to Maven Central. This example use the new Portal to publish the artifacts. Currently new Central portal does not support publishing snapshots.

## GPG Key Generation
Create gpg key pair with following command. This will be required when signing the artifacts to publish.
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

# Export the private key armor
gpg --export-secret-key -a > private.key

# If there are multiple keys specify the key id
gpg --export-secret-key -a <key id> > private.key
```


## Sign Artifacts
Maven plug-in `maven-gpg-plugin` is used to sign the artifacts. This information is useful if the signing
is performed manually.

Each artifact need to be signed using the gpg key. Following command is used get the signature in a separate file
This creates the <artifact>.asc file with the signature.
```sh
# Create signature for the artifact in separate file (-b option to create separate file)
gpg -ab --local-user <secret key id> <artifact>
```


## Local Testing
Following setup starts a Docker container.
```sh
# Export secrets
export MAVEN_GPG_PASSPHRASE=<gpg passphrase>
export CENTRAL_USERNAME=<central portal username>
export CENTRAL_PASSWORD=<central portal token>

# Starting docker container
docker run -it \
  -v $PWD:/home/circleci/project \
  -v $PWD/m2:/home/circleci/.m2 \
  -e "MAVEN_GPG_PASSPHRASE=$MAVEN_GPG_PASSPHRASE" \
  -e "CENTRAL_USERNAME=$CENTRAL_USERNAME" \
  -e "CENTRAL_PASSWORD=$CENTRAL_PASSWORD" \
  cimg/openjdk:11.0.22

# Run the setup.sh inside the container. This will import the private key
./setup.sh

# Maven command to build the artifacts and sign
mvn verify

# Maven command to publish to central. During this process hash are generated before publish
mvn deploy
```


## GitHub Action Setup
GitHub action requires GPG private key and passphrase in GitHub action secrets.

| GitHub Secret    | Description                                                           |
|------------------|-----------------------------------------------------------------------|
|`GPG_BASE64_KEY`  | base64 encoded private key `gpg --export-secret-key -a > private.key` |
|`GPG_PASSPHRASE`  | gpg key passphrase                                                    |
|`CENTRAL_USERNAME`| central username obtained via central portal                          |
|`CENTRAL_PASSWORD`| central password obtained via central portal                          |


## References
- https://central.sonatype.org/publish/publish-portal-maven/
- https://medium.com/simform-engineering/publishing-library-in-maven-central-part-1-994c5fe0c004#b85c