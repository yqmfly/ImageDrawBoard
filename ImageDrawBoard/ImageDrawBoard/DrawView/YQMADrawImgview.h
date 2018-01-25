//
//  YQMADrawImgview.h
//  TestHttp
//
//  Created by yqm on 2018/1/25.
//  Copyright © 2018年 y. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface YQMADrawImgview : UIImageView


@property (nonatomic, strong) UIImage *drawImage; // 传入的操作的图片
@property (nonatomic, strong) UIImage *returnImage ; // 操作后的图片

//绘图路径数组
@property (strong, nonatomic)NSMutableArray *muarrDPath;

- (void)initScratch ;
-(void)initImage ;
-(void)undoStep;
-(void)clearScreen;


@end

@interface YQMDrawPath:NSObject

+(id)YQMDrawPathWithCGPath:(CGPathRef)drawPath lineWidth:(CGFloat)lineWidth;

@property (strong, nonatomic)UIBezierPath *drawPath;
@property (assign, nonatomic)CGFloat lineWidth;

@end
