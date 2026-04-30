_G.YargiEngine = _G.YargiEngine or {}
_G.YargiEngine.Loaded = false

local DATA_PATH = (function()
    local packages = { "com.pubg.krmobile", "com.tencent.ig", "com.vng.pubgmobile", "com.rekoo.pubgm", "com.pubg.imobile" }
    local base = "/storage/emulated/0/Android/data/"
    for _, pkg in ipairs(packages) do
        local path = base .. pkg .. "/files"
        local f = io.open(path .. "/config.ini", "r")
        if f then
            f:close(); return path
        end
    end
    return base .. "com.pubg.krmobile/files"
end)()

local CONFIG_PATH = DATA_PATH .. "/config.ini"

-- ====================== CONFIG OKUMA (EN ÜSTTE) ======================
local lastConfig = {}
function _G.ReadConfigFile()
    local possiblePaths = {
        '/storage/emulated/0/Android/data/com.tencent.ig/files/config.ini',
        '/storage/emulated/0/Android/data/com.pubg.krmobile/files/config.ini',
        '/storage/emulated/0/Android/data/com.vng.pubgmobile/files/config.ini',
        '/storage/emulated/0/Android/data/com.rekoo.pubgmobile/files/config.ini',
        '/storage/emulated/0/config.ini'
    }
    local configPath = nil
    for _, path in ipairs(possiblePaths) do
        local file = io.open(path, 'r')
        if file then
            file:close(); configPath = path; break
        end
    end
    if not configPath then return end

    local file = io.open(configPath, 'r')
    local content = file:read('*all')
    file:close()

    local newConfig = {}
    for line in content:gmatch('[^\r\n]+') do
        local key, value = line:match('(%w+)=(%d+)')
        if key and value then newConfig[key] = tonumber(value) end
    end

    local function UpdWep(key, id)
        if newConfig[key] and newConfig[key] ~= lastConfig[key] then
            _G.WeaponSkinIndex[id] = newConfig[key] + 1
            lastConfig[key] = newConfig[key]
        end
    end

    UpdWep('M416', 101004); UpdWep('AKM', 101001); UpdWep('SCAR', 101003); UpdWep('M16A4', 101002)
    UpdWep('GROZA', 101005); UpdWep('AUG', 101006); UpdWep('QBZ', 101007); UpdWep('M762', 101008)
    UpdWep('HONEY', 101009); UpdWep('ACE32', 101011); UpdWep('UZI', 102001)
    UpdWep('UMP', 102002); UpdWep('Vector', 102003); UpdWep('Thompson', 102004)
    UpdWep('Kar98', 103001); UpdWep('M24', 103002); UpdWep('AWM', 103003)
    UpdWep('Mini14', 103006); UpdWep('MK14', 103007); UpdWep('AMR', 103012)
    UpdWep('M249', 105002); UpdWep('DP28', 105001); UpdWep('MG3', 105010)
    UpdWep('DBS', 104004); UpdWep('S12K', 104003); UpdWep('S686', 104002)
    UpdWep('Pan', 106001); UpdWep('P90', 102009)

    local vehMap = {
        Vehicle_UAZ = 101,
        Vehicle_Buggy = 102,
        Vehicle_Bike = 103,
        Vehicle_Boat = 104,
        Vehicle_Pickup = 108,
        Vehicle_Mirado = 109,
        Vehicle_Coupe = 112,
        Vehicle_Dacia = 113
    }
    for key, id in pairs(vehMap) do
        if newConfig[key] and newConfig[key] ~= lastConfig[key] then
            _G.VehicleSkinIndex[id] = newConfig[key] + 1
            lastConfig[key] = newConfig[key]
        end
    end
end

-- ====================== SİLAH SKIN ID'LERİ ======================
_G.skinIdMappings = {
    [101004] = { 101004, 1101004046, 1101004226, 1101004236, 1101004062, 1101004078, 1101004086, 1101004098, 1101004138, 1101004163, 1101004201, 1101004209, 1101004218 },
    [101001] = { 101001, 1101001089, 1101001213, 1101001172, 1101001127, 1101001142, 1101001153, 1101001115, 1101001102, 1101001230, 1101001241 },
    [101003] = { 101003, 1103003208, 1101003195, 1101003187, 1101003098, 1101003166, 1101003069, 1101003218, 1101003079, 1101003118, 1101003145, 1101003180, 1101003056 },
    [103001] = { 103001, 1103001191, 1103001101, 1103001178, 1103001145, 1103001230, 1103001213 },
    [102002] = { 102002, 1102002136, 1102002043, 1102002061, 1102002424, 1102002198 },
    [103002] = { 103002, 1103002030, 1103002087, 1103002105, 1103002112, 1103002201 },
    [103003] = { 103003, 1103003042, 1103003087, 1103003062, 1103003022, 1103003051, 1103003030, 1103003079 },
    [101008] = { 101008, 1101008079, 1101008126, 1101008104, 1101008146, 1101008026, 1101008061, 1101008116, 1101008051 },
    [102003] = { 102003, 1102003019, 1102003030, 1102003064, 1102003079 },
    [105010] = { 105010, 1105010018, 1105010007, 1105010025 },
    [102004] = { 102004, 1102004017, 1102004033, 1102004048 },
    [105002] = { 105002, 1105002090, 1105002075, 1105002018, 1105002034, 1105002057, 1105002062 },
    [105001] = { 105001, 1105001047, 1105001068, 1105001033, 1105001061 },
    [101006] = { 101006, 1101006061, 1101006074, 1101006043, 1101006032, 1101006084, 1101006096 },
    [104004] = { 104004, 1104004034, 1104004015, 1104004040 },
    [101002] = { 101002, 1101002081, 1101002105, 1101002128 },
    [101005] = { 101005, 1101005052, 1101005073, 1101005091 },
    [101007] = { 101007, 1101007046, 1101007068, 1101007089 },
    [102001] = { 102001, 1102001103, 1102001124, 1102001148 },
    [103004] = { 103004, 1103004001, 1103004022, 1103004047 },
    [103006] = { 103006, 1103006030, 1103006055, 1103006079 },
    [103007] = { 103007, 1103007028, 1103007049 },
    [103012] = { 103012, 1103012010, 1103012025 },
    [104003] = { 104003, 1104003027, 1104003048 },
    [101009] = { 101009, 1101009035, 1101009058, 1101009079 },
    [101010] = { 101010, 1101010022, 1101010043 },
    [101011] = { 101011, 1101011019, 1101011038 },
    [103008] = { 103008, 1103008015, 1103008035 },
    [103009] = { 103009, 1103009018, 1103009037 },
    [103011] = { 103011, 1103011010, 1103011022 },
    [102005] = { 102005, 1102005018, 1102005037 },
    [102006] = { 102006, 1102006015, 1102006031 },
    [104005] = { 104005, 1104005012, 1104005025 },
    [106001] = { 106001, 1108004356 }
}

_G.VehskinIdMappings = {
    [101] = { 1105001001, 1105001002, 1105001003, 1105001004 },
    [102] = { 1105002001, 1105002002, 1105002003, 1105002004 },
    [103] = { 1105003001, 1105003002, 1105003003 },
    [104] = { 1105004001, 1105004002 },
    [108] = { 1105008001, 1105008002, 1105008003 },
    [109] = { 1105009001, 1105009002 },
    [111] = { 1105011001, 1105011002 },
    [112] = { 1961007, 1961010, 1961012, 1961013, 1961014, 1961015, 1961016, 1961017, 1961018, 1961020, 1961021, 1961024, 1961025, 1961029, 1961030, 1961031, 1961041, 1961042, 1961044, 1961048, 1961050, 1961051 },
    [113] = { 1903075, 1903071, 1903072, 1903073, 1903074, 1903076, 1903200, 1903201 }
}

_G.WeaponSkinIndex = _G.WeaponSkinIndex or {}
_G.VehicleSkinIndex = _G.VehicleSkinIndex or {}
_G.skinIdCache = _G.skinIdCache or {}

-- ====================== KILL COUNTER ======================
_G.killCountInfo = _G.killCountInfo or {}
_G.lastFileContent = ""
_G.isFileWatcherActive = true
_G.UpdateMyKillCounter = false
_G.WeaponEvents = _G.WeaponEvents or { onWeaponChanged = function() end }

local KILL_COUNTER_PATH = (function()
    local paths = {
        '/storage/emulated/0/Android/data/com.tencent.ig/files/NumberUpdate.txt',
        '/storage/emulated/0/Android/data/com.pubg.krmobile/files/NumberUpdate.txt',
        '/storage/emulated/0/Android/data/com.vng.pubgmobile/files/NumberUpdate.txt',
        '/storage/emulated/0/Android/data/com.rekoo.pubgm/files/NumberUpdate.txt'
    }
    for _, p in ipairs(paths) do
        local f = io.open(p, 'r')
        if f then
            f:close(); return p
        end
    end
    for _, p in ipairs(paths) do
        local dir = p:match("(.*)/NumberUpdate.txt")
        local f = io.open(dir .. "/config.ini", 'r')
        if f then
            f:close(); return p
        end
    end
    return '/storage/emulated/0/Android/data/com.tencent.ig/files/NumberUpdate.txt'
end)()
_G.ActiveKillCounterPath = KILL_COUNTER_PATH

function _G.getKills(weaponID)
    return weaponID and _G.killCountInfo[weaponID] or 0
end

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

function _G.loadKillCountFromFile()
    local file = io.open(_G.ActiveKillCounterPath, 'r')
    if file then
        local content = file:read('*a')
        file:close()
        _G.lastFileContent = content
        if content ~= '' then
            content = content:gsub('\239\187\191', ''):gsub('^%s+', '')
            local temp = {}
            for wid, cnt in content:gmatch('%[(%d+)%]%s*=%s*(%d+)') do
                temp[tonumber(wid)] = tonumber(cnt)
            end
            if next(temp) then _G.killCountInfo = temp end
        end
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
        local temp = {}
        for wid, cnt in cur:gmatch('%[(%d+)%]%s*=%s*(%d+)') do
            temp[tonumber(wid)] = tonumber(cnt)
        end
        if next(temp) then _G.killCountInfo = temp end
        _G.UpdateMyKillCounter = true
    end)
end

-- ====================== KILL INFO HOOK ======================
local SKillInfo = require("GameLua.Mod.BaseMod.Client.KillInfoTips.KillInfo")
local ECharacterHealthStatus = import("ECharacterHealthStatus")
local o_FileItem = SKillInfo.__inner_impl.FileItem
SKillInfo.__inner_impl.FileItem = function(self, DamageRecordData)
    if not self or not DamageRecordData then return o_FileItem(self, DamageRecordData) end
    local LogicKillCounter = require("client.module_framework.ModuleManager").GetModule(require(
        "client.module_framework.ModuleManager").CommonModuleConfig.LogicKillCounter)
    if not LogicKillCounter then return o_FileItem(self, DamageRecordData) end
    local uCharacter = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController() and
        slua_GameFrontendHUD:GetPlayerController():GetPlayerCharacterSafety()
    if not uCharacter or not slua.isValid(uCharacter) then return o_FileItem(self, DamageRecordData) end
    local SelfName = uCharacter:GetPlayerNameSafety()
    if DamageRecordData.Causer == SelfName then
        local currWeapon = uCharacter:GetCurrentWeapon()
        if currWeapon and slua.isValid(currWeapon) then
            local DefineID = currWeapon:GetItemDefineID() and currWeapon:GetItemDefineID().TypeSpecificID or 0
            if DefineID ~= 0 then
                local ExpandData = slua.LuaArchiverDecode(LuaStateWrapper, DamageRecordData.ExpandDataContent) or {}
                local SupportKillCounter = LogicKillCounter:GetBaseKillCounterIdByWeaponId(DefineID)
                if SupportKillCounter and DamageRecordData.ResultHealthStatus == ECharacterHealthStatus.FinishedLastBreath then
                    ExpandData.KillCounterItemId = DefineID
                    ExpandData.KillCounterNum = (ExpandData.KillCounterNum or 0) + 1
                    _G.addKill(DefineID, 1)
                end
                local synData = currWeapon.synData
                if synData and slua.isValid(synData) then
                    local weaponDefineID = slua.IndexReference(synData:Get(7), "defineID")
                    if weaponDefineID and slua.isValid(weaponDefineID) then
                        DamageRecordData.CauserWeaponAvatarID = weaponDefineID.TypeSpecificID
                    end
                end
                DamageRecordData.ExpandDataContent = slua.LuaArchiverEncode(LuaStateWrapper, ExpandData)
            end
        end
    end
    o_FileItem(self, DamageRecordData)
end

-- ====================== KILL COUNTER UI HOOKS ======================
function _G.InstallKillCounterUIHooks()
    pcall(function()
        local SubsystemMgr = require("GameLua.GameCore.Module.Subsystem.SubsystemMgr")
        local MyMainKillCounter = require("GameLua.Mod.BaseMod.Client.KillCounter.MainKillCounter")
        local MyKillCountSubSystem = require("GameLua.Mod.BaseMod.Client.KillCounter.KillCounterUISubsystem")
        local MyMainWeaponInfoItemUI = require("GameLua.Mod.BaseMod.Client.Backpack.MainWeaponInfoItemUI")
        local MyMainWeaponKillCounter = require("GameLua.Mod.BaseMod.Client.KillCounter.MainWeaponKillCounter")
        local SlotBase = require("GameLua.Mod.BaseMod.Client.MainControlUI.SwitchWeaponSlotMode2")

        _G.OurkillCountSystem = MyKillCountSubSystem.__inner_impl

        MyMainKillCounter.__inner_impl.OnRefreshUI = function(self, _, _, UID)
            pcall(function()
                local ModuleManager = require("client.module_framework.ModuleManager")
                local LogicKillCounter = ModuleManager.GetModule(ModuleManager.CommonModuleConfig.LogicKillCounter)
                local uCharacter = slua_GameFrontendHUD:GetPlayerController():GetPlayerCharacterSafety()
                if not uCharacter then return end
                local currweapon = uCharacter:GetCurrentWeapon()
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

        local o_CheckNeedMainKillCounterUI = MyKillCountSubSystem.__inner_impl.CheckNeedMainKillCounterUI
        MyKillCountSubSystem.__inner_impl.CheckNeedMainKillCounterUI = function(self, Weapon, PlayerID)
            pcall(function()
                local uCharacter = slua_GameFrontendHUD:GetPlayerController():GetPlayerCharacterSafety()
                if not uCharacter then return end
                local currweapon = uCharacter:GetCurrentWeapon()
                if currweapon then
                    local DefineID = currweapon:GetItemDefineID().TypeSpecificID
                    _G.WeaponEvents.onWeaponChanged(DefineID)
                    self:UpdateMainKillCounterUI(true, DefineID,
                        slua.IndexReference(currweapon.synData:Get(7), "defineID").TypeSpecificID)
                end
            end)
        end

        local o_UpdateMainKillCounterUI = MyKillCountSubSystem.__inner_impl.UpdateMainKillCounterUI
        MyKillCountSubSystem.__inner_impl.UpdateMainKillCounterUI = function(self, bShow, WeaponID, AvatarID)
            pcall(function()
                o_UpdateMainKillCounterUI(self, bShow, WeaponID, AvatarID)
                local UIManager = require("client.slua_ui_framework.manager")
                local MainKillCounter = UIManager.GetUI(UIManager.UI_Config_InGame.MainKillCounter)
                local uCharacter = slua_GameFrontendHUD:GetPlayerController():GetPlayerCharacterSafety()
                if not uCharacter then return end
                local currweapon = uCharacter:GetCurrentWeapon()
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
                self.KillCounterItem:SetKillCounterItemShowWithNum(curEquiped, _G.getKills(self.WeaponID),
                    _G.get_skin_id2(self.WeaponID))
            end)
        end

        local o_DUpdateWeaponAppearanceInfo = MyMainWeaponInfoItemUI.__inner_impl.UpdateWeaponAppearanceInfo
        MyMainWeaponInfoItemUI.__inner_impl.UpdateWeaponAppearanceInfo = function(self, TypeSpecificID, BattleData,
                                                                                  DragOrigin)
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
                    if self.ItemID == self.WeaponIDOrAvatarID then
                        self.UIRoot.CanvasPanel_KillCounter:SetVisibility(UEnums.GSlateVisibility.Collapsed)
                        return
                    end
                    if not curEquiped then
                        self.UIRoot.CanvasPanel_KillCounter:SetVisibility(UEnums.GSlateVisibility.Collapsed)
                        return
                    end
                    local UIManager = require("client.slua_ui_framework.manager")
                    if not self.KillCounterUI then
                        self.KillCounterUI = UIManager.ShowUI(UIManager.UI_Config_InGame.MainWeaponKillCounter,
                            self.ItemID, self.WeaponIDOrAvatarID, self)
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

-- ====================== ATTACHMENT TABLOLARI ======================
_G.muzzles = {
    id_flash_hider = { 201010, 201005, 201004 },
    id_compensator = { 201009, 201003, 201002 },
    id_suppressor = { 201011, 201006, 201007 }
}
_G.foregrips = {
    id_Angledforegrip = 202001,
    id_thumb_grip = 202006,
    id_vertical_grip = 202002,
    id_light_grip = 202004,
    id_half_grip = 202005,
    id_ergonomic_grip = 202051,
    id_laser_sight = 202007
}
_G.magazines = {
    id_expanded_mag = { 204011, 204007, 204004 },
    id_quick_mag = { 204012, 204008, 204005 },
    id_expanded_quick_mag = { 204013, 204009, 204006 }
}
_G.scopes = {
    id_reddot = 203001,
    id_holo = 203002,
    id_2x = 203003,
    id_3x = 203014,
    id_4x = 203004,
    id_6x = 203015,
    id_8x = 203005
}
_G.stock = {
    id_microStock = 205001, id_tactical = 205002, id_bulletloop = 204014, id_CheekPad = 205003
}

_G.g_parts = _G.g_parts or {}
_G.IsPtrValid = function(ptr) return ptr ~= nil and slua.isValid(ptr) end

function _G.download_item(id)
    if not id or id == 0 then return end
    pcall(function()
        local PM = require("client.slua.logic.download.puffer.puffer_manager")
        local PC = require("client.slua.logic.download.puffer_const")
        if not PM or not PC then return end
        local state = PM.GetState(PC.ENUM_DownloadType.ODPAK, { id })
        if state ~= PC.ENUM_DownloadState.Done then
            PM.Download(PC.ENUM_DownloadType.ODPAK, { id })
        end
    end)
end

function _G.get_group_id(itemId)
    if not _G.ItemUpgradeSystem or not itemId then return nil end
    local cfg = _G.ItemUpgradeSystem:GetUpgradeCfg(itemId)
    return cfg and cfg.GroupID or nil
end

function _G.InitParts(groupId, itemId)
    if not itemId then return _G.g_parts end
    if not _G.g_parts[itemId] then _G.g_parts[itemId] = {} end
    local realGroupId = groupId or _G.get_group_id(itemId)
    if _G.ItemUpgradeSystem and _G.ItemUpgradeSystem.IsWeaponIsRefit and _G.ItemUpgradeSystem:IsWeaponIsRefit(itemId) then
        realGroupId = _G.ItemUpgradeSystem:GetNormalGroupID(realGroupId)
    end
    local CDataTable = _G.CDataTable or require("client.slua.config.ClientConfig.data_mgr")
    local cfg = CDataTable.GetTableByFilter("ItemUpgradeUnLockConfig", "GroupID", realGroupId)
    if cfg then
        for _, info in pairs(cfg) do
            local partId = info.PartId
            if _G.ItemUpgradeSystem and _G.ItemUpgradeSystem.IsWeaponIsRefit and _G.ItemUpgradeSystem:IsWeaponIsRefit(itemId) then
                local switched = _G.ItemUpgradeSystem:PartIDSwitch(partId, true)
                if switched and switched ~= partId then partId = switched end
            end
            local item = CDataTable.GetTableData("Item", partId)
            if item then _G.g_parts[itemId][item.ItemName] = partId end
        end
    end
    return _G.g_parts
end

function _G.GetSlotFromSkinID(skinid, stock)
    if not skinid or not stock then return 0 end
    local attachmentTypeMap = {
        [1] = { 291004, 291102, 291001, 291006, 291005, 291002, 293003, 293004, 293009, 293007, 293005, 293006, 295001, 295002, 291007, 291003, 292002, 292003, 291011, 291008 },
        [2] = { 205005, 205102, 205007, 205009, 205006 },
        [3] = { 203008, 203009, 203006, 203022, 203010 }
    }
    local targetIDs = attachmentTypeMap[stock]
    if not targetIDs then return 0 end
    local UAvatarUtils = import("AvatarUtils")
    if not UAvatarUtils then return 0 end
    local list = UAvatarUtils.GetWeaponAvatarDefaultAttachmentSkin(skinid, {}, false) or {}
    for _, tID in ipairs(targetIDs) do
        for aID, aSkinID in pairs(list) do
            if aID == tID then return aSkinID end
        end
    end
    return 0
end

function _G.get_muzzleid(current_id, avatarid)
    local initial_id = current_id
    _G.InitParts(_G.get_group_id(avatarid), avatarid)
    local function is_in(mtype)
        for _, id in ipairs(_G.muzzles[mtype]) do if current_id == id then return true end end
    end
    local mtype = nil
    if is_in("id_flash_hider") then
        mtype = "Flash Hider"
    elseif is_in("id_compensator") then
        mtype = "Compensator"
    elseif is_in("id_suppressor") then
        mtype = "Suppressor"
    end
    if mtype and _G.g_parts[avatarid] and _G.g_parts[avatarid][mtype] then
        current_id = _G.g_parts[avatarid][mtype]
    end
    return current_id, initial_id ~= current_id
end

function _G.get_forgripid(current_id, avatarid)
    local initial_id = current_id
    _G.InitParts(_G.get_group_id(avatarid), avatarid)
    local p = _G.g_parts[avatarid] or {}
    local map = {
        [202001] = "Angled Foregrip",
        [202006] = "Thumb Grip",
        [202002] = "Vertical Foregrip",
        [202004] = "Light Grip",
        [202005] = "Half Grip",
        [202051] = "Ergonomic Grip",
        [202007] = "Laser Sight"
    }
    if map[current_id] and p[map[current_id]] then current_id = p[map[current_id]] end
    return current_id, initial_id ~= current_id
end

function _G.get_magazinesid(current_id, avatarid)
    local initial_id = current_id
    _G.InitParts(_G.get_group_id(avatarid), avatarid)
    local function is_in(mtype)
        for _, id in ipairs(_G.magazines[mtype]) do if current_id == id then return true end end
    end
    local mtype = nil
    if is_in("id_expanded_mag") then
        mtype = "Extended Mag"
    elseif is_in("id_quick_mag") then
        mtype = "Quickdraw Mag"
    elseif is_in("id_expanded_quick_mag") then
        mtype = "Extended Quickdraw Mag"
    end
    if mtype and _G.g_parts[avatarid] and _G.g_parts[avatarid][mtype] then
        current_id = _G.g_parts[avatarid][mtype]
    elseif not mtype then
        current_id = _G.GetSlotFromSkinID(avatarid, 1) or current_id
    end
    return current_id, initial_id ~= current_id
end

function _G.get_scopeid(current_id, avatarid)
    local initial_id = current_id
    _G.InitParts(_G.get_group_id(avatarid), avatarid)
    local p = _G.g_parts[avatarid] or {}
    local map = {
        [203001] = "Red Dot Sight",
        [203002] = "Holographic Sight",
        [203003] = "2x Scope",
        [203014] = "3x Scope",
        [203004] = "4x Scope",
        [203015] = "6x Scope",
        [203005] = "8x Scope"
    }
    if map[current_id] and p[map[current_id]] then
        current_id = p[map[current_id]]
    else
        current_id = _G.GetSlotFromSkinID(avatarid, 3) or current_id
    end
    return current_id, initial_id ~= current_id
end

function _G.get_stockid(current_id, avatarid)
    local initial_id = current_id
    _G.InitParts(_G.get_group_id(avatarid), avatarid)
    local p = _G.g_parts[avatarid] or {}
    local map = {
        [205001] = "Stock",
        [205002] = "Tactical Stock",
        [204014] = "Bullet Loop",
        [205003] = "Cheek Pad"
    }
    if map[current_id] and p[map[current_id]] then
        current_id = p[map[current_id]]
    else
        current_id = _G.GetSlotFromSkinID(avatarid, 2) or current_id
    end
    return current_id, initial_id ~= current_id
end

function _G.apply_attachment(CurWeapon, avatarid)
    local array = CurWeapon.synData
    for AttachIdx = 0, 4 do
        local isrefresh = false
        local Data = array:Get(AttachIdx)
        if not Data then break end
        local itemid = slua.IndexReference(Data, "defineID").TypeSpecificID
        if itemid and itemid < 10000000 and itemid > 0 then
            if AttachIdx == 0 then
                Data.defineID.TypeSpecificID, isrefresh = _G.get_muzzleid(itemid, avatarid)
            elseif AttachIdx == 1 then
                Data.defineID.TypeSpecificID, isrefresh = _G.get_forgripid(itemid, avatarid)
            elseif AttachIdx == 2 then
                Data.defineID.TypeSpecificID, isrefresh = _G.get_magazinesid(itemid, avatarid)
            elseif AttachIdx == 3 then
                Data.defineID.TypeSpecificID, isrefresh = _G.get_stockid(itemid, avatarid)
            elseif AttachIdx == 4 then
                Data.defineID.TypeSpecificID, isrefresh = _G.get_scopeid(itemid, avatarid)
            end
            if isrefresh then
                array:Set(AttachIdx, Data)
                CurWeapon:DelayHandleAvatarMeshChanged()
            end
        end
    end
end

function _G.get_skin_id(weaponID)
    if not weaponID then return weaponID end
    local index = _G.WeaponSkinIndex[weaponID] or 1
    local skins = _G.skinIdMappings[weaponID]
    if not skins then return weaponID end
    local skinID = skins[index] or weaponID
    if not _G.skinIdCache[skinID] then
        _G.download_item(skinID)
        _G.skinIdCache[skinID] = true
    end
    return skinID
end

_G.get_skin_id2 = _G.get_skin_id

-- ====================== HANDLER FONKSİYONLARI ======================
function _G.GameAvatarHandlerweapons()
    pcall(function()
        local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
        if not _G.IsPtrValid(pc) then return end
        local uChar = pc:GetPlayerCharacterSafety()
        if not _G.IsPtrValid(uChar) then return end
        local currweapon = uChar:GetCurrentWeapon()
        if _G.IsPtrValid(currweapon) then
            local weaponid = currweapon:GetItemDefineID().TypeSpecificID
            local targetSkin = _G.get_skin_id(weaponid)
            if targetSkin and targetSkin ~= weaponid then
                local DefineID = currweapon:GetItemDefineID()
                DefineID.TypeSpecificID = targetSkin
                currweapon:SetWeaponSkin(DefineID)
                _G.apply_attachment(currweapon, targetSkin)
            end
        end
    end)
end

function _G.UpdateWeapon_BackPack_Appearance(PlayerController)
    pcall(function()
        local uCharacter = PlayerController:GetPlayerCharacterSafety()
        if not _G.IsPtrValid(uCharacter) then return end
        local BackpackComponent = uCharacter.BackpackComponent
        if not BackpackComponent then return end
        local WeaponList = BackpackComponent:GetWeaponList()
        if not WeaponList then return end
        for i = 0, WeaponList:Num() - 1 do
            local Weapon = WeaponList:Get(i)
            if _G.IsPtrValid(Weapon) then
                local weaponid = Weapon:GetItemDefineID().TypeSpecificID
                local targetSkin = _G.get_skin_id(weaponid)
                if targetSkin and targetSkin ~= weaponid then
                    local DefineID = Weapon:GetItemDefineID()
                    DefineID.TypeSpecificID = targetSkin
                    Weapon:SetWeaponSkin(DefineID)
                    _G.apply_attachment(Weapon, targetSkin)
                end
            end
        end
    end)
end

function _G.GameAvatarHandlerBagPack()
    local PlayerController = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if _G.IsPtrValid(PlayerController) then _G.UpdateWeapon_BackPack_Appearance(PlayerController) end
end

function _G.GameAvatarHandlervehicles()
    local PlayerController = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if not _G.IsPtrValid(PlayerController) then return end
    local uChar = PlayerController:GetPlayerCharacterSafety()
    if not _G.IsPtrValid(uChar) then return end
    local CurrentVehicle = uChar.CurrentVehicle
    if not _G.IsPtrValid(CurrentVehicle) then return end
    local VehicleAvatar = CurrentVehicle.VehicleAvatar
    if not _G.IsPtrValid(VehicleAvatar) then return end
    VehicleAvatar.curSwitchEffectId = 7303001
    local DefaultAvatarID = tostring(VehicleAvatar:GetDefaultAvatarID())
    local CurrentAvatarID = CurrentVehicle:GetAvatarId()
    for vehicleType, skinIdTable in pairs(_G.VehskinIdMappings) do
        if DefaultAvatarID:find(tostring(vehicleType)) then
            local idx = _G.VehicleSkinIndex[vehicleType] or 1
            if idx > #skinIdTable then idx = 1 end
            local skinId = skinIdTable[idx]
            if skinId and CurrentAvatarID ~= skinId then
                _G.download_item(skinId)
                VehicleAvatar:ChangeItemAvatar(skinId, true)
            end
            break
        end
    end
end

function _G.GameAvatarHandlerkillcounter()
    pcall(function()
        if not _G.UpdateMyKillCounter then return end
        _G.UpdateMyKillCounter = false
        local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
        if not _G.IsPtrValid(pc) then return end
        local uChar = pc:GetPlayerCharacterSafety()
        if not _G.IsPtrValid(uChar) then return end
        local currweapon = uChar:GetCurrentWeapon()
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

-- ====================== ANTI BAN BYPASS ======================
_G.InitializeGameplayBypass = function()
    if _G.GameplayBypassInitialized then return end
    pcall(function()
        if not _G.GameplayCallbacks then return end
        local GC = _G.GameplayCallbacks
        local emptyFunc = function() end
        GC.ReportAttackFlow = emptyFunc
        GC.ReportSecAttackFlow = emptyFunc
        GC.ReportHurtFlow = emptyFunc
        GC.ReportFireArms = emptyFunc
        GC.ReportPlayerMoveRoute = emptyFunc
        GC.ReportPlayerPosition = emptyFunc
        GC.ReportVehicleMoveFlow = emptyFunc
        GC.ReportSecTgameMovingFlow = emptyFunc
        GC.ReportParachuteData = emptyFunc
        GC.ReportEquipmentFlow = emptyFunc
        GC.ReportAimFlow = emptyFunc
        GC.ReportPlayersPing = emptyFunc
        GC.ReportPlayerIP = emptyFunc
        GC.ReportCircleFlow = emptyFunc
        GC.ReportDSCircleFlow = emptyFunc
        GC.ReportJumpFlow = emptyFunc
        GC.ReportAIStrategyInfo = emptyFunc
        GC.SendSecTLog = emptyFunc
        GC.SendDataMiningTLog = emptyFunc
        GC.SendActivityTLog = emptyFunc
        GC.GetGeneralTLogData = function() return nil end
        GC.IsBypassed = true
    end)
    _G.GameplayBypassInitialized = true
end

_G.InitializeConnectionGuard = function()
    if _G.ConnectionGuardInitialized then return end
    pcall(function()
        if not _G.GameplayCallbacks then return end
        local GC = _G.GameplayCallbacks
        local original = GC.OnDSPlayerStateChanged
        GC.OnDSPlayerStateChanged = function(UID, state, ...)
            local s = state and string.lower(tostring(state)) or ""
            if s == "cheatdetected" or s == "connectionlost" then return end
            if original then return original(UID, state, ...) end
        end
    end)
    _G.ConnectionGuardInitialized = true
end

function _G.DisableHiggsBoson()
    local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if not pc or not slua.isValid(pc) then return end
    if pc.HiggsBoson then
        pc.HiggsBoson.bMHActive = false
        pc.HiggsBoson.bCallPreReplication = false
    end
end

-- ====================== DEXTER -> YARGI ENGINE UI ======================
local IngamePhoneStateUI = require("GameLua.Mod.Library.Client.UI.IngamePhoneStateUI")
local Lobby_Main_Wifi_UIBP = require("client.slua.umg.lobby.Main.Lobby_Main_Wifi_UIBP")

local o_UpdateQuality = Lobby_Main_Wifi_UIBP.__inner_impl.UpdateQuality
Lobby_Main_Wifi_UIBP.__inner_impl.UpdateQuality = function(self)
    if o_UpdateQuality then o_UpdateQuality(self) end
    pcall(function()
        self.UIRoot.WidgetSwitcher_Quality:SetActiveWidgetIndex(0)
        self.UIRoot.TextBlock_High:SetText("YARGI ENGINE")
        self.UIRoot.TextBlock_High:SetColorAndOpacity(FSlateColor(FLinearColor(1, 0, 0, 1)))
        self.UIRoot.TextBlock_Low:SetText("YARGI ENGINE")
        self.UIRoot.TextBlock_Low:SetColorAndOpacity(FSlateColor(FLinearColor(0, 1, 0, 1)))
    end)
end

local o_UpdateArtQualityUI = IngamePhoneStateUI.__inner_impl.UpdateArtQualityUI
IngamePhoneStateUI.__inner_impl.UpdateArtQualityUI = function(self, _, _)
    if o_UpdateArtQualityUI then o_UpdateArtQualityUI(self, _, _) end
    pcall(function()
        self.UIRoot.TextBlock_quality:SetText("YARGI ENGINE")
        self.UIRoot.TextBlock_quality:SetColorAndOpacity(FSlateColor(FLinearColor(1, 0, 0, 1)))
    end)
end

local o_TickRefreshBatteryInfo = IngamePhoneStateUI.__inner_impl.TickRefreshBatteryInfo
IngamePhoneStateUI.__inner_impl.TickRefreshBatteryInfo = function(self)
    if o_TickRefreshBatteryInfo then o_TickRefreshBatteryInfo(self) end
    pcall(function()
        self.UIRoot.ProgressBar_Battery:SetFillColorAndOpacity(FLinearColor(0.9, 0, 1, 1))
    end)
end

local o_SetPingText = IngamePhoneStateUI.__inner_impl.SetPingText
IngamePhoneStateUI.__inner_impl.SetPingText = function(self, ping, bLostNet)
    if o_SetPingText then o_SetPingText(self, ping, bLostNet) end
    pcall(function()
        self.UIRoot.TextBlock_Ping:SetColorAndOpacity(FSlateColor(FLinearColor(1, 0, 0.6, 1)))
    end)
end

-- ====================== YARGI INVENTORY UNLOCKER (ENVANTER) ======================
function _G.YargiInventoryUnlocker()
    pcall(function()
        local wardrobe_data = require("client.slua.logic.wardrobe.wardrobe_data")
        if wardrobe_data and not wardrobe_data._YargiUnlocked then
            
            -- 1. Eşya Sahipliğini Doğrulama (Tekil Kontrol)
            local oldGetItem = wardrobe_data.GetHallDepotItemDataByResID
            wardrobe_data.GetHallDepotItemDataByResID = function(self, resID)
                local data = oldGetItem(self, resID)
                if not data and resID then
                    -- Eğer eşya yoksa, varmış gibi sahte bir veri dön
                    data = {
                        insID = tostring(resID) .. "_YARGI",
                        resID = resID,
                        count = 1,
                        expireTS = 0,
                        lock_cnt = 0,
                        bFake = true
                    }
                end
                return data
            end
            
            -- 2. Envanter Listesini Doldurma (Toplu Kontrol)
            local oldGetArray = wardrobe_data.GetArrayHallDepotItemInfo
            wardrobe_data.GetArrayHallDepotItemInfo = function(self)
                local array = oldGetArray(self) or {}
                
                local function AddFakeItem(skinId)
                    local found = false
                    for k, v in pairs(array) do
                        if v.resID == skinId then found = true; break end
                    end
                    if not found then
                        local fakeIns = tostring(skinId) .. "_YARGI"
                        array[fakeIns] = {
                            insID = fakeIns,
                            resID = skinId,
                            count = 1,
                            expireTS = 0,
                            lock_cnt = 0,
                            bFake = true
                        }
                    end
                end

                -- Senin scriptindeki tüm silah skinlerini envantere ekle
                if _G.skinIdMappings then
                    for _, skins in pairs(_G.skinIdMappings) do
                        for _, skinId in ipairs(skins) do
                            AddFakeItem(skinId)
                        end
                    end
                end
                
                -- Senin scriptindeki tüm araç skinlerini envantere ekle
                if _G.VehskinIdMappings then
                    for _, skins in pairs(_G.VehskinIdMappings) do
                        for _, skinId in ipairs(skins) do
                            AddFakeItem(skinId)
                        end
                    end
                end
                
                return array
            end
            
            wardrobe_data._YargiUnlocked = true
        end
    end)
end

-- ====================== MODÜL YÜKLEME ======================
pcall(function()
    local ModuleManager = require("client.module_framework.ModuleManager")
    _G.ItemUpgradeSystem = ModuleManager.GetModule(ModuleManager.CommonModuleConfig.ItemUpgradeSystem)
    if _G.ItemUpgradeSystem then
        _G.ItemUpgradeSystem:DefineAndResetData()
        _G.ItemUpgradeSystem:OnInitialize()
    end
end)

_G.loadKillCountFromFile()
_G.ReadConfigFile()

local TXtime_ticker = require("common.time_ticker")
_G.Mytimer_ticker = TXtime_ticker

if _G.Mytimer_ticker then
    _G.Mytimer_ticker.AddTimerLoop(0, function() pcall(_G.GameAvatarHandlerweapons) end, -1, 0.10)
    _G.Mytimer_ticker.AddTimerLoop(0, function() pcall(_G.GameAvatarHandlerBagPack) end, -1, 0.10)
    _G.Mytimer_ticker.AddTimerLoop(0, function() pcall(_G.GameAvatarHandlervehicles) end, -1, 0.40)
    _G.Mytimer_ticker.AddTimerLoop(0, function() pcall(_G.GameAvatarHandlerkillcounter) end, -1, 0.50)
    _G.Mytimer_ticker.AddTimerLoop(0, function() pcall(_G.FileWatcher) end, -1, 0.05)
    _G.Mytimer_ticker.AddTimerLoop(0, function() pcall(_G.DisableHiggsBoson) end, -1, 0.50)
    _G.Mytimer_ticker.AddTimerLoop(1, function() pcall(_G.InitializeConnectionGuard) end, -1, 1)
    _G.Mytimer_ticker.AddTimerLoop(1, function() pcall(_G.InitializeGameplayBypass) end, -1, 1)
    _G.Mytimer_ticker.AddTimerLoop(1, function() pcall(_G.ReadConfigFile) end, -1, 1)
    _G.Mytimer_ticker.AddTimerLoop(1, function() pcall(_G.YargiInventoryUnlocker) end, -1, 2)
    _G.Mytimer_ticker.AddTimerOnce(1, function()
        pcall(_G.InstallKillCounterUIHooks)
    end)
    _G.YargiEngine.Loaded = true
end

_G.YargiEngine.Start = function() print("[YARGI ENGINE] Ready") end
print("[YARGI ENGINE] LOADED!")
