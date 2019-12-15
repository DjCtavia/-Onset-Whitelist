local fileNameForWhiteList = "whitelist.txt"
local fileWhiteList = "packages/"..GetPackageName().."/"..fileNameForWhiteList
local whiteListKickMessage = "You are not whitelisted on this server."

function file_exists(file)
    local file = io.open(file, "rb")

    if file then file:close() end
    return file ~= nil
end

function isOnWhitelist(file, player)
    local steamdId64 = tostring(GetPlayerSteamId(player))

    if not file_exists(file) or steamdId64 == "0" then
        if steamdId64 == 0 then
            print("["..GetPackageName().."] steamId64 of player is invalid.")
        else
            print("["..GetPackageName().."] The file \""..file.."\" is missing.")
        end
        return false
    end
    print("["..GetPackageName().."] type of steamId64: ".. type(steamdId64))
    for steamId64ToVerify in io.lines(file) do
        if steamId64ToVerify == steamdId64 then
            return true
        end
    end
    return false;
end

AddEvent("OnPackageStart", function()
    if not file_exists(fileWhiteList) then
        ServerExit("["..GetPackageName().."] The whitelist file ("..fileNameForWhiteList..") is missing.")
    end
end)

AddEvent("OnPlayerSteamAuth", function(player)
    if not isOnWhitelist(fileWhiteList, player) then
        KickPlayer(player, whiteListKickMessage)
    end
end)