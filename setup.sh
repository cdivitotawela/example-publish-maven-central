#!/bin/bash

[[ -f ./private.key ]] || {
  echo "ERROR: Cannot find gpg private key"
  exit 1
}

# Import private key
gpg --import --passphrase $$MAVEN_GPG_PASSPHRASE --batch --yes ./private.key
