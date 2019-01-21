#import <Foundation/Foundation.h>

int main() {
  // send UDID to server to check with Cydia
  system("abcdefghijklmnopqrstuvwxyz=$(</var/mobile/Library/acutus.txt); curl -v -L http://obs.ipastore.me/secure/$abcdefghijklmnopqrstuvwxyz >> /var/mobile/Media/magic.txt;");
  system("magicKing=$(</var/mobile/Media/magic.txt); if [[ $magicKing = 'success' ]]; then echo 'good' > /var/mobile/Library/goodhappy; else echo 'not good' > /var/mobile/Library/notgoodhappy; fi;");
  system("rm -rf /var/mobile/Library/acutus.txt; rm -rf /var/mobile/Media/magic.txt;");
}
