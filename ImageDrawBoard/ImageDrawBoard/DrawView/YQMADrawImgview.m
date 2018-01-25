//
//  YQMADrawImgview.m
//  TestHttp
//
//  Created by yqm on 2018/1/25.
//  Copyright © 2018年 y. All rights reserved.
//

#import "YQMADrawImgview.h"

@interface YQMADrawImgview () {
    CGPoint prePoint;
    CGPoint curPoint;
    CGContextRef contextMask;
    UIImage *imageToDraw ;
}

//当前绘图路径
@property (assign, nonatomic)CGMutablePathRef drawPath;
//路径是否被释放
@property (assign, nonatomic)BOOL pathReleased;

@end

@implementation YQMADrawImgview

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setOpaque:NO];
        
        if (self.muarrDPath == nil) {
            self.muarrDPath = [NSMutableArray array];
        }
    }
    return self;
}

- (void)initScratch {
    curPoint = CGPointZero;
    prePoint = CGPointZero;
    imageToDraw = self.drawImage ;
	// 设置图片显示模式
    self.clipsToBounds  = YES ;
    self.contentMode = UIViewContentModeScaleAspectFill ;
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight ;
    self.contentScaleFactor = [[UIScreen mainScreen] scale] ;
    self.userInteractionEnabled = YES ;
}

-(void)initImage {
    self.returnImage = imageToDraw ;
    self.image = imageToDraw ;
}


#pragma mark -  Touch event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [[event touchesForView:self] anyObject];
    curPoint = [touch locationInView:self];
    CGPoint location = [touch locationInView:self];
    self.drawPath = CGPathCreateMutable();
    self.pathReleased = NO;
    CGPathMoveToPoint(self.drawPath, NULL, location.x, location.y);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    
    UITouch *touch = [[event touchesForView:self] anyObject];
    if (!CGPointEqualToPoint(prePoint, CGPointZero))     {
        curPoint = [touch locationInView:self];
    }
    prePoint = [touch previousLocationInView:self];
    [self scratchTheViewFrom:prePoint to:curPoint withPenSize: 12 ];
    
    CGPoint location = [touch locationInView:self];
    CGPathAddLineToPoint(self.drawPath, NULL, location.x, location.y);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    UITouch *touch = [[event touchesForView:self] anyObject];
    if (!CGPointEqualToPoint(prePoint, CGPointZero))     {
        prePoint = [touch previousLocationInView:self];
		// 需要有移动距离，才能执行操作
        if ( curPoint.x - prePoint.x > 1 || curPoint.y - prePoint.y > 1 ) {
            [self scratchTheViewFrom:prePoint to:curPoint withPenSize: 12 ];
        }
    }
    
    if (self.muarrDPath == nil) {
        self.muarrDPath = [NSMutableArray array];
    }
    YQMDrawPath *path = [YQMDrawPath YQMDrawPathWithCGPath:self.drawPath lineWidth:12];
    [self.muarrDPath addObject:path];
    CGPathRelease(self.drawPath);
    self.pathReleased = YES;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
}


#pragma mark - 工具视图执行方法
// 撤销
-(void)undoStep {
    imageToDraw = self.drawImage ;
    self.image = imageToDraw ;
    [self.muarrDPath removeLastObject ];
    for(YQMDrawPath *path in self.muarrDPath) {
        [self drawImageWithPath:path ] ;
    }
} 
// 清屏
-(void)clearScreen {
    imageToDraw = self.drawImage ;
    self.image = imageToDraw ;
}

// 继承于UIImageView，不会自动重绘，只能手动实现
- (void)scratchTheViewFrom:(CGPoint)startPoint to:(CGPoint)endPoint withPenSize:(float )fPenSize {
	UIGraphicsBeginImageContext( self.frame.size);
	[ imageToDraw drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	
	CGContextSaveGState(UIGraphicsGetCurrentContext());
	CGContextSetShouldAntialias(UIGraphicsGetCurrentContext(), YES);
	CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
	CGContextSetLineWidth(UIGraphicsGetCurrentContext(), fPenSize );
	CGContextSetStrokeColorWithColor( UIGraphicsGetCurrentContext() , [ [ UIColor whiteColor ] CGColor]);
	CGContextSetFillColorWithColor( UIGraphicsGetCurrentContext() , [ [ UIColor whiteColor ] CGColor]);
	CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1 , 1 , 1 , 1.0);
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, nil, startPoint.x, startPoint.y);
	CGPathAddLineToPoint(path, nil, endPoint.x, endPoint.y);
	CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear );
	CGContextAddPath(UIGraphicsGetCurrentContext(), path);
	CGContextStrokePath(UIGraphicsGetCurrentContext());
	imageToDraw = UIGraphicsGetImageFromCurrentImageContext();
	CGContextRestoreGState(UIGraphicsGetCurrentContext());
	UIGraphicsEndImageContext();
	
	[self initImage];
	
}

-(void)drawImageWithPath :(YQMDrawPath * ) path {
    UIGraphicsBeginImageContext( self.frame.size);
    [ imageToDraw drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    CGContextSaveGState(UIGraphicsGetCurrentContext());
    CGContextSetShouldAntialias(UIGraphicsGetCurrentContext(), YES);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(),  path.lineWidth );
    CGContextSetStrokeColorWithColor( UIGraphicsGetCurrentContext() , [ [ UIColor whiteColor ] CGColor]);
    CGContextSetFillColorWithColor( UIGraphicsGetCurrentContext() , [ [ UIColor whiteColor ] CGColor]);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1 , 1 , 1 , 1.0);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear );
    CGContextAddPath(UIGraphicsGetCurrentContext(), path.drawPath.CGPath);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    imageToDraw = UIGraphicsGetImageFromCurrentImageContext();
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
    UIGraphicsEndImageContext();
    
    [ self initImage ];
}


@end

@implementation YQMDrawPath

+(id)YQMDrawPathWithCGPath:(CGPathRef)drawPath lineWidth:(CGFloat)lineWidth {
    YQMDrawPath *path = [[YQMDrawPath alloc]init];
    path.drawPath = [UIBezierPath bezierPathWithCGPath:drawPath];
    path.lineWidth = lineWidth;
    return path;
}


@end
