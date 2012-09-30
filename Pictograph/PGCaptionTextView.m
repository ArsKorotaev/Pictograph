//
//  PGCaptionTextView.m
//  Pictograph
//
//  Created by Арсений Коротаев on 26.09.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//

#import "PGCaptionTextView.h"
#define DEFAULT_FONT_SIZE 24
#define MIN_FONT_SIZE 10

@implementation PGCaptionTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    self.backgroundColor = [UIColor clearColor];
    
    return self;
}

- (void) drawText:(NSString *)text withFont:(NSString *)fontName
{
    if (text != nil)
    {
        self.textToDraw = text;
    }
    _fontName = fontName;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    DrawText(context, self.frame, [self.textToDraw UTF8String], [self.textToDraw length],[_fontName UTF8String], 'Y');

    
}


CGSize LenghtForString(const char *str, const char *fontName_, int fontSize)
{
    NSString *string = [NSString stringWithUTF8String:str];
    NSString *fontName = [NSString stringWithUTF8String:fontName_];
    return [string sizeWithFont:[UIFont fontWithName:fontName size:fontSize]];
}

int GetFontSize(const char *str, const char *fontName_, float width)
{
    int resultFontSize = DEFAULT_FONT_SIZE;
    
    while (LenghtForString(str, fontName_, resultFontSize).width > 300 && resultFontSize >= MIN_FONT_SIZE)
    {
        resultFontSize--;
    }
    
    return resultFontSize;
}

void DrawText (CGContextRef myContext, CGRect contextRect, const char *text, unsigned int length, const char *fontName, char upsidedown) // 1
{
    

    float w, h;
    if (text == NULL)
    {
        return;
    }

    
    
    w = contextRect.size.width;
    h = contextRect.size.height;
    
    int fontSize = GetFontSize(text, fontName, w);
    
    CGSize stringSize = LenghtForString(text, fontName, fontSize);
    
    
 
    if (upsidedown == 'Y') {
        CGContextSelectFont (myContext, // 3
                             fontName,
                             fontSize,
                             kCGEncodingMacRoman);
    }
    else
    {
        CGContextSelectFont (myContext, // 3
                             fontName,
                             fontSize*2,
                             kCGEncodingMacRoman);
    }
    
    CGContextSetCharacterSpacing (myContext, 0); // 4
    CGContextSetTextDrawingMode (myContext, kCGTextFill); // 5
    
    CGContextSetRGBFillColor (myContext, 1, 1, 1, 1); // 6
    CGContextSetShadowWithColor(myContext,
                                CGSizeMake(1, 1),
                                3,
                                [UIColor blackColor].CGColor);

    CGAffineTransform transform;
    if (upsidedown == 'Y')
    {
        transform = CGAffineTransformConcat(CGContextGetTextMatrix(myContext),
                                            CGAffineTransformMake(1.0, 0.0, 0.0,
                                                                  -1.0, 0.0, 0.0));
        CGContextSetTextMatrix(myContext, transform);
        CGContextShowTextAtPoint (myContext, w / 2 - stringSize.width / 2, h-10, text, length); // 10
    }
    else
    {
        CGContextShowTextAtPoint (myContext, w*2 / 2 - stringSize.width*2 / 2, h / 2 - 10, text, length); // 10
    }

    
}

-(void) dealloc
{
    NSLog(@"PGCaptionTextView - dealloc");
}
@end
