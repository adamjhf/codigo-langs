#!/usr/bin/env nu

yq -o=json schema.yaml | save -f schema.json;
let files = ls languages/*.yaml | get name
let failures = $files | each { |file|
    yq -o=json $file
    | jsonschema-cli schema.json -i /dev/stdin
    | complete
    | if $in.exit_code != 0 { { file: $file, error: $in.stdout } }
  }
  | (if ($in | is-not-empty) { print $in }; $in | length)
rm schema.json
print $"Validated ($files | length) language files. ($failures) failures."
