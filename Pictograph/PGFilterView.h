//
//  PGFilterView.h
//  Pictograph
//
//  Created by Арсений Коротаев on 23.09.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//
//Вью для просмотра пяти фильтров

#import <UIKit/UIKit.h>

#import "GPUImage.h"

//@class PGFilterView;

@protocol  PGFilterViewDelegate
- (void) setFilterNamed:(NSString*) filterName;
@end

@interface PGFilterView : UIView
{
    //GPUImageView *view1, *view2, *view3, *view4, *view5;
    
    NSMutableArray *viewsArray;
    
    NSArray *filterNames;
    NSInteger oldeSelectedView;
    
    NSArray *thumbnailImages;//Именя картинок с изображением фильтра
    
    
}
@property BOOL isAdded;
@property (readonly) NSThread *thread;
@property (unsafe_unretained) id<PGFilterViewDelegate> del;
@property (readonly) NSArray *avialebleFilterNames;
@property (readonly) NSArray *views;
- (id) initFilterView;
- (id) initFilterViewWithFilterNames:(NSArray *) names;
@end
