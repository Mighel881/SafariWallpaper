#import <UIKit/UIKit.h>
#import <Cephei/HBPreferences.h>

#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

HBPreferences* preferences;

UIImageView* wallpaperView;
UIImage* wallpaper;

extern BOOL enabled;

extern CFArrayRef CPBitmapCreateImagesFromData(CFDataRef cpbitmap, void*, int, void*);

// wallpaper
BOOL useSpringBoardWallpaperSwitch = NO;

// user interface based wallpaper
BOOL useDifferentInterfaceWallpapersSwitch = NO;

@interface CatalogViewController : UIViewController
@end

@interface BookmarksNavigationController : UIViewController
@end