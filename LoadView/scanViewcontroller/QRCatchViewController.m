//
//  QRCatchViewController.m
//  QR_Code
//
//  Created by 郑随山 on 16/5/23.
//  Copyright © 2016年 郑随山. All rights reserved.
//

#import "QRCatchViewController.h"
#import "AppDelegate.h"

#import <AVFoundation/AVFoundation.h>
#import "NSObject+Macro.h"


@interface QRCatchViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property (weak, nonatomic) IBOutlet UILabel *stringLabel;
@property (weak, nonatomic) IBOutlet UIView *preview;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *blurView;
@property (weak, nonatomic) IBOutlet UIImageView *catcherIndicator;
@property (weak, nonatomic) IBOutlet UIView *borderView;
@property (strong,nonatomic) CAShapeLayer *mask;

//AVFoundation
@property (strong,nonatomic) AVCaptureSession *session;
@property (strong,nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation QRCatchViewController

#pragma mark View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupAVFoundation];
    [self setupLabelBorder];
    [self setupRippleAnimation];
    
    //add blur view mask
    self.mask = [CAShapeLayer layer];
    self.mask.fillRule = kCAFillRuleEvenOdd;
    self.blurView.layer.mask = self.mask;
    
}

//使用Autolayout布局,我们在viewDidLayoutSubviews才能获取布局后的正确frame
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    //layout preview layer
    self.previewLayer.bounds = self.preview.bounds;
    self.previewLayer.position = CGPointMake(CGRectGetMidX(self.preview.bounds), CGRectGetMidY(self.preview.bounds));
    
    //configure blur view mask layer
    self.mask.frame = self.blurView.bounds;

    UIBezierPath *outRectangle = [UIBezierPath bezierPathWithRect:self.blurView.bounds];
    CGRect inRect;
    if (IS_IPHONE_6P)
    {
        inRect = [self.catcherIndicator convertRect:CGRectMake(72, 72, 272, 272) toView:self.blurView];
    }
    else
    {
        inRect = [self.catcherIndicator convertRect:CGRectMake(52, 52, 272, 272) toView:self.blurView];
    }
    UIBezierPath *inRectangle = [UIBezierPath bezierPathWithRect:inRect];
    
    [outRectangle appendPath:inRectangle];
    outRectangle.usesEvenOddFillRule = YES;
    self.mask.path = outRectangle.CGPath;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -  view did load setup
- (void)setupAVFoundation
{
    //session
    self.session = [[AVCaptureSession alloc] init];
    //device
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    //input
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if(input)
    {
        [self.session addInput:input];
    } else {
        NSLog(@"%@", error);
        return;
    }
    //output
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [self.session addOutput:output];
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //add preview layer
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    [self.preview.layer addSublayer:self.previewLayer];
    
    //start
    [self.session startRunning];
}

- (void)setupLabelBorder
{
    self.borderView.layer.borderWidth = 1;
    self.borderView.layer.borderColor = [[UIColor colorWithRed:65/225.0 green:182/255.0 blue:251 alpha:1] CGColor];
    self.borderView.backgroundColor = [UIColor colorWithRed:23/255.0 green:133/255.0 blue:251/255.0 alpha:0.3];
    self.borderView.hidden = YES;
}

- (void)setupRippleAnimation
{
    CGFloat width = 4;
    CGRect pathFrame = CGRectMake(0,0, width, width);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:pathFrame cornerRadius:width/2];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.position = self.view.center;
    shapeLayer.bounds = path.bounds;
    shapeLayer.path = [path CGPath];
    shapeLayer.strokeColor = [[UIColor colorWithRed:65/225.0 green:182/255.0 blue:251 alpha:1] CGColor];
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    shapeLayer.lineWidth = 0.2;
    [self.view.layer addSublayer:shapeLayer];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(60, 60, 1)];
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = @1;
    alphaAnimation.toValue = @0;
    
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    animation.animations = @[scaleAnimation, alphaAnimation];
    animation.duration = 1;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.repeatCount =  HUGE_VALF;
    animation.removedOnCompletion = NO;
    [shapeLayer addAnimation:animation forKey:nil];
    
    NSLog(@"%@",NSStringFromCGRect(shapeLayer.frame));
    
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Sure" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [_session startRunning];
    }]];
    [self presentViewController:alert animated:true completion:nil];
    for (AVMetadataMachineReadableCodeObject *metadata in metadataObjects) {
        if ([metadata.type isEqualToString:AVMetadataObjectTypeQRCode]) {
            
            self.borderView.hidden = NO;
            self.stringLabel.text = metadata.stringValue;
            
        }
    }
}

@end
