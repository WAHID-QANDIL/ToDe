//
//  LuanchViewController.m
//  ToDe
//
//  Created by Wahid Ali Wahid on 08/04/2026.
//

#import "LuanchViewController.h"
#import "SDWebImage/SDWebImage.h"

@interface LuanchViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end

@implementation LuanchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSURL *url = [[NSURL alloc]initWithString:@"https://cdn.dribbble.com/userupload/33913675/file/original-8981491c7f67d5e4effe16000747166a.png?resize=1024x768&vertical=center"];
    [self.image sd_setImageWithURL:url];
    
    
    
    
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
