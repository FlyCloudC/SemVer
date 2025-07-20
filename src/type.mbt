///|
pub enum Identifier {
  Num(String)
  Alpha(String)
} derive(Eq)

///|
pub struct T {
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
typealias (A, @string.View) as P[A]

///|
fn[A, B] map(x : P[A], f : (A) -> B) -> P[B] {
  let (a, rest) = x
  (f(a), rest)
}
