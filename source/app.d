
import std.stdio;
import std.datetime.stopwatch : StopWatch, AutoStart;
import core.time : Duration;
import core.thread : Thread, nsecs;

import platform;
import math;
import bitmap;

enum WIDTH = 320;
enum HEIGHT = 200;
enum SCALE = 3;
enum TARGET_FRAME_TIME = nsecs(33333333);

void main() {
	IWindow win = createWindow("Tiny RTS", WIDTH * SCALE, HEIGHT * SCALE);

   Bitmap canvas = new Bitmap(320, 200);
   BitmapPainter painter = new BitmapPainter(canvas);

   auto frameWatch = new StopWatch(AutoStart.yes);

   win.show();

   while (true) {
      frameWatch.reset();

      if (!win.pump())
         break;

      painter.clear(Color(255, 255, 0));
      win.paint(canvas);

      auto frameDuration = frameWatch.peek();
      //_frameTime = cast(double)frameDuration.split!("nsecs").nsecs / 1_000_000_000.0;

      if (frameDuration < TARGET_FRAME_TIME) {
         auto sleepTime = TARGET_FRAME_TIME - frameDuration;
         Thread.sleep(sleepTime);
      }
   }
}
