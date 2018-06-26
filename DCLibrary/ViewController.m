//
//  ViewController.m
//  DCLibrary
//
//  Created by 浩克 on 2018/6/25.
//  Copyright © 2018年 浩克. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "DCViewController.h"
#import <objc/runtime.h>
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    Person *p = [[Person alloc] init];
    Person *p1 = [[Person alloc] init];
    Person *p2 = [[Person alloc] init];
    Person *p3 = [[Person alloc] init];
    
    [self.navigationController pushViewController:[[DCViewController alloc] init] animated:true];
    
    
}
- (IBAction)touch:(id)sender {
    [self animation];
}

- (void)animation {
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = self.imageView.frame;
        self.imageView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height - 20);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGRect frame = self.imageView.frame;
            self.imageView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height + 40);
        } completion:^(BOOL finished) {
            
        }];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
