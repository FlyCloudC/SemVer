///|
#callsite(autofill(loc))
#coverage.skip
fn assert_valid(v : String, loc~ : SourceLoc) -> Unit raise {
  try parse(v).to_string() catch {
    ParseError(pos) => fail("Err at \{pos}", loc~)
  } noraise {
    pv => assert_eq(pv, v, loc~)
  }
}

///|
#callsite(autofill(loc))
#coverage.skip
fn fail_pos(v : String, loc~ : SourceLoc) -> Int raise {
  try parse(v) catch {
    ParseError(pos) => pos
  } noraise {
    v => fail("Ok \{v}", loc~)
  }
}

///|
#callsite(autofill(loc))
#coverage.skip
fn assert_le(a : Version, b : Version, loc~ : SourceLoc) -> Unit raise {
  assert_true(a < b, loc~, msg="`\{a} >= \{b}`")
}

///|
test "parse success" {
  assert_valid("1.0.1-alpha")
  assert_valid("1.0.11-alpha")
  assert_valid("1.0.0-beta.22+exp.sha.51fff85")
  assert_valid("1.0.0+exp.sha.51fff85")
}

///|
test "parse fail" {
  inspect(fail_pos(""), content="0")
  inspect(fail_pos("1"), content="1")
  inspect(fail_pos(".."), content="0")
  inspect(fail_pos("..1"), content="0")
  inspect(fail_pos("1..1"), content="2")
  inspect(fail_pos("1.1."), content="4")
  inspect(fail_pos("1.1.1."), content="5")
  inspect(fail_pos("1.0.0-"), content="6")
  inspect(fail_pos("1.0.0-.1"), content="6")
  inspect(fail_pos("1.0.0-beta.00"), content="11")
  inspect(fail_pos("1.0.0-beta.1+"), content="13")
  inspect(fail_pos("1.0.0-beta.+exp.sha.5114f85"), content="11")
}

///|
test "equal and compare" {
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
  assert_le(v1_0_0, v2_0_0)
  assert_le(v2_0_0, v2_1_0)
  assert_le(v2_1_0, v2_1_1)
  assert_not_eq(v1_0_0, v2_0_0)
  assert_not_eq(v2_0_0, v2_1_0)
  assert_not_eq(v2_1_0, v2_1_1)
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
  assert_not_eq(v1_0_0, v1_0_0_beta)
  assert_eq(v1_0_0, v1_0_0_build)
  assert_le(v1_0_0_alpha, v1_0_0_alpha_beta)
  assert_le(v1_0_0_alpha_beta, v1_0_0_beta)
  assert_le(v1_0_0_beta, v1_0_0_beta_1)
  assert_le(v1_0_0_beta_1, v1_0_0_beta_2)
  assert_le(v1_0_0_beta_2, v1_0_0_beta_12)
  assert_le(v1_0_0_beta_12, v1_0_0)
}

///|
test "is_prelease" {
  assert_true(parse("1.1.4-beta.1").is_pre_release())
  assert_true(parse("1.1.4-beta").is_pre_release())
  assert_false(parse("5.1.4").is_pre_release())
  assert_false(parse("1.0.0+wow").is_pre_release())
}
