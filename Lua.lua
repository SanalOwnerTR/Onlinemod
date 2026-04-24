-- ============================================
-- BİRLEŞTİRİLMİŞ WEAPON SKIN + ATTACHMENT + KILL COUNTER SİSTEMİ
-- ============================================

_G.skinIdMappings = {
    [101004]={101004,1101004046,1101004226,1101004236,1101004062,1101004078,1101004086,1101004098,1101004138,1101004163,1101004201,1101004209,1101004218},
    [101001]={101001,1101001089,1101001213,1101001172,1101001127,1101001142,1101001153,1101001115,1101001102,1101001230,1101001241},
    [101003]={101003,1103003208,1101003195,1101003187,1101003098,1101003166,1101003069,1101003218,1101003079,1101003118,1101003145,1101003180,1101003056},
    [103001]={103001,1103001191,1103001101,1103001178,1103001145},
    [102002]={102002,1102002136,1102002043,1102002061,1102002424},
    [103002]={103002,1103002030,1103002087,1103002105,1103002112},
    [103003]={103003,1103003042,1103003087,1103003062,1103003022,1103003051,1103003030,1103003079},
    [101008]={101008,1101008079,1101008126,1101008104,1101008146,1101008026,1101008061,1101008116,1101008051},
    [102003]={102003,1102003019,1102003030,1102003064,1102003079},
    [105010]={105010,1105010018,1105010007},
    [102004]={102004,1102004017,1102004033},
    [105002]={105002,1105002090,1105002075,1105002018,1105002034,1105002057,1105002062},
    [105001]={105001,1105001047,1105001068,1105001033,1105001061},
    [101006]={101006,1101006061,1101006074,1101006043,1101006032,1101006084},
    [104004]={104004,1104004034,1104004015,1104004040}
}
_G.skinIdMappings2 = _G.skinIdMappings
_G.WeaponSkinMap = _G.skinIdMappings

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
    id_microStock = 205001,
    id_tactical = 205002,
    id_bulletloop = 204014,
    id_CheekPad = 205003
}

_G.WeaponSkinIndex = _G.WeaponSkinIndex or {}
_G.skinIdCache = _G.skinIdCache or {}
_G.killCountInfo = _G.killCountInfo or {}
_G.lastFileContent = ""
_G.isFileWatcherActive = false
_G.ActiveKillCounterPath = nil
_G.lastDisplayedKills = {}
_G.UpdateMyKillCounter = false
_G.g_parts = {}
_G.hasShownDownloadPopup = false
_G.skinApplicationAllowed = false
_G.lastAppliedAttachments = _G.lastAppliedAttachments or {}
_G.lastAppliedSkin = _G.lastAppliedSkin or {}
_G.last_refreshed_weapon = _G.last_refreshed_weapon or 0
_G.DeadBoxSkins = _G.DeadBoxSkins or {}
_G.AlreadyChangedSet = _G.AlreadyChangedSet or {}

local lastConfig = {}

-- ============================================
-- YARDIMCI FONKSİYONLAR
-- ============================================

local function IsPtrValid(ptr)
    if ptr == nil then return false end
    return slua.isValid(ptr)
end

function logfile(formatStr, ...)
    if not formatStr then return end
    local message = select("#", ...) > 0 and string.format(formatStr, ...) or formatStr
    local file = io.open("/data/share1/hook_log.txt", "a")
    if file then
        file:write(os.date("[%Y-%m-%d %H:%M:%S] ") .. tostring(message) .. "\n")
        file:close()
    end
end

local function download_item(i)
    local PufferManager = require("client.slua.logic.download.puffer.puffer_manager")
    local PufferConst = require("client.slua.logic.download.puffer_const")
    if not PufferManager or not PufferConst then return end
    local state = PufferManager.GetState(PufferConst.ENUM_DownloadType.ODPAK, {i})
    if state ~= PufferConst.ENUM_DownloadState.Done then
        PufferManager.Download(PufferConst.ENUM_DownloadType.ODPAK, {i})
    end
end

-- ============================================
-- CONFIG OKUMA (WEAPON SKIN INDEX)
-- ============================================

local function ReadConfigFile()
    local possiblePaths = {
        '/storage/emulated/0/Android/data/com.tencent.ig/files/config.ini',
        '/storage/emulated/0/Android/data/com.pubg.krmobile/files/config.ini',
        '/storage/emulated/0/Android/data/com.vng.pubgmobile/files/config.ini',
        '/storage/emulated/0/Android/data/com.rekoo.pubgm/files/config.ini',
        '/storage/emulated/0/config.ini'
    }
    
    local configPath = nil
    for _, path in ipairs(possiblePaths) do
        local file = io.open(path, 'r')
        if file then 
            file:close()
            configPath = path
            break 
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
    
    local function UpdateWep(key, id)
        if newConfig[key] and newConfig[key] ~= lastConfig[key] then
            if not _G.WeaponSkinIndex then _G.WeaponSkinIndex = {} end
            _G.WeaponSkinIndex[id] = newConfig[key] + 1
            lastConfig[key] = newConfig[key]
        end
    end
    
    UpdateWep('M416', 101004); UpdateWep('AKM', 101001); UpdateWep('SCAR', 101003); UpdateWep('M16A4', 101002)
    UpdateWep('GROZA', 101005); UpdateWep('AUG', 101006); UpdateWep('QBZ', 101007); UpdateWep('M762', 101008)
    UpdateWep('MK47', 101009); UpdateWep('G36C', 101010); UpdateWep('FAMAS', 101011)
    UpdateWep('Kar98', 103001); UpdateWep('M24', 103002); UpdateWep('AWM', 103003); UpdateWep('SKS', 103004)
    UpdateWep('VSS', 103005); UpdateWep('Mini14', 103006); UpdateWep('MK14', 103007); UpdateWep('SLR', 103009)
    UpdateWep('QBU', 103010); UpdateWep('MK12', 103011); UpdateWep('AMR', 103012); UpdateWep('Mosin', 103013)
    UpdateWep('UZI', 102001); UpdateWep('UMP', 102002); UpdateWep('Vector', 102003); UpdateWep('Thompson', 102004)
    UpdateWep('Bizon', 102005); UpdateWep('MP5K', 102007); UpdateWep('P90', 102009)
    UpdateWep('S12K', 104003); UpdateWep('DBS', 104004); UpdateWep('S1897', 104001); UpdateWep('S686', 104002)
    UpdateWep('M249', 105002); UpdateWep('DP28', 105001); UpdateWep('MG3', 105010)
    UpdateWep('Pan', 106001); UpdateWep('Machete', 106003); UpdateWep('Crowbar', 106002); UpdateWep('Sickle', 106004)
end
_G.ReadConfigFile = ReadConfigFile

-- ============================================
-- WEAPON SKIN FONKSİYONLARI
-- ============================================

function _G.get_skin_id(weaponID)
    if not weaponID then return weaponID end
    local index = (_G.WeaponSkinIndex and _G.WeaponSkinIndex[weaponID]) or 1
    local weaponSkins = _G.skinIdMappings[weaponID]
    if not weaponSkins then return weaponID end
    local skinID = weaponSkins[index]
    if not skinID then return weaponID end
    if not _G.skinIdCache[skinID] then
        pcall(download_item, skinID) 
        _G.skinIdCache[skinID] = true
    end
    return skinID
end
_G.get_skin_id2 = _G.get_skin_id

function _G.get_cached_skin_id(gun_id)
    return _G.skinIdCache[gun_id] or _G.get_skin_id(gun_id)
end

-- ============================================
-- ATTACHMENT FONKSİYONLARI (2.lua'dan)
-- ============================================

local function get_group_id(itemId)
    local ModuleManager = require("client.module_framework.ModuleManager")
    local ItemUpgradeSystem = ModuleManager.GetModule(ModuleManager.CommonModuleConfig.ItemUpgradeSystem)
    if not ItemUpgradeSystem or not itemId then return nil end
    local itemcfg = ItemUpgradeSystem:GetUpgradeCfg(itemId)
    return itemcfg and itemcfg.GroupID or nil
end

function _G.InitParts(groupId, itemId)
    local ModuleManager = require("client.module_framework.ModuleManager")
    local ItemUpgradeSystem = ModuleManager.GetModule(ModuleManager.CommonModuleConfig.ItemUpgradeSystem)
    if not itemId then return _G.g_parts end
    if not _G.g_parts[itemId] then _G.g_parts[itemId] = {} end
    if ItemUpgradeSystem:IsWeaponIsRefit(itemId) then
        groupId = ItemUpgradeSystem:GetNormalGroupID(groupId or get_group_id(itemId))
    else
        groupId = groupId or get_group_id(itemId)
    end
    local cfg = CDataTable.GetTableByFilter("ItemUpgradeUnLockConfig", "GroupID", groupId)
    if cfg then
        for _, info in pairs(cfg) do
            local partId = info.PartId
            if ItemUpgradeSystem:IsWeaponIsRefit(itemId) then
                local switched = ItemUpgradeSystem:PartIDSwitch(partId, true)
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
        [1] = {291004, 291102, 291001, 291006, 291005, 291002, 293003, 293004, 293009, 293007, 293005, 293006, 295001, 295002, 291007, 291003, 292002, 292003, 291011, 291008},
        [2] = {205005, 205102, 205007, 205009, 205006},
        [3] = {203008, 203009, 203006, 203022, 203010}
    }
    local targetAttachmentIDs = attachmentTypeMap[stock]
    if not targetAttachmentIDs then return 0 end
    local UAvatarUtils = import("AvatarUtils")
    if not UAvatarUtils then return 0 end
    local uCurWeaponDefaultAttachmentList = UAvatarUtils.GetWeaponAvatarDefaultAttachmentSkin(skinid, {}, false) or {}
    for _, targetAttachmentID in ipairs(targetAttachmentIDs) do
        for attachmentID, attachmentSkinID in pairs(uCurWeaponDefaultAttachmentList) do
            if attachmentID == targetAttachmentID then return attachmentSkinID end
        end
    end
    return 0
end

function _G.get_muzzleid(current_id, avatarid)
    local initial_id = current_id
    _G.InitParts(_G.get_group_id(avatarid), avatarid)

    local function is_in_muzzles_list(muzzle_type)
        for _, id in ipairs(_G.muzzles[muzzle_type]) do
            if current_id == id then return true end
        end
        return false
    end

    local muzzle_type = nil
    if is_in_muzzles_list("id_flash_hider") then
        muzzle_type = "Flash Hider"
    elseif is_in_muzzles_list("id_compensator") then
        muzzle_type = "Compensator"
    elseif is_in_muzzles_list("id_suppressor") then
        muzzle_type = "Suppressor"
    end

    if muzzle_type and _G.g_parts[avatarid] and _G.g_parts[avatarid][muzzle_type] then
        current_id = _G.g_parts[avatarid][muzzle_type]
    end
    if initial_id ~= current_id then
        return current_id, true
    end
    return current_id, false
end

function _G.get_forgripid(current_id, avatarid)
    local initial_id = current_id
    _G.InitParts(_G.get_group_id(avatarid), avatarid)
    if current_id == _G.foregrips.id_Angledforegrip then
        current_id = _G.g_parts[avatarid]["Angled Foregrip"] or current_id
    elseif current_id == _G.foregrips.id_thumb_grip then
        current_id = _G.g_parts[avatarid]["Thumb Grip"] or current_id
    elseif current_id == _G.foregrips.id_vertical_grip then
        current_id = _G.g_parts[avatarid]["Vertical Foregrip"] or current_id
    elseif current_id == _G.foregrips.id_light_grip then
        current_id = _G.g_parts[avatarid]["Light Grip"] or current_id
    elseif current_id == _G.foregrips.id_half_grip then
        current_id = _G.g_parts[avatarid]["Half Grip"] or current_id
    elseif current_id == _G.foregrips.id_ergonomic_grip then
        current_id = _G.g_parts[avatarid]["Ergonomic Grip"] or current_id
    elseif current_id == _G.foregrips.id_laser_sight then
        current_id = _G.g_parts[avatarid]["Laser Sight"] or current_id
    end
    if initial_id ~= current_id then
        return current_id, true
    end
    return current_id, false
end

function _G.get_magazinesid(current_id, avatarid)
    local initial_id = current_id
    _G.InitParts(_G.get_group_id(avatarid), avatarid)

    local function is_in_magazine_list(mag_type)
        for _, id in ipairs(_G.magazines[mag_type]) do
            if current_id == id then return true end
        end
        return false
    end

    local magazine_type = nil
    if is_in_magazine_list("id_expanded_mag") then
        magazine_type = "Extended Mag"
    elseif is_in_magazine_list("id_quick_mag") then
        magazine_type = "Quickdraw Mag"
    elseif is_in_magazine_list("id_expanded_quick_mag") then
        magazine_type = "Extended Quickdraw Mag"
    end

    if magazine_type and _G.g_parts[avatarid] and _G.g_parts[avatarid][magazine_type] then
        current_id = _G.g_parts[avatarid][magazine_type]
    elseif not magazine_type then
        current_id = _G.GetSlotFromSkinID(avatarid, 1) or current_id
    end
    if initial_id ~= current_id then
        return current_id, true
    end
    return current_id, false
end

function _G.get_scopeid(current_id, avatarid)
    local initial_id = current_id
    _G.InitParts(_G.get_group_id(avatarid), avatarid)

    if current_id == _G.scopes.id_reddot then
        current_id = _G.g_parts[avatarid]["Red Dot Sight"] or current_id
    elseif current_id == _G.scopes.id_holo then
        current_id = _G.g_parts[avatarid]["Holographic Sight"] or current_id
    elseif current_id == _G.scopes.id_2x then
        current_id = _G.g_parts[avatarid]["2x Scope"] or current_id
    elseif current_id == _G.scopes.id_3x then
        current_id = _G.g_parts[avatarid]["3x Scope"] or current_id
    elseif current_id == _G.scopes.id_4x then
        current_id = _G.g_parts[avatarid]["4x Scope"] or current_id
    elseif current_id == _G.scopes.id_6x then
        current_id = _G.g_parts[avatarid]["6x Scope"] or current_id
    elseif current_id == _G.scopes.id_8x then
        current_id = _G.g_parts[avatarid]["8x Scope"] or current_id
    else
        current_id = _G.GetSlotFromSkinID(avatarid, 3) or current_id
    end

    if initial_id ~= current_id then
        return current_id, true
    end
    return current_id, false
end

function _G.get_stockid(current_id, avatarid)
    local initial_id = current_id
    _G.InitParts(_G.get_group_id(avatarid), avatarid)

    if current_id == _G.stock.id_microStock then
        current_id = _G.g_parts[avatarid]["Stock"] or current_id
    elseif current_id == _G.stock.id_tactical then
        current_id = _G.g_parts[avatarid]["Tactical Stock"] or current_id
    elseif current_id == _G.stock.id_bulletloop then
        current_id = _G.g_parts[avatarid]["Bullet Loop"] or current_id
    elseif current_id == _G.stock.id_CheekPad then
        current_id = _G.g_parts[avatarid]["Cheek Pad"] or current_id
    else
        current_id = _G.GetSlotFromSkinID(avatarid, 2) or current_id
    end

    if initial_id ~= current_id then
        return current_id, true
    end
    return current_id, false
end

-- ============================================
-- WEAPON SKIN UYGULAMA
-- ============================================

function _G.apply_weapon_skin(Weapon)
    if not Weapon or not slua.isValid(Weapon) then return end
    
    local DefineID = Weapon:GetItemDefineID().TypeSpecificID
    local SkinID = _G.get_skin_id(DefineID)
    
    if SkinID and SkinID ~= DefineID then
        local synData = Weapon.synData
        if synData and slua.isValid(synData) then
            local weaponDefineID = slua.IndexReference(synData:Get(7), "defineID")
            if weaponDefineID then
                weaponDefineID.TypeSpecificID = SkinID
                Weapon:DelayHandleAvatarMeshChanged()
            end
        end
    end
end

function _G.apply_attachment(CurWeapon, avatarid)
    local array = CurWeapon.synData
    for AttachIdx = 0, 4 do
        local isrefresh = false
        local Data = array:Get(AttachIdx)
        local itemid = slua.IndexReference(Data, "defineID").TypeSpecificID
        if itemid and itemid < 10000000 and itemid > 0 then
            if AttachIdx == 0 then
                Data.defineID.TypeSpecificID, isrefresh = _G.get_muzzleid(slua.IndexReference(Data, "defineID").TypeSpecificID, avatarid)
                array:Set(AttachIdx, Data)
            elseif AttachIdx == 1 then
                Data.defineID.TypeSpecificID, isrefresh = _G.get_forgripid(slua.IndexReference(Data, "defineID").TypeSpecificID, avatarid)
                array:Set(AttachIdx, Data)
            elseif AttachIdx == 2 then
                Data.defineID.TypeSpecificID, isrefresh = _G.get_magazinesid(slua.IndexReference(Data, "defineID").TypeSpecificID, avatarid)
                array:Set(AttachIdx, Data)
            elseif AttachIdx == 3 then
                Data.defineID.TypeSpecificID, isrefresh = _G.get_stockid(slua.IndexReference(Data, "defineID").TypeSpecificID, avatarid)
                array:Set(AttachIdx, Data)
            elseif AttachIdx == 4 then
                Data.defineID.TypeSpecificID, isrefresh = _G.get_scopeid(slua.IndexReference(Data, "defineID").TypeSpecificID, avatarid)
                array:Set(AttachIdx, Data)
            end
            if isrefresh then
                CurWeapon:DelayHandleAvatarMeshChanged()
            end
        end
    end
end

-- ============================================
-- KILL COUNTER FONKSİYONLARI
-- ============================================

function _G.GetKillCounterPath()
    local possiblePaths = {
        '/storage/emulated/0/Android/data/com.tencent.ig/files/NumberUpdate.txt',
        '/storage/emulated/0/Android/data/com.pubg.krmobile/files/NumberUpdate.txt',
        '/storage/emulated/0/Android/data/com.vng.pubgmobile/files/NumberUpdate.txt',
        '/storage/emulated/0/Android/data/com.rekoo.pubgm/files/NumberUpdate.txt'
    }
    
    for _, path in ipairs(possiblePaths) do
        local file = io.open(path, 'r')
        if file then
            file:close()
            return path
        end
    end
    
    for _, path in ipairs(possiblePaths) do
        local dir = path:match("(.*)/NumberUpdate.txt")
        local f = io.open(dir .. "/config.ini", 'r')
        if f then
            f:close()
            return path
        end
    end
    
    return '/storage/emulated/0/Android/data/com.tencent.ig/files/NumberUpdate.txt'
end

local function saveKillCountToFile()
    if not _G.ActiveKillCounterPath then _G.ActiveKillCounterPath = _G.GetKillCounterPath() end
    local path = _G.ActiveKillCounterPath
    
    local file = io.open(path, 'w+')
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
    if not _G.ActiveKillCounterPath then _G.ActiveKillCounterPath = _G.GetKillCounterPath() end
    local path = _G.ActiveKillCounterPath
    
    local file = io.open(path, 'r')
    if file then
        local content = file:read('*a')
        file:close()
        _G.lastFileContent = content
        
        if content ~= '' then
            content = content:gsub('\239\187\191', ''):gsub('^%s+', '')
            local tempTable = {}
            for weaponID, count in content:gmatch('%[(%d+)%]%s*=%s*(%d+)') do
                tempTable[tonumber(weaponID)] = tonumber(count)
            end
            if next(tempTable) then 
                _G.killCountInfo = tempTable 
            end
        end
    end
end

function _G.getKills(weaponID)
    return weaponID and _G.killCountInfo[weaponID] or 0
end

function _G.addKill(weaponID, count)
    if not weaponID or not count then return end
    _G.killCountInfo[weaponID] = (_G.killCountInfo[weaponID] or 0) + count
    pcall(saveKillCountToFile)

    local PlayerController = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if PlayerController then
        local uCharacter = PlayerController:GetPlayerCharacterSafety()
        if uCharacter then
            local currweapon = uCharacter:GetCurrentWeapon()
            if currweapon then
                local SkinID = slua.IndexReference(currweapon.synData:Get(7), "defineID").TypeSpecificID
                if _G.OurkillCountSystem then
                    _G.OurkillCountSystem:UpdateMainKillCounterUI(true, weaponID, SkinID)
                end
            end
        end
    end
end

function _G.ForceUpdateKillCounterUI()
    pcall(function()
        local PlayerController = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
        if not PlayerController or not slua.isValid(PlayerController) then return end
        
        local uCharacter = PlayerController:GetPlayerCharacterSafety()
        if not uCharacter or not slua.isValid(uCharacter) then return end
        
        local currweapon = uCharacter:GetCurrentWeapon()
        if not currweapon or not slua.isValid(currweapon) then return end
        
        local DefineID = currweapon:GetItemDefineID() and currweapon:GetItemDefineID().TypeSpecificID or 0
        if DefineID == 0 then return end
        
        local currentEquipAvatarID = slua.IndexReference(currweapon.synData:Get(7), "defineID").TypeSpecificID
        
        local UIManager = require("client.slua_ui_framework.manager")
        local MainKillCounter = UIManager.GetUI(UIManager.UI_Config_InGame.MainKillCounter)
        
        if MainKillCounter and slua.isValid(MainKillCounter) then
            local ModuleManager = require("client.module_framework.ModuleManager")
            local LogicKillCounter = ModuleManager.GetModule(ModuleManager.CommonModuleConfig.LogicKillCounter)
            
            local curEquipedKillCounter = LogicKillCounter:GetEquipedKillCounterId(6114302174, currentEquipAvatarID)
            if not curEquipedKillCounter or curEquipedKillCounter == 0 then
                curEquipedKillCounter = LogicKillCounter:GetBaseKillCounterIdByWeaponId(DefineID)
            end
            
            MainKillCounter:SetKillCounterItemShowWithNum(curEquipedKillCounter, _G.getKills(DefineID), currentEquipAvatarID)
            
            if MainKillCounter.KillCounterItem and MainKillCounter.KillCounterItem.SetVisibility then
                local ESlateVisibility = import("ESlateVisibility")
                MainKillCounter.KillCounterItem:SetVisibility(ESlateVisibility.Collapsed)
                MainKillCounter.KillCounterItem:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            end
        end
    end)
end

function _G.FileWatcher()
    if not _G.isFileWatcherActive then return end
    
    pcall(function()
        if not _G.ActiveKillCounterPath then _G.ActiveKillCounterPath = _G.GetKillCounterPath() end
        local path = _G.ActiveKillCounterPath
        
        local file = io.open(path, 'r')
        if not file then return end
        
        local currentContent = file:read('*a') or ""
        file:close()
        
        currentContent = currentContent:gsub('\239\187\191', ''):gsub('^%s+', ''):gsub('%s+$', '')
        
        if currentContent == "" or currentContent == _G.lastFileContent then return end
        
        _G.lastFileContent = currentContent
        
        local tempTable = {}
        for weaponID, count in currentContent:gmatch('%[(%d+)%]%s*=%s*(%d+)') do
            tempTable[tonumber(weaponID)] = tonumber(count)
        end
        
        if not next(tempTable) then return end
        
        _G.killCountInfo = tempTable
        _G.ForceUpdateKillCounterUI()
    end)
end

function _G.CheckAndRefreshKillUI()
    pcall(function()
        if not _G.UpdateMyKillCounter then return end
        _G.UpdateMyKillCounter = false
        
        local PlayerController = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
        if not PlayerController then return end
        
        local uCharacter = PlayerController:GetPlayerCharacterSafety()
        if not uCharacter then return end
        
        local currweapon = uCharacter:GetCurrentWeapon()
        if not currweapon then return end
        
        local DefineID = currweapon:GetItemDefineID().TypeSpecificID
        if DefineID == 0 then return end
        
        local realKills = _G.getKills(DefineID)
        local lastShown = _G.lastDisplayedKills[DefineID] or -1
        
        if realKills ~= lastShown then
            local UIManager = require("client.slua_ui_framework.manager")
            local MainKillCounter = UIManager.GetUI(UIManager.UI_Config_InGame.MainKillCounter)
            
            if MainKillCounter and slua.isValid(MainKillCounter) then
                local currentEquipAvatarID = slua.IndexReference(currweapon.synData:Get(7), "defineID").TypeSpecificID
                local ModuleManager = require("client.module_framework.ModuleManager")
                local LogicKillCounter = ModuleManager.GetModule(ModuleManager.CommonModuleConfig.LogicKillCounter)
                
                local curEquipedKillCounter = LogicKillCounter:GetEquipedKillCounterId(6114302174, currentEquipAvatarID)
                if not curEquipedKillCounter or curEquipedKillCounter == 0 then
                    curEquipedKillCounter = LogicKillCounter:GetBaseKillCounterIdByWeaponId(DefineID)
                end
                
                MainKillCounter:SetKillCounterItemShowWithNum(curEquipedKillCounter, realKills, currentEquipAvatarID)
                _G.lastDisplayedKills[DefineID] = realKills
            end
        end
    end)
end

function _G.RefreshKillCounterUIOptimized()
    pcall(_G.CheckAndRefreshKillUI)
end

function _G.GameAvatarHandlerkillcounter()
    pcall(_G.RefreshKillCounterUIOptimized)
end

-- ============================================
-- GAME HANDLER FONKSİYONLARI
-- ============================================

function _G.GameAvatarHandlerweapons()
    pcall(function()
        local PlayerController = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
        if not PlayerController then return end
        
        local uCharacter = PlayerController:GetPlayerCharacterSafety()
        if not uCharacter then return end
        
        local currweapon = uCharacter:GetCurrentWeapon()
        if currweapon then
            _G.apply_weapon_skin(currweapon)
            _G.apply_attachment(currweapon, _G.get_skin_id(currweapon:GetItemDefineID().TypeSpecificID))
        end
    end)
end

function _G.UpdateWeapon_BackPack_Appearance(PlayerController)
    pcall(function()
        local uCharacter = PlayerController:GetPlayerCharacterSafety()
        if not uCharacter then return end
        
        local BackpackComponent = uCharacter.BackpackComponent
        if not BackpackComponent then return end
        
        local WeaponList = BackpackComponent:GetWeaponList()
        if not WeaponList then return end
        
        for i = 0, WeaponList:Num() - 1 do
            local Weapon = WeaponList:Get(i)
            if Weapon and slua.isValid(Weapon) then
                _G.apply_weapon_skin(Weapon)
                _G.apply_attachment(Weapon, _G.get_skin_id(Weapon:GetItemDefineID().TypeSpecificID))
            end
        end
    end)
end

function _G.GameAvatarHandlerBagPack()
    local PlayerController = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if PlayerController then
        _G.UpdateWeapon_BackPack_Appearance(PlayerController)
    end
end

function _G.GameAvatarHandlerplayers()
    pcall(function()
        local PlayerController = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
        if not PlayerController then return end
        
        local uCharacter = PlayerController:GetPlayerCharacterSafety()
        if not uCharacter then return end
        
        local UGameplayStatics = import("GameplayStatics")
        if not UGameplayStatics then return end
        
        local uGameInstance = PlayerController:GetGameInstance()
        if not uGameInstance then return end
        
        local APlayerState = import("PlayerState")
        local PlayerStateArray = UGameplayStatics.GetAllActorsOfClass(uGameInstance, APlayerState, slua.Array(UEnums.EPropertyClass.Object, import("Actor")))
        
        if not PlayerStateArray then return end
        
        for _, PlayerState in pairs(PlayerStateArray) do
            if PlayerState and slua.isValid(PlayerState) then
                local Character = PlayerState:GetPlayerCharacterSafety()
                if Character and slua.isValid(Character) and Character ~= uCharacter then
                    local AvatarComponent = Character.AvatarComponent2
                    if AvatarComponent and slua.isValid(AvatarComponent) then
                        -- Diğer oyunculara skin uygulama (opsiyonel)
                    end
                end
            end
        end
    end)
end

function _G.GameAvatarHandlervehicles()
    pcall(function()
        local PlayerController = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
        if not PlayerController then return end
        
        local uCharacter = PlayerController:GetPlayerCharacterSafety()
        if not uCharacter then return end
        
        local CurrentVehicle = uCharacter.CurrentVehicle
        if CurrentVehicle and slua.isValid(CurrentVehicle) then
            local VehicleAvatar = CurrentVehicle.VehicleAvatar
            if VehicleAvatar and slua.isValid(VehicleAvatar) then
                VehicleAvatar.curSwitchEffectId = 7303001
                local DefaultAvatarID = tostring(VehicleAvatar:GetDefaultAvatarID())
                local CurrentAvatarID = CurrentVehicle:GetAvatarId()
                
                for gunId, skinIdTable in pairs(_G.VehskinIdMappings or {}) do
                    local gunIdStr = tostring(gunId)
                    if DefaultAvatarID:find(gunIdStr) then
                        local skinId = skinIdTable[1]
                        if CurrentAvatarID ~= skinId then
                            VehicleAvatar:ChangeItemAvatar(skinId, true)
                            _G.CurrentEquipVehicleID = skinId
                            break
                        end
                    end
                end
            end
        end
    end)
end

-- ============================================
-- DEADBOX SKIN FONKSİYONLARI
-- ============================================

function table.contains(tbl, element)
    for _, value in ipairs(tbl) do
        if value == element then return true end
    end
    return false
end

local function locationsClose(loc1, loc2, tolerance)
    local dx = loc1.X - loc2.X
    local dy = loc1.Y - loc2.Y
    local dz = loc1.Z - loc2.Z
    return dx * dx + dy * dy + dz * dz < tolerance * tolerance
end

function _G.GameAvatarHandlerDeadBox()
    pcall(function()
        local PlayerController = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
        if not PlayerController then return end
        
        local uCharacter = PlayerController:GetPlayerCharacterSafety()
        if not uCharacter then return end
        
        local UGameplayStatics = import("GameplayStatics")
        if not UGameplayStatics then return end
        
        local UIUtil = require("client.common.ui_util")
        if not UIUtil then return end
        
        local uGameInstance = UIUtil.GetGameInstance()
        if not uGameInstance then return end
        
        local APlayerTombBox = import("PlayerTombBox")
        local uActor = import("Actor")
        
        local uActorArray = UGameplayStatics.GetAllActorsOfClass(uGameInstance, APlayerTombBox, slua.Array(UEnums.EPropertyClass.Object, uActor))
        
        for _, actor in pairs(uActorArray) do
            if IsPtrValid(actor) then
                local DamageCauser = actor.DamageCauser
                if DamageCauser and DamageCauser.Playerkey == PlayerController.Playerkey then
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
                                found = true
                                break
                            end
                        end
                        
                        if not found then
                            local ApplySkinID = 0
                            local CurrentVehicle = uCharacter.CurrentVehicle
                            if CurrentVehicle then
                                local carSkinID = _G.CurrentEquipVehicleID or 0
                                if carSkinID ~= 0 then 
                                    ApplySkinID = tostring(carSkinID) .. "1"
                                end
                            else
                                local currweapon = uCharacter:GetCurrentWeapon()
                                if currweapon and slua.isValid(currweapon) and currweapon.synData then
                                    local defineIDRef = slua.IndexReference(currweapon.synData:Get(7), "defineID")
                                    if defineIDRef then
                                        ApplySkinID = defineIDRef.TypeSpecificID
                                    end
                                end
                            end
                            
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
    end)
end

-- ============================================
-- BACKPACK HOOK
-- ============================================

pcall(function()
    local BackpackComponent = require("GameLua.Mod.BaseMod.Client.Backpack.BackpackComponent")
    if BackpackComponent then
        local O_OnRep_ItemListNet = BackpackComponent.__inner_impl.OnRep_ItemListNet
        BackpackComponent.__inner_impl.OnRep_ItemListNet = function(self)
            if O_OnRep_ItemListNet then O_OnRep_ItemListNet(self) end
            pcall(function()
                local PlayerController = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
                if PlayerController then
                    _G.UpdateWeapon_BackPack_Appearance(PlayerController)
                end
            end)
        end
        print('[BackpackHook] OnRep_ItemListNet hooked!')
    end
end)

-- ============================================
-- KILL INFO HOOK
-- ============================================

local SKillInfo = require("GameLua.Mod.BaseMod.Client.KillInfoTips.KillInfo")
local ECharacterHealthStatus = import("ECharacterHealthStatus")
local SKillInfoModuleManager = require("client.module_framework.ModuleManager")
local O_FileItem = SKillInfo.__inner_impl.FileItem

SKillInfo.__inner_impl.FileItem = function(self, DamageRecordData)
    if not self or not DamageRecordData then 
        return O_FileItem(self, DamageRecordData) 
    end

    local LogicKillCounter = SKillInfoModuleManager.GetModule(SKillInfoModuleManager.CommonModuleConfig.LogicKillCounter)
    if not LogicKillCounter then 
        return O_FileItem(self, DamageRecordData) 
    end

    local uCharacter = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController() and
                       slua_GameFrontendHUD:GetPlayerController():GetPlayerCharacterSafety()
    if not uCharacter or not slua.isValid(uCharacter) then 
        return O_FileItem(self, DamageRecordData) 
    end

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
                    _G.UpdateMyKillCounter = true
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

    return O_FileItem(self, DamageRecordData)
end

-- ============================================
-- MAIN KILL COUNTER UI HOOKLARI
-- ============================================

local MyMainKillCounter = require("GameLua.Mod.BaseMod.Client.KillCounter.MainKillCounter")
local MyKillCountSubSystem = require("GameLua.Mod.BaseMod.Client.KillCounter.KillCounterUISubsystem")
local MyMainWeaponInfoItemUI = require("GameLua.Mod.BaseMod.Client.Backpack.MainWeaponInfoItemUI")
local MyMainWeaponKillCounter = require("GameLua.Mod.BaseMod.Client.KillCounter.MainWeaponKillCounter")
local SubsystemMgr = require("GameLua.GameCore.Module.Subsystem.SubsystemMgr")
local SlotBase = require("GameLua.Mod.BaseMod.Client.MainControlUI.SwitchWeaponSlotMode2")

_G.WeaponEvents = _G.WeaponEvents or { onWeaponChanged = function() end }
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
            local currentEquipAvatarID = slua.IndexReference(currweapon.synData:Get(7), "defineID").TypeSpecificID
            local curEquipedKillCounter = LogicKillCounter:GetEquipedKillCounterId(6114302174, currentEquipAvatarID)
            
            self.KillCounterItem:SetKillCounterItemShowWithNum(curEquipedKillCounter, _G.getKills(DefineID), currentEquipAvatarID)
        end
    end)
end

MyKillCountSubSystem.__inner_impl.CheckSupportKCUI = function(self) return true end

o_CheckNeedMainKillCounterUI = MyKillCountSubSystem.__inner_impl.CheckNeedMainKillCounterUI
MyKillCountSubSystem.__inner_impl.CheckNeedMainKillCounterUI = function(self, Weapon, PlayerID)
    pcall(function()
        local uCharacter = slua_GameFrontendHUD:GetPlayerController():GetPlayerCharacterSafety()
        if not uCharacter then return end
        
        local currweapon = uCharacter:GetCurrentWeapon()
        if currweapon then
            local DefineID = currweapon:GetItemDefineID().TypeSpecificID
            _G.WeaponEvents.onWeaponChanged(DefineID)
            self:UpdateMainKillCounterUI(true, DefineID, slua.IndexReference(currweapon.synData:Get(7), "defineID").TypeSpecificID)
        end
    end)
end

o_UpdateMainKillCounterUI = MyKillCountSubSystem.__inner_impl.UpdateMainKillCounterUI
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
            local currentEquipAvatarID = slua.IndexReference(currweapon.synData:Get(7), "defineID").TypeSpecificID
            
            local ModuleManager = require("client.module_framework.ModuleManager")
            local LogicKillCounter = ModuleManager.GetModule(ModuleManager.CommonModuleConfig.LogicKillCounter)
            local SupportKillCounter = LogicKillCounter:GetBaseKillCounterIdByWeaponId(DefineID)
            
            if SupportKillCounter == nil and MainKillCounter then
                UIManager.CloseUI(UIManager.UI_Config_InGame.MainKillCounter)
            elseif DefineID == currentEquipAvatarID and MainKillCounter then
                UIManager.CloseUI(UIManager.UI_Config_InGame.MainKillCounter)
            else
                local curEquipedKillCounter = LogicKillCounter:GetEquipedKillCounterId(6114302174, currentEquipAvatarID)
                
                if not MainKillCounter then
                    UIManager.ShowUI(UIManager.UI_Config_InGame.MainKillCounter, DefineID, currentEquipAvatarID)
                    MainKillCounter = UIManager.GetUI(UIManager.UI_Config_InGame.MainKillCounter)
                    if MainKillCounter then
                        MainKillCounter:SetKillCounterItemShowWithNum(curEquipedKillCounter, _G.getKills(DefineID), currentEquipAvatarID)
                    end
                else
                    MainKillCounter:UpdateWeaponID(DefineID, currentEquipAvatarID)
                    MainKillCounter:SetKillCounterItemShowWithNum(curEquipedKillCounter, _G.getKills(DefineID), currentEquipAvatarID)
                end
            end
        end
    end)
end

o_DOnRefresh = MyMainWeaponKillCounter.__inner_impl.OnRefresh
MyMainWeaponKillCounter.__inner_impl.OnRefresh = function(self, SelfUID)
    pcall(function()
        local ModuleManager = require("client.module_framework.ModuleManager")
        local LogicKillCounter = ModuleManager.GetModule(ModuleManager.CommonModuleConfig.LogicKillCounter)
        local curEquipedKillCounter = LogicKillCounter:GetMyEquipedKillCounterId(_G.get_skin_id2(self.WeaponID))
        
        self.KillCounterItem:SetKillCounterItemShowWithNum(curEquipedKillCounter, _G.getKills(self.WeaponID), _G.get_skin_id2(self.WeaponID))
    end)
end

o_DUpdateWeaponAppearanceInfo = MyMainWeaponInfoItemUI.__inner_impl.UpdateWeaponAppearanceInfo
MyMainWeaponInfoItemUI.__inner_impl.UpdateWeaponAppearanceInfo = function(self, TypeSpecificID, BattleData, DragOrigin)
    pcall(function()
        o_DUpdateWeaponAppearanceInfo(self, TypeSpecificID, BattleData, DragOrigin)
        self:UpdateKillCounter(true)
    end)
end

o_DUpdateKillCounter = MyMainWeaponInfoItemUI.__inner_impl.UpdateKillCounter
MyMainWeaponInfoItemUI.__inner_impl.UpdateKillCounter = function(self, bShow)
    pcall(function()
        local KillCounterUISubsystem = SubsystemMgr:Get("KillCounterUISubsystem")
        if not KillCounterUISubsystem then bShow = false end
        
        if bShow then
            local ModuleManager = require("client.module_framework.ModuleManager")
            local LogicKillCounter = ModuleManager.GetModule(ModuleManager.CommonModuleConfig.LogicKillCounter)
            local curEquipedKillCounter = LogicKillCounter:GetBaseKillCounterIdByWeaponId(self.ItemID)
            
            if self.ItemID == self.WeaponIDOrAvatarID then
                self.UIRoot.CanvasPanel_KillCounter:SetVisibility(UEnums.GSlateVisibility.Collapsed)
                return
            end
            
            if not curEquipedKillCounter then
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
        local SupportKillCounter = LogicKillCounter:GetBaseKillCounterIdByWeaponId(WeaponID)
        if SupportKillCounter then
            self.KillCounterImg:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        end
    end)
end

_G.WeaponEvents.onWeaponChanged = function(weaponId)
    pcall(function()
        local PlayerController = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
        if not PlayerController or not slua.isValid(PlayerController) then return end
        
        local uCharacter = PlayerController:GetPlayerCharacterSafety()
        if not uCharacter or not slua.isValid(uCharacter) or not _G.OurkillCountSystem then return end
        
        local currweapon = uCharacter:GetCurrentWeapon()
        if not currweapon then return end
        
        local DefineID = currweapon:GetItemDefineID().TypeSpecificID
        local SkinID = slua.IndexReference(currweapon.synData:Get(7), "defineID").TypeSpecificID
        _G.OurkillCountSystem:UpdateMainKillCounterUI(true, DefineID, SkinID)
    end)
end

-- ============================================
-- ITEM UPGRADE SYSTEM INIT
-- ============================================

pcall(function()
    local ModuleManager = require("client.module_framework.ModuleManager")
    local ItemUpgradeSystem = ModuleManager.GetModule(ModuleManager.CommonModuleConfig.ItemUpgradeSystem)
    if ItemUpgradeSystem then
        ItemUpgradeSystem:DefineAndResetData()
        ItemUpgradeSystem:OnInitialize()
    end
end)

-- ============================================
-- BAŞLANGIÇ YÜKLEMELERİ
-- ============================================

_G.loadKillCountFromFile()
_G.isFileWatcherActive = true
_G.ReadConfigFile()

-- ============================================
-- TIMER LOOPS
-- ============================================

if _G.Mytimer_ticker then
    pcall(function()
        _G.Mytimer_ticker.AddTimerLoop(0.8, _G.GameAvatarHandlerweapons, -1, 1)
        _G.Mytimer_ticker.AddTimerLoop(0.4, _G.GameAvatarHandlerBagPack, -1, 1)
        _G.Mytimer_ticker.AddTimerLoop(0.05, _G.GameAvatarHandlerkillcounter, -1, 1)
        _G.Mytimer_ticker.AddTimerLoop(0, _G.FileWatcher, -1, 0.05)
        _G.Mytimer_ticker.AddTimerLoop(0, _G.GameAvatarHandlerDeadBox, -1, 0.6)
        _G.Mytimer_ticker.AddTimerLoop(0, _G.GameAvatarHandlerplayers, -1, 0.4)
        _G.Mytimer_ticker.AddTimerLoop(0, _G.GameAvatarHandlervehicles, -1, 0.4)
        print('[Combined System] Weapon Skin + Attachment + KillCounter + Vehicle + DeadBox Ready!')
    end)
end

print('[Combined System] Full System Loaded Successfully!')