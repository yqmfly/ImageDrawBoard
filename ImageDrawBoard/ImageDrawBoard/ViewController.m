//
//  ViewController.m
//  ImageDrawBoard
//
//  Created by y on 2018/1/25.
//  Copyright © 2018年 y. All rights reserved.
//

#import "ViewController.h"

#import "YQMADrawImgview.h"

@interface ViewController () {
	YQMADrawImgview *yView ;
	UIImageView *imgviewReturn ;
}

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	yView = [[YQMADrawImgview alloc]initWithFrame: CGRectMake( 10 , 110 , 320 , 480 )  ];
	[self.view addSubview:yView];
	[self.view bringSubviewToFront:yView];
	yView.drawImage = [UIImage imageNamed:@"320.jpeg"] ;
	[yView initScratch];
	[yView initImage];
	
	imgviewReturn = [[UIImageView alloc]initWithFrame: CGRectMake( 10 , 600 , 160 , 240 )  ] ;
	imgviewReturn.image = yView.returnImage ;
	[self.view addSubview:imgviewReturn];
	
	UIButton *btnUndo = [UIButton buttonWithType:UIButtonTypeCustom];
	[btnUndo setTitle:@"undoStep" forState:UIControlStateNormal];
	btnUndo.frame = CGRectMake(20, 65, 90, 30);
	btnUndo.backgroundColor = [UIColor redColor];
	[self.view addSubview:btnUndo];
	[btnUndo addTarget:self action:@selector(undoAction) forControlEvents:UIControlEventTouchUpInside];
	
	UIButton *btnClear = [UIButton buttonWithType:UIButtonTypeCustom];
	[btnClear setTitle:@"Clear" forState:UIControlStateNormal];
	btnClear.frame = CGRectMake(120, 65, 90, 30);
	btnClear.backgroundColor = [UIColor redColor];
	[self.view addSubview:btnClear];
	[btnClear addTarget:self action:@selector(btnClearAction:) forControlEvents:UIControlEventTouchUpInside];
	
	UIButton *btnShow = [UIButton buttonWithType:UIButtonTypeCustom];
	[btnShow setTitle:@"show" forState:UIControlStateNormal];
	btnShow.frame = CGRectMake(220, 65, 90, 30);
	btnShow.backgroundColor = [UIColor redColor];
	[self.view addSubview:btnShow];
	[btnShow addTarget:self action:@selector(benShowAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - ---Button Action---
-(void)undoAction{
	[yView undoStep];
}

-(void)btnClearAction:(UIButton *)btn {
	[yView clearScreen];
}


-(void)benShowAction:(UIButton *)btn {
	imgviewReturn.image = yView.returnImage ; 
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


@end
