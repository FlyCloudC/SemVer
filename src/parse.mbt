///|
priv suberror Fail View

///|
/// Parse and handle semantic version strings according to
/// the Semantic Versioning specification (https://semver.org/).
/// 
/// If parsing fails, a `ParseError` is raised indicating the position of the error.
pub fn parse(view : View) -> T raise ParseError {
  try {
    let (major, rest) = parse_numeric_identifier(view)
    guard rest is ['.', .. rest] else { raise Fail(rest) }
    let (minor, rest) = parse_numeric_identifier(rest)
    guard rest is ['.', .. rest] else { raise Fail(rest) }
    let (patch, rest) = parse_numeric_identifier(rest)
    //
    let (pre_release, rest) = parse_pre_release(rest)
    let (build, rest) = parse_build(rest)
    guard rest.is_empty() else { raise Fail(rest) }
    { major, minor, patch, pre_release, build }
  } catch {
    Fail(x) => raise ParseError(view.length() - x.length())
  }
}

///|
fn parse_pre_release(view : View) -> P[Array[Identifier]?] raise Fail {
  guard view is ['-', .. rest] else { return (None, view) }
  fn f(view : View) raise Fail {
    let rest = view
    loop (0, true, rest) {
      (end, is_digit, ['0'..='9', .. rest]) => //
        continue (end + 1, is_digit, rest)
      (end, _, ['a'..='z' | 'A'..='Z' | '-', .. rest]) =>
        continue (end + 1, false, rest)
      (0, _, _) => raise Fail(view)
      (end, is_digit, rest) => {
        let result = view.charcodes(end~)
        if is_digit {
          guard is_numeric_identifier(result) else { raise Fail(view) }
          (Num(result), rest)
        } else {
          (Alpha(result), rest)
        }
      }
    }
  }

  parse_dot_list(rest, f) |> map(Some(_))
}

///|
fn parse_build(view : View) -> P[Array[View]?] raise Fail {
  guard view is ['+', .. rest] else { return (None, view) }
  fn f(view : View) raise Fail {
    let rest = view
    loop (0, rest) {
      (end, ['0'..='9' | 'a'..='z' | 'A'..='Z' | '-', .. rest]) =>
        continue (end + 1, rest)
      (0, _) => raise Fail(view)
      (end, rest) => (view.charcodes(end~), rest)
    }
  }

  parse_dot_list(rest, f) |> map(Some(_))
}

///|
fn parse_numeric_identifier(view : View) -> P[View] raise Fail {
  // <numeric identifier> ::= "0"
  //                        | <positive digit>
  //                        | <positive digit> <digits>
  match view {
    ['0', .. rest] => (view.charcodes(end=1), rest)
    ['1'..='9', .. rest] =>
      loop (1, rest) {
        (end, ['0'..='9', .. rest]) => continue (end + 1, rest)
        (end, rest) => (view.charcodes(end~), rest)
      }
    _ => raise Fail(view)
  }
}

///|
fn[A] parse_dot_list(
  str : View,
  parse : (View) -> P[A] raise Fail
) -> P[Array[A]] raise Fail {
  let (first, rest) = parse(str)
  let result = [first]
  loop rest {
    ['.', .. rest] => {
      let (next, rest) = parse(rest)
      result.push(next)
      continue rest
    }
    rest => (result, rest)
  }
}

///|
fn is_numeric_identifier(view : View) -> Bool {
  match view {
    "0" => true
    ['1'..='9', .. rest] =>
      loop rest {
        [] => true
        ['0'..='9', .. rest] => continue rest
        _ => false
      }
    _ => false
  }
}
