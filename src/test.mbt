///|
test "parse success" {
  fn f(x) {
    parse?(x).unwrap().to_string()
  }

  let v1 = "1.0.1-alpha"
  assert_eq!(v1, f(v1))
  let v2 = "1.0.1-alpha"
  assert_eq!(v2, f(v2))
  let v3 = "1.0.0-beta.22+exp.sha.51fff85"
  assert_eq!(v3, f(v3))
  let v4 = "1.0.0+exp.sha.51fff85"
  assert_eq!(v4, f(v4))
}

///|
test "parse fail" {
  assert_false!(is_valid(""))
  assert_false!(is_valid("1"))
  assert_false!(is_valid(".."))
  assert_false!(is_valid("..1"))
  assert_false!(is_valid("1..1"))
  assert_false!(is_valid("1.1."))
  assert_false!(is_valid("1.1.1."))
  assert_false!(is_valid("1.0.0-"))
  assert_false!(is_valid("1.0.0-.1"))
  assert_false!(is_valid("1.0.0-beta.00"))
  assert_false!(is_valid("1.0.0-beta.1+"))
  assert_false!(is_valid("1.0.0-beta.+exp.sha.5114f85"))
}

///|
test "compare" {
  let v1_0_0 = {
    major: "1",
    minor: "0",
    patch: "0",
    pre_release: None,
    build: None,
  }
  let v2_0_0 = {
    major: "2",
    minor: "0",
    patch: "0",
    pre_release: None,
    build: None,
  }
  let v2_1_0 = {
    major: "2",
    minor: "1",
    patch: "0",
    pre_release: None,
    build: None,
  }
  let v2_1_1 = {
    major: "2",
    minor: "1",
    patch: "1",
    pre_release: None,
    build: None,
  }
  let v1_0_0_pre_release = {
    major: "1",
    minor: "0",
    patch: "0",
    pre_release: Some([Alpha("alpha114")]),
    build: None,
  }
  let v1_0_0_build = {
    major: "1",
    minor: "0",
    patch: "0",
    pre_release: None,
    build: Some(["build1919"]),
  }
  assert_false!(v1_0_0 == v2_0_0)
  assert_false!(v2_0_0 == v2_1_0)
  assert_false!(v2_1_0 == v2_1_1)
  assert_false!(v1_0_0 == v1_0_0_pre_release)
  assert_true!(v1_0_0 < v2_0_0)
  assert_true!(v2_0_0 < v2_1_0)
  assert_true!(v2_1_0 < v2_1_1)
  assert_true!(v1_0_0_pre_release < v1_0_0)
  assert_true!(v1_0_0 == v1_0_0_build)
}

///|
test "is_prelease" {
  assert_true!(parse?("1.1.4-beta.1").unwrap().is_pre_release())
  assert_true!(parse?("1.1.4-beta").unwrap().is_pre_release())
  assert_false!(parse?("5.1.4").unwrap().is_pre_release())
  assert_false!(parse?("1.0.0+wow").unwrap().is_pre_release())
}
