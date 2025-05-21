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
type! ParseError View

///|
typealias P[A] = (A, View)

///|
fn map[A, B](x : P[A], f : (A) -> B) -> P[B] {
  let (a, rest) = x
  (f(a), rest)
}
