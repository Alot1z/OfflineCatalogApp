#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

%ctor {
    NSLog(@"[OfflineCatalogApp] Tweak loaded.");

    // Minimal example: Show an alert after SpringBoard loaded
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"OfflineCatalogApp"
                                                                       message:@"App loaded successfully!"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:nil];
        [alert addAction:ok];

        UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
        [rootVC presentViewController:alert animated:YES completion:nil];
    });
}
