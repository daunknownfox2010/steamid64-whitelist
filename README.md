# Server SteamID64 Whitelist
*Server SteamID64 Whitelist* is a Garry's Mod add-on that allows server hosters to create a player whitelist for their server using 64-bit SteamIDs.
Server hosters can use this instead of `sv_password` to create a locked public server that doesn't require a password.
<br/><br/>
## Installation
* Download via `git` or the ZIP.
* Place the "id64wl" folder inside the Garry's Mod "addons" folder.
## Commands
`id64wl_enabled [0 ... 1]` - enables the whitelist.
`id64wl_message "#GameUI_ConnectionFailed"` - disconnection reason when failing the whitelist.
`id64wl_addid "STEAM_0:*:*" ...` - add a regular SteamID to the whitelist.
`id64wl_addid64 "***********" ...` - add a 64-bit SteamID to the whitelist.
`id64wl_removeid "STEAM_0:*:*" ...` - remove a regular SteamID from the whitelist.
`id64wl_removeid64 "***********" ...` - remove a 64-bit SteamID from the whitelist.
`id64wl_clear` - clears the entire whitelist.
`id64wl_print` - lists the current IDs in the whitelist.
