# Discordia-bot-that-fix-Twitter-embeds
A small bot made using [Discordia](https://github.com/SinisterRectus/Discordia) API. It's porpuse is to fix Twitter links that fails to embed its content in Discord messages, by adding 'vx' to the beginning of the url.

It's not perfect, but I'm planning in improve it.

## How it works
When a Twitter link is sent to a channel and has not been given an embed to it, the bot will copy the link and send with and additional 'vx' at the beginning of the url after few seconds.

## Known issue
If there's two or more Twitter links in one message, only the first link will be sent.
