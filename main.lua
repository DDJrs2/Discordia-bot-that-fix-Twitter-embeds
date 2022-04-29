Discord = require('discordia');
Client = Discord.Client();

require('TwitterFX');

Client:on("messageCreate", function(message)
	if not Client.user.bot then return end
	if (FindTwitterAndStatus(message) and message.embed == nil and not message.author.bot) then

		if not Client:waitFor("messageUpdate", 2000) then --This condition will be true if the message don't get an embed in 2000 milliseconds
			message.channel:send(SendFXTwitterLink(message));
		end

	end
end)

local TokenFile = io.open("token.txt", "r");
local TokenString = TokenFile:read('*a');
TokenFile:close();
Client:run('Bot ' .. TokenString);
