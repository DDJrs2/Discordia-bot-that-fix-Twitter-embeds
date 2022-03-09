# Discordia-bot-that-changes-Twitter-links-into-FXTwitter-or-something-well-this-name-is-exaggeratedly-long-but-i-can-do-worst-than-that
A small bot made using [Discordia](https://github.com/SinisterRectus/Discordia) API.

Some friends of mine where complaining about Twitter status posts not embeding correctly in Discord, and they were lazy enough to not add 'fx' at the beginning of the URL.
So I did this bot to do all the work.

## Known issue
If there's two or more Twitter links in one message, only the first link will be sent.

If the 'separateOnlyFXTwitterLink' function is not used, the entire user's message will be sent throught the bot, so if there's more than one Twitter link in the message, the bot will keep sending the message until all Twitter links has been fixed.

Sometimes the bot will try to fix the link regardless if the original link got embedded succesfully.
