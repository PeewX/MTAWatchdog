--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 13 Ultimate
-- Date: 03.12.2014 - Time: 10:56
-- pewx.de // iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
local wtd = {prefix = "|Server| MTAWatchdog: "}

wtd.resources = {}
addEvent("onMTAWatchdogInitResource")
addEventHandler("onMTAWatchdogInitResource", root,
    function(r)
        for k, v in ipairs(wtd.resources) do if not isElement(v) then table.remove(wtd.resources, k) end end
        outputDebugString(wtd.prefix .. ("Registered resource '%s'"):format(getResourceName(r)))
        table.insert(wtd.resources, r)
    end
)

addEventHandler("onResourceStop", root,
    function(r)
        for k, v in ipairs(wtd.resources) do
            if v == r then
                outputDebugString(wtd.prefix .. ("Unregistered resource '%s'"):format(getResourceName(v) or "unknown"))
                table.remove(wtd.resources, k)
                return
            end
        end
    end
)
