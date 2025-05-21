# FlyCloudC/SemVer

A [semantic versioning](https://semver.org/) library for MoonBit.

## Features

- validate and parse semantic versions
- compare versions

## Usage

```mbt
test "compare" {
  try {
    let v1 = parse!("1.0.0")
    let v2 = parse!("1.2.3-alpha")
    assert_true!(v1 > v2)
  } catch {
    _ => ()
  }
}
```

```mbt
test "error pos" {
  try {
    parse!("1.0.0.2") |> ignore
  } catch {
    ParseError(pos) => assert_eq!(pos, 5)
  }
}
```
