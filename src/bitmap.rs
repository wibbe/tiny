
use super::*;

use std::cell::RefCell;
use std::ptr;
use std::path::Path;
use std::result::Result;

use image;
use image::GenericImage;

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

   pub fn load(ctx: &Context, path: &Path) -> Result<Bitmap, String> {
      if let Ok(ref img) = image::open(path) {
         let (w, h) = img.dimensions();

         let bitmap = Bitmap::new(w, h);

         {
            let mut pixels = bitmap.pixels.borrow_mut();

            for (x, y, pixel) in img.pixels() {
               let color = ctx.palette_add(Color::new(pixel[0], pixel[1], pixel[2], pixel[3]));
               pixels[(x + y * w) as usize] = color;
            }
         }

         Ok(bitmap)
      } else {
         Err(String::from("Could not load image"))
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

   fn pixel(&self, x: i32, y: i32, color: u8) {
      if self.clip.borrow().inside(x, y) {
         self.target.pixels.borrow_mut()[(x + y * self.target.width as i32) as usize] = color;
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

   fn line(&self, x0: i32, y0: i32, x1: i32, y1: i32, color: u8)
   {
      let sx = if x0 < x1 { 1 } else { -1 };
      let sy = if y0 < y1 { 1 } else { -1 };
      let dx = (x1 - x0).abs();
      let dy = (y1 - y0).abs();

      let mut err = dx - dy;
      let mut x = x0;
      let mut y = y0;
      
      let clip = self.clip.borrow();
      let mut pixels = self.target.pixels.borrow_mut();


      while x != x1 || y != y1 {
         if clip.inside(x, y) {
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

   fn blit(&self, source: &Bitmap, x0: i32, y0: i32, source_rect: Rect) {
      let clip = self.clip.borrow();

      let source_pixels = source.pixels.borrow();
      let mut target_pixels = self.target.pixels.borrow_mut();

      for y in source_rect.top..source_rect.bottom {
         for x in source_rect.left..source_rect.right {
            let target_x = x0 + x;
            let target_y = y0 + y;

            if clip.inside(target_x, target_y) {
               target_pixels[(target_x + target_y * self.target.width as i32) as usize] = source_pixels[(x + y * source.width as i32) as usize];
            }
         }
      }
   }
}