#import "SafariWallpaper.h"

BOOL enabled;

%group SafariWallpaper

%hook CatalogViewController

- (void)viewDidLoad { // add wallpaper

	%orig;

	if (!wallpaperView) {
		wallpaperView = [[UIImageView alloc] initWithFrame:[[self view] bounds]];
		[wallpaperView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[wallpaperView setContentMode:UIViewContentModeScaleAspectFill];
		if (!useDifferentInterfaceWallpapersSwitch) {
			NSData* data = [[NSDictionary dictionaryWithContentsOfFile: @"/var/mobile/Library/Preferences/love.litten.safariwallpaperpreferences.plist"] objectForKey:@"wallpaperImage"];
			wallpaper = [UIImage imageWithData:data];
		} else {
			if ([[self traitCollection] userInterfaceStyle] == UIUserInterfaceStyleLight) {
				NSData* data = [[NSDictionary dictionaryWithContentsOfFile: @"/var/mobile/Library/Preferences/love.litten.safariwallpaperpreferences.plist"] objectForKey:@"wallpaperImageLight"];
				wallpaper = [UIImage imageWithData:data];
			} else if ([[self traitCollection] userInterfaceStyle] == UIUserInterfaceStyleDark) {
				NSData* data = [[NSDictionary dictionaryWithContentsOfFile: @"/var/mobile/Library/Preferences/love.litten.safariwallpaperpreferences.plist"] objectForKey:@"wallpaperImageDark"];
				wallpaper = [UIImage imageWithData:data];
			}
		}
		[wallpaperView setImage:wallpaper];
		if (![wallpaperView isDescendantOfView:[self view]]) [[self view] insertSubview:wallpaperView atIndex:0];
	}

}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection { // transition when changing interface mode

	%orig;

	if ([[self traitCollection] userInterfaceStyle] == UIUserInterfaceStyleLight) {
		NSData* data = [[NSDictionary dictionaryWithContentsOfFile: @"/var/mobile/Library/Preferences/love.litten.safariwallpaperpreferences.plist"] objectForKey:@"wallpaperImageLight"];
		wallpaper = [UIImage imageWithData:data];
		[UIView transitionWithView:wallpaperView duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
			[wallpaperView setImage:wallpaper];
		} completion:nil];
	} else if ([[self traitCollection] userInterfaceStyle] == UIUserInterfaceStyleDark) {
		NSData* data = [[NSDictionary dictionaryWithContentsOfFile: @"/var/mobile/Library/Preferences/love.litten.safariwallpaperpreferences.plist"] objectForKey:@"wallpaperImageDark"];
		wallpaper = [UIImage imageWithData:data];
		[UIView transitionWithView:wallpaperView duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
			[wallpaperView setImage:wallpaper];
		} completion:nil];
	}

}

%end

%end

%ctor {

	preferences = [[HBPreferences alloc] initWithIdentifier:@"love.litten.safariwallpaperpreferences"];

	[preferences registerBool:&enabled default:nil forKey:@"Enabled"];

	// Miscellaneous
	[preferences registerBool:&useDifferentInterfaceWallpapersSwitch default:NO forKey:@"useDifferentInterfaceWallpapers"];

	if (enabled) {
		%init(SafariWallpaper);
	}

}