--[[
	---------------------------------------------------------
    TimeSpeaker is a app telling current time as speech.
    
    TimeSpeaker is activated from a momentary switch. If 
    switch is left on time is announced every 10 seconds.
    
    Timespeaker works in DC/DS-14/16/24 and requires 
    firmware 4.22 or up. 
    
	---------------------------------------------------------
	Localisation-file has to be as /Apps/Lang/RCT-Time.jsn
	---------------------------------------------------------
	Timespeaker is part of RC-Thoughts Jeti Tools.
	---------------------------------------------------------
	Released under MIT-license by Tero @ RC-Thoughts.com 2017
	---------------------------------------------------------
--]]
collectgarbage()
--------------------------------------------------------------------------------
-- Locals for application
local curTime, curHour, curMinute = 0, 0, 0
local swTime, timeStamp, timeStampSpeak = 0, 0, 0
--------------------------------------------------------------------------------
-- Read translations
local function setLanguage()
    local lng = system.getLocale()
    local file = io.readall("Apps/Lang/RCT-Time.jsn")
    local obj = json.decode(file)
    if(obj) then
        trans16 = obj[lng] or obj[obj.default]
    end
    collectgarbage()
end
--------------------------------------------------------------------------------
local function swTimeChanged(value)
    local pSave = system.pSave
	swTime = value
	pSave("swTime",value)
end
--------------------------------------------------------------------------------
-- Draw the main form (Application inteface)
local function initForm()
    local form, addRow, addLabel = form, form.addRow ,form.addLabel
    local addIntbox, addSelectbox = form.addIntbox, form.addSelectbox
    local addInputbox = form.addInputbox
    
	addRow(1)
	addLabel({label="---   RC-Thoughts Jeti Tools    ---", font=FONT_BIG})
	
	addRow(2)
	addLabel({label=trans16.swTime, width=220})
	form.addInputbox(swTime, true, swTimeChanged)
	
	addRow(1)
	addLabel({label="Powered by RC-Thoughts.com - v."..timeVersion.." ", font=FONT_MINI, alignRight=true})
    collectgarbage()
end
--------------------------------------------------------------------------------
local function loop()
    local swTime = system.getInputsVal(swTime)
    timeStamp = system.getTimeCounter()
    if(swTime and swTime == 1 and timeStamp > timeStampSpeak) then
        timeStampSpeak = timeStamp + 10000
        curTime = system.getDateTime()
        curHour = string.format("%.0f", curTime.hour)
        curMinute = string.format("%.0f", curTime.min)
        system.playNumber(curHour, 0)
        system.playNumber(curMinute, 0)
    end
    collectgarbage()
end
--------------------------------------------------------------------------------
local function init()
    local pLoad, registerForm = system.pLoad, system.registerForm
    registerForm(1, MENU_APPS, trans16.appName, initForm, nil, printForm)
    swTime = pLoad("swTime")
    collectgarbage()
end
--------------------------------------------------------------------------------
timeVersion = "1.0"
setLanguage()
collectgarbage()
return {init=init, loop=loop, author="RC-Thoughts", version=timeVersion, name=trans16.appName}
