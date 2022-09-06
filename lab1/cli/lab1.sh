#!/bin/bash

## Set required environment variable
export VAULT_ADDR=<VAULT ADDRESS URL>

## Enable Transform engine
vault secrets enable transform

## Create a named role
vault write transform/role/payments transformations=ccn-fpe

## Create a transformation
vault write transform/transformation/ccn-fpe \
type=fpe \
template=ccn \
tweak_source=internal \
allowed_roles=payments

## Optionally create a template
vault write transform/template/ccn \
type=regex \
pattern='(\d{4})[- ](\d{4})[- ](\d{4})[- ](\d{4})' \
encode_format='$1-$2-$3-$4' \
decode_formats=last-four='$4' \
alphabet=numerics

## Optionally create a alphabet
vault write transform/alphabet/numerics alphabet="0123456789"
