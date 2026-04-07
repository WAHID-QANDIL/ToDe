//
//  EditViewController.h
//  ToDe
//
//  Created by Wahid Ali Wahid on 08/04/2026.
//

#import <UIKit/UIKit.h>
#import "ToDe-Swift.h"
#import "DataSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface EditViewController : UIViewController
@property Task *task;
@property DataSource *dataSource;
@end

NS_ASSUME_NONNULL_END
