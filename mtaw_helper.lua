--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 13 Ultimate
-- Date: 04.12.2014 - Time: 21:20
-- pewx.de // iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--

--[[
 //
You need to add follow lines in any resource meta!
<script src = "mtaw_helper.lua" type = "shared" />
<export function = "MTAWatchdogEnv" type = "shared" />
\\
]]

__SERVER = triggerServerEvent == nil
__CLIENT = not SERVER

addEventHandler(__SERVER == true and "onResourceStart" or "onClientResourceStart", root,
    function(r)
        if r == getThisResource() or getResourceName(r) == "MTAWatchdog" then
            triggerEvent("onMTAWatchdogInitResource", root, getThisResource())
        end
    end
)

function MTAWatchdogEnv()
    return _G
end
