# Introduction
This repository contains Erlang implementation of [RFC
7515](https://tools.ietf.org/html/rfc7515),
[7516](https://tools.ietf.org/html/rfc7516),
[7517](https://tools.ietf.org/html/rfc7517),
[7518](https://tools.ietf.org/html/rfc7518) and
[7797](https://tools.ietf.org/html/rfc7797).

# Motivation
Existing JOSE implementations are not compatible with a lot of JOSE header
parameter name which allow to easly manage JOSE with PKI infrastruture; and
bind C library with NIF which render Erlang release portability more complex.

# Build
You can build the library with:

    make build

# Test
You can execute the test suite with:

    make dialyzer test

You can generate test coverage with:

    make cover

# Documentation
A handbook is available [in the `doc` directory](doc/handbook.md).


# Contact
If you find a bug or have any question, feel free to open a Github issue or to
contact me [by email](mailto:bryan@frimin.fr).

Please note that I do not currently review or accept any contribution.

# License
Released under the ISC license.

Copyright (c) 2020 Bryan Frimin <bryan@frimin.fr>.

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
PERFORMANCE OF THIS SOFTWARE.
