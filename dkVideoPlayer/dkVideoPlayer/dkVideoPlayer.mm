#line 1 "/Users/zhudekun/mycode/test/AppHooker/dkVideoPlayer/dkVideoPlayer/dkVideoPlayer.xm"


#if TARGET_OS_SIMULATOR
#error Do not support the simulator, please use the real iPhone Device.
#endif

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

static __attribute__((constructor)) void _logosLocalCtor_3b47fc20(int __unused argc, char __unused **argv, char __unused **envp) {


    NSDictionary *pref = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.dkjone.dkplayer.plist"];
    NSString *dylibPath = @"/Library/Application Support/DKVideoLoader/libDKVideo.dylib";

    if (![[NSFileManager defaultManager] fileExistsAtPath:dylibPath]) {
        NSLog(@"DKVideoLoader dylib file not found: %@", dylibPath);
        return;
    }

    NSString *keyPath = [NSString stringWithFormat:@"DKVideoEnable--%@", [[NSBundle mainBundle] bundleIdentifier]];
    if ([[pref objectForKey:keyPath] boolValue]) {
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

}
