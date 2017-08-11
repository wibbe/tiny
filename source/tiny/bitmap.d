module bitmap;


class Bitmap {
    private ubyte[] _pixels;
    private uint _width;
    private uint _height;

    @property int width() const { return _width; }
    @property int height() const { return _height; }

    this(uint width, uint height) {
        _width = width;
        _height = height;

        _pixels = new ubyte[width * height];
        for (int i = 0; i < (width * height); i++)
            _pixels[i] = 0;
    }
}