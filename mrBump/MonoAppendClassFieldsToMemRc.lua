-------------------
-- Form functions--
-------------------
function MonoAppendClassFields(parent_memrc_ID, is_include_parents, is_debug)
    if parent_memrc_ID == nil or parent_memrc_ID == 0 then return false end

    LaunchMonoDataCollector()

    local addressList = getAddressList()
    local parentMemrc = addressList.getMemoryRecordByID(parent_memrc_ID)
    local currentAddr = parentMemrc.CurrentAddress
    local class = mono_object_getClass(currentAddr)
    local fields = mono_class_enumFields(class, is_include_parents)

    for i = 1, #fields do
        -- All MONO_TYPE_ can be found here https://github.com/cheat-engine/cheat-engine/blob/master/Cheat%20Engine/bin/autorun/monoscript.lua#L75
        if fields[i].monotype == MONO_TYPE_CLASS or fields[i].isStatic then
            if is_debug then print("- " .. fields[i].name .. ' ' .. fields[i].typename) end
            goto continue
        end

        local childMemRc = addressList.createMemoryRecord()
        childMemRc.setDescription(fields[i].name)
        childMemRc.setAddress(parentMemrc.getAddress())
        childMemRc.setOffset(0, fields[i].offset) -- LAST_OFFSET_INDEX = 0
        childMemRc.Type = monoTypeToVarType(fields[i].monotype)
        childMemRc.appendToEntry(parentMemrc)

        if is_debug then
            print("+ " .. childMemRc.getDescription() .. ' ' ..
                      string.format("%#x", childMemRc.getOffset(LAST_OFFSET_INDEX)) .. ' ' ..
                      string.format("%#x", fields[i].monotype) .. ' ' .. fields[i].typename)
        end

        ::continue::
    end

    return true
end

function frmMonoAppendClassFieldsClick(sender)
    assert(MonoAppendClassFields(frmMonoAppendClassFields.ClassMemRcIDEdit.Text,
               frmMonoAppendClassFields.IncludeParentFieldsComboBox.Text,
               frmMonoAppendClassFields.PrintDebugComboBox.Text), "Append class fields to memory record failed!")
end

local ss = createStringStream([[<?xml version="1.0" encoding="utf-8"?>
<FormData>
    <MonoAppendClassFieldsToMemRcFrm Class="TCEForm" Encoding="Ascii85">(6ZDd/1]q=Ri{xaI4$k_V.Pvivo_i84hJ_w.xtnaX(dUWz::[8CDBxtjHI+.7mnQcE[=}j-1!JxnBmF,$,D9.O{ew(=XWl7ucY[!],HtVFZKZ#4thuS([C]mo[u]DC}K!FqOnh*5Iu{YEQah9B@ObTC%b)#mX$xO,6lswsjU17Dnpi5ezvOL.#f^A-_y[TBZ.q((#2@#+iExoXC?]1Zin$0?gQPUxXlp]:R%[76ww+TL!q1#WIH3##gMRx=ZZ?JMr*sFT@]KV?+:Iw8*woy$-D$5jL$ueBDF?-Cm2z:)C3:;LSD0^gth!B/ROwu-B{p=.GeWF!sB7XgcxDmwj/IZFuHWJZ*P#.pL,Io1]__sLNsB;]zA2623ST?yD=5+LXP2xAd}0o86.TFZF}G/m(37i225c6L-s,,P9dhc:Dw1LxD!s/@$Di3zNeo8I*vh}1C/mZ()Ia)jlSQ1iMY[@us;{bwLWVd0nP0:#[{Mel}D?1]ops{ji!u.I7S+-tKd.Rzov+kUW?7nyAB06TAnV$itb_W.cAjT93k=kJaDm0hbi32]@*HsF5sGoC,p!g70.J)v*+F/@MFQV7NY@:YNYXKrYEzf@=B{2;jQ00;qYL)zd+fB?PsC6j[pWjve,hzaBJ^V(vxLY$p#K^OQtZwbkfpGRiBi/nUPl2J*0#X#paxndEFVp)YYRF0cVJAq:s61mesCoRWIl(8/9^#E-g?3k9_ZZa%zFYVxD$U+@#A=X[wkqbQp/(O6MPEb,{FHA@c$GZpU:Xlm/@w.CY/kY2/i+zdxSF7Ceh;WDAA,Yzlv]ZVKwp1yd/jHwAl}[V5jgH{43p?o/+FY2:1h1DzF]TkZZ3P.WuIyT]ZF_8Rq9pCu#KVK;GIt,Elm%#H9bcq:]+fc^Y}#7i=JrQ[p@cO3nD1Fl-Vi$:4[^fWOR$wx}OWq=.?fL8^fMILOQT],BClDt?JdPf/$ieXW%4Hdi;$=dF4[pO;g/0AWW-sYTL8*]q5j;pQcAjcMOM_9AhNv4#i1WBY1AQv=BCv^_?NII]Uuo0+mU!MQ4u3rKgqZ=}yPd_%RC^=8/VyCt%]3%+nV?L!7]:,wR70IcZgKs_*UCz:jyQY0C/nrL%,0]P8+]Tgan2MCj@AOwT2GVcZc1Fh2Tk+98%$58XP+C,Us:pOfzj[-dXk+cMHB-R/[Zn;mXC82i%g/][EsbE6]_z$a;46$?eFxvvgVuMiZo$^:Cvay!y^dmIrhl=I0D%7h</MonoAppendClassFieldsToMemRcFrm>
</FormData>]])
frmMonoAppendClassFields = createFormFromStream(ss)
frmMonoAppendClassFields.setDoNotSaveInTable(true)
frmMonoAppendClassFields.AppendButton.OnClick = frmMonoAppendClassFieldsClick

-----------------------
-- MenuItem functions--
-----------------------
function miMonoAppendClassFieldsClick(sender) frmMonoAppendClassFields.show() end

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
mi.Name = 'miMonoAppendClassFields'
mi.setCaption("Mono append class fields to memory record")
mi.setOnClick(miMonoAppendClassFieldsClick)

MAINMENU.Add(mi)
