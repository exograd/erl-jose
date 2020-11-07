%% Copyright (c) 2020 Bryan Frimin <bryan@frimin.fr>.
%%
%% Permission to use, copy, modify, and/or distribute this software for any
%% purpose with or without fee is hereby granted, provided that the above
%% copyright notice and this permission notice appear in all copies.
%%
%% THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
%% REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
%% AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
%% INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
%% LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
%% OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
%% PERFORMANCE OF THIS SOFTWARE.

-module(jose_jwk).

-export([]).

-export_type([jwk/0,
              type/0,
              use/0,
              key_ops/0,
              certificate_thumbprint/0,
              crv/0,
              coordinate/0,
              ecc_private_key/0,
              modulus/0,
              exponent/0,
              prime_factor/0,
              oth/0]).

-type jwk() :: #{kty => type(),
                 use => use(),
                 key_ops => key_ops(),
                 alg => jose_jwa:alg(),
                 kid => binary(),
                 x5u => uri:uri(),
                 x5c => [{'Certificate' | 'OTPCertificate', _, _, _}],
                 x5t => certificate_thumbprint(),
                 'x5t#S256' => certificate_thumbprint(),
                 crv => crv(),
                 x => coordinate(),
                 y => coordinate(),
                 d => ecc_private_key(),
                 n => modulus(),
                 e => exponent(),
                 d => exponent(),
                 p => prime_factor(),
                 q => prime_factor(),
                 dp => exponent(),
                 dq => exponent(),
                 qi => non_neg_integer(),
                 oth => [oth()],
                 k => binary()}.

-type certificate_thumbprint() :: binary().

% https://www.iana.org/assignments/jose/jose.xhtml#web-key-types
-type type() :: 'RSA' | 'EC' | oct | 'OKP'.

% https://www.iana.org/assignments/jose/jose.xhtml#web-key-use
-type use() :: sig | enc.

-type key_ops() :: sign
                 | verify
                 | encrypt
                 | decrypt
                 | wrapKey
                 | unwrapKey
                 | deriveKey
                 | deriveBits.

% https://www.iana.org/assignments/jose/jose.xhtml#web-key-elliptic-curve
-type crv() :: 'P-256'
             | 'P-384'
             | 'P-521'
             | 'Ed25519'
             | 'Ed448'
             | 'X25519'
             | 'X448'
             | 'secp256k1'.

-type coordinate() :: binary().
-type ecc_private_key() :: binary().
-type modulus() :: non_neg_integer().
-type exponent() :: non_neg_integer().
-type prime_factor() :: non_neg_integer().
-type oth() :: #{r => prime_factor(),
                 d => exponent(),
                 d => non_neg_integer()}.