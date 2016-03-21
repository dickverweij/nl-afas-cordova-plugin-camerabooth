Camera (photo)booth plugin
==========================
Camera photo-booth plugin, 'CameraBooth'.. shows a preview and after counting down to 1 takes a number of pictures.


Requirements
-------------
- iOS 8 or higher
- Cordova 3.0 or higher

    Installation
-------------
    cordova plugin add nl-afas-cordova-plugin-camerabooth

Usage
------
    // n = number of pictures taken
	// images is array of base64 image data

    cordova.plugins.CameraBooth.start(n).then(function (images){});

LICENSE
--------
The MIT License (MIT)

Copyright (c) 2016 dickydick1969@hotmail.com Dick Verweij AFAS Software BV - d.verweij@afas.nl

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
