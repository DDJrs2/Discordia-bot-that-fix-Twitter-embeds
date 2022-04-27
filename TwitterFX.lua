local function isThisTwitter(twitterString, i)
	return string.sub(twitterString, i, string.len("https://twitter.com")+i) == "https://twitter.com/";
end

local function isThisFXTwitter(twitterString, i)
	return string.sub(twitterString, i, string.len("https://fxtwitter.com")+i) == "https://fxtwitter.com/";
end

local function isThisStatus(twitterString, i)
	return string.sub(twitterString, i, string.len("status")+i) == "status/";
end

local function separateOnlyFXTwitterLink(entiremessage)
	for i = 1, string.len(entiremessage), 1 do
		if isThisFXTwitter(entiremessage, i) then
			for j = i, string.len(entiremessage), 1 do
				if string.sub(entiremessage, j, j) == " " then
					return string.sub(entiremessage, i, j);
				end
			end
		end
	end

	for i = 1, string.len(entiremessage), 1 do
    	if isThisFXTwitter(entiremessage, i) then
			return string.sub(entiremessage, i,-1);
    	end
    end
end

local function removeLastBar(link)
	local quantity = 0;
	for i = 1, string.len(link) do
		if string.sub(link, i+1, i+1) == "/" then
			quantity = quantity + 1;
		elseif quantity == 6 then
			return string.sub(link, 1, i-1);
		end
	end
end

function FindTwitterAndStatus(message)
    local rawContent = message.content;
	local yeaTwitterDoesExistLmao = false;

	for i = 1, string.len(rawContent), 1 do
		if isThisTwitter(rawContent, i) then
			yeaTwitterDoesExistLmao = true;
			break;
		end
	end

	if yeaTwitterDoesExistLmao then
		for i = 1, string.len(rawContent), 1 do
			if isThisStatus(rawContent, i) then
				return true;
			end
		end
	else
		return false;
	end
end

function SendFXTwitterLink(message)
	local rawContent = message.content;

	for i = 1, string.len(rawContent), 1 do
		if isThisTwitter(rawContent, i) then
			local link = separateOnlyFXTwitterLink(string.sub(rawContent, 1, i-1) .. "https://fxtwitter.com" .. string.sub(rawContent, i+string.len("https://twitter.com"), -1));
			local linkWithoutPhoto = removeLastBar(link);
			if linkWithoutPhoto ~= nil then
				return linkWithoutPhoto;
			else
				return link;
			end
		end
	end
end
