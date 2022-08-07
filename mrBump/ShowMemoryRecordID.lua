function ShowMemoryRecordID()
    local addressList = getAddressList()

    for i = 0, addressList.getCount() - 1 do
        local memrc = addressList.getMemoryRecord(i)
        -- Append "#id" at the end of memory record description
        memrc.setDescription('#' .. memrc.ID .. ' ' .. memrc.getDescription())
    end

    addressList.rebuildDescriptionCache()
end

function HideMemoryRecordID()
    local addressList = getAddressList()

    for i = 0, addressList.getCount() - 1 do
        local memrc = addressList.getMemoryRecord(i)
        -- Remove "#id" amd the space right after it
        local firstHashPos = memrc.getDescription():find("%#")
        if firstHashPos ~= nil then
            local fistSpacePos = memrc.getDescription():find(' ')
            memrc.setDescription(string.sub(memrc.getDescription(), fistSpacePos + 1))
        end
    end

    addressList.rebuildDescriptionCache()
end

-----------------------
-- MenuItem functions--
-----------------------
function miShowMemoryRecordIDClick(sender)
    MAINMENU.miShowMemoryRecordID.Checked = not MAINMENU.miShowMemoryRecordID.Checked

    if MAINMENU.miShowMemoryRecordID.Checked then
        ShowMemoryRecordID()
    else
        HideMemoryRecordID()
    end
end

-- If MAINMENU doesn't exist. Create it
-- This will hold all my extension MenuItems
if MAINMENU == nil then
    local mainForm = getMainForm()
    local frmMenu = mainForm.getMenu()
    local frmMenuItems = frmMenu.getItems()

    MAINMENU = createMenuItem(frmMenuItems)
    MAINMENU.setCaption("mrBump")

    frmMenuItems.add(MAINMENU)
end

-- Create our extension MenuItem
local mi = createMenuItem(MAINMENU)
mi.Name = 'miShowMemoryRecordID'
mi.setCaption("Show memory record #ID")
mi.setOnClick(miShowMemoryRecordIDClick)

MAINMENU.Add(mi)
