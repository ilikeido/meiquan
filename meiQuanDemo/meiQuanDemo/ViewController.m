//
//  ViewController.m
//  meiQuanDemo
//
//  Created by ilikeido on 15-3-3.
//  Copyright (c) 2015年 ilikeido. All rights reserved.
//

#import "ViewController.h"
#import "GPUImage.h"
@interface ViewController ()

@property(nonatomic,strong) NSString *imageName;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property(nonatomic,strong) NSArray *filters;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property(nonatomic,strong) GPUImageOutput<GPUImageInput> *filter;

@end

@implementation ViewController

-(void)initWithFilter{
    self.filters = @[@{@"name":@"原始"},@{@"name":@"薄荷"},@{@"name":@"灰调"},@{@"name":@"卡布奇诺"},@{@"name":@"拿铁"},@{@"name":@"摩卡"},@{@"name":@"黑白"},@{@"name":@"黄昏"},@{@"name":@"蓝调"},@{@"name":@"热情"},@{@"name":@"玛奇朵"},@{@"name":@"HDR"}];
}

-(void)initScrollView{
    CGRect rect = self.scrollView.frame;
    CGFloat width = rect.size.height;
    CGFloat beginX = 0;
    UIImage *image = [UIImage imageNamed:self.imageName];
    int i = 0;
    for (NSDictionary *dict in self.filters) {
        GPUImageOutput<GPUImageInput> *filter = [self getFilter:i];
        UIImage *imageResult = [filter imageByFilteringImage:image];;

        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(beginX, 0, width, width)];
        button.tag = i;
        beginX += width;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:[dict objectForKey:@"name"] forState:UIControlStateNormal];
        [button setBackgroundImage:imageResult forState:UIControlStateNormal];
        [self.scrollView addSubview:button];
        i++;
    }
    if (beginX > self.scrollView.frame.size.width) {
        rect.size.width = beginX;
        self.scrollView.contentSize = rect.size;
    }
}

-(GPUImageOutput<GPUImageInput> *) getFilter:(int) index {
    GPUImageOutput<GPUImageInput> *filter = nil;;
    switch (index) {
        case 1:{
            filter = [[GPUImageContrastFilter alloc] init];
            [(GPUImageContrastFilter *) filter setContrast:1.75];
        } break;
        case 2: {
            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"crossprocess"];
        } break;
        case 3: {
            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"02"];
        } break;
        case 4: {
            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"17"];
        } break;
        case 5: {
            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"aqua"];
        } break;
        case 6: {
            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"yellow-red"];
        } break;
        case 7: {
            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"06"];
        } break;
        case 8: {
            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"purple-green"];
        } break;
        default:
            filter = [[GPUImageRGBFilter alloc] init];
            break;
    }
    return filter;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageName = @"mm.jpg";
    [self initWithFilter];
    [self initScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
