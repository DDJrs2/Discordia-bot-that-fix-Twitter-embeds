# Discordia-bot-that-changes-Twitter-links-into-FXTwitter-or-something-well-this-name-is-exaggeratedly-long-but-i-can-do-worst-than-that
A small bot made using [Discordia](https://github.com/SinisterRectus/Discordia) API. It's porpuse is to fix Twitter links that fails to embed in Discord, by adding 'fx' to the link

## Known issue
If there's two or more Twitter links in one message, only the first link will be sent.

If the 'separateOnlyFXTwitterLink' function is not used, the entire user's message will be sent throught the bot, so if there's more than one Twitter link in the message, the bot will keep sending the message until all Twitter links has been fixed.

Sometimes the bot will try to fix the link regardless if the original link got embedded succesfully.
