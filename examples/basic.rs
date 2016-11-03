
extern crate tiny;

use tiny::*;

struct App {
   red: u8,
   green: u8,
   blue: u8,
}


impl tiny::Application for App {
   fn new(ctx: &tiny::Context) -> App {
      App {
         red: ctx.palette_add(Color::new(255, 0, 0, 255)),
         green: ctx.palette_add(Color::new(30, 255, 40, 255)),
         blue: ctx.palette_add(Color::new(30, 40, 255, 255)),
      }
   }
   
   fn step(&mut self, ctx: &tiny::Context) -> bool {
      !ctx.key_down(tiny::Key::Escape)
   }

   fn paint(&self, painter: &tiny::Painter) {
      painter.clear(tiny::BLACK);

      painter.rect_stroke(Rect::new(2, 2, 4, 4), self.green);
      painter.rect_stroke(Rect::new(0, 0, 159, 159), self.red);
      painter.rect_fill(Rect::new(154, 154, 157, 157), self.green);

      painter.line(4, 4, 156, 156, self.blue);
   }
}

fn main() {
   if let Err(err) = tiny::run::<App>("Tiny - Basic Example", 160, 160, 3) {
      println!("Error: {}", err);
   }
}