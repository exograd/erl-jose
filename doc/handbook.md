# Introduction
This repository contains development notes about the `erl-jose` library.

# Versioning
The following `jose` versions are available:
- `0.y.z` unstable versions.
- `x.y.z` stable versions: `jose` will maintain reasonable backward
  compatibility, deprecating features before removing them.
- Experimental untagged versions.

Developers who use unstable or experimental versions are responsible for
updating their application when `jose` is modified. Note that unstable
versions can be modified without backward compatibility at any time.

# Terminology
These terms are used by this documentation:
- **JSON Web Signature (JWS):** A data structure representing a digitally signed
  or MAC message.
- **JSON Web Token (JWT):** A string representing a set of claims as a JSON
  object that is encoded in a JWS or JWE, enabling the claims to be digitally
  signed or MACed and/or encrypted.
- **JOSE Header:** JSON object containing the parameters describing the
  cryptographic operations and parameters employed.
- **JWS Payload:** The sequence of octets to be secured. The payload can contain
  an arbitrary sequence of octets.
- **JWS Signature:** Digital signature or MAC over the JWS Protected Header and
  the JWS Payload.
- **Header Parameter:** A name/value pair that is member of the JOSE Header.

These terms are defined by the documentation:
- **Certificate store:** A database that stores certificates to make trust
  decisions when decoding JWS.

# JSON Web Key (JWK)
The JWK is currently not supported.

# JSON Web Signature (JWS)
## Supported algorithms
The table below describes supported signature algorithms:
| "alg" param value | Digital signature or MAC algorithms            | Supported |
|-------------------|------------------------------------------------|-----------|
| HS256             | HMAC using SHA-256                             | YES       |
| HS384             | HMAC using SHA-384                             | YES       |
| HS512             | HMAC using SHA-512                             | YES       |
| RS256             | RSASSA-PKCS1-v1_5 using SHA-256                | YES       |
| RS384             | RSASSA-PKCS1-v1_5 using SHA-384                | YES       |
| RS512             | RSASSA-PKCS1-v1_5 using SHA-512                | YES       |
| ES256             | ECDSA using P-256 and SHA-256                  | YES       |
| ES384             | ECDSA using P-384 and SHA-384                  | YES       |
| ES512             | ECDSA using P-521 and SHA-512                  | YES       |
| PS256             | RSASSA-PSS using SHA-256 and MGF1 with SHA-256 | NO        |
| PS384             | RSASSA-PSS using SHA-384 and MGF1 with SHA-384 | NO        |
| PS512             | RSASSA-PSS using SHA-512 and MGF1 with SHA-512 | NO        |
| none              | No digital signature or MAC performed          | YES       |

Only algorithms used by Exograd are implemented and there is no plan to
support more algorithms at the moment.

## Encode
### Compact
Encode JWS in compact format can be done with:
```erlang
Header = #{alg => hs256},
Payload = <<"signed message">>,
Key = <<"secret key">>,
jose_jws:encode_compact({Header, Payload}, hs256, Key).
```

The library understands and processes the `b64` header name. Encode JWS in
compact format with non-base64url encoded payload can be done with:
```erlang
Header = #{alg => hs256, b64 => false, crit => [<<"b64">>]},
Payload = <<"signed message not base64 encoded">>,
Secret = <<"secret key">>,
jose_jws:encode_compact({Header, Payload}, hs256, Key).
```

### JSON
The JSON format is currently not supported.

### Flattened JSON
The Flattened JSON format is currently not supported.

## Decode
The library understands and processes `x5c`, `x5t`, `x5t#S256`, `x5u`, `jku`,
`jwk`, and `kid` header name to collect potential verify keys. For each
collected key a trust decision is done by querying the [certificate
store](#certificate-store) and the [key store](#key-store).

**NOTE:** when the alg refers to a symmetric key each collected key is
evaluated as not trustable to not allow JWS crafting by an attacker.

### Compact
Decode JWT can be done with:
```erl
Token = <<"...">>,
{ok, JWS} = jose_jws:decode_compact(Token, hs256, <<"secret key">>).
```

Or with multiple keys with:
```erl
Token = <<"...">>,
{ok, JWS} = jose_jws:decode_compact(Token, hs256, [<<"bad key">>, <<"secret key">>]).
```

### JSON
The JSON format is currently not supported.

### Flattened JSON
The Flattened JSON format is currently not supported.

# JWE
The JWE is currently not supported.

# JSON Web Token (JWT)
## Encode
Encode JWT can be done with:
```erlang
Key = jose_jwa:generate_key(hs256),
Header = Header = #{alg => hs256, typ => <<"application/JWT">>},
Payload = #{sub => <<"1234567890">>, <<"name">> => <<"Bryan F.">>},
jose_jwt:encode_compact({Header, Payload}, hs256, Key, #{header_claims => [sub]}).
```

The library understands and processes the `b64` header name. Encode JWT in
with non-base64url encoded payload can be done with:
```erlang
Key = jose_jwa:generate_key(hs256),
Header = #{alg => hs256, typ => <<"application/JWT">>, b64 => false, crit => [<<"b64">>]},
Payload = #{sub => <<"1234567890">>, <<"name">> => <<"Bryan F.">>, iat => 1607772974},
jose_jwt:encode_compact({Header, Payload}, hs256, Key).
```

Encode accepts following options:
| Option        | Description                                         | Default |
|---------------|-----------------------------------------------------|---------|
| header_claims | A list of JWT claims to merge in the header object. | []      |

## Decode
Decode JWT can be done with:
```erl
Token = <<"...">>,
{ok, JWT} = jose_jwt:decode_compact(Token, hs256, <<"secret key">>).
```

Or with multiple keys with:
```erl
Token = <<"...">>,
{ok, JWT} = jose_jwt:decode_compact(Token, hs256, [<<"bad key">>, <<"secret key">>]).
```

Decode accepts following options:
| Option         | Description                                  | Default           |
|----------------|----------------------------------------------|-------------------|
| aud            | The audience claim identifies the recipients | computer hostname |
| validate_claim | A function to validate extra claims          | none              |

# Certificate store
As described in the [decode section](#decode), the library understands and
processes `x5t`, `x5t#S255`, `x5c`, and `x5u` header names. Those header names
hint at which certificates sign or encrypt the JOSE token. The certificate
must be in the certificate store to be trusted; otherwise, it evaluates it as
not trustable. In brief, the certificate stores is a collection of trusted
certificates.

## Configuration
The `jose_sup` creates a certificate store base on the `jose` application
configuration. The certificate store configuration allows loading certificate
bundles at the process startup.
```erlang
[{jose,
    [{certificate_store,
        #{files => ["priv/pki/acme.crt",
                    "priv/pki/example.crt"]}}]}].
```

## Add a certificate
It is possible adding a new certificate after the process boot with:
```erlang
% Der must be a valid Der encoded certificate.
jose_certificate_store:add(certificate_store_default, Der).
```

## Remove a certificate
It is possible removing a certificate after the process boot with:
```erlang
% Der must be a valid Der encoded certificate.
jose_certificate_store:remove(certificate_store_default, Der).
```

## Find a certificate
`certificate-store` store certificates by their SHA1 fingerprint and SHA256
fingerprint. Finding a certificate with:
```erlang
jose_certificate_store:find(certificate_store_default, {sha1, Sha1Fingerprint}).
jose_certificate_store:find(certificate_store_default, {sha2, Sha2Fingerprint}).
```

# Key store
As described in the [decode section](#decode), the library understands and
processes `kid` header names. Those header names hint at which keys sign or
encrypt the JOSE token. The key stores act as a trusted public keys store to
verify the signature or decrypt a JOSE token.

## Configuration
The `jose_sup` creates a certificate store base on the `jose` application
configuration. The certificate store configuration allows loading certificate
bundles at the process startup.
```erlang
[{jose,
    [{key_store,
        #{files => ["priv/pki/acme.crt",
                    "priv/pki/example.crt"]}}]}].
```


## Add a key
It is possible adding a new key after the process boot with:
```erlang
% Key must be a valid public key in PemEntry format.
jose_key_store:add(key_store_default, PemEntry).
```

## Remove a key
It is possible removing a key after the process boot with:
```erlang
jose_key_store:remove(key_store_default, <<"md5 of the DER">>).
```

## Find a key
`key-store` store public key by the MD5 fingerprint. It is possible finding a key with:
```erlang
jose_key_store:find(key_store_default, <<"md5 of the DER">>).
```
