#line 1 "/Users/zhudekun/mycode/test/AppHooker/dkvideoLoader/dkvideoLoaderDylib/Logos/dkvideoLoaderDylib.xm"


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

static __attribute__((constructor)) void _logosLocalCtor_acb97b70(int __unused argc, char __unused **argv, char __unused **envp) {

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
    























}
