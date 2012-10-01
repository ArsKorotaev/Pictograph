//
//  PGCaptionTextView.h
//  Pictograph
//
//  Created by Арсений Коротаев on 26.09.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PGCaptionTextView : UIView
{
  //  NSString *textToDraw;
    NSString *_fontName;
}

@property  NSString *textToDraw;
-(void) drawText:(NSString*) text withFont:(NSString*) fontName;

@end

void DrawUpText(CGContextRef myContext, CGRect contextRect, const char *text, unsigned int length, const char *fontName, char upsidedown);
void DrawText (CGContextRef myContext, CGRect contextRect, const char *text, unsigned int length, const char *fontName, char upsidedown);