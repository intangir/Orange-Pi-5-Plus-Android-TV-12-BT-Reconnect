# Orange-Pi-5-Plus-Android-TV-12-BT-Reconnect

Magisk module to restart the bluetooth service after waking from resume so it reconnects the devices.

This was written specifically for the Orange Pi 5 Plus running either default Android TV 12 or similar images.
it has the issue of losing connection to all of the bluetooth devices when suspending and resuming,
but it doesn't seem to realize it and never reconnects to them, so you can't control them via bluetooth after they wake.

This just listens to a suspend/wake count and restarts it after it increments. 

This may work on other versions/images also but you may need to adjust it.

Requires Magisk and probably root.
