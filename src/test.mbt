///|
test "parse success" {
  fn f(x) raise {
    parse(x).to_string()
  }

  let v1 = "1.0.1-alpha"
  assert_eq(v1, f(v1))
  let v2 = "1.0.11-alpha"
  assert_eq(v2, f(v2))
  let v3 = "1.0.0-beta.22+exp.sha.51fff85"
  assert_eq(v3, f(v3))
  let v4 = "1.0.0+exp.sha.51fff85"
  assert_eq(v4, f(v4))
}

///|
test "parse fail" {
  assert_false(is_valid(""))
  assert_false(is_valid("1"))
  assert_false(is_valid(".."))
  assert_false(is_valid("..1"))
  assert_false(is_valid("1..1"))
  assert_false(is_valid("1.1."))
  assert_false(is_valid("1.1.1."))
  assert_false(is_valid("1.0.0-"))
  assert_false(is_valid("1.0.0-.1"))
  assert_false(is_valid("1.0.0-beta.00"))
  assert_false(is_valid("1.0.0-beta.1+"))
  assert_false(is_valid("1.0.0-beta.+exp.sha.5114f85"))
}

///|
test "compare" {
  fn m(major, minor, patch) {
    { major, minor, patch, pre_release: None, build: None }
  }

  fn pre(x) {
    { major: "1", minor: "0", patch: "0", pre_release: Some(x), build: None }
  }

  let v1_0_0 = m("1", "0", "0")
  let v2_0_0 = m("2", "0", "0")
  let v2_1_0 = m("2", "1", "0")
  let v2_1_1 = m("2", "1", "1")
  assert_true(v1_0_0 < v2_0_0)
  assert_true(v2_0_0 < v2_1_0)
  assert_true(v2_1_0 < v2_1_1)
  assert_false(v1_0_0 == v2_0_0)
  assert_false(v2_0_0 == v2_1_0)
  assert_false(v2_1_0 == v2_1_1)
  let v1_0_0_alpha = pre([Alpha("alpha")])
  let v1_0_0_alpha_beta = pre([Alpha("alpha"), Alpha("beta")])
  let v1_0_0_beta = pre([Alpha("beta")])
  let v1_0_0_beta_1 = pre([Alpha("beta"), Num("1")])
  let v1_0_0_beta_2 = pre([Alpha("beta"), Num("2")])
  let v1_0_0_beta_12 = pre([Alpha("beta"), Num("12")])
  let v1_0_0_build = {
    major: "1",
    minor: "0",
    patch: "0",
    pre_release: None,
    build: Some(["build1919"]),
  }
  assert_false(v1_0_0 == v1_0_0_beta)
  assert_true(v1_0_0 == v1_0_0_build)
  assert_true(v1_0_0_alpha < v1_0_0_alpha_beta)
  assert_true(v1_0_0_alpha_beta < v1_0_0_beta)
  assert_true(v1_0_0_beta < v1_0_0_beta_1)
  assert_true(v1_0_0_beta_1 < v1_0_0_beta_2)
  assert_true(v1_0_0_beta_2 < v1_0_0_beta_12)
}

///|
test "is_prelease" {
  assert_true(parse("1.1.4-beta.1").is_pre_release())
  assert_true(parse("1.1.4-beta").is_pre_release())
  assert_false(parse("5.1.4").is_pre_release())
  assert_false(parse("1.0.0+wow").is_pre_release())
}
