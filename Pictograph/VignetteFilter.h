//
//  WarmFilter.h
//  Pictograph
//
//  Created by Арсений Коротаев on 24.09.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "PGFilter.h"


@class GPUImageFilter;

@interface VignetteFilter : PGFilter
{
    GPUImageFilter *filter1, *filter2;
}


@end
