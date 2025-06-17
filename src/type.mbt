///|
typealias @string.View

///|
pub enum Identifier {
  Num(View)
  Alpha(View)
} derive(Eq)

///|
pub struct T {
  major : View
  minor : View
  patch : View
  pre_release : Array[Identifier]?
  build : Array[View]?
}

///|
/// Indicates the position where failure occurred.
pub suberror ParseError Int derive(Show)

///|
typealias (A, View) as P[A]

///|
fn[A, B] map(x : P[A], f : (A) -> B) -> P[B] {
  let (a, rest) = x
  (f(a), rest)
}
