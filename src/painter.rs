
use super::Rect;

pub trait Painter {
   fn clip_reset(&self);
   fn clip_set(&self, rect: Rect);

   fn clear(&self, color: u8);
   fn rect_stroke(&self, rect: Rect, color: u8);
   fn rect_fill(&self, rect: Rect, color: u8);

   fn line(&self, x1: i32, y1: i32, x2: i32, y2: i32, color: u8);
}