
use super::*;

use std::cell::RefCell;
use std::ptr;

pub struct Bitmap {
   pixels: RefCell<Vec<u8>>,
   width: u32,
   height: u32,
}

impl Bitmap {
   pub fn new(w: u32, h: u32) -> Bitmap {
      let mut pixels: Vec<u8> = Vec::new();
      pixels.resize((w* h) as usize, 0 as u8);

      Bitmap {
         pixels: RefCell::new(pixels),
         width: w,
         height: h
      }
   }

   #[inline]
   pub fn pixel(&self, x: u32, y: u32) -> u8 {
      self.pixels.borrow()[(self.width * y + x) as usize]
   }
}


pub struct BitmapPainter<'a> {
   target: &'a mut Bitmap,
   clip: RefCell<Rect>,
}

impl<'a> BitmapPainter<'a> {
   pub fn new(target: &'a mut Bitmap) -> BitmapPainter {
      let w = target.width;
      let h = target.height;

      BitmapPainter {
         target: target,
         clip: RefCell::new(Rect::new_size(0, 0, w as i32, h as i32)),
      }
   }

   fn inside_clip(&self, x: i32, y: i32) -> bool {
      let clip = self.clip.borrow();
      x >= clip.left && y >= clip.top && x <= clip.right && y <= clip.bottom
   }
}

impl<'a> Painter for BitmapPainter<'a> {
   fn clip_reset(&self) {
      *self.clip.borrow_mut() = Rect::new_size(0, 0, self.target.width as i32, self.target.height as i32);
   }

   fn clip_set(&self, rect: Rect) {
      *self.clip.borrow_mut() = rect.fit(0, 0, self.target.width as i32, self.target.height as i32);
   }

   fn clear(&self, color: u8) {
      unsafe {
         let len = (self.target.width * self.target.height) as usize;
         ptr::write_bytes(self.target.pixels.borrow_mut().as_mut_ptr(), color, len);
      }
   }

   fn rect_stroke(&self, rect: Rect, color: u8) {
      self.line(rect.left, rect.top, rect.right + 1, rect.top, color);
      self.line(rect.left, rect.bottom, rect.right + 1, rect.bottom, color);
      self.line(rect.left, rect.top, rect.left, rect.bottom, color);
      self.line(rect.right, rect.top, rect.right, rect.bottom, color);
   }

   fn rect_fill(&self, rect: Rect, color: u8) {
      let stride = self.target.width as isize;
      let start = (rect.top * self.target.width as i32) + rect.left;
      let len = (rect.right - rect.left) as usize;
      let mut pixels = self.target.pixels.borrow_mut();

      unsafe {
         let mut pos = start as isize;
         for _ in 0..(rect.bottom - rect.top) as i32 {
            ptr::write_bytes(pixels.as_mut_ptr().offset(pos), color, len);
            pos += stride;
         }
      }
   }

/*
void tigrLine(Tigr *bmp, int x0, int y0, int x1, int y1, TPixel color)
{
   int sx, sy, dx, dy, err, e2;
   dx = abs(x1 - x0);
   dy = abs(y1 - y0);
   if (x0 < x1) sx = 1; else sx = -1;
   if (y0 < y1) sy = 1; else sy = -1;
   err = dx - dy;

   tigrPlot(bmp, x0, y0, color);
   while (x0 != x1 || y0 != y1)
   {
      tigrPlot(bmp, x0, y0, color);
      e2 = 2*err;
      if (e2 > -dy) { err -= dy; x0 += sx; }
      if (e2 <  dx) { err += dx; y0 += sy; }
   }
}
*/
   fn line(&self, x0: i32, y0: i32, x1: i32, y1: i32, color: u8)
   {
      let sx = if x0 < x1 { 1 } else { -1 };
      let sy = if y0 < y1 { 1 } else { -1 };
      let dx = (x1 - x0).abs();
      let dy = (y1 - y0).abs();

      let mut pixels = self.target.pixels.borrow_mut();
      let mut err = dx - dy;
      let mut x = x0;
      let mut y = y0;


      while x != x1 || y != y1 {
         if self.inside_clip(x, y) {
            pixels[(x + y * self.target.width as i32) as usize] = color;
         }

         let e2 = 2 * err;

         if e2 > -dy {
            err -= dy;
            x += sx;
         }
         if e2 < dx {
            err += dx;
            y += sy;
         }
      }
   }
}