module context;

import tiny;
import bitmap;

public class Context {
    private bool _showPerformace = false;
    
    private double _frameTime = 0.0;
    private double _stepTime = 0.0;
    private double _paintTime = 0.0;
    private double _blitTime = 0.0;

    private Bitmap _canvas = null;
    private IWindow _window = null;

    
}