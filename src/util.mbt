///|
/// Verify whether the string complies with
/// the Semantic Versioning specification (https://semver.org/).
pub fn is_valid(view : View) -> Bool {
  parse?(view) is Ok(_)
}

///|
pub fn is_pre_release(self : T) -> Bool {
  self.pre_release is Some(_)
}

///|
pub impl Eq for T with op_equal(self, other) {
  self.major == other.major &&
  self.minor == other.minor &&
  self.patch == other.patch &&
  self.pre_release == other.pre_release
}

///|
pub impl Compare for T with compare(self, other) {
  let c1 = self.major.compare(other.major)
  guard c1 == 0 else { return c1 }
  let c2 = self.minor.compare(other.minor)
  guard c2 == 0 else { return c2 }
  let c3 = self.patch.compare(other.patch)
  guard c3 == 0 else { return c3 }
  match (self.pre_release, other.pre_release) {
    (None, None) => 0
    (None, Some(_)) => 1
    (Some(_), None) => -1
    (Some(a), Some(b)) => {
      let len_a = a.length()
      let len_b = b.length()
      let len_min = if len_a < len_b { len_a } else { len_b }
      for i in 0..<len_min {
        let x = a[i].compare(b[i])
        guard x == 0 else { return x }

      }
      a.length().compare(b.length())
    }
  }
}

///|
impl Compare for Identifier with compare(self, other) {
  match (self, other) {
    (Alpha(_), Num(_)) => 1
    (Num(_), Alpha(_)) => -1
    (Alpha(a), Alpha(b)) => a.compare(b)
    (Num(a), Num(b)) => {
      let x = a.length().compare(b.length())
      guard x == 0 else { return x }
      a.compare(b)
    }
  }
}

///|
priv type S View

///|
impl Show for S with output(self, logger) {
  logger.write_string(self._.to_string())
}

///|
pub impl Show for T with output(self, logger) {
  logger
  ..write_string(self.major.to_string())
  ..write_char('.')
  ..write_string(self.minor.to_string())
  ..write_char('.')
  ..write_string(self.patch.to_string())
  if self.pre_release is Some(x) {
    logger
    ..write_char('-')
    ..write_iter(
      x.iter().map(fn { Num(x) | Alpha(x) => S(x) }),
      prefix="",
      suffix="",
      sep=".",
    )
  }
  if self.build is Some(x) {
    logger
    ..write_char('+')
    ..write_iter(x.iter().map(S(_)), prefix="", suffix="", sep=".")
  }
}
