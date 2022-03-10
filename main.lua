Discord = require('discordia');
Client = Discord.Client();

local file = io.open("prefix.txt", "r");
local prefix = file:read("*a"); --let's say the prefix is 'ts!'.
local prefixLenght = string.len(prefix);
file:close();

Client:on('ready', function()
    print('Yeehaw');
end)

--begin of these helpful functions--
local function extractContent(rawContentToExtract)
    for i = 1, string.len(rawContentToExtract), 1 do
        if string.sub(rawContentToExtract, i, i) == " " then
            return string.sub(rawContentToExtract, i+1, -1); --"ts!echo Nanora!" --> "Nanora!"
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
    local confirmation1 = false;
    local confirmation2 = false;

    for i = 1, string.len(rawContent), 1 do
        if isThisTwitter(rawContent, i) then
            confirmation1 = true;
            break;
        end
    end

    if confirmation1 then
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
--end of these helpful functions--

--user-controlled functions--
local function hello(Message)
    Message:reply(string.format('Hey %s!', Message.author.mentionString));
    Message:addReaction("👋");
end

local function echo(Message)
    local rawContent = Message.content;
    local echo = extractContent(rawContent);
    if echo ~= nil then
        Message:reply(string.format("%s", echo));
    else
        Message:reply(string.format("%s, Say something and I'll say it back!", Message.author.mentionString));
    end
end
--end functions--

--functions table
CommandsTable = {

    ["hello"] = hello,
    ["echo"]  = echo,

}

--event-oriented, will execute everytime a message is sent to a server
Client:on("messageCreate", function(Message)

    local rawContent = Message.content;

    if (string.sub(rawContent, 1, prefixLenght):lower() == prefix) then

        local command;
        local content = extractContent(rawContent);

        if content ~= nil then
            command = string.sub(rawContent, prefixLenght+1, -(string.len(content))-2):lower(); --"ts!echo henlo lizer" will be "echo", excluding "ts!" and " henlo lizer"
        else
            command = string.sub(rawContent, prefixLenght+1, -1):lower(); --"ts!hello" will be "hello", excluding "ts!" only
        end

        local funcao = CommandsTable[command]; --CommandsTable["echo"];

        if funcao ~= nil then
            funcao(Message); --> echo(Message);
        end

    elseif (Message.embed == nil and FindTwitterAndStatus(Message)) then

        Message.channel:send(TransformTwitterToFXTwitter(Message));

    end

end)

local TokenFile = io.open("token.txt", "r");
local TokenString = TokenFile:read('*a');
TokenFile:close();
Client:run('Bot ' .. TokenString);
