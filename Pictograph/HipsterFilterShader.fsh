varying highp vec2 textureCoordinate;

uniform sampler2D inputImageTexture;

void main()
{
//	lowp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
//    lowp vec4 outputColor;
//    outputColor.r = (textureColor.r * 0.393) + (textureColor.g * 0.769) + (textureColor.b * 0.189);
//    outputColor.g = (textureColor.r * 0.349) + (textureColor.g * 0.686) + (textureColor.b * 0.168);
//    outputColor.b = (textureColor.r * 0.272) + (textureColor.g * 0.534) + (textureColor.b * 0.131);
//    outputColor.a = 1.0;
//    
//    gl_FragColor = outputColor;
    
//    lowp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
//    lowp vec4 outputColor;
//    
//    outputColor.r = max(textureColor.r, 0.027);
//    outputColor.g = max(outputColor.g, 0.269);
//    outputColor.b = max(outputColor.b, 0.457);
//    outputColor.a = 1.0;
    
    mediump vec4 base = texture2D(inputImageTexture, textureCoordinate);
    mediump vec4 overlay = vec4( 11.0 / 256.0, 113.0 / 256.0, 192.0 / 256.0, 0.5);
    mediump vec4 outputColor;
    //outputColor = base * (overlay.a * (base / base.a) + (2.0 * overlay * (1.0 - (base / base.a)))) + overlay * (1.0 - base.a) + base * (1.0 - overlay.a);
    if (overlay.r > base.r)
    {
        outputColor.r = overlay.r / base.a + base.r;
    }
    else
    {
        outputColor.r = base.r;
    }
    
    if (overlay.g > base.g)
    {
        outputColor.g = overlay.g / base.a + base.g;
    }
    else
    {
        outputColor.g = base.g;
    }
    
    if (overlay.b > base.b)
    {
        outputColor.b = overlay.b / base.a + base.b;
    }
    else
    {
        outputColor.b = base.b;
    }
    gl_FragColor = outputColor;
    
}



