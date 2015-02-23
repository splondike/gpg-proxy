This simple proxy lets me access my GPG configuration from a SELinux sandboxed Thunderbird using Enigmail. Hopefully it prevents a compromised Thunderbird from exporting private keys.

## Sandboxing Thunderbird

I use a command line line like this to sandbox Thunderbird:

   seunshare -t $(mktemp -d /tmp/thunderbird.XXXXXXXX) -h $THUNDERBIRD_HOME -- thunderbird

This doesn't stop a compromised thunderbird from attacking my other X applications via calls to the X server, but lets me use copy paste.

## Setup Enigmail to use proxy

1. Put the repo folder (containing client.sh and server.sh) inside your SELinux sandbox.
2. Start the server.sh script outside your sandbox context.
3. Open up Enigmail -> Preferences from the main application menu and select the basic tab. Override the GnuPG path with one pointing to your client.sh. Note that the home directory will be your sandbox dir.
4. Attempt to use Enigmail by decrypting or encrypting/signing an email.
