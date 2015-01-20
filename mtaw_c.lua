--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 13 Ultimate
-- Date: 03.12.2014 - Time: 10:55
-- pewx.de // iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
local wtd = {prefix = "|Client| MTAWatchdog: ", w = 645, h = 500, t = {state = nil}}

wtd.watch = {}
function wtd.vAdd()
    if wtd.t.state == 1 then
        if guiGetText(wtd.t.edit) == "" then return end
        if not guiCheckBoxGetSelected(wtd.t.cb) then
            local sRes = "-"
            if guiComboBoxGetSelected(wtd.t.cbx) >= 0 then sRes = getResourceFromName(guiComboBoxGetItemText(wtd.t.cbx, guiComboBoxGetSelected(wtd.t.cbx))) end
            local t = guiGetText(wtd.t.edit)
            local nRow = guiGridListAddRow(wtd.gridlist)
            guiGridListSetItemText(wtd.gridlist, nRow, 1, #wtd.watch, false, true)
            guiGridListSetItemText(wtd.gridlist, nRow, 2, "Client", false, false)
            guiGridListSetItemText(wtd.gridlist, nRow, 3, sRes ~= "-" and getResourceName(sRes) or "-", false, false)
            guiGridListSetItemText(wtd.gridlist, nRow, 4, "-", false, false)
            guiGridListSetItemText(wtd.gridlist, nRow, 5, t, false, false)
            guiGridListSetItemText(wtd.gridlist, nRow, 6, "wait..", false, false)
            table.insert(wtd.watch, {sToWatch = t, nRow = nRow, sRes = sRes})
       end
    end
end

setTimer(function()
    for i, w in ipairs(wtd.watch) do
        if getResourceState(w.sRes) then
            local value = call(w.sRes, "MTAWatchdogEnv")[w.sToWatch]
            guiGridListSetItemText(wtd.gridlist, w.nRow, 6, tostring(value), false, false)
        end
    end
end, 2500, -1)

function wtd.switch(nSTo)
    if nSTo == wtd.t.state then
        for _, e in pairs(wtd.t) do if isElement(e) then destroyElement(e) else end end
       wtd.t = {state = 0}
       guiSetSize(wtd.window, wtd.w, wtd.h - 40, false)
       return true
    end
    
    if nSTo == 1 then
        for _, e in pairs(wtd.t) do if isElement(e) then destroyElement(e) else end end
        guiSetSize(wtd.window, wtd.w, wtd.h, false)
        wtd.t = {state = 1}
        wtd.t.edit = guiCreateEdit(8, 297, 120, 27, "", false, wtd.window)
        wtd.t.cbx = guiCreateComboBox(136, 297, 150, 27, "Resource", false, wtd.window)
        wtd.t.cb = guiCreateCheckBox(398, 297, 150, 27, "Serverside", false, false, wtd.window)
        for _, r in ipairs(wtd.resources) do outputChatBox("Added") guiComboBoxAddItem(wtd.t.cbx, getResourceName(r)) end
        guiComboBoxAdjustHeight(wtd.t.cbx, #wtd.resources+1)
        return true
    end
    
    if nSTo == 2 then
        for _, e in pairs(wtd.t) do if isElement(e) then destroyElement(e) else end end
        guiSetSize(wtd.window, wtd.w, wtd.h, false)
        wtd.t = {state = 2}
        wtd.t.edit = guiCreateEdit(8, 297, 216, 27, "", false, wtd.window)
        wtd.t.cb = guiCreateCheckBox(398, 297, 239, 27, "Serverside", false, false, wtd.window)
        return true
    end
end

wtd.scrs = {guiGetScreenSize()}
function wtd.createPanel()
    wtd.onClick = {}
    wtd.window = guiCreateWindow(wtd.scrs[1]/2-wtd.w/2, wtd.scrs[2]/2-wtd.h/2, wtd.w, wtd.h, "MTA Watchdog", false)
    guiWindowSetSizable(wtd.window, false)

    wtd.lblInfo = guiCreateLabel(14, 26, 391, 34, "Github: https://github.com/HorrorClown/MTAWatchdog\nBy HorrorClown (PewX)", false, wtd.window)

    wtd.gridlist = guiCreateGridList(8, 70, 628, 220, false, wtd.window)
    guiGridListAddColumn(wtd.gridlist, "ID", 0.05)
    guiGridListAddColumn(wtd.gridlist, "Side", 0.05)
    guiGridListAddColumn(wtd.gridlist, "Resource", 0.1)
    guiGridListAddColumn(wtd.gridlist, "Element", 0.2)
    guiGridListAddColumn(wtd.gridlist, "Var/Key", 0.3)
    guiGridListAddColumn(wtd.gridlist, "Value", 0.2)

    wtd.btnElementDatas = guiCreateButton(535, 26, 99, 34, "Element datas", false, wtd.window)
    wtd.btnVariables = guiCreateButton(417, 26, 110, 34, "Variables", false, wtd.window)
    wtd.btnAdd = guiCreateButton(586, 297, 60, 27, "Add", false, wtd.window)
    wtd.onClick[wtd.btnVariables] = {wtd.switch, 1}
    wtd.onClick[wtd.btnElementDatas] = {wtd.switch, 2}
    wtd.onClick[wtd.btnAdd] = {wtd.vAdd}

    wtd.switch(1)
    --[[wtd.t = {state = 1}
    wtd.t.edit = guiCreateEdit(11, 297, 216, 27, "", false, wtd.window)
    wtd.t.btnAdd = guiCreateButton(237, 297, 133, 27, "Add", false, wtd.window)
    wtd.t.cb = guiCreateCheckBox(398, 297, 239, 27, "Serverside", false, false, wtd.window)]]
end

addEventHandler("onClientGUIClick", root,
    function(btn, st)
        if btn ~= "left" or st ~= "up" then return end
        local callFunc = wtd.onClick[source]
        if callFunc and callFunc[1] then
            callFunc[1](callFunc[2])
        end
    end
)

wtd.resources = {}
addEvent("onMTAWatchdogInitResource")
addEventHandler("onMTAWatchdogInitResource", root,
    function(r)
        for k, v in ipairs(wtd.resources) do if not isElement(v) then table.remove(wtd.resources, k) end end
        outputDebugString(wtd.prefix .. ("Registered resource '%s'"):format(getResourceName(r)))
        table.insert(wtd.resources, r)
    end
)

addEventHandler("onClientResourceStop", root,
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

--//Useful
function guiComboBoxAdjustHeight ( combobox, itemcount )
    if getElementType ( combobox ) ~= "gui-combobox" or type ( itemcount ) ~= "number" then error ( "Invalid arguments @ 'guiComboBoxAdjustHeight'", 2 ) end
    local width = guiGetSize ( combobox, false )
    return guiSetSize ( combobox, width,  itemcount*20+5 , false )
end

wtd.createPanel()
showCursor(true)
