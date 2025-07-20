# FlyCloudC/SemVer

A [semantic versioning](https://semver.org/) library for MoonBit.

## Features

1. A struct representing a semantic version:
```mbt
pub struct T {
  major : String
  minor : String
  patch : String
  pre_release : Array[Identifier]?
  build : Array[String]?
}
```

2. From string:
```mbt
pub suberror ParseError Int derive(Show)
fn parse(@string.StringView) -> T raise ParseError
```
If parsing fails, a `ParseError` is raised indicating the position of the error.

3. Compare two semantic version:
```mbt
impl Eq for T
impl Compare for T
```
