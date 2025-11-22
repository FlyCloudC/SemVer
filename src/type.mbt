///|
pub enum Identifier {
  Num(String)
  Alpha(String)
} derive(Eq)

///|
pub struct Version {
  major : String
  minor : String
  patch : String
  pre_release : Array[Identifier]?
  build : Array[String]?
}

///|
/// Indicates the position where failure occurred.
pub suberror ParseError Int derive(Show)

///|
type P[A] = (A, StringView)

///|
fn[A, B] map(x : P[A], f : (A) -> B) -> P[B] {
  let (a, rest) = x
  (f(a), rest)
}
