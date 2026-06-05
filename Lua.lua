_G.YargiEngine = _G.YargiEngine or {}
_G.YargiEngine.Loaded = false
_G.TargetLobbyThemeID = 202408001
_G.LastAppliedThemeID = nil
_G.WeaponSkinIndex = _G.WeaponSkinIndex or {}

local lastConfig = {}
local weaponMap = {
    M416=101004, AKM=101001, SCAR=101003, M16A4=101002,
    GROZA=101005, AUG=101006, QBZ=101007, M762=101008,
    HONEY=101009, ACE32=101011, UZI=102001, UMP=102002,
    Vector=102003, Thompson=102004, Kar98=103001, M24=103002,
    AWM=103003, Mini14=103006, MK14=103007, AMR=103012,
    M249=105002, DP28=105001, MG3=105010, DBS=104004,
    S12K=104003, S686=104002, Pan=106001, P90=102009
}

local configPath = nil
local possiblePaths = {
    '/storage/emulated/0/Android/data/com.tencent.ig/files/config.ini',
    '/storage/emulated/0/Android/data/com.pubg.krmobile/files/config.ini',
    '/storage/emulated/0/Android/data/com.vng.pubgmobile/files/config.ini',
    '/storage/emulated/0/Android/data/com.rekoo.pubgmobile/files/config.ini',
    '/storage/emulated/0/config.ini'
}
for _, path in ipairs(possiblePaths) do
    local file = io.open(path, 'r')
    if file then file:close(); configPath = path; break end
end
configPath = configPath or '/storage/emulated/0/Android/data/com.tencent.ig/files/config.ini'

function _G.ReadConfigFile()
    local file = io.open(configPath, 'r')
    if not file then return end
    local content = file:read('*all')
    file:close()

    local newConfig = {}
    for line in content:gmatch('[^\r\n]+') do
        local key, value = line:match('([%w_]+)%s*=%s*(%d+)')
        if key and value then newConfig[key] = tonumber(value) end
    end

    for key, id in pairs(weaponMap) do
        if newConfig[key] and newConfig[key] ~= lastConfig[key] then
            _G.WeaponSkinIndex[id] = newConfig[key]
            lastConfig[key] = newConfig[key]
        end
    end

    if newConfig.LobbyTheme and newConfig.LobbyTheme ~= _G.TargetLobbyThemeID then
        _G.TargetLobbyThemeID = newConfig.LobbyTheme
        _G.ApplyLobbyTheme()
    end
end

function _G.ApplyLobbyTheme()
    pcall(function()
        local themeID = _G.TargetLobbyThemeID
        if not themeID or themeID == 0 or _G.LastAppliedThemeID == themeID then return end
        local ModuleManager = require('client.module_framework.ModuleManager')
        if not ModuleManager then return end
        local LobbyThemeManager = ModuleManager.GetModule(ModuleManager.LobbyModuleConfig.LobbyThemeManager)
        if LobbyThemeManager then
            if LobbyThemeManager.ShowThemeByItemID then
                LobbyThemeManager:ShowThemeByItemID(themeID)
            elseif LobbyThemeManager.SetTheme then
                LobbyThemeManager:SetTheme(themeID)
            end
            local ThemeVehicleManager = ModuleManager.GetModule(ModuleManager.LobbyModuleConfig.ThemeVehicleManager)
            if ThemeVehicleManager then
                ThemeVehicleManager:ShowThemeVehicle()
                ThemeVehicleManager:RefreshSpecialEffect()
            end
            _G.LastAppliedThemeID = themeID
        end
        local HallThemeUtils = require('client.logic.lobby.hall_theme_utils')
        if HallThemeUtils then HallThemeUtils.themeVehicleShow = true end
        local logic_lobby = require('client.slua.logic.lobby.logic_lobby_main')
        if logic_lobby and logic_lobby.RefreshLobbyUI then logic_lobby:RefreshLobbyUI() end
    end)
end

pcall(function()
    local EventSystem = require('client.slua.event.EventSystem')
    if EventSystem then
        EventSystem:RegisterEvent(EVENTTYPE_LOBBY_SKIN, EVENTID_LOBBY_SKIN_LOADED, _G.ApplyLobbyTheme)
        EventSystem:RegisterEvent(EVENTTYPE_LOBBY_SKIN, EVENTID_LOBBY_SKIN_CHANGE, _G.ApplyLobbyTheme)
    end
end)

_G.killCountInfo = _G.killCountInfo or {}
_G.lastFileContent = ""
_G.isFileWatcherActive = true
_G.UpdateMyKillCounter = false
_G.WeaponEvents = _G.WeaponEvents or { onWeaponChanged = function() end }
_G.ActiveKillCounterPath = configPath:gsub("config%.ini$", "NumberUpdate.txt")

function _G.getKills(weaponID) return weaponID and _G.killCountInfo[weaponID] or 0 end

local function saveKillCountToFile()
    local file = io.open(_G.ActiveKillCounterPath, 'w+')
    if not file then return end
    local content = '{\n'
    for weaponID, count in pairs(_G.killCountInfo) do
        content = content .. string.format('    [%d] = %d,\n', weaponID, count)
    end
    content = content .. '}'
    file:write(content)
    file:close()
    _G.lastFileContent = content
end

local function parseKillCount(content)
    local temp = {}
    for wid, cnt in content:gmatch('%[(%d+)%]%s*=%s*(%d+)') do
        temp[tonumber(wid)] = tonumber(cnt)
    end
    if next(temp) then _G.killCountInfo = temp end
end

function _G.loadKillCountFromFile()
    local file = io.open(_G.ActiveKillCounterPath, 'r')
    if file then
        local content = file:read('*a') or ""
        file:close()
        _G.lastFileContent = content
        parseKillCount(content)
    end
end

function _G.addKill(weaponID, count)
    if not weaponID or not count then return end
    _G.killCountInfo[weaponID] = (_G.killCountInfo[weaponID] or 0) + count
    pcall(saveKillCountToFile)
    _G.UpdateMyKillCounter = true
end

function _G.FileWatcher()
    if not _G.isFileWatcherActive then return end
    pcall(function()
        local file = io.open(_G.ActiveKillCounterPath, 'r')
        if not file then return end
        local cur = file:read('*a') or ""
        file:close()
        cur = cur:gsub('\239\187\191', ''):gsub('^%s+', ''):gsub('%s+$', '')
        if cur == "" or cur == _G.lastFileContent then return end
        _G.lastFileContent = cur
        parseKillCount(cur)
        _G.UpdateMyKillCounter = true
    end)
end

local SKillInfo = require("GameLua.Mod.BaseMod.Client.KillInfoTips.KillInfo")
local ECharacterHealthStatus = import("ECharacterHealthStatus")
local o_FileItem = SKillInfo.__inner_impl.FileItem
SKillInfo.__inner_impl.FileItem = function(self, DamageRecordData)
    if not self or not DamageRecordData then return o_FileItem(self, DamageRecordData) end
    local ModuleManager = require("client.module_framework.ModuleManager")
    local LogicKillCounter = ModuleManager.GetModule(ModuleManager.CommonModuleConfig.LogicKillCounter)
    if not LogicKillCounter then return o_FileItem(self, DamageRecordData) end
    local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    local uCharacter = pc and pc:GetPlayerCharacterSafety()
    if not uCharacter or not slua.isValid(uCharacter) then return o_FileItem(self, DamageRecordData) end
    if DamageRecordData.Causer == uCharacter:GetPlayerNameSafety() then
        local currWeapon = uCharacter:GetCurrentWeapon()
        if currWeapon and slua.isValid(currWeapon) then
            local DefineID = currWeapon:GetItemDefineID() and currWeapon:GetItemDefineID().TypeSpecificID or 0
            if DefineID ~= 0 then
                local ExpandData = slua.LuaArchiverDecode(LuaStateWrapper, DamageRecordData.ExpandDataContent) or {}
                if LogicKillCounter:GetBaseKillCounterIdByWeaponId(DefineID) and DamageRecordData.ResultHealthStatus == ECharacterHealthStatus.FinishedLastBreath then
                    ExpandData.KillCounterItemId = DefineID
                    ExpandData.KillCounterNum = (ExpandData.KillCounterNum or 0) + 1
                    _G.addKill(DefineID, 1)
                end
                local synData = currWeapon.synData
                local weaponDefineID = synData and slua.isValid(synData) and slua.IndexReference(synData:Get(7), "defineID")
                if weaponDefineID and slua.isValid(weaponDefineID) then
                    DamageRecordData.CauserWeaponAvatarID = weaponDefineID.TypeSpecificID
                end
                DamageRecordData.ExpandDataContent = slua.LuaArchiverEncode(LuaStateWrapper, ExpandData)
            end
        end
    end
    o_FileItem(self, DamageRecordData)
end

function _G.InstallKillCounterUIHooks()
    pcall(function()
        local SubsystemMgr = require("GameLua.GameCore.Module.Subsystem.SubsystemMgr")
        local MyMainKillCounter = require("GameLua.Mod.BaseMod.Client.KillCounter.MainKillCounter")
        local MyKillCountSubSystem = require("GameLua.Mod.BaseMod.Client.KillCounter.KillCounterUISubsystem")
        local MyMainWeaponInfoItemUI = require("GameLua.Mod.BaseMod.Client.Backpack.MainWeaponInfoItemUI")
        local MyMainWeaponKillCounter = require("GameLua.Mod.BaseMod.Client.KillCounter.MainWeaponKillCounter")
        local SlotBase = require("GameLua.Mod.BaseMod.Client.MainControlUI.SwitchWeaponSlotMode2")
        _G.OurkillCountSystem = MyKillCountSubSystem.__inner_impl

        local ModuleManager = require("client.module_framework.ModuleManager")
        local LogicKillCounter = ModuleManager.GetModule(ModuleManager.CommonModuleConfig.LogicKillCounter)
        if LogicKillCounter then
            LogicKillCounter.GetMyEquipedKillCounterId = function(self, weaponId)
                local realWep = self:GetWeaponIdBySkinId(weaponId) or weaponId
                return self:GetBaseKillCounterIdByWeaponId(realWep)
            end
            LogicKillCounter.GetEquipedKillCounterId = function(self, uid, weaponId)
                local realWep = self:GetWeaponIdBySkinId(weaponId) or weaponId
                return self:GetBaseKillCounterIdByWeaponId(realWep)
            end
            LogicKillCounter.GetWeaponKillCountByUid = function(self, uid, weaponId)
                local realWep = self:GetWeaponIdBySkinId(weaponId) or weaponId
                return _G.getKills(realWep)
            end
            LogicKillCounter.GetCurBattleWeaponKillCountByUid = function(self, uid, weaponId)
                local realWep = self:GetWeaponIdBySkinId(weaponId) or weaponId
                return _G.getKills(realWep)
            end
            LogicKillCounter.GetOneWeaponKillCountInBattle = function(self, uid, weaponId)
                local realWep = self:GetWeaponIdBySkinId(weaponId) or weaponId
                return _G.getKills(realWep)
            end
            LogicKillCounter.CheckHaveKillCounterByWeaponId = function(self, originWeaponId)
                return self:GetBaseKillCounterIdByWeaponId(originWeaponId) ~= nil
            end
            LogicKillCounter.CheckHasWeaponKillCounter = function(self, weaponId)
                local realWep = self:GetWeaponIdBySkinId(weaponId) or weaponId
                return self:GetBaseKillCounterIdByWeaponId(realWep) ~= nil
            end
        end

        MyMainKillCounter.__inner_impl.OnRefreshUI = function(self, _, _, UID)
            pcall(function()
                local ModuleManager = require("client.module_framework.ModuleManager")
                local LogicKillCounter = ModuleManager.GetModule(ModuleManager.CommonModuleConfig.LogicKillCounter)
                local pc = slua_GameFrontendHUD:GetPlayerController()
                local uCharacter = pc and pc:GetPlayerCharacterSafety()
                local currweapon = uCharacter and uCharacter:GetCurrentWeapon()
                if currweapon then
                    local DefineID = currweapon:GetItemDefineID().TypeSpecificID
                    local curSkin = slua.IndexReference(currweapon.synData:Get(7), "defineID").TypeSpecificID
                    local curEquiped = LogicKillCounter:GetEquipedKillCounterId(6114302174, curSkin)
                    if not curEquiped or curEquiped == 0 then
                        curEquiped = LogicKillCounter:GetBaseKillCounterIdByWeaponId(DefineID)
                    end
                    self.KillCounterItem:SetKillCounterItemShowWithNum(curEquiped, _G.getKills(DefineID), curSkin)
                end
            end)
        end
        MyKillCountSubSystem.__inner_impl.CheckSupportKCUI = function(self) return true end
        MyKillCountSubSystem.__inner_impl.CheckNeedMainKillCounterUI = function(self, Weapon, PlayerID)
            pcall(function()
                local pc = slua_GameFrontendHUD:GetPlayerController()
                local uCharacter = pc and pc:GetPlayerCharacterSafety()
                local currweapon = uCharacter and uCharacter:GetCurrentWeapon()
                if currweapon then
                    local DefineID = currweapon:GetItemDefineID().TypeSpecificID
                    _G.WeaponEvents.onWeaponChanged(DefineID)
                    self:UpdateMainKillCounterUI(true, DefineID, slua.IndexReference(currweapon.synData:Get(7), "defineID").TypeSpecificID)
                end
            end)
        end
        local o_UpdateMainKillCounterUI = MyKillCountSubSystem.__inner_impl.UpdateMainKillCounterUI
        MyKillCountSubSystem.__inner_impl.UpdateMainKillCounterUI = function(self, bShow, WeaponID, AvatarID)
            pcall(function()
                o_UpdateMainKillCounterUI(self, bShow, WeaponID, AvatarID)
                local UIManager = require("client.slua_ui_framework.manager")
                local MainKillCounter = UIManager.GetUI(UIManager.UI_Config_InGame.MainKillCounter)
                local pc = slua_GameFrontendHUD:GetPlayerController()
                local uCharacter = pc and pc:GetPlayerCharacterSafety()
                local currweapon = uCharacter and uCharacter:GetCurrentWeapon()
                if not bShow and MainKillCounter then
                    UIManager.CloseUI(UIManager.UI_Config_InGame.MainKillCounter)
                elseif bShow and currweapon then
                    local DefineID = currweapon:GetItemDefineID().TypeSpecificID
                    local curSkin = slua.IndexReference(currweapon.synData:Get(7), "defineID").TypeSpecificID
                    local ModuleManager = require("client.module_framework.ModuleManager")
                    local LogicKillCounter = ModuleManager.GetModule(ModuleManager.CommonModuleConfig.LogicKillCounter)
                    local SupportKillCounter = LogicKillCounter:GetBaseKillCounterIdByWeaponId(DefineID)
                    if SupportKillCounter == nil and MainKillCounter then
                        UIManager.CloseUI(UIManager.UI_Config_InGame.MainKillCounter)
                    elseif DefineID == curSkin and MainKillCounter then
                        UIManager.CloseUI(UIManager.UI_Config_InGame.MainKillCounter)
                    else
                        local curEquiped = LogicKillCounter:GetEquipedKillCounterId(6114302174, curSkin)
                        if not MainKillCounter then
                            UIManager.ShowUI(UIManager.UI_Config_InGame.MainKillCounter, DefineID, curSkin)
                            MainKillCounter = UIManager.GetUI(UIManager.UI_Config_InGame.MainKillCounter)
                            if MainKillCounter then
                                MainKillCounter:SetKillCounterItemShowWithNum(curEquiped, _G.getKills(DefineID), curSkin)
                            end
                        else
                            MainKillCounter:UpdateWeaponID(DefineID, curSkin)
                            MainKillCounter:SetKillCounterItemShowWithNum(curEquiped, _G.getKills(DefineID), curSkin)
                        end
                    end
                end
            end)
        end
        local o_DOnRefresh = MyMainWeaponKillCounter.__inner_impl.OnRefresh
        MyMainWeaponKillCounter.__inner_impl.OnRefresh = function(self, SelfUID)
            pcall(function()
                local ModuleManager = require("client.module_framework.ModuleManager")
                local LogicKillCounter = ModuleManager.GetModule(ModuleManager.CommonModuleConfig.LogicKillCounter)
                local curEquiped = LogicKillCounter:GetMyEquipedKillCounterId(_G.get_skin_id2(self.WeaponID))
                self.KillCounterItem:SetKillCounterItemShowWithNum(curEquiped, _G.getKills(self.WeaponID), _G.get_skin_id2(self.WeaponID))
            end)
        end
        local o_DUpdateWeaponAppearanceInfo = MyMainWeaponInfoItemUI.__inner_impl.UpdateWeaponAppearanceInfo
        MyMainWeaponInfoItemUI.__inner_impl.UpdateWeaponAppearanceInfo = function(self, TypeSpecificID, BattleData, DragOrigin)
            pcall(function()
                o_DUpdateWeaponAppearanceInfo(self, TypeSpecificID, BattleData, DragOrigin)
                self:UpdateKillCounter(true)
            end)
        end
        local o_DUpdateKillCounter = MyMainWeaponInfoItemUI.__inner_impl.UpdateKillCounter
        MyMainWeaponInfoItemUI.__inner_impl.UpdateKillCounter = function(self, bShow)
            pcall(function()
                local KillCounterUISubsystem = SubsystemMgr:Get("KillCounterUISubsystem")
                if not KillCounterUISubsystem then bShow = false end
                if bShow then
                    local ModuleManager = require("client.module_framework.ModuleManager")
                    local LogicKillCounter = ModuleManager.GetModule(ModuleManager.CommonModuleConfig.LogicKillCounter)
                    local curEquiped = LogicKillCounter:GetBaseKillCounterIdByWeaponId(self.ItemID)
                    if self.ItemID == self.WeaponIDOrAvatarID or not curEquiped then
                        self.UIRoot.CanvasPanel_KillCounter:SetVisibility(UEnums.GSlateVisibility.Collapsed)
                        return
                    end
                    local UIManager = require("client.slua_ui_framework.manager")
                    if not self.KillCounterUI then
                        self.KillCounterUI = UIManager.ShowUI(UIManager.UI_Config_InGame.MainWeaponKillCounter, self.ItemID, self.WeaponIDOrAvatarID, self)
                        self.UIRoot.CanvasPanel_KillCounter.Slot:SetLayer(1)
                    else
                        self.KillCounterUI:UpdateWeaponID(self.ItemID, self.WeaponIDOrAvatarID)
                        self.UIRoot.CanvasPanel_KillCounter:SetVisibility(UEnums.GSlateVisibility.SelfHitTestInvisible)
                    end
                end
            end)
        end
        local o_CheckShowKCIcon = SlotBase.__inner_impl.CheckShowKCIcon
        SlotBase.__inner_impl.CheckShowKCIcon = function(self)
            pcall(function()
                o_CheckShowKCIcon(self)
                local ESlateVisibility = import("ESlateVisibility")
                local ModuleManager = require("client.module_framework.ModuleManager")
                local LogicKillCounter = ModuleManager.GetModule(ModuleManager.CommonModuleConfig.LogicKillCounter)
                local CurWeapon = self:GetCurrentWeapon()
                if not slua.isValid(CurWeapon) then
                    self.KillCounterImg:SetVisibility(ESlateVisibility.Collapsed)
                    return
                end
                local WeaponID = CurWeapon:GetWeaponID()
                if LogicKillCounter:GetBaseKillCounterIdByWeaponId(WeaponID) then
                    self.KillCounterImg:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
                end
            end)
        end
    end)
end

_G.IsPtrValid = function(ptr) return ptr ~= nil and slua.isValid(ptr) end
function _G.download_item(id) end

function _G.get_skin_id(weaponID)
    return _G.WeaponSkinIndex[weaponID] or weaponID
end
_G.get_skin_id2 = _G.get_skin_id

function _G.GameAvatarHandlervehicles()
    local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    local uChar = pc and pc:GetPlayerCharacterSafety()
    local curVeh = uChar and uChar.CurrentVehicle
    local vehAvatar = curVeh and curVeh.VehicleAvatar
    if _G.IsPtrValid(vehAvatar) then
        vehAvatar.curSwitchEffectId = 7303001
    end
end

function _G.GameAvatarHandlerkillcounter()
    pcall(function()
        if not _G.UpdateMyKillCounter then return end
        _G.UpdateMyKillCounter = false
        local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
        local uChar = pc and pc:GetPlayerCharacterSafety()
        local currweapon = uChar and uChar:GetCurrentWeapon()
        if not _G.IsPtrValid(currweapon) then return end
        local DefineID = currweapon:GetItemDefineID().TypeSpecificID
        if DefineID == 0 then return end
        local SkinID = slua.IndexReference(currweapon.synData:Get(7), "defineID").TypeSpecificID
        local UIManager = require("client.slua_ui_framework.manager")
        local MainKillCounter = UIManager.GetUI(UIManager.UI_Config_InGame.MainKillCounter)
        if MainKillCounter and MainKillCounter.KillCounterItem then
            MainKillCounter.KillCounterItem:SetKillCounterItemShowWithNum(nil, _G.getKills(DefineID), SkinID)
        end
    end)
end

pcall(function()
    local ModuleManager = require("client.module_framework.ModuleManager")
    _G.ItemUpgradeSystem = ModuleManager.GetModule(ModuleManager.CommonModuleConfig.ItemUpgradeSystem)
    if _G.ItemUpgradeSystem then
        _G.ItemUpgradeSystem:DefineAndResetData()
        _G.ItemUpgradeSystem:OnInitialize()
    end
end)

_G.loadKillCountFromFile()
_G.ApplyLobbyTheme()
pcall(_G.ReadConfigFile)
pcall(_G.InstallKillCounterUIHooks)

_G.YargiEngine.Loaded = true
_G.YargiEngine.Start = function() end

