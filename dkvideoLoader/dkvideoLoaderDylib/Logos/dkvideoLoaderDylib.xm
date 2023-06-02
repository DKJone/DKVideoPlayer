// See http://iphonedevwiki.net/index.php/Logos

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <dlfcn.h>

@interface AssistiveTouch:UIWindow
+ (instancetype)shared;
@end


@interface DKVideoLoader: NSObject
@end

@implementation DKVideoLoader

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static DKVideoLoader *loader;
    dispatch_once(&onceToken, ^{
        loader = [[DKVideoLoader alloc] init];
    });

    return loader;
}

- (void)show {

     [[objc_getClass("AssistiveTouch") shared]  setHidden:NO];
}

@end

%ctor {

    NSString* dylibPath = [NSBundle.mainBundle  pathForResource:@"libDKVideo" ofType:@"dylib"];
     if (![[NSFileManager defaultManager] fileExistsAtPath:dylibPath]) {
         NSLog(@"DKVideoLoader dylib file not found: %@", dylibPath);
         return;
     }
     void *handle = dlopen([dylibPath UTF8String], RTLD_NOW);
    if (handle == NULL) {
        char *error = dlerror();
        return;
    }
    [[NSNotificationCenter defaultCenter] addObserver:[DKVideoLoader sharedInstance]
                                       selector:@selector(show)
                                           name:UIApplicationDidBecomeActiveNotification
                                         object:nil];


}
