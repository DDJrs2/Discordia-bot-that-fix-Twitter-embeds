Discord = require('discordia');
Client = Discord.Client();

local file = io.open("prefix.txt", "r");
local prefix = file:read("*a");
local prefixLenght = string.len(prefix);
file:close();

Client:on('ready', function()
    print('Yeehaw');
end)


local function extractContent(rawContentToExtract)
    for i = 1, string.len(rawContentToExtract), 1 do
        if string.sub(rawContentToExtract, i, i) == " " then
            return string.sub(rawContentToExtract, i+1, -1);
        end
    end
end

local function isThisTwitter(rawContent, i)
    return string.sub(rawContent, i, string.len("https://twitter.com")+i) == "https://twitter.com/";
end

local function isThisFXTwitter(rawContent, i)
    return string.sub(rawContent, i, string.len("https://fxtwitter.com")+i) == "https://fxtwitter.com/";
end

local function isThisStatus(rawContent, i)
    return string.sub(rawContent, i, string.len("status")+i) == "status/";
end

local function FindTwitterAndStatus(Message)
    local rawContent = Message.content;
    local confirmation = false;

    for i = 1, string.len(rawContent), 1 do
        if isThisTwitter(rawContent, i) then
            confirmation = true;
            break;
        end
    end

    if confirmation then
        for i = 1, string.len(rawContent), 1 do
            if isThisStatus(rawContent, i) then
                return true;
            end
        end
    else
        return false;
    end
    
    return false;
end

local function separateOnlyFXTwitterLink(entireMessage)
    for i = 1, string.len(entireMessage), 1 do
        if isThisFXTwitter(entireMessage, i) then
            for j = i, string.len(entireMessage), 1 do
                if string.sub(entireMessage, j, j) == " " then
                    return string.sub(entireMessage, i, j);
                end
            end
        end
    end

    for i = 1, string.len(entireMessage), 1 do
        if isThisFXTwitter(entireMessage, i) then
            return string.sub(entireMessage, i,-1);
        end
    end
end

local function TransformTwitterToFXTwitter(Message)
    if FindTwitterAndStatus(Message) then

        local rawContent = Message.content;

        for i = 1, string.len(rawContent), 1 do
            if isThisTwitter(rawContent, i) then
                return separateOnlyFXTwitterLink(string.sub(rawContent, 1, i-1) .. "https://fxtwitter.com" .. string.sub(rawContent, i+string.len("https://twitter.com"), -1)); 
            end
        end

    end
end


local function hello(Message)
    Message:reply(string.format('Hey %s!', Message.author.mentionString));
    Message:addReaction("👋");
end

local function echo(Message, echo)
    if echo ~= nil then
        Message:reply(string.format("%s", echo));
    else
        Message:reply(string.format("%s, Say something and I'll say it back!", Message.author.mentionString));
    end
end


CommandsTable = {

    ["hello"] = hello,
    ["echo"]  = echo,

}


Client:on("messageCreate", function(Message)

    local rawContent = Message.content;

    if (string.sub(rawContent, 1, prefixLenght):lower() == prefix) then

        local command;
        local argument = extractContent(rawContent);

        if argument ~= nil then
            command = string.sub(rawContent, prefixLenght+1, -(string.len(argument))-2):lower();
        else
            command = string.sub(rawContent, prefixLenght+1, -1):lower();
        end

        local funcao = CommandsTable[command];

        if funcao ~= nil then
            funcao(Message, argument);
        end

    elseif (FindTwitterAndStatus(Message) and Message.embed == nil and not Message.author.bot) then

        Message.channel:send(TransformTwitterToFXTwitter(Message));

    end

end)

local TokenFile = io.open("token.txt", "r");
local TokenString = TokenFile:read('*a');
TokenFile:close();
Client:run('Bot ' .. TokenString);
