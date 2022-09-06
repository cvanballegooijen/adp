resource "vault_mount" "transform" {
  path = "transform"
  type = "transform"
}

resource "vault_transform_role" "role" {
  path = vault_mount.transform.path
  name = "payments"
  transformations = ["ccn-fpe"]
}

resource "vault_transform_transformation" "transformation" {
  path          = vault_mount.transform.path
  name          = "ccn-fpe"
  type          = "fpe"
  template      = "ccn"
  tweak_source  = "internal"
  allowed_roles = ["payments"]
}

resource "vault_transform_alphabet" "numerics" {
  path      = vault_mount.transform.path
  name      = "numerics"
  alphabet  = "0123456789"
}

resource "vault_transform_template" "template" {
  path           = vault_transform_alphabet.numerics.path
  name           = "ccn"
  type           = "regex"
  pattern        = "(\\d{4})[- ](\\d{4})[- ](\\d{4})[- ](\\d{4})"
  alphabet       = "numerics"
  encode_format  = "$1-$2-$3-$4"
  decode_formats = {
    "last-four-digits" = "$4"
  }
}
