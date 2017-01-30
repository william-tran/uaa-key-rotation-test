# uaa-key-rotation-test
A UAA server config and some scripts to test key rotation support

## Setup
Add this to your /etc/hosts:
```
127.0.0.1 test.localhost
```

## Running UAA

```
$ mvn cargo:run
```

After UAA starts up, in a new tab:

```
$ ./init.sh
```

This will create the test identity zone that can be used to perform key rotations, with the active signing key set to 0.pem, and the public keys of 0.pem and 1.pem in the JWKS. It will also create a client that you can get a token for.

## Perform a key rotation

Included are ten keys with IDs 0-9. 

```
$ ./rotate.sh [one or more keys]
```

This will cause http://test.locahost:8080/uaa/token_keys to return a JWKS containing the list of keys public keys specified in the command. The active key used for sigining new tokens and returned by http://test.locahost:8080/uaa/token_key is set to the first argument. For example:

```
$ ./rotate.sh 0 1 2
```

will cause /token_keys to return the public key components of 0.pem, 1.pem, and 2.pem, and set the active signing key to 0.pem.

## Get a token

```
$ curl http://myclient:mysecret@test.localhost:8080/uaa/oauth/token -d'grant_type=client_credentials'
``` 

Then use this token against a resource server.

## Acceptance testing

1. Setup and run UAA as described above.
1. Configure a resource server app to use JWT verification keys from http://test.locahost:8080/uaa/token_keys
1. Get a token and hit the resource server with it. The resource server should validate the token.
1. Rotate keys, using `1` as the active key ID.
1. Get a new token and hit the resource server with it. The resource server should validate the token, ideally without having to re-fecth token_keys.

Implementations of JWKS JWT validation could poll the /token_keys endpoint, and as long as the time between the introduction of a new key, and its use as the active signing key, is greater than the polling frequency, then the validation process shouldn't encounter a `kid` "miss". The previous signing key also should be retained in the JWKS until all tokens that it signed have expired. 
