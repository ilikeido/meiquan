//
//  ViewController.m
//  meiQuanDemo
//
//  Created by ilikeido on 15-3-3.
//  Copyright (c) 2015年 ilikeido. All rights reserved.
//

#import "ViewController.h"
#import "GPUImage.h"
#import "ZDStickerView.h"
#import "UIImage+Resize.h"

@interface ViewController ()<ZDStickerViewDelegate>


@property(nonatomic,strong) NSString *imageName;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property(nonatomic,strong) NSArray *filters;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property(nonatomic,strong) ZDStickerView *stickerView;
@property(nonatomic,strong) UITapGestureRecognizer* stickerViewTapRecognizer;
@property(nonatomic,strong) UIView* contentView;
@property(nonatomic,strong) UIImageView *tempImageView;
@property(nonatomic,strong) UIImage *sourceImage;

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
        [button addTarget:self action:@selector(processFilter:) forControlEvents:UIControlEventTouchUpInside];
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

-(IBAction)processFilter:(id)sender{
    UIButton *button = (UIButton *)sender;
    int tag = (int)button.tag;
    GPUImageOutput<GPUImageInput> *filter = [self getFilter:tag];
    UIImage *imageResult = [filter imageByFilteringImage:self.sourceImage];
    self.imageView.image = imageResult;
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
    [self initContentView];
    self.sourceImage = [self.imageView.image resizedImageWithContentMode:self.imageView.contentMode bounds:self.imageView.bounds.size interpolationQuality:3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)initContentView{
    self.contentView = [[UIView alloc] init];
    [self.imageView setUserInteractionEnabled:YES];
//    [self addImage:nil];
}

- (IBAction)addImage:(id)sender {
    [self.contentView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]];
    
    self.stickerView = [[ZDStickerView alloc] init];
    self.stickerView.tag = 0;
    self.stickerView.delegate = self;
    self.stickerView.contentView = self.contentView;//contentView;
    self.stickerView.preventsPositionOutsideSuperview = YES;
    
    self.tempImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"test.png"]];
    CGRect gripFrame1 = CGRectInset(self.tempImageView.frame, 50, 50);//CGRectMake(50, 50, 140, 140);
    self.contentView.frame = gripFrame1;
    [self.contentView addSubview:self.tempImageView];
    
    self.stickerView.frame = gripFrame1;
    [self.stickerView showEditingHandles];
    
    [self.imageView addSubview:self.stickerView];
    [self addTapAction];
    
}

-(IBAction)mergedImage:(id)sender{
    UIImage *image = [self imageFormImageView:self.imageView mergedImageByImageView:self.tempImageView];
    self.imageView.image = image;
}

-(void)addTapAction{
    UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideStickerButton)];
    singleRecognizer.numberOfTapsRequired = 1;
    [self.imageView addGestureRecognizer:singleRecognizer];
}


-(void)hideStickerButton{
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    [self.stickerView hideEditingHandles];
    self.stickerViewTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showStickerButton)];
    self.stickerViewTapRecognizer.numberOfTapsRequired = 1;
    [self.stickerView addGestureRecognizer:self.stickerViewTapRecognizer];
}

-(void)showStickerButton{
    [self.stickerView showEditingHandles];
    [self.stickerView removeGestureRecognizer:self.stickerViewTapRecognizer];
    [self.contentView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]];
}

- (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 rect:(CGRect)clipRect{
    UIGraphicsBeginImageContext(image1.size);
    [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
    [image2 drawInRect:clipRect];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

-(UIImage *)imageFormImageView:(UIImageView *)fromImageView mergedImageByImageView:(UIImageView *)mergedImageView{
    UIImage *targetImage = [fromImageView.image resizedImageWithContentMode:fromImageView.contentMode bounds:fromImageView.bounds.size interpolationQuality:3];
    UIImage *tempImage = [mergedImageView.image resizedImage:mergedImageView.frame.size interpolationQuality:kCGInterpolationHigh];
    CGPoint point = [fromImageView convertPoint:CGPointZero fromView:mergedImageView];
    CGRect rect = mergedImageView.frame;
    rect.origin =  point;
    UIImage *image = [self addImage:targetImage toImage:tempImage rect:rect];
    return image;
}

@end
