_G.YargiEngine = _G.YargiEngine or {}
_G.YargiEngine.Loaded = false

local DATA_PATH = (function()
    local packages = {"com.pubg.krmobile", "com.tencent.am", "com.vng.pubgmobile", "com.rekoo.pubgm", "com.pubg.imobile"}
    local base = "/storage/emulated/0/Android/data/"
    for _, pkg in ipairs(packages) do
        local path = base .. pkg .. "/files"
        local f = io.open(path .. "/config.ini", "r")
        if f then f:close(); return path end
    end
    return base .. "com.pubg.krmobile/files"
end)()

local CONFIG_PATH = DATA_PATH .. "/config.ini"
local KILL_COUNTER_PATH

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
    Pet = {50000,50001,50002,50003,50004,50005,50006,50007,50008,50009,50010,50011,50012,50013,50014,50015,50016,50017,50018,50019,50020,50021,50022,50023,50024,50025,50026,50027,50028,50029,50030,50031,50032,50033,50034,50035,50036,50037,50038,50039,50040,50041,50042,50043,50044},
    Glove = {801001,1801001001,1801001002,1801001003,1801001004,1801001005,1801001006,1801001007,1801001008,1801001009,1801001010,1801001011,1801001012,1801001013,1801001014,1801001015,1801001016,1801001017,1801001018,1801001019,1801001020,1801001021,1801001022,1801001023,1801001024,1801001025,1801001026,1801001027,1801001028,1801001029,1801001030},
    Face = {401001,1401001001,1401001002,1401001003,1401001004,1401001005,1401001006,1401001007,1401001008,1401001009,1401001010,1401001011,1401001012,1401001013,1401001014,1401001015,1401001016,1401001017,1401001018,1401001019,1401001020},
    Hair = {402001,1402001001,1402001002,1402001003,1402001004,1402001005,1402001006,1402001007,1402001008,1402001009,1402001010},
    Shoe = {405001,1405001001,1405001002,1405001003,1405001004,1405001005,1405001006,1405001007,1405001008,1405001009,1405001010,1405001011,1405001012,1405001013,1405001014,1405001015},
    Pant = {404001,1404001001,1404001002,1404001003,1404001004,1404001005,1404001006,1404001007,1404001008,1404001009,1404001010},
    Hat = {406001,1406001001,1406001002,1406001003,1406001004,1406001005,1406001006,1406001007,1406001008,1406001009,1406001010},
    Mask = {407001,1407001001,1407001002,1407001003,1407001004,1407001005,1407001006,1407001007,1407001008,1407001009,1407001010},
    Glider = {702001,1702001001,1702001002,1702001003,1702001004,1702001005,1702001006,1702001007,1702001008,1702001009,1702001010,1702001011,1702001012,1702001013,1702001014,1702001015}
}

_G.SuitSkinsMap = _G.OutfitSkins.Suit
_G.BagSkinsMap = _G.OutfitSkins.Bag
_G.HelmetSkinsMap = _G.OutfitSkins.Helmet
_G.ParachutSkinsMap = _G.OutfitSkins.Parachut
_G.PetSkinsMap = _G.OutfitSkins.Pet
_G.GloveSkinsMap = _G.OutfitSkins.Glove
_G.FaceSkinsMap = _G.OutfitSkins.Face
_G.HairSkinsMap = _G.OutfitSkins.Hair
_G.ShoeSkinsMap = _G.OutfitSkins.Shoe
_G.PantSkinsMap = _G.OutfitSkins.Pant
_G.HatSkinsMap = _G.OutfitSkins.Hat
_G.MaskSkinsMap = _G.OutfitSkins.Mask
_G.GliderSkinsMap = _G.OutfitSkins.Glider

_G.CustSlotType = {
    NONE = 0, HeadEquipemtSlot = 1, HairEquipemtSlot = 2, HatEquipemtSlot = 3, FaceEquipemtSlot = 4,
    ClothesEquipemtSlot = 5, PantsEquipemtSlot = 6, ShoesEquipemtSlot = 7, BackpackEquipemtSlot = 8,
    HelmetEquipemtSlot = 9, ArmorEquipemtSlot = 10, ParachuteEquipemtSlot = 11, GlassEquipemtSlot = 12,
    NightVisionEquipemtSlot = 13, BeardEquipemtSlot = 14, GlideEquipemtSlot = 15, HandEffectEquipemtSlot = 16,
    BackPack_PendantSlot = 17, MechaChestSlot = 18, MechaArmSlot = 19, MechaLegSlot = 20, MechaInnerSuitSlot = 21,
    FootEffectEquipemtSlot = 22, MaxSlotNum = 23, VehicleCut = 24, UnderClothSlot = 25, UnderPantsSlot = 26,
    SimpleSlotMax = 27, MAX = 28
}

_G.WeaponSkinIndex = _G.WeaponSkinIndex or {}
_G.VehicleSkinIndex = _G.VehicleSkinIndex or {}
_G.skinIdCache = _G.skinIdCache or {}
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
_G.GloveSkin = 0
_G.PantSkin = 0
_G.ShoeSkin = 0
_G.BagSkin1 = 1501001220
_G.BagSkin2 = 1501002220
_G.BagSkin3 = 1501003220
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
_G.CurrentBagApplicationValue = 0
_G.CurrentHelmetApplicationValue = 0

_G.muzzles = {
    id_flash_hider = { 201010, 201005, 201004 },
    id_compensator = { 201009, 201003, 201002 },
    id_suppressor = { 201011, 201006, 201007 }
}
_G.foregrips = {
    id_Angledforegrip = 202001, id_thumb_grip = 202006, id_vertical_grip = 202002,
    id_light_grip = 202004, id_half_grip = 202005, id_ergonomic_grip = 202051, id_laser_sight = 202007
}
_G.magazines = {
    id_expanded_mag = { 204011, 204007, 204004 },
    id_quick_mag = { 204012, 204008, 204005 },
    id_expanded_quick_mag = { 204013, 204009, 204006 }
}
_G.scopes = {
    id_reddot = 203001, id_holo = 203002, id_2x = 203003, id_3x = 203014,
    id_4x = 203004, id_6x = 203015, id_8x = 203005
}
_G.stock = {
    id_microStock = 205001, id_tactical = 205002, id_bulletloop = 204014, id_CheekPad = 205003
}

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

function _G.GetKillCounterPath()
    local possiblePaths = {
        '/storage/emulated/0/Android/data/com.tencent.am/files/NumberUpdate.txt',
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
    return '/storage/emulated/0/Android/data/com.tencent.am/files/NumberUpdate.txt'
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

local function applySlotSkin(slotData, slotIndex, targetSlotType, newItemId)
    if not slotData or not slua.isValid(slotData) then return false end
    if not newItemId or newItemId == 0 then return false end
    local equipment = slotData:Get(slotIndex)
    if equipment and equipment.SlotID == targetSlotType and equipment.ItemId ~= newItemId then
        if not _G.skinIdCache[newItemId] then
            _G.download_item(newItemId)
            _G.skinIdCache[newItemId] = true
        end
        equipment.ItemId = newItemId
        slotData:Set(slotIndex, equipment)
        return true
    end
    return false
end

function _G.equip_character_avatar(uCharacter)
    if not uCharacter or not slua.isValid(uCharacter) or not uCharacter.AvatarComponent2 then return end
    local BackpackUtils = import("BackpackUtils")
    if not BackpackUtils then return end
    local ApplyData = uCharacter.AvatarComponent2.NetAvatarData and uCharacter.AvatarComponent2.NetAvatarData.SlotSyncData
    if not ApplyData or not slua.isValid(ApplyData) then return end
    local AvatarComp = uCharacter.AvatarComponent2

    local bagLevelMap = {}
    local helmetLevelMap = {}
    for i = 0, ApplyData:Num() - 1 do
        local equipment = ApplyData:Get(i)
        if equipment then
            if equipment.SlotID == _G.CustSlotType.BackpackEquipemtSlot then
                bagLevelMap[i] = BackpackUtils.GetEquipmentBagLevel(equipment.AdditionalItemID) or 1
            elseif equipment.SlotID == _G.CustSlotType.HelmetEquipemtSlot then
                helmetLevelMap[i] = BackpackUtils.GetEquipmentHelmetLevel(equipment.AdditionalItemID) or 1
            end
        end
    end

    local skinSlots = {
        {id = _G.SuitSkin,     slot = _G.CustSlotType.ClothesEquipemtSlot},
        {id = _G.PantSkin,     slot = _G.CustSlotType.PantsEquipemtSlot},
        {id = _G.ShoeSkin,     slot = _G.CustSlotType.ShoesEquipemtSlot},
        {id = _G.HatSkin,      slot = _G.CustSlotType.HatEquipemtSlot},
        {id = _G.FaceSkin,     slot = _G.CustSlotType.HeadEquipemtSlot},
        {id = _G.MaskSkin,     slot = _G.CustSlotType.FaceEquipemtSlot},
        {id = _G.GloveSkin,    slot = _G.CustSlotType.HandEffectEquipemtSlot},
        {id = _G.GliderSkin,   slot = _G.CustSlotType.GlideEquipemtSlot},
        {id = _G.ParachuteSkin,slot = _G.CustSlotType.ParachuteEquipemtSlot},
        {id = _G.HairSkin,     slot = _G.CustSlotType.HairEquipemtSlot},
        {id = _G.GlassSkin or 0, slot = _G.CustSlotType.GlassEquipemtSlot},
    }

    local changed = false
    for i = 0, ApplyData:Num() - 1 do
        for _, skin in ipairs(skinSlots) do
            if skin.id ~= 0 and applySlotSkin(ApplyData, i, skin.slot, skin.id) then
                changed = true
            end
        end

        if bagLevelMap[i] then
            local level = bagLevelMap[i]
            local bagSkin = (level == 1 and _G.BagSkin1) or (level == 2 and _G.BagSkin2) or (level == 3 and _G.BagSkin3) or 0
            if bagSkin ~= 0 then
                local applyVal = bagSkin + (level - 1) * 1000
                if _G.LastBackApplyValue ~= applyVal then
                    if applySlotSkin(ApplyData, i, _G.CustSlotType.BackpackEquipemtSlot, applyVal) then
                        _G.LastBackApplyValue = applyVal
                        changed = true
                    end
                end
            end
        end

        if helmetLevelMap[i] then
            local level = helmetLevelMap[i]
            local helSkin = (level == 1 and _G.HelmetSkin1) or (level == 2 and _G.HelmetSkin2) or (level == 3 and _G.HelmetSkin3) or 0
            if helSkin ~= 0 then
                local applyVal = helSkin + (level - 1) * 1000
                if _G.LastHelmetApplyValue ~= applyVal then
                    if applySlotSkin(ApplyData, i, _G.CustSlotType.HelmetEquipemtSlot, applyVal) then
                        _G.LastHelmetApplyValue = applyVal
                        changed = true
                    end
                end
            end
        end
    end

    if changed then
        AvatarComp:OnRep_BodySlotStateChanged()
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
                        local cv = uCharacter.CurrentVehicle
                        if cv and _G.CurrentEquipVehicleID ~= 0 then
                            ApplySkinID = tostring(_G.CurrentEquipVehicleID) .. "1"
                        else
                            ApplySkinID = slua.IndexReference(currweapon.synData:Get(7), "defineID").TypeSpecificID
                        end
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

function _G.ReadLobbyThemeConfig()
    local possiblePaths = {
        '/storage/emulated/0/Android/data/com.tencent.am/files/config.ini',
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

local lastConfig = {}
function _G.ReadConfigFile()
    local possiblePaths = {
        '/storage/emulated/0/Android/data/com.tencent.am/files/config.ini',
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

    local function Upd(key, map, var)
        if newConfig[key] and newConfig[key] ~= lastConfig[key] then
            local idx = newConfig[key] + 1
            _G[var] = (map and map[idx]) or newConfig[key]
            lastConfig[key] = newConfig[key]
        end
    end

    Upd("Suit",      _G.SuitSkinsMap,    "SuitSkin")
    Upd("Hat",       _G.HatSkinsMap,     "HatSkin")
    Upd("Gloves",    _G.GloveSkinsMap,   "GloveSkin")
    Upd("Face",      _G.FaceSkinsMap,    "FaceSkin")
    Upd("Mask",      _G.MaskSkinsMap,    "MaskSkin")
    Upd("Pant",      _G.PantSkinsMap,    "PantSkin")
    Upd("Shoe",      _G.ShoeSkinsMap,    "ShoeSkin")
    Upd("Hair",      _G.HairSkinsMap,    "HairSkin")
    Upd("Parachute", _G.ParachutSkinsMap,"ParachuteSkin")
    Upd("Pet",       _G.PetSkinsMap,     "PetSkin")
    Upd("Glider",    _G.GliderSkinsMap,  "GliderSkin")
    Upd("Bag1",      _G.BagSkinsMap,     "BagSkin1")
    Upd("Bag2",      _G.BagSkinsMap,     "BagSkin2")
    Upd("Bag3",      _G.BagSkinsMap,     "BagSkin3")
    Upd("Helmet1",   _G.HelmetSkinsMap,  "HelmetSkin1")
    Upd("Helmet2",   _G.HelmetSkinsMap,  "HelmetSkin2")
    Upd("Helmet3",   _G.HelmetSkinsMap,  "HelmetSkin3")

    if newConfig["Emote1"] and newConfig["Emote1"] ~= lastConfig["Emote1"] then
        _G.Emote1Skin = newConfig["Emote1"]; lastConfig["Emote1"] = newConfig["Emote1"]
    end
    if newConfig["Emote2"] and newConfig["Emote2"] ~= lastConfig["Emote2"] then
        _G.Emote2Skin = newConfig["Emote2"]; lastConfig["Emote2"] = newConfig["Emote2"]
    end
    if newConfig["Emote3"] and newConfig["Emote3"] ~= lastConfig["Emote3"] then
        _G.Emote3Skin = newConfig["Emote3"]; lastConfig["Emote3"] = newConfig["Emote3"]
    end
    if newConfig["HAE"] and newConfig["HAE"] ~= lastConfig["HAE"] then
        _G.HAESkin = newConfig["HAE"]; lastConfig["HAE"] = newConfig["HAE"]
    end
    if newConfig["Molotov"] and newConfig["Molotov"] ~= lastConfig["Molotov"] then
        _G.MolotovSkin = newConfig["Molotov"]; lastConfig["Molotov"] = newConfig["Molotov"]
    end
    if newConfig["Smoke"] and newConfig["Smoke"] ~= lastConfig["Smoke"] then
        _G.SmokeSkin = newConfig["Smoke"]; lastConfig["Smoke"] = newConfig["Smoke"]
    end
    if newConfig["LobbyTheme"] and newConfig["LobbyTheme"] ~= lastConfig["LobbyTheme"] then
        _G.TargetLobbyThemeID = newConfig["LobbyTheme"]
        _G.LastAppliedThemeID = nil
        lastConfig["LobbyTheme"] = newConfig["LobbyTheme"]
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
end

_G.Lobby_Avatar_Handler = function()
    pcall(_G.ReadConfigFile)
    pcall(_G.CheckLobbyThemeChanges)
    pcall(_G.GameAvatarHandlerplayers)
    pcall(_G.HandlePetLogic)
end

_G.Game_Avatar_Handler = function()
    pcall(_G.GameAvatarHandlerplayers)
end

_G.InitializeAntiReport = function()
    pcall(function()
        local ClientReport = require("GameLua.Mod.BaseMod.Client.Security.ClientReportPlayerSubsystem")
        if ClientReport then
            ClientReport.OnInit = function() end
            ClientReport._OnPlayerKilledOtherPlayer = function() end
            ClientReport._OnBattleResult = function() end
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
        local emptyFunc = function() end
        GC.ReportAttackFlow = emptyFunc
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

local function GetMyUID()
    pcall(function()
        if DataMgr and DataMgr.roleData then return tostring(DataMgr.roleData.uid) end
    end)
    return nil
end

local function GetCurrentWeaponSkinID()
    local result = 0
    pcall(function()
        local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
        if not pc or not slua.isValid(pc) then return end
        local uChar = pc:GetPlayerCharacterSafety()
        if not uChar or not slua.isValid(uChar) then return end
        local cw = uChar:GetCurrentWeapon()
        if not cw or not slua.isValid(cw) then return end
        local weaponBaseID = cw:GetItemDefineID().TypeSpecificID
        if weaponBaseID == 0 then return end
        local skinRef = slua.IndexReference(cw.synData:Get(7), "defineID")
        if skinRef then result = skinRef.TypeSpecificID end
        if result == weaponBaseID and _G.get_skin_id then result = _G.get_skin_id(weaponBaseID) end
    end)
    return result
end

local function GetCurrentWeaponBaseID()
    local result = 0
    pcall(function()
        local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
        if not pc or not slua.isValid(pc) then return end
        local uChar = pc:GetPlayerCharacterSafety()
        if not uChar or not slua.isValid(uChar) then return end
        local cw = uChar:GetCurrentWeapon()
        if not cw or not slua.isValid(cw) then return end
        result = cw:GetItemDefineID().TypeSpecificID
    end)
    return result
end

pcall(function()
    local O_OnBattleResult = BattleResultUI.OnBattleResult
    BattleResultUI.OnBattleResult = function(uid, result)
        local mySkinID   = GetCurrentWeaponSkinID()
        local myWeaponID = GetCurrentWeaponBaseID()
        O_OnBattleResult(uid, result)
        pcall(function()
            if not result or not result.TeammateList then return end
            if mySkinID == 0 then return end
            local myUID = GetMyUID()
            if not myUID then return end
            for _, teammate in pairs(result.TeammateList) do
                if tostring(teammate.UID) == myUID then
                    if not teammate.wear_ext then teammate.wear_ext = {} end
                    if not teammate.wear_ext[14] then teammate.wear_ext[14] = {} end
                    teammate.wear_ext[14][1] = mySkinID
                    teammate.wear_ext[14][4] = 0
                    if myWeaponID ~= 0 then teammate.mainWeaponID = myWeaponID end
                    break
                end
            end
        end)
    end
end)

pcall(function()
    local O_ResultMVP_DynamicCreateUI = ResultMVP_DynamicCreateUI
    ResultMVP_DynamicCreateUI = function(rank, delay, resultType, subMode)
        pcall(function()
            local mySkinID   = GetCurrentWeaponSkinID()
            local myWeaponID = GetCurrentWeaponBaseID()
            if not BP_STRUCT_MVP_SpawnPlayerRoleInfo then return end
            if mySkinID ~= 0 then
                BP_STRUCT_MVP_SpawnPlayerRoleInfo.weaponSkinId        = mySkinID
                BP_STRUCT_MVP_SpawnPlayerRoleInfo.weaponSkinDIYPlanId = 0
            end
            if myWeaponID ~= 0 then
                BP_STRUCT_MVP_SpawnPlayerRoleInfo.weaponId = myWeaponID
            end
            if _G.PetSkin and _G.PetSkin ~= 0 and _G.PetSkin ~= 50000 then
                BP_STRUCT_MVP_SpawnPlayerRoleInfo.PetId      = _G.PetSkin
                BP_STRUCT_MVP_SpawnPlayerRoleInfo.PetAvatarID = _G.PetSkin
            end
        end)
        O_ResultMVP_DynamicCreateUI(rank, delay, resultType, subMode)
    end
end)

pcall(function()
    local O_OnClientGameOver = OnClientGameOver
    OnClientGameOver = function()
        if O_OnClientGameOver then O_OnClientGameOver() end
        _G.AlreadyChangedSet = {}
        _G.DeadBoxSkins = {}
        _G.g_parts = {}
        _G.CurrentEquipVehicleID = 0
        _G.LastAppliedPet = 0
    end
end)

local function YargiEngineWiFiHook()
    local Lobby_Main_Wifi_UIBP = require("GameLua.Mod.BaseMod.Client.Lobby.Lobby_Main_Wifi_UIBP")
    if Lobby_Main_Wifi_UIBP and Lobby_Main_Wifi_UIBP.__inner_impl then
        local OldOnPostInit = Lobby_Main_Wifi_UIBP.__inner_impl.OnPostInitialize
        Lobby_Main_Wifi_UIBP.__inner_impl.OnPostInitialize = function(self)
            if OldOnPostInit then OldOnPostInit(self) end
            pcall(function()
                if self.WidgetSwitcher_Network then self.WidgetSwitcher_Network:SetVisibility(UEnums.ESlateVisibility.Collapsed) end
                if self.WidgetSwitcher_WIFI then self.WidgetSwitcher_WIFI:SetVisibility(UEnums.ESlateVisibility.Collapsed) end
                if self.WidgetSwitcher_Signal then self.WidgetSwitcher_Signal:SetVisibility(UEnums.ESlateVisibility.Collapsed) end
                if self.UIRoot and self.UIRoot.TextBlock_Zone then self.UIRoot.TextBlock_Zone:SetText("YARGI ENGINE") end
            end)
        end
    end
end
pcall(YargiEngineWiFiHook)

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
        pcall(_G.ApplyLobbyTheme)
        pcall(_G.ReadConfigFile)
        pcall(_G.GameAvatarHandlerplayers)
    end)
    _G.YargiEngine.Loaded = true
end

_G.YargiEngine.Start = function() print("[YARGI ENGINE ULTIMATE] Ready") end
print("[YARGI ENGINE ULTIMATE] FULL SYSTEM LOADED!")