NSString* baseId = @"org.cocoapods.NicoMediaUIComponent";
NSString* bundleSuffix = @"/NicoMediaUIComponent.bundle";
NSString* bundleDirSuffix = @"/NicoMediaUIComponent.bundle/";
NSString* replaceTo = @"org.cocoapods.NicoMediaUIComponent.Resources";
CFStringRef bundleDirSuffixCF = (__bridge CFStringRef) bundleDirSuffix;
CFStringRef replaceToCF = (__bridge CFStringRef) replaceTo;
NSDictionary<NSString *,id>* replaced;

%hook NSBundle

- (NSDictionary<NSString *,id>*) infoDictionary {
	// NSLog(@"!!!infoDictionary %@ in %@", self.bundlePath, [ret objectForKey: @"CFBundleIdentifier"]);
	if ([self.bundlePath hasSuffix: bundleSuffix]) { // 当該bundleっぽい
		if (replaced) return replaced;
		NSDictionary<NSString *,id>* ret = %orig;
		if ([[ret objectForKey: @"CFBundleIdentifier"] isEqualToString: baseId]) {
			NSMutableDictionary<NSString *,id>* mod = [ret mutableCopy];
			mod[@"CFBundleIdentifier"] = replaceTo;
			replaced = [NSDictionary dictionaryWithDictionary: mod];
			// NSLog(@"Replaced! %@", replaced);
			return replaced;
		}
		// NSLog(@"Unknown Identifier: %@", [ret objectForKey: @"CFBundleIdentifier"]);
	}
	return %orig;
}

%end

CFStringRef (*__old__CFBundleGetIdentifier)(CFBundleRef bundle);

CFStringRef __new__CFBundleGetIdentifier(CFBundleRef bundle) {
	CFURLRef bundleUrl = CFBundleCopyBundleURL(bundle);
	CFStringRef bundlePath = CFURLGetString(bundleUrl);
	// NSLog(@"bundlePath: %@", bundlePath);
	if (CFStringHasSuffix(bundlePath, bundleDirSuffixCF)) {
		CFRelease(bundleUrl);
		// NSLog(@"Replaced CFBundleGetIdentifier");
		return replaceToCF;
	}
	CFRelease(bundleUrl);
	CFStringRef ret = __old__CFBundleGetIdentifier(bundle);
	// NSLog(@"CFBundleGetIdentifier: %@", ret);
	return ret;
}

%ctor {
	MSHookFunction(&CFBundleGetIdentifier, &__new__CFBundleGetIdentifier, &__old__CFBundleGetIdentifier);
}
