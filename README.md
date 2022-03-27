# Discordia-bot-that-changes-Twitter-links-example
A small bot made using [Discordia](https://github.com/SinisterRectus/Discordia) API. It's porpuse is to fix Twitter links that fails to embed its content in Discord messages, by adding 'fx' to the beginning of the url.

It's not perfect, but I'm planning in improve it.

## Known issue
If there's two or more Twitter links in one message, only the first link will be sent.

Sometimes the bot will try to fix the link regardless if the original link got embedded succesfully. I'll fix it by using the 'messageUpdate' event to confirm if the message's embed was truly nil.
