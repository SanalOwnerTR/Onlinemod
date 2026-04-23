--[[
    YARGI ENGINE ULTIMATE - FULL SKIN SYSTEM
    Merged & optimized version.
]]

_G.YargiEngine = _G.YargiEngine or {}
_G.YargiEngine.Loaded = false

-- ====================== DATA PATH DETECTION ======================
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
local KILL_COUNTER_PATH        -- will be set in kill‑counter section

-- ====================== GLOBAL VARIABLES ======================
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
    [101]={1105001001,1105001002,1105001003,1105001004},
    [102]={1105002001,1105002002,1105002003,1105002004},
    [103]={1105003001,1105003002,1105003003},
    [104]={1105004001,1105004002},
    [108]={1105008001,1105008002,1105008003},
    [109]={1105009001,1105009002},
    [111]={1105011001,1105011002},
    [112]={1961007,1961010,1961012,1961013,1961014,1961015,1961016,1961017,1961018,1961020,1961021,1961024,1961025,1961029,1961030,1961031,1961041,1961042,1961044,1961048,1961050,1961051},
    [113]={1903075,1903071,1903072,1903073,1903074,1903076,1903200,1903201}
}

_G.OutfitSkins = {
    Suit = {403003,1406469,1405870,1407140,1407141,1407142,1407550,1406638,1406872,1406971,1407103,1407512,1407391,1407366,1407330,1407329,1407286,1407285,1407277,1407276,1407275,1407225,1407224,1407259,1407161,1407160,1407107,1407106,1407079,1407048,1406977,1406976,1406898,1400569,1404000,1404049,1400119,1400117,1406060,1406891,1400687,1405160,1405145,1405436,1405435,1405434,1405064,1405207,1406895,1400333,1400377,1405092,1405121,1406889,1407278,1407279,1407381,1407380,1407385,1406389,1406388,1406387,1406386,1406385,1406140,1400782,1407392,1407318,1407317,1407404,1407402,1407401,1407387,1404434,1404437,1404440,1404448,1400324,1400708,1404043,1404048,1405953,1400101,1404153,1407440,1407441},
    Bag = {501001,1501001174,1501001220,1501001051,1501001443,1501001265,1501001321,1501001277,1501001550,1501001592,1501001608,1501001024,1501001019,1501001195,1501001179,1501001194,1501001346,1501001097,1501001081,1501001093,1501001022,1501001639,1501001640,1501001625},
    Helmet = {502001,1502001014,1502001349,1502001012,1502001009,1502001397,1502001390,1502001381,1502001358,1502001350,1502001342,1502001336,1502001333,1502001327,1502001325,1502001299,1502001295,1502001222,1502001069,1502001054,1502001033,1502001016,1502001031,1502001023,1502001018,1502001408,1502001410},
    Parachut = {703001,1401619,1401625,1401624,1401836,1401833,1401287,1401282,1401385,1401549,1401336,1401335,1401629,1401628},
    Pet = {
        50000,
        50001,50002,50003,50004,50005,50006,50007,50008,50009,50010,
        50011,50012,50013,50014,50015,50016,50017,50018,50019,50020,
        50021,50022,50023,50024,50025,50026,50027,50028,50029,50030,
        50031,50032,50033,50034,50035,50036,50037,50038,50039,50040,
        50041,50042,50043,50044
    }
}

_G.SuitSkinsMap = _G.OutfitSkins.Suit
_G.BagSkinsMap = _G.OutfitSkins.Bag
_G.HelmetSkinsMap = _G.OutfitSkins.Helmet
_G.ParachutSkinsMap = _G.OutfitSkins.Parachut
_G.PetSkinsMap = _G.OutfitSkins.Pet

_G.CustSlotType = {
    NONE = 0,
    HeadEquipemtSlot = 1,
    HairEquipemtSlot = 2,
    HatEquipemtSlot = 3,
    FaceEquipemtSlot = 4,
    ClothesEquipemtSlot = 5,
    PantsEquipemtSlot = 6,
    ShoesEquipemtSlot = 7,
    BackpackEquipemtSlot = 8,
    HelmetEquipemtSlot = 9,
    ArmorEquipemtSlot = 10,
    ParachuteEquipemtSlot = 11,
    GlassEquipemtSlot = 12,
    NightVisionEquipemtSlot = 13,
    BeardEquipemtSlot = 14,
    GlideEquipemtSlot = 15,
    HandEffectEquipemtSlot = 16,
    BackPack_PendantSlot = 17,
    MechaChestSlot = 18,
    MechaArmSlot = 19,
    MechaLegSlot = 20,
    MechaInnerSuitSlot = 21,
    FootEffectEquipemtSlot = 22,
    MaxSlotNum = 23,
    VehicleCut = 24,
    UnderClothSlot = 25,
    UnderPantsSlot = 26,
    SimpleSlotMax = 27,
    MAX = 28
}

_G.WeaponSkinIndex = _G.WeaponSkinIndex or {}
_G.VehicleSkinIndex = _G.VehicleSkinIndex or {}
_G.skinIdCache = _G.skinIdCache or {}
_G.skinIdCache2 = _G.skinIdCache2 or {}
_G.killCountInfo = _G.killCountInfo or {}
_G.DeadBoxSkins = _G.DeadBoxSkins or {}
_G.AlreadyChangedSet = _G.AlreadyChangedSet or {}
_G.g_parts = _G.g_parts or {}
_G.lastAppliedSkin = _G.lastAppliedSkin or {}
_G.lastAppliedAttachments = _G.lastAppliedAttachments or {}
_G.lastDisplayedKills = _G.lastDisplayedKills or {}
_G.CurrentEquipVehicleID = 0
_G.lastFileContent = ""
_G.isFileWatcherActive = true
_G.WelcomeShown = _G.WelcomeShown or false
_G.UpdateMyKillCounter = false
_G.LastBackApplyValue = 0
_G.LastHelmetApplyValue = 0
_G.LastAppliedPet = 0
_G.LastAppliedThemeID = nil
_G.TargetLobbyThemeID = 202408001

_G.SuitSkin = 0
_G.HatSkin = 0
_G.FaceSkin = 0
_G.MaskSkin = 0
_G.GlovesSkin = 0
_G.PantSkin = 0
_G.ShoeSkin = 0
_G.BagSkin = 501001
_G.BagSkin1 = 1501001220
_G.BagSkin2 = 1501002220
_G.BagSkin3 = 1501003220
_G.HelmetSkin = 502001
_G.HelmetSkin1 = 1502001023
_G.HelmetSkin2 = 1502002023
_G.HelmetSkin3 = 1502003023
_G.ParachuteSkin = 0
_G.GliderSkin = 0
_G.Emote1Skin = 0
_G.Emote2Skin = 0
_G.Emote3Skin = 0
_G.HAESkin = 0
_G.MolotovSkin = 0
_G.SmokeSkin = 0
_G.PetSkin = 0

-- ====================== UTILITY FUNCTIONS ======================
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

-- ====================== ATTACHMENT SYSTEM TABLES ======================
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
        [202001] = "Angled Foregrip", [202006] = "Thumb Grip",
        [202002] = "Vertical Foregrip", [202004] = "Light Grip",
        [202005] = "Half Grip", [202051] = "Ergonomic Grip",
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
        [203001] = "Red Dot Sight", [203002] = "Holographic Sight",
        [203003] = "2x Scope", [203014] = "3x Scope",
        [203004] = "4x Scope", [203015] = "6x Scope",
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
        [205001] = "Stock", [205002] = "Tactical Stock",
        [204014] = "Bullet Loop", [205003] = "Cheek Pad"
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

-- ====================== WEAPON SKIN HELPERS ======================
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
-- alias for compatibility
_G.get_skin_id2 = _G.get_skin_id

-- ====================== KILL COUNTER SYSTEM ======================
function _G.GetKillCounterPath()
    local possiblePaths = {
        '/storage/emulated/0/Android/data/com.tencent.ig/files/NumberUpdate.txt',
        '/storage/emulated/0/Android/data/com.pubg.krmobile/files/NumberUpdate.txt',
        '/storage/emulated/0/Android/data/com.vng.pubgmobile/files/NumberUpdate.txt',
        '/storage/emulated/0/Android/data/com.rekoo.pubgm/files/NumberUpdate.txt'
    }
    for _, path in ipairs(possiblePaths) do
        local file = io.open(path, 'r')
        if file then file:close(); return path end
    end
    for _, path in ipairs(possiblePaths) do
        local dir = path:match("(.*)/NumberUpdate.txt")
        local f = io.open(dir .. "/config.ini", 'r')
        if f then f:close(); return path end
    end
    return '/storage/emulated/0/Android/data/com.tencent.ig/files/NumberUpdate.txt'
end
KILL_COUNTER_PATH = _G.GetKillCounterPath()
_G.ActiveKillCounterPath = KILL_COUNTER_PATH

function _G.getKills(weaponID)
    return weaponID and _G.killCountInfo[weaponID] or 0
end

local function saveKillCountToFile()
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
            if next(tempTable) then _G.killCountInfo = tempTable end
        end
    end
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

function _G.FileWatcher()
    if not _G.isFileWatcherActive then return end
    pcall(function()
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
        if next(tempTable) then _G.killCountInfo = tempTable end
        _G.ForceUpdateKillCounterUI()
    end)
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
        end
    end)
end

-- ====================== AVATAR HANDLERS ======================
function _G.equip_character_avatar(uCharacter)
    if not uCharacter or not slua.isValid(uCharacter) or not uCharacter.AvatarComponent2 then return end
    local BackpackUtils = import("BackpackUtils")
    if not BackpackUtils then return end
    local ApplyData = uCharacter.AvatarComponent2.NetAvatarData and uCharacter.AvatarComponent2.NetAvatarData.SlotSyncData
    if not ApplyData or not slua.isValid(ApplyData) then return end

    local function setMakeSkin(idx, itemId, slot)
        if itemId and itemId ~= 0 then
            local equipment = ApplyData:Get(idx)
            if equipment and equipment.SlotID == slot and equipment.ItemId ~= itemId then
                if not _G.skinIdCache[itemId] then _G.download_item(itemId); _G.skinIdCache[itemId] = true end
                equipment.ItemId = itemId
                ApplyData:Set(idx, equipment)
                uCharacter.AvatarComponent2:OnRep_BodySlotStateChanged()
            end
        end
    end

    local function setMakeBagSkin(idx, itemId, slot)
        local equipment = ApplyData:Get(idx)
        if equipment and itemId ~= 0 and equipment.SlotID == slot then
            local nItemLevel = BackpackUtils.GetEquipmentBagLevel(equipment.AdditionalItemID) or 1
            local bagSkin = _G.BagSkin
            if nItemLevel == 1 and _G.BagSkin1 ~= 0 then bagSkin = _G.BagSkin1
            elseif nItemLevel == 2 and _G.BagSkin2 ~= 0 then bagSkin = _G.BagSkin2
            elseif nItemLevel == 3 and _G.BagSkin3 ~= 0 then bagSkin = _G.BagSkin3 end
            local applyVal = bagSkin + (nItemLevel - 1) * 1000
            if bagSkin ~= 501001 and equipment.ItemId ~= applyVal then
                if not _G.skinIdCache[applyVal] then _G.download_item(applyVal); _G.skinIdCache[applyVal] = true end
                equipment.ItemId = applyVal
                ApplyData:Set(idx, equipment)
                uCharacter.AvatarComponent2:OnRep_BodySlotStateChanged()
            end
        end
    end

    local function setMakeHelmetSkin(idx, itemId, slot)
        local equipment = ApplyData:Get(idx)
        if equipment and itemId ~= 0 and equipment.SlotID == slot then
            local nItemLevel = BackpackUtils.GetEquipmentHelmetLevel(equipment.AdditionalItemID) or 1
            local helSkin = _G.HelmetSkin
            if nItemLevel == 1 and _G.HelmetSkin1 ~= 0 then helSkin = _G.HelmetSkin1
            elseif nItemLevel == 2 and _G.HelmetSkin2 ~= 0 then helSkin = _G.HelmetSkin2
            elseif nItemLevel == 3 and _G.HelmetSkin3 ~= 0 then helSkin = _G.HelmetSkin3 end
            local applyVal = helSkin + (nItemLevel - 1) * 1000
            if helSkin ~= 502001 and equipment.ItemId ~= applyVal then
                if not _G.skinIdCache[applyVal] then _G.download_item(applyVal); _G.skinIdCache[applyVal] = true end
                equipment.ItemId = applyVal
                ApplyData:Set(idx, equipment)
                uCharacter.AvatarComponent2:OnRep_BodySlotStateChanged()
            end
        end
    end

    for i = 0, ApplyData:Num() - 1 do
        setMakeSkin(i, _G.SuitSkin, _G.CustSlotType.ClothesEquipemtSlot)
        setMakeSkin(i, _G.PantSkin, _G.CustSlotType.PantsEquipemtSlot)
        setMakeSkin(i, _G.ShoeSkin, _G.CustSlotType.ShoesEquipemtSlot)
        setMakeSkin(i, _G.HatSkin, _G.CustSlotType.HatEquipemtSlot)
        setMakeSkin(i, _G.FaceSkin, _G.CustSlotType.HeadEquipemtSlot)
        setMakeSkin(i, _G.MaskSkin, _G.CustSlotType.FaceEquipemtSlot)
        setMakeSkin(i, _G.GlovesSkin, _G.CustSlotType.UnderClothSlot)
        setMakeSkin(i, _G.GliderSkin, _G.CustSlotType.GlideEquipemtSlot)
        setMakeSkin(i, _G.ParachuteSkin, _G.CustSlotType.ParachuteEquipemtSlot)
        setMakeBagSkin(i, _G.BagSkin, _G.CustSlotType.BackpackEquipemtSlot)
        setMakeHelmetSkin(i, _G.HelmetSkin, _G.CustSlotType.HelmetEquipemtSlot)
    end
end

function _G.HandlePetLogic()
    pcall(function()
        if not _G.PetSkin or _G.PetSkin == 0 or _G.PetSkin == 50000 then return end
        if _G.PetSkin == _G.LastAppliedPet then return end
        if not _G.skinIdCache[_G.PetSkin] then _G.download_item(_G.PetSkin); _G.skinIdCache[_G.PetSkin] = true end
        local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
        if pc and slua.isValid(pc) then
            if pc.InitialPetInfo then pc.InitialPetInfo.PetId = _G.PetSkin end
            if pc.PetComponent and slua.isValid(pc.PetComponent) and pc.PetComponent.SetPetID then
                pc.PetComponent:SetPetID(_G.PetSkin)
            end
        end
        _G.LastAppliedPet = _G.PetSkin
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

function _G.GameAvatarHandlerplayers()
    local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if not pc then return end
    if pc.HiggsBoson then
        pc.HiggsBoson.bMHActive = false
        pc.HiggsBoson.bCallPreReplication = false
    end
    local uChar = pc:GetPlayerCharacterSafety()
    if uChar and slua.isValid(uChar) then _G.equip_character_avatar(uChar) end
    _G.HandlePetLogic()
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
    local PlayerController = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if _G.IsPtrValid(PlayerController) then _G.UpdateWeapon_BackPack_Appearance(PlayerController) end
end

function _G.GameAvatarHandlerDeadBox()
    local PlayerController = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if _G.IsPtrValid(PlayerController) then _G.DeadBox_TemperRequest(PlayerController) end
end

function _G.GameAvatarHandlervehicles()
    local PlayerController = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if _G.IsPtrValid(PlayerController) then
        local uChar = PlayerController:GetPlayerCharacterSafety()
        if _G.IsPtrValid(uChar) then _G.Game_Vehicle_Avatar_Change(uChar) end
    end
end

-- ====================== LOBBY THEME SYSTEM ======================
function _G.ReadLobbyThemeConfig()
    local possiblePaths = {
        '/storage/emulated/0/Android/data/com.tencent.ig/files/config.ini',
        '/storage/emulated/0/Android/data/com.pubg.krmobile/files/config.ini',
        '/storage/emulated/0/Android/data/com.vng.pubgmobile/files/config.ini',
        '/storage/emulated/0/Android/data/com.rekoo.pubgm/files/config.ini'
    }
    local file = nil
    for _, p in ipairs(possiblePaths) do
        file = io.open(p, 'r')
        if file then break end
    end
    if not file then return end
    local content = file:read('*all')
    file:close()
    for line in content:gmatch('[^\r\n]+') do
        local key, value = line:match('([%w_]+)%s*=%s*(%d+)')
        if key == 'LobbyTheme' then
            local newID = tonumber(value)
            if newID and newID ~= _G.TargetLobbyThemeID then
                _G.TargetLobbyThemeID = newID
            end
        end
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
            _G.LastAppliedThemeID = themeID
            local ThemeVehicleManager = ModuleManager.GetModule(ModuleManager.LobbyModuleConfig.ThemeVehicleManager)
            if ThemeVehicleManager then
                ThemeVehicleManager:ShowThemeVehicle()
            end
        end
    end)
end

function _G.CheckLobbyThemeChanges()
    local oldID = _G.TargetLobbyThemeID
    _G.ReadLobbyThemeConfig()
    if _G.TargetLobbyThemeID ~= oldID then _G.ApplyLobbyTheme() end
end

-- ====================== MAIN CONFIG FILE READER ======================
local lastConfig = {}
function _G.ReadConfigFile()
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
        if file then file:close(); configPath = path; break end
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

    -- Outfits
    if newConfig['Suit'] and newConfig['Suit'] ~= lastConfig['Suit'] then
        local idx = newConfig['Suit'] + 1
        _G.SuitSkin = _G.SuitSkinsMap and _G.SuitSkinsMap[idx] or 0
        lastConfig['Suit'] = newConfig['Suit']
    end
    if newConfig['Bag'] and newConfig['Bag'] ~= lastConfig['Bag'] then
        local idx = newConfig['Bag'] + 1
        _G.BagSkin = _G.BagSkinsMap and _G.BagSkinsMap[idx] or 0
        lastConfig['Bag'] = newConfig['Bag']
    end
    if newConfig['Helmet'] and newConfig['Helmet'] ~= lastConfig['Helmet'] then
        local idx = newConfig['Helmet'] + 1
        _G.HelmetSkin = _G.HelmetSkinsMap and _G.HelmetSkinsMap[idx] or 0
        lastConfig['Helmet'] = newConfig['Helmet']
    end
    if newConfig['Parachute'] and newConfig['Parachute'] ~= lastConfig['Parachute'] then
        local idx = newConfig['Parachute'] + 1
        _G.ParachuteSkin = _G.ParachutSkinsMap and _G.ParachutSkinsMap[idx] or 0
        lastConfig['Parachute'] = newConfig['Parachute']
    end
    if newConfig['Pet'] and newConfig['Pet'] ~= lastConfig['Pet'] then
        local idx = newConfig['Pet'] + 1
        _G.PetSkin = _G.PetSkinsMap and _G.PetSkinsMap[idx] or 0
        lastConfig['Pet'] = newConfig['Pet']
    end

    -- Weapons
    local function UpdateWep(key, id)
        if newConfig[key] and newConfig[key] ~= lastConfig[key] then
            _G.WeaponSkinIndex[id] = newConfig[key] + 1
            lastConfig[key] = newConfig[key]
        end
    end
    UpdateWep('M416', 101004); UpdateWep('AKM', 101001); UpdateWep('SCAR', 101003); UpdateWep('M16A4', 101002)
    UpdateWep('GROZA', 101005); UpdateWep('AUG', 101006); UpdateWep('QBZ', 101007); UpdateWep('M762', 101008)
    UpdateWep('HONEY', 101009); UpdateWep('ACE32', 101011); UpdateWep('UZI', 102001)
    UpdateWep('UMP', 102002); UpdateWep('Vector', 102003); UpdateWep('Thompson', 102004)
    UpdateWep('Kar98', 103001); UpdateWep('M24', 103002); UpdateWep('AWM', 103003)
    UpdateWep('Mini14', 103006); UpdateWep('MK14', 103007); UpdateWep('AMR', 103012)
    UpdateWep('M249', 105002); UpdateWep('DP28', 105001); UpdateWep('MG3', 105010)
    UpdateWep('DBS', 104004); UpdateWep('S12K', 104003); UpdateWep('S686', 104002)
    UpdateWep('Pan', 106001)

    -- Vehicles
    local vehMap = {
        Vehicle_UAZ=101, Vehicle_Buggy=102, Vehicle_Bike=103,
        Vehicle_Boat=104, Vehicle_Pickup=108, Vehicle_Mirado=109,
        Vehicle_Coupe=112, Vehicle_Dacia=113
    }
    for key, id in pairs(vehMap) do
        if newConfig[key] and newConfig[key] ~= lastConfig[key] then
            _G.VehicleSkinIndex[id] = newConfig[key] + 1
            lastConfig[key] = newConfig[key]
        end
    end

    -- Misc direct skins
    local directMap = {
        Suit = 'SuitSkin', Hat = 'HatSkin', Face = 'FaceSkin', Mask = 'MaskSkin',
        Gloves = 'GlovesSkin', Pant = 'PantSkin', Shoe = 'ShoeSkin',
        Parachute = 'ParachuteSkin', Glider = 'GliderSkin',
        Emote1 = 'Emote1Skin', Emote2 = 'Emote2Skin', Emote3 = 'Emote3Skin',
        HAE = 'HAESkin', Molotov = 'MolotovSkin', Smoke = 'SmokeSkin',
        LobbyTheme = 'TargetLobbyThemeID'
    }
    for key, var in pairs(directMap) do
        if newConfig[key] then
            if key == 'LobbyTheme' then
                _G[var] = newConfig[key]
                _G.LastAppliedThemeID = nil
            else
                _G[var] = newConfig[key]
            end
        end
    end
end

-- ====================== INTEGRATED HANDLERS ======================
_G.Lobby_Avatar_Handler = function()
    pcall(_G.ReadConfigFile)
    pcall(_G.CheckLobbyThemeChanges)
    pcall(_G.GameAvatarHandlerplayers)
    pcall(_G.HandlePetLogic)
end

_G.Game_Avatar_Handler = function()
    pcall(_G.GameAvatarHandlerplayers)
end

-- ====================== ANTI-REPORT / BYPASS SYSTEMS ======================
_G.InitializeAntiReport = function()
    pcall(function()
        local ClientReport = require("GameLua.Mod.BaseMod.Client.Security.ClientReportPlayerSubsystem")
        if ClientReport then
            ClientReport.OnInit = function() end
            ClientReport._OnPlayerKilledOtherPlayer = function() end
            ClientReport._RecordFatalDamager = function() end
            ClientReport._OnDeathReplayDataWhenFatalDamaged = function() end
            ClientReport._RecordMurdererFromDeathReplayData = function() end
            ClientReport._RecordTeammatePlayerInfo = function() end
            ClientReport._OnBattleResult = function() end
            ClientReport._OnShowQuickReportMutualExclusiveUI = function() end
            ClientReport.GetFatalDamagerMap = function() return {} end
            ClientReport.GetCachedTeammateName2InfoMap = function() return {} end
            ClientReport.GetTeammateName2InfoMapDuringBattle = function() return {} end
            ClientReport.GetCurrentNotInTeamHistoricalTeammateMap = function() return {} end
            ClientReport.GetInTeamIndexFromHistoricalTeammateInfo = function() return -1 end
        end
        local DSReport = require("GameLua.Mod.BaseMod.DS.Security.DSReportPlayerSubsystem")
        if DSReport then
            DSReport.OnInit = function() end
            DSReport._OnNearDeathOrRescued = function() end
            DSReport._OnCharacterDied = function() end
            DSReport._OnTeammateDamage = function() end
            DSReport._OnPlayerSettlementStart = function() end
            DSReport._AddKnockDownerToBattleResult = function() end
            DSReport._AddKillerToBattleResult = function() end
            DSReport._AddTeammateMurderToBattleResult = function() end
            DSReport._AddFatalDamagerMapToBattleResult = function() end
            DSReport._AddMLKillerUIDToBattleResult = function() end
            DSReport._SaveHistoricalTeammateInfo = function() end
            DSReport._RecordFatalDamager = function() end
            DSReport._RecordTeammateMurderer = function() end
        end
        local HiggsBoson = require("GameLua.Mod.BaseMod.Common.Security.HiggsBosonComponent")
        if HiggsBoson then HiggsBoson.StaticShowSecurityAlertInDev = function() end end
    end)
end

_G.InitializeGameplayBypass = function()
    if _G.GameplayBypassInitialized then return end
    pcall(function()
        if not _G.GameplayCallbacks then return end
        local GC = _G.GameplayCallbacks
        GC.ReportAttackFlow = function() end
        GC.ReportSecAttackFlow = function() end
        GC.ReportHurtFlow = function() end
        GC.ReportFireArms = function() end
        GC.ReportVerifyInfoFlow = function() end
        GC.ReportMrpcsFlow = function() end
        GC.ReportPlayerBehavior = function() end
        GC.ReportTeammatHurt = function() end
        GC.ReportMisKillByTeammate = function() end
        GC.ReportForbitPick = function() end
        GC.ReportPlayerMoveRoute = function() end
        GC.ReportPlayerPosition = function() end
        GC.ReportVehicleMoveFlow = function() end
        GC.ReportSecTgameMovingFlow = function() end
        GC.ReportParachuteData = function() end
        GC.SendTssSdkAntiDataToLobby = function() end
        GC.SendDSErrorLogToLobby = function() end
        GC.SendDSErrorLogToLobbyOnece = function() end
        GC.SendDSHawkEyePatrolLogToLobby = function() end
        GC.ReportEquipmentFlow = function() end
        GC.ReportAimFlow = function() end
        GC.GetWeaponReport = function() return {} end
        GC.GetOneWeaponReport = function() return {} end
        GC.ReportHeavyWeaponBoxSpawnFlow = function() end
        GC.ReportHeavyWeaponBoxActivationFlow = function() end
        GC.ReportHeavyWeaponBoxOpenPlayerFlow = function() end
        GC.ReportHeavyWeaponBoxItemFlow = function() end
        GC.ReportPlayersPing = function() end
        GC.ReportPlayerIP = function() end
        GC.ReportPlayerFramePingRecord = function() end
        GC.OnDSConnectionSaturated = function() end
        GC.ReportDSNetSaturation = function() end
        GC.ReportNetContinuousSaturate = function() end
        GC.ReportDSNetRate = function() end
        GC.SendClientStats = function() end
        GC.SendServerAvgTickDelta = function() end
        GC.ReportCircleFlow = function() end
        GC.ReportDSCircleFlow = function() end
        GC.ReportJumpFlow = function() end
        GC.ReportAIStrategyInfo = function() end
        GC.SendAIDeliveryInfo = function() end
        GC.ReportDailyTaskInfo = function() end
        GC.ReportMatchRoomData = function() end
        GC.SendPlayerSpectatingLog = function() end
        GC.ReportIDCardProduceFlow = function() end
        GC.ReportIDCardPickUpFlow = function() end
        GC.ReportIDCardDestroyFlow = function() end
        GC.ReportRevivalFlow = function() end
        GC.ReportGameSetting = function() end
        GC.ReportGameSettingNew = function() end
        GC.ReportAntsVoiceTeamCreate = function() end
        GC.ReportAntsVoiceTeamQuit = function() end
        GC.ReportCommonInfo = function() end
        GC.ReportLightweightStat = function() end
        GC.SendSecTLog = function() end
        GC.SendDataMiningTLog = function() end
        GC.SendActivityTLog = function() end
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

-- ====================== KILL COUNTER UI HOOKS ======================
-- (these hooks require the game to be fully loaded; they are wrapped in pcall inside the hook definitions)
local SKillInfo = require("GameLua.Mod.BaseMod.Client.KillInfoTips.KillInfo")
local ECharacterHealthStatus = import("ECharacterHealthStatus")
local o_FileItem = SKillInfo.__inner_impl.FileItem
SKillInfo.__inner_impl.FileItem = function(self, DamageRecordData)
    if not self or not DamageRecordData then return o_FileItem(self, DamageRecordData) end
    local LogicKillCounter = require("client.module_framework.ModuleManager").GetModule(require("client.module_framework.ModuleManager").CommonModuleConfig.LogicKillCounter)
    if not LogicKillCounter then return o_FileItem(self, DamageRecordData) end
    local uCharacter = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController() and slua_GameFrontendHUD:GetPlayerController():GetPlayerCharacterSafety()
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

-- Additional UI hooks will be activated later after modules are initialized (via timer)

function _G.InstallKillCounterUIHooks()
    pcall(function()
        local SubsystemMgr = require("GameLua.GameCore.Module.Subsystem.SubsystemMgr")
        local MyMainKillCounter = require("GameLua.Mod.BaseMod.Client.KillCounter.MainKillCounter")
        local MyKillCountSubSystem = require("GameLua.Mod.BaseMod.Client.KillCounter.KillCounterUISubsystem")
        local MyMainWeaponInfoItemUI = require("GameLua.Mod.BaseMod.Client.Backpack.MainWeaponInfoItemUI")
        local MyMainWeaponKillCounter = require("GameLua.Mod.BaseMod.Client.KillCounter.MainWeaponKillCounter")
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

        local o_CheckNeedMainKillCounterUI = MyKillCountSubSystem.__inner_impl.CheckNeedMainKillCounterUI
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

        local o_DOnRefresh = MyMainWeaponKillCounter.__inner_impl.OnRefresh
        MyMainWeaponKillCounter.__inner_impl.OnRefresh = function(self, SelfUID)
            pcall(function()
                local ModuleManager = require("client.module_framework.ModuleManager")
                local LogicKillCounter = ModuleManager.GetModule(ModuleManager.CommonModuleConfig.LogicKillCounter)
                local curEquipedKillCounter = LogicKillCounter:GetMyEquipedKillCounterId(_G.get_skin_id2(self.WeaponID))
                self.KillCounterItem:SetKillCounterItemShowWithNum(curEquipedKillCounter, _G.getKills(self.WeaponID), _G.get_skin_id2(self.WeaponID))
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
    end)
end

-- ====================== WELCOME & FORCED SKIN ======================
function _G.TryShowWelcome()
    if _G.WelcomeShown then return end
    pcall(function()
        local CommonMsgBoxMgr = require("client.slua.logic.common.logic_common_msg_box")
        local WebviewSDK = require("client.slua.logic.url.logic_webview_sdk")
        if not CommonMsgBoxMgr then return end
        local function onClick2() end
        local function onClick1()
            if WebviewSDK then WebviewSDK:OpenURL("https://t.me/XD_SAITMA") end
            CommonMsgBoxMgr.Show(1, "PUBG", "[ LET THE FUN BEGIN ]", onClick2)
        end
        CommonMsgBoxMgr.Show(4, "Hack XD", "Welcome to Hack XD\n\nJoin To Channel First...\n\n[ NEED TO ENJOY ]", onClick1)
        _G.WelcomeShown = true
    end)
end

-- Force skin ownership (call after modules ready)
local function ForceSkinsOwnership()
    pcall(function()
        local SkinManager = require("client.module_framework.SkinManager")
        local UI_Mgr = require("client.slua_ui_framework.manager")
        local TargetSkins = {
            [101001] = 1101001265,
            [102002] = 1102002424,
            [101003] = 1101003219,
            [101004] = 1101004046,
            [101008] = 1101008163,
            [101006] = 1101006085
        }
        if SkinManager then
            for weaponID, skinID in pairs(TargetSkins) do
                if SkinManager.AddSkinData then SkinManager.AddSkinData(weaponID, skinID) end
                if SkinManager.SetSkinOwned then SkinManager.SetSkinOwned(weaponID, skinID, true) end
                if SkinManager.SelectSkin then SkinManager.SelectSkin(weaponID, skinID) end
            end
        end
        local LobbyUI = UI_Mgr.GetUI(UI_Mgr.UI_Config.Lobby_Main_UIBP)
        if LobbyUI then
            if LobbyUI.RefreshInventory then LobbyUI:RefreshInventory() end
            if LobbyUI.UpdateWeaponDisplay then LobbyUI:UpdateWeaponDisplay() end
        end
    end)
end

-- ====================== MODULE INITIALIZATION ======================
pcall(function()
    local ModuleManager = require("client.module_framework.ModuleManager")
    _G.ItemUpgradeSystem = ModuleManager.GetModule(ModuleManager.CommonModuleConfig.ItemUpgradeSystem)
    if _G.ItemUpgradeSystem then
        _G.ItemUpgradeSystem:DefineAndResetData()
        _G.ItemUpgradeSystem:OnInitialize()
    end
end)

pcall(_G.InitializeAntiReport)
pcall(_G.InitializeGameplayBypass)
pcall(_G.InitializeConnectionGuard)

_G.loadKillCountFromFile()
_G.ReadConfigFile()

-- ====================== TIMER SETUP ======================
local TXtime_ticker = require("common.time_ticker")
_G.Mytimer_ticker = TXtime_ticker

if _G.Mytimer_ticker then
    _G.Mytimer_ticker.AddTimerLoop(0, function() pcall(_G.GameAvatarHandlerweapons) end, -1, 0.10)
    _G.Mytimer_ticker.AddTimerLoop(0, function() pcall(_G.GameAvatarHandlerBagPack) end, -1, 0.10)
    _G.Mytimer_ticker.AddTimerLoop(0, function() pcall(_G.FileWatcher) end, -1, 0.05)
    _G.Mytimer_ticker.AddTimerLoop(0, function() pcall(_G.DisableHiggsBoson) end, -1, 0.50)
    _G.Mytimer_ticker.AddTimerLoop(1, function() pcall(_G.InitializeConnectionGuard) end, -1, 1)
    _G.Mytimer_ticker.AddTimerLoop(1, function() pcall(_G.InitializeGameplayBypass) end, -1, 1)
    _G.Mytimer_ticker.AddTimerLoop(1, function() pcall(_G.Lobby_Avatar_Handler) end, -1, 1)
    _G.Mytimer_ticker.AddTimerLoop(1, function() pcall(_G.Game_Avatar_Handler) end, -1, 1)
    _G.Mytimer_ticker.AddTimerLoop(0.05, function() pcall(_G.ForceUpdateKillCounterUI) end, -1, 0.05)
    _G.Mytimer_ticker.AddTimerLoop(3, function() pcall(_G.DisableHiggsBoson) end, -1, 1)
    _G.Mytimer_ticker.AddTimerOnce(2, function()
        pcall(_G.TryShowWelcome)
        pcall(_G.ApplyLobbyTheme)
        pcall(_G.ReadConfigFile)
        pcall(_G.GameAvatarHandlerplayers)
        pcall(_G.InstallKillCounterUIHooks)
        pcall(ForceSkinsOwnership)
    end)
    _G.YargiEngine.Loaded = true
end

_G.YargiEngine.Start = function() print("[YARGI ENGINE ULTIMATE] Ready - CEXY 31 TEAM") end
print("[YARGI ENGINE ULTIMATE] FULL SKIN SYSTEM LOADED!")