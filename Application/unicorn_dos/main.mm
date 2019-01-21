#import <Foundation/Foundation.h>
OBJC_EXTERN CFStringRef MGCopyAnswer(CFStringRef key) WEAK_IMPORT_ATTRIBUTE;

NSString* getUDID() {
    NSString *udid = (__bridge NSString*)MGCopyAnswer(CFSTR("UniqueDeviceID"));
    return udid;
}

int main() {
  system("killall -SEGV SpringBoard");
}
