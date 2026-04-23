_G.YargiEngine = _G.YargiEngine or {}
_G.YargiEngine.Loaded = false

local DATA_PATH = (function()
    local packages = {"com.pubg.krmobile", "com.tencent.ig", "com.vng.pubgmobile", "com.rekoo.pubgm", "com.pubg.imobile"}
    local base = "/storage/emulated/0/Android/data/"
    for _, pkg in ipairs(packages) do
        local path = base .. pkg .. "/files"
        local f = io.open(path .. "/config.ini", "r")
        if f then f:close(); return path end
    end
    return base .. "com.pubg.krmobile/files"
end)()

local CONFIG_PATH = DATA_PATH .. "/config.ini"
local KILL_COUNTER_PATH = DATA_PATH .. "/NumberUpdate.txt"

_G.skinIdMappings = {
    [101004]={101004,1101004046,1101004226,1101004236,1101004062,1101004078,1101004086,1101004098,1101004138,1101004163,1101004201,1101004209,1101004218},
    [101001]={101001,1101001089,1101001213,1101001172,1101001127,1101001142,1101001153,1101001115,1101001102,1101001230,1101001241},
    [101003]={101003,1103003208,1101003195,1101003187,1101003098,1101003166,1101003069,1101003218,1101003079,1101003118,1101003145,1101003180,1101003056},
    [103001]={103001,1103001191,1103001101,1103001178,1103001145,1103001230,1103001213},
    [102002]={102002,1102002136,1102002043,1102002061,1102002424,1102002198},
    [103002]={103002,1103002030,1103002087,1103002105,1103002112,1103002201},
    [103003]={103003,1103003042,1103003087,1103003062,1103003022,1103003051,1103003030,1103003079},
    [101008]={101008,1101008079,1101008126,1101008104,1101008146,1101008026,1101008061,1101008116,1101008051},
    [102003]={102003,1102003019,1102003030,1102003064,1102003079},
    [105010]={105010,1105010018,1105010007,1105010025},
    [102004]={102004,1102004017,1102004033,1102004048},
    [105002]={105002,1105002090,1105002075,1105002018,1105002034,1105002057,1105002062},
    [105001]={105001,1105001047,1105001068,1105001033,1105001061},
    [101006]={101006,1101006061,1101006074,1101006043,1101006032,1101006084,1101006096},
    [104004]={104004,1104004034,1104004015,1104004040},
    [101002]={101002,1101002081,1101002105,1101002128},
    [101005]={101005,1101005052,1101005073,1101005091},
    [101007]={101007,1101007046,1101007068,1101007089},
    [102001]={102001,1102001103,1102001124,1102001148},
    [103004]={103004,1103004001,1103004022,1103004047},
    [103006]={103006,1103006030,1103006055,1103006079},
    [103007]={103007,1103007028,1103007049},
    [103012]={103012,1103012010,1103012025},
    [104003]={104003,1104003027,1104003048},
    [101009]={101009,1101009035,1101009058,1101009079},
    [101010]={101010,1101010022,1101010043},
    [101011]={101011,1101011019,1101011038},
    [103008]={103008,1103008015,1103008035},
    [103009]={103009,1103009018,1103009037},
    [103011]={103011,1103011010,1103011022},
    [102005]={102005,1102005018,1102005037},
    [102006]={102006,1102006015,1102006031},
    [104005]={104005,1104005012,1104005025},
    [106001]={106001,1108004356}
}

_G.VehskinIdMappings = {
    [101] = {1105001001, 1105001002, 1105001003, 1105001004},
    [102] = {1105002001, 1105002002, 1105002003, 1105002004},
    [103] = {1105003001, 1105003002, 1105003003},
    [104] = {1105004001, 1105004002},
    [108] = {1105008001, 1105008002, 1105008003},
    [109] = {1105009001, 1105009002},
    [111] = {1105011001, 1105011002},
}

_G.muzzles = {
    id_flash_hider = {201010, 201005, 201004},
    id_compensator = {201009, 201003, 201002},
    id_suppressor = {201011, 201006, 201007}
}
_G.foregrips = {
    id_Angledforegrip = 202001, id_thumb_grip = 202006, id_vertical_grip = 202002,
    id_light_grip = 202004, id_half_grip = 202005, id_ergonomic_grip = 202051, id_laser_sight = 202007
}
_G.magazines = {
    id_expanded_mag = {204011, 204007, 204004},
    id_quick_mag = {204012, 204008, 204005},
    id_expanded_quick_mag = {204013, 204009, 204006}
}
_G.scopes = {
    id_reddot = 203001, id_holo = 203002, id_2x = 203003,
    id_3x = 203014, id_4x = 203004, id_6x = 203015, id_8x = 203005
}
_G.stock = {
    id_microStock = 205001, id_tactical = 205002,
    id_bulletloop = 204014, id_CheekPad = 205003
}

_G.WeaponSkinIndex = _G.WeaponSkinIndex or {}
_G.VehicleSkinIndex = _G.VehicleSkinIndex or {}
_G.skinIdCache = _G.skinIdCache or {}
_G.killCountInfo = _G.killCountInfo or {}
_G.DeadBoxSkins = _G.DeadBoxSkins or {}
_G.AlreadyChangedSet = _G.AlreadyChangedSet or {}
_G.g_parts = _G.g_parts or {}
_G.lastAppliedSkin = _G.lastAppliedSkin or {}
_G.CurrentEquipVehicleID = 0
_G.lastFileContent = ""
_G.isFileWatcherActive = true
_G.WelcomeShown = false

_G.IsPtrValid = function(ptr) return ptr ~= nil and slua.isValid(ptr) end

function table.contains(tbl, element)
    for _, v in ipairs(tbl) do if v == element then return true end end
    return false
end

local function locationsClose(loc1, loc2, tolerance)
    local dx, dy, dz = loc1.X - loc2.X, loc1.Y - loc2.Y, loc1.Z - loc2.Z
    return dx*dx + dy*dy + dz*dz < tolerance*tolerance
end

function _G.download_item(id)
    if not id or id == 0 then return end
    pcall(function()
        local PM = require("client.slua.logic.download.puffer.puffer_manager")
        local PC = require("client.slua.logic.download.puffer_const")
        if not PM or not PC then return end
        local state = PM.GetState(PC.ENUM_DownloadType.ODPAK, {id})
        if state ~= PC.ENUM_DownloadState.Done then
            PM.Download(PC.ENUM_DownloadType.ODPAK, {id})
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
        [1] = {291004,291102,291001,291006,291005,291002,293003,293004,293009,293007,293005,293006,295001,295002,291007,291003,292002,292003,291011,291008},
        [2] = {205005,205102,205007,205009,205006},
        [3] = {203008,203009,203006,203022,203010}
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
    if is_in("id_flash_hider") then mtype = "Flash Hider"
    elseif is_in("id_compensator") then mtype = "Compensator"
    elseif is_in("id_suppressor") then mtype = "Suppressor"
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
        [_G.foregrips.id_Angledforegrip] = "Angled Foregrip",
        [_G.foregrips.id_thumb_grip] = "Thumb Grip",
        [_G.foregrips.id_vertical_grip] = "Vertical Foregrip",
        [_G.foregrips.id_light_grip] = "Light Grip",
        [_G.foregrips.id_half_grip] = "Half Grip",
        [_G.foregrips.id_ergonomic_grip] = "Ergonomic Grip",
        [_G.foregrips.id_laser_sight] = "Laser Sight",
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
    if is_in("id_expanded_mag") then mtype = "Extended Mag"
    elseif is_in("id_quick_mag") then mtype = "Quickdraw Mag"
    elseif is_in("id_expanded_quick_mag") then mtype = "Extended Quickdraw Mag"
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
        [_G.scopes.id_reddot] = "Red Dot Sight", [_G.scopes.id_holo] = "Holographic Sight",
        [_G.scopes.id_2x] = "2x Scope", [_G.scopes.id_3x] = "3x Scope",
        [_G.scopes.id_4x] = "4x Scope", [_G.scopes.id_6x] = "6x Scope", [_G.scopes.id_8x] = "8x Scope",
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
        [_G.stock.id_microStock] = "Stock", [_G.stock.id_tactical] = "Tactical Stock",
        [_G.stock.id_bulletloop] = "Bullet Loop", [_G.stock.id_CheekPad] = "Cheek Pad",
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

function _G.ReadConfigFile()
    local file = io.open(CONFIG_PATH, "r")
    if not file then return end
    local content = file:read("*all")
    file:close()
    for line in content:gmatch("[^\r\n]+") do
        local key, value = line:match("(%w+)=(%d+)")
        if key and value then
            local val = tonumber(value)
            local wepMap = {
                M416=101004,AKM=101001,SCAR=101003,M16A4=101002,GROZA=101005,AUG=101006,QBZ=101007,M762=101008,
                Kar98=103001,M24=103002,AWM=103003,SKS=103004,Mini14=103006,MK14=103007,UZI=102001,UMP=102002,
                Vector=102003,Thompson=102004,M249=105002,DP28=105001,G36C=101009,Mk47=101010,Beryl=101011,
                QBU=103008,SLR=103009,Lynx=103011,PP19=102005,P90=102006,DBS=104005,S12K=104004,S1897=104003,
                S686=102004,MG3=103012
            }
            for wName, wId in pairs(wepMap) do
                if key == wName then _G.WeaponSkinIndex[wId] = val + 1; break end
            end
            local vehMap = {Vehicle_UAZ=101, Vehicle_Buggy=102, Vehicle_Bike=103, Vehicle_Boat=104, Vehicle_Pickup=108, Vehicle_Mirado=109}
            if vehMap[key] then _G.VehicleSkinIndex[vehMap[key]] = val end
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

function _G.getKills(weaponID) return weaponID and _G.killCountInfo[weaponID] or 0 end

function _G.saveKillCountToFile()
    local file = io.open(KILL_COUNTER_PATH, "w+")
    if not file then return end
    local content = "{\n"
    for weaponID, count in pairs(_G.killCountInfo) do
        content = content .. string.format("    [%d] = %d,\n", weaponID, count)
    end
    content = content .. "}"
    file:write(content)
    file:close()
    _G.lastFileContent = content
end

function _G.loadKillCountFromFile()
    local file = io.open(KILL_COUNTER_PATH, "r")
    if not file then return end
    local content = file:read("*a")
    file:close()
    _G.lastFileContent = content
    if content ~= "" then
        content = content:gsub("\239\187\191", ""):gsub("^%s+", "")
        for weaponID, count in content:gmatch("%[(%d+)%]%s*=%s*(%d+)") do
            _G.killCountInfo[tonumber(weaponID)] = tonumber(count)
        end
    end
end

function _G.addKill(weaponID, count)
    if not weaponID or not count then return end
    _G.killCountInfo[weaponID] = (_G.killCountInfo[weaponID] or 0) + count
    _G.saveKillCountToFile()
    _G.ForceUpdateAllKillCounterUI()
end

function _G.ForceUpdateAllKillCounterUI()
    pcall(function()
        local UIManager = require("client.slua_ui_framework.manager")
        local MainKillCounter = UIManager.GetUI(UIManager.UI_Config_InGame.MainKillCounter)
        if MainKillCounter and MainKillCounter.KillCounterItem then
            local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
            if not _G.IsPtrValid(pc) then return end
            local uChar = pc:GetPlayerCharacterSafety()
            if not _G.IsPtrValid(uChar) then return end
            local currWeapon = uChar:GetCurrentWeapon()
            if not _G.IsPtrValid(currWeapon) then return end
            local DefineID = currWeapon:GetItemDefineID().TypeSpecificID
            if DefineID == 0 then return end
            local SkinID = slua.IndexReference(currWeapon.synData:Get(7), "defineID").TypeSpecificID
            local kills = _G.getKills(DefineID)
            MainKillCounter.KillCounterItem:SetKillCounterItemShowWithNum(nil, kills, SkinID)
        end
    end)
end

function _G.DeadBox_TemperRequest(PlayerController)
    local uCharacter = PlayerController:GetPlayerCharacterSafety()
    if not _G.IsPtrValid(uCharacter) then return end
    local UGameplayStatics = import("GameplayStatics")
    if not UGameplayStatics then return end
    local UIUtil = require("client.common.ui_util")
    if not UIUtil then return end
    local uGameInstance = UIUtil.GetGameInstance()
    if not uGameInstance then return end
    local APlayerTombBox = import("PlayerTombBox")
    local actors = UGameplayStatics.GetAllActorsOfClass(uGameInstance, APlayerTombBox, slua.Array(UEnums.EPropertyClass.Object, import("Actor")))
    for _, actor in pairs(actors) do
        if _G.IsPtrValid(actor) and actor.DamageCauser and actor.DamageCauser.Playerkey == PlayerController.Playerkey then
            local Deadboxavatar = actor.DeadBoxAvatarComponent_BP
            if Deadboxavatar and not table.contains(_G.AlreadyChangedSet, actor) then
                local actorLocation = actor:K2_GetActorLocation()
                local found = false
                for _, entry in pairs(_G.DeadBoxSkins) do
                    if locationsClose(entry.location, actorLocation, 1.0) then
                        Deadboxavatar:ResetItemAvatar()
                        Deadboxavatar:PreChangeItemAvatar(entry.SkinID)
                        Deadboxavatar:SyncChangeItemAvatar(entry.SkinID)
                        table.insert(_G.AlreadyChangedSet, actor)
                        found = true; break
                    end
                end
                if not found then
                    local ApplySkinID = 0
                    local currweapon = uCharacter:GetCurrentWeapon()
                    if _G.IsPtrValid(currweapon) then
                        ApplySkinID = slua.IndexReference(currweapon.synData:Get(7), "defineID").TypeSpecificID
                    end
                    if ApplySkinID ~= 0 then
                        Deadboxavatar:ResetItemAvatar()
                        Deadboxavatar:PreChangeItemAvatar(ApplySkinID)
                        Deadboxavatar:SyncChangeItemAvatar(ApplySkinID)
                        table.insert(_G.DeadBoxSkins, {location = actorLocation, SkinID = ApplySkinID})
                        table.insert(_G.AlreadyChangedSet, actor)
                    end
                end
            end
        end
    end
end

function _G.Game_Vehicle_Avatar_Change(uCharacter)
    if not _G.IsPtrValid(uCharacter) then return end
    local CurrentVehicle = uCharacter.CurrentVehicle
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
                _G.CurrentEquipVehicleID = skinId
            end
            break
        end
    end
end

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
            local DefineID = currweapon:GetItemDefineID()
            DefineID.TypeSpecificID = targetSkin
            currweapon:SetWeaponSkin(DefineID)
            _G.apply_attachment(currweapon, targetSkin)
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
                local DefineID = Weapon:GetItemDefineID()
                DefineID.TypeSpecificID = targetSkin
                Weapon:SetWeaponSkin(DefineID)
                _G.apply_attachment(Weapon, targetSkin)
            end
        end
    end)
end

function _G.GameAvatarHandlerBagPack()
    local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if _G.IsPtrValid(pc) then _G.UpdateWeapon_BackPack_Appearance(pc) end
end

function _G.GameAvatarHandlerkillcounter()
    _G.ForceUpdateAllKillCounterUI()
end

function _G.GameAvatarHandlerDeadBox()
    local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if _G.IsPtrValid(pc) then _G.DeadBox_TemperRequest(pc) end
end

function _G.GameAvatarHandlervehicles()
    local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if _G.IsPtrValid(pc) then
        local uChar = pc:GetPlayerCharacterSafety()
        if _G.IsPtrValid(uChar) then _G.Game_Vehicle_Avatar_Change(uChar) end
    end
end

function _G.FileWatcher()
    if not _G.isFileWatcherActive then return end
    pcall(function()
        local file = io.open(KILL_COUNTER_PATH, "r")
        if not file then return end
        local currentContent = file:read("*a") or ""
        file:close()
        currentContent = currentContent:gsub("\239\187\191", ""):gsub("^%s+", ""):gsub("%s+$", "")
        if currentContent == "" or currentContent == _G.lastFileContent then return end
        _G.lastFileContent = currentContent
        local tempTable = {}
        for weaponID, count in currentContent:gmatch("%[(%d+)%]%s*=%s*(%d+)") do
            tempTable[tonumber(weaponID)] = tonumber(count)
        end
        if next(tempTable) then
            _G.killCountInfo = tempTable
            _G.ForceUpdateAllKillCounterUI()
        end
    end)
end

function _G.InitializeAntiReport()
    pcall(function()
        local ClientReport = require("GameLua.Mod.BaseMod.Client.Security.ClientReportPlayerSubsystem")
        if ClientReport then
            ClientReport.OnInit = function() end
            ClientReport._OnPlayerKilledOtherPlayer = function() end
            ClientReport._OnBattleResult = function() end
        end
    end)
    pcall(function()
        local HiggsBoson = require("GameLua.Mod.BaseMod.Common.Security.HiggsBosonComponent")
        if HiggsBoson then HiggsBoson.StaticShowSecurityAlertInDev = function() end end
    end)
end

function _G.InitializeGameplayBypass()
    pcall(function()
        if _G.GameplayCallbacks then
            local GC = _G.GameplayCallbacks
            GC.ReportAttackFlow = function() end
            GC.ReportHurtFlow = function() end
            GC.SendTssSdkAntiDataToLobby = function() end
            GC.ReportPlayerPosition = function() end
        end
    end)
end

function _G.InitializeConnectionGuard()
    pcall(function()
        if _G.GameplayCallbacks then
            local original = _G.GameplayCallbacks.OnDSPlayerStateChanged
            _G.GameplayCallbacks.OnDSPlayerStateChanged = function(UID, state, ...)
                local s = state and string.lower(tostring(state)) or ""
                if s == "cheatdetected" or s == "connectionlost" then return end
                if original then return original(UID, state, ...) end
            end
        end
    end)
end

function _G.DisableHiggsBoson()
    local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if not pc or not slua.isValid(pc) then return end
    if pc.HiggsBoson then
        pc.HiggsBoson.bMHActive = false
        pc.HiggsBoson.bCallPreReplication = false
    end
end

local function InitEmulatorBypass()
    pcall(function()
        local EmulatorSystem = require("client.slua.logic.login.emulator_system")
        if EmulatorSystem then
            EmulatorSystem.IsEmulator = function() return false end
            EmulatorSystem.GetEmulatorName = function() return "NoEmulator" end
            EmulatorSystem.Tick = function() end
        end
    end)
end

function _G.TryShowWelcome()
    if _G.WelcomeShown then return end
    pcall(function()
        local CommonMsgBoxMgr = require("client.slua.logic.common.logic_common_msg_box")
        if CommonMsgBoxMgr then
            local msg = "YARGI ENGINE v555.0\n\nWeapon Skins\nKill Counter\nDeadBox\nVehicle\nAnti-Report\n\nCEXY 31 TEAM"
            CommonMsgBoxMgr.Show(4, "YARGI ENGINE", msg, function() end)
        end
    end)
    _G.WelcomeShown = true
end

pcall(function()
    local SKillInfo = require("GameLua.Mod.BaseMod.Client.KillInfoTips.KillInfo")
    local ECharacterHealthStatus = import("ECharacterHealthStatus")
    local O_FileItem = SKillInfo.__inner_impl.FileItem
    SKillInfo.__inner_impl.FileItem = function(self, DamageRecordData)
        if not self or not DamageRecordData then return O_FileItem(self, DamageRecordData) end
        local uCharacter = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController() and slua_GameFrontendHUD:GetPlayerController():GetPlayerCharacterSafety()
        if not _G.IsPtrValid(uCharacter) then return O_FileItem(self, DamageRecordData) end
        local SelfName = uCharacter:GetPlayerNameSafety()
        if DamageRecordData.Causer == SelfName then
            local currWeapon = uCharacter:GetCurrentWeapon()
            if _G.IsPtrValid(currWeapon) then
                local DefineID = currWeapon:GetItemDefineID().TypeSpecificID
                if DefineID ~= 0 and DamageRecordData.ResultHealthStatus == ECharacterHealthStatus.FinishedLastBreath then
                    _G.addKill(DefineID, 1)
                end
                local SkinID = slua.IndexReference(currWeapon.synData:Get(7), "defineID").TypeSpecificID
                DamageRecordData.CauserWeaponAvatarID = SkinID
            end
        end
        return O_FileItem(self, DamageRecordData)
    end
end)

pcall(function()
    local MyMainKillCounter = require("GameLua.Mod.BaseMod.Client.KillCounter.MainKillCounter")
    if MyMainKillCounter and MyMainKillCounter.__inner_impl then
        MyMainKillCounter.__inner_impl.OnRefreshUI = function(self, _, _, UID)
            pcall(function()
                local uCharacter = slua_GameFrontendHUD:GetPlayerController():GetPlayerCharacterSafety()
                if not uCharacter then return end
                local cw = uCharacter:GetCurrentWeapon()
                if cw then
                    local DefineID = cw:GetItemDefineID().TypeSpecificID
                    local currentAvatarID = slua.IndexReference(cw.synData:Get(7), "defineID").TypeSpecificID
                    local kills = _G.getKills(DefineID)
                    if self.KillCounterItem then
                        self.KillCounterItem:SetKillCounterItemShowWithNum(nil, kills, currentAvatarID)
                    end
                end
            end)
        end
    end
end)

local function InitItemUpgradeSystem()
    local ModuleManager = require("client.module_framework.ModuleManager")
    if ModuleManager then
        _G.ItemUpgradeSystem = ModuleManager.GetModule(ModuleManager.CommonModuleConfig.ItemUpgradeSystem)
        if _G.ItemUpgradeSystem then
            _G.ItemUpgradeSystem:DefineAndResetData()
            _G.ItemUpgradeSystem:OnInitialize()
        end
    end
end

local TXtime_ticker = require("common.time_ticker")
_G.Mytimer_ticker = TXtime_ticker

if _G.Mytimer_ticker then
    pcall(InitItemUpgradeSystem)
    pcall(_G.InitializeAntiReport)
    pcall(_G.InitializeGameplayBypass)
    pcall(_G.InitializeConnectionGuard)
    pcall(InitEmulatorBypass)
    _G.Mytimer_ticker.AddTimerLoop(0, function() pcall(_G.GameAvatarHandlerweapons) end, -1, 0.10)
    _G.Mytimer_ticker.AddTimerLoop(0, function() pcall(_G.GameAvatarHandlerBagPack) end, -1, 0.10)
    _G.Mytimer_ticker.AddTimerLoop(0, function() pcall(_G.GameAvatarHandlerkillcounter) end, -1, 0.10)
    _G.Mytimer_ticker.AddTimerLoop(0, function() pcall(_G.GameAvatarHandlerDeadBox) end, -1, 0.10)
    _G.Mytimer_ticker.AddTimerLoop(0, function() pcall(_G.GameAvatarHandlervehicles) end, -1, 0.10)
    _G.Mytimer_ticker.AddTimerLoop(0, function() pcall(_G.DisableHiggsBoson) end, -1, 0.50)
    _G.Mytimer_ticker.AddTimerLoop(0, function() pcall(_G.FileWatcher) end, -1, 0.05)
    _G.Mytimer_ticker.AddTimerOnce(0.2, function()
        pcall(_G.loadKillCountFromFile)
        pcall(_G.ReadConfigFile)
        pcall(_G.TryShowWelcome)
    end)
    _G.YargiEngine.Loaded = true
end

_G.YargiEngine.Start = function() print("[YARGI] Engine Started - CEXY 31 TEAM") end