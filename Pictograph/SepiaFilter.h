//
//  SepiaFilter.h
//  Pictograph
//
//  Created by Арсений Коротаев on 29.09.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//

#import "PGFilter.h"
#import "GPUImage.h"    
@interface SepiaFilter : PGFilter
{
    GPUImageFilter *filter1;
}
@end
