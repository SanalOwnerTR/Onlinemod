
_G.YargiEngine = _G.YargiEngine or {}
_G.YargiEngine.Loaded = false

local function GetDataPath()
    local packages = {"com.pubg.krmobile", "com.tencent.ig/files", "com.vng.pubgmobile", "com.rekoo.pubgm"}
    local base = "/storage/emulated/0/Android/data/"
    for _, pkg in ipairs(packages) do
        local path = base .. pkg .. "/files"
        local f = io.open(path .. "/config.ini", "r")
        if f then f:close(); return path end
    end
    return base .. "com.pubg.krmobile"
end

local DATA_PATH = GetDataPath()
local CONFIG_PATH = DATA_PATH .. "/config.ini"
local KILL_COUNTER_PATH = DATA_PATH .. "/NumberUpdate.txt"

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
    id_expanded_mag = { 204011, 204007, 204004 }, id_quick_mag = { 204012, 204008, 204005 },
    id_expanded_quick_mag = { 204013, 204009, 204006 }
}
_G.scopes = {
    id_reddot = 203001, id_holo = 203002, id_2x = 203003, id_3x = 203014,
    id_4x = 203004, id_6x = 203015, id_8x = 203005
}
_G.stock = {
    id_microStock = 205001, id_tactical = 205002, id_bulletloop = 204014, id_CheekPad = 205003
}

_G.OutfitSkins = {
    Suit = {403003,1406469,1405870,1407140,1407141,1407142,1407550,1406638,1406872,1406971,1407103,1407512,1407391,1407366,1407330,1407329,1407286,1407285,1407277,1407276,1407275,1407225,1407224,1407259,1407161,1407160,1407107,1407106,1407079,1407048,1406977,1406976,1406898,1400569,1404000,1404049,1400119,1400117,1406060,1406891,1400687,1405160,1405145,1405436,1405435,1405434,1405064,1405207,1406895,1400333,1400377,1405092,1405121,1406889,1407278,1407279,1407381,1407380,1407385,1406389,1406388,1406387,1406386,1406385,1406140,1400782,1407392,1407318,1407317,1407404,1407402,1407401,1407387,1404434,1404437,1404440,1404448,1400324,1400708,1404043,1404048,1405953,1400101,1404153,1407440,1407441},
    Bag = {501001,1501001174,1501001220,1501001051,1501001443,1501001265,1501001321,1501001277,1501001550,1501001592,1501001608,1501001024,1501001019,1501001195,1501001179,1501001194,1501001346,1501001097,1501001081,1501001093,1501001022,1501001639,1501001640,1501001625},
    Helmet = {502001,1502001014,1502001349,1502001012,1502001009,1502001397,1502001390,1502001381,1502001358,1502001350,1502001342,1502001336,1502001333,1502001327,1502001325,1502001299,1502001295,1502001222,1502001069,1502001054,1502001033,1502001016,1502001031,1502001023,1502001018,1502001408,1502001410},
    Parachut = {703001,1401619,1401625,1401624,1401836,1401833,1401287,1401282,1401385,1401549,1401336,1401335,1401629,1401628},
    Pet = {50000,50001,50002,50003,50004,50005,50006,50007,50008,50009,50010,50011,50012,50013,50014,50015,50016,50017,50018,50019,50020,50021,50022,50023,50024,50025,50026,50027,50028,50029,50030,50031,50032,50033,50034,50035,50036,50037,50038,50039,50040,50041,50042,50043,50044},
    Gloves = {409001,1409001002,1409001003,1409001004,1409001005,1409001006,1409001007,1409001008,1409001009,1409001010},
    Face = {404001,1404001002,1404001003,1404001004,1404001005,1404001006,1404001007,1404001008,1404001009,1404001010},
    Hair = {402001,1402001002,1402001003,1402001004,1402001005,1402001006,1402001007,1402001008,1402001009,1402001010},
    Pant = {405001,1405001002,1405001003,1405001004,1405001005,1405001006,1405001007,1405001008,1405001009,1405001010},
    Shoe = {407001,1407001002,1407001003,1407001004,1407001005,1407001006,1407001007,1407001008,1407001009,1407001010},
    Cap = {401001,1401001002,1401001003,1401001004,1401001005,1401001006,1401001007,1401001008,1401001009,1401001010},
    Glass = {408001,1408001002,1408001003,1408001004,1408001005,1408001006,1408001007,1408001008,1408001009,1408001010},
    Mask = {406001,1406001002,1406001003,1406001004,1406001005,1406001006,1406001007,1406001008,1406001009,1406001010}
}

_G.SuitSkinsMap = _G.OutfitSkins.Suit
_G.BagSkinsMap = _G.OutfitSkins.Bag
_G.HelmetSkinsMap = _G.OutfitSkins.Helmet
_G.ParachutSkinsMap = _G.OutfitSkins.Parachut
_G.PetSkinsMap = _G.OutfitSkins.Pet
_G.GlovesSkinsMap = _G.OutfitSkins.Gloves
_G.FaceSkinsMap = _G.OutfitSkins.Face
_G.HairSkinsMap = _G.OutfitSkins.Hair
_G.PantSkinsMap = _G.OutfitSkins.Pant
_G.ShoeSkinsMap = _G.OutfitSkins.Shoe
_G.CapSkinsMap = _G.OutfitSkins.Cap
_G.GlassSkinsMap = _G.OutfitSkins.Glass
_G.MaskSkinsMap = _G.OutfitSkins.Mask

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
    [104004]={104004,1104004034,1104004015,1104004040},
    [101002]={101002,1101002081},
    [101005]={101005,1101005052},
    [101007]={101007,1101007046},
    [102001]={102001,1102001103},
    [103004]={103004,1103004001},
    [103006]={103006,1103006030},
    [103007]={103007,1103007028},
    [103012]={103012,1103012010},
    [104003]={104003,1104003027},
    [106001]={106001,1108004356}
}

_G.CustSlotType = {
    NONE = 0, HeadEquipemtSlot = 1, HairEquipemtSlot = 2, HatEquipemtSlot = 3,
    FaceEquipemtSlot = 4, ClothesEquipemtSlot = 5, PantsEquipemtSlot = 6,
    ShoesEquipemtSlot = 7, BackpackEquipemtSlot = 8, HelmetEquipemtSlot = 9,
    ArmorEquipemtSlot = 10, ParachuteEquipemtSlot = 11, GlassEquipemtSlot = 12,
    NightVisionEquipemtSlot = 13, BeardEquipemtSlot = 14, GlideEquipemtSlot = 15,
    HandEffectEquipemtSlot = 16, BackPack_PendantSlot = 17, MechaChestSlot = 18,
    MechaArmSlot = 19, MechaLegSlot = 20, MechaInnerSuitSlot = 21,
    FootEffectEquipemtSlot = 22, MaxSlotNum = 23, VehicleCut = 24,
    UnderClothSlot = 25, UnderPantsSlot = 26, SimpleSlotMax = 27, MAX = 28
}

_G.skinIdCache = _G.skinIdCache or {}
_G.skinIdCache2 = _G.skinIdCache2 or {}
_G.killCountInfo = _G.killCountInfo or {}
_G.DeadBoxSkins = _G.DeadBoxSkins or {}
_G.AlreadyChangedSet = _G.AlreadyChangedSet or {}
_G.WeaponSkinIndex = _G.WeaponSkinIndex or {}
_G.g_parts = _G.g_parts or {}
_G.lastAppliedSkin = _G.lastAppliedSkin or {}
_G.lastAppliedAttachments = _G.lastAppliedAttachments or {}
_G.lastConfig = _G.lastConfig or {}

_G.SuitSkin = 0; _G.BagSkin = 0; _G.HelmetSkin = 0; _G.ParachuteSkin = 0
_G.PetSkin = 0; _G.FaceSkin = 0; _G.HairSkin = 0; _G.PantSkin = 0
_G.ShoeSkin = 0; _G.CapSkin = 0; _G.GlassSkin = 0; _G.MaskSkin = 0; _G.GlovesSkin = 0

_G.LastBackApplyValue = 0; _G.CurrentBagApplicationValue = 0
_G.LastHelmetApplyValue = 0; _G.CurrentHelmetApplicationValue = 0
_G.LastAppliedPet = 0; _G.CurrentEquipVehicleID = 0

_G.TargetLobbyThemeID = 202408001
_G.LastAppliedThemeID = nil
_G.WelcomeShown = false
_G.lastFileContent = ""
_G.isFileWatcherActive = true

function _G.download_item(id)
    if not id or id == 0 then return end
    pcall(function()
        local PufferManager = require('client.slua.logic.download.puffer.puffer_manager')
        local PufferConst = require('client.slua.logic.download.puffer_const')
        if not PufferManager or not PufferConst then return end
        local state = PufferManager.GetState(PufferConst.ENUM_DownloadType.ODPAK, {id})
        if state ~= PufferConst.ENUM_DownloadState.Done then
            PufferManager.Download(PufferConst.ENUM_DownloadType.ODPAK, {id})
        end
    end)
end

_G.IsPtrValid = function(ptr)
    return ptr ~= nil and slua.isValid(ptr)
end

function table.contains(tbl, element)
    for _, v in ipairs(tbl) do
        if v == element then return true end
    end
    return false
end

local function locationsClose(loc1, loc2, tolerance)
    local dx = loc1.X - loc2.X; local dy = loc1.Y - loc2.Y; local dz = loc1.Z - loc2.Z
    return dx*dx + dy*dy + dz*dz < tolerance*tolerance
end

function _G.get_group_id(itemId)
    if not _G.ItemUpgradeSystem or not itemId then return nil end
    local itemcfg = _G.ItemUpgradeSystem:GetUpgradeCfg(itemId)
    if itemcfg and itemcfg.GroupID then return itemcfg.GroupID end
    return nil
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
    if is_in_muzzles_list("id_flash_hider") then muzzle_type = "Flash Hider"
    elseif is_in_muzzles_list("id_compensator") then muzzle_type = "Compensator"
    elseif is_in_muzzles_list("id_suppressor") then muzzle_type = "Suppressor"
    end
    if muzzle_type and _G.g_parts[avatarid] and _G.g_parts[avatarid][muzzle_type] then
        current_id = _G.g_parts[avatarid][muzzle_type]
    end
    if initial_id ~= current_id then return current_id, true end
    return current_id, false
end

function _G.get_forgripid(current_id, avatarid)
    local initial_id = current_id
    _G.InitParts(_G.get_group_id(avatarid), avatarid)
    if current_id == _G.foregrips.id_Angledforegrip then current_id = _G.g_parts[avatarid]["Angled Foregrip"] or current_id
    elseif current_id == _G.foregrips.id_thumb_grip then current_id = _G.g_parts[avatarid]["Thumb Grip"] or current_id
    elseif current_id == _G.foregrips.id_vertical_grip then current_id = _G.g_parts[avatarid]["Vertical Foregrip"] or current_id
    elseif current_id == _G.foregrips.id_light_grip then current_id = _G.g_parts[avatarid]["Light Grip"] or current_id
    elseif current_id == _G.foregrips.id_half_grip then current_id = _G.g_parts[avatarid]["Half Grip"] or current_id
    elseif current_id == _G.foregrips.id_ergonomic_grip then current_id = _G.g_parts[avatarid]["Ergonomic Grip"] or current_id
    elseif current_id == _G.foregrips.id_laser_sight then current_id = _G.g_parts[avatarid]["Laser Sight"] or current_id
    end
    if initial_id ~= current_id then return current_id, true end
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
    if is_in_magazine_list("id_expanded_mag") then magazine_type = "Extended Mag"
    elseif is_in_magazine_list("id_quick_mag") then magazine_type = "Quickdraw Mag"
    elseif is_in_magazine_list("id_expanded_quick_mag") then magazine_type = "Extended Quickdraw Mag"
    end
    if magazine_type and _G.g_parts[avatarid] and _G.g_parts[avatarid][magazine_type] then
        current_id = _G.g_parts[avatarid][magazine_type]
    elseif not magazine_type then
        current_id = _G.GetSlotFromSkinID(avatarid, 1) or current_id
    end
    if initial_id ~= current_id then return current_id, true end
    return current_id, false
end

function _G.get_scopeid(current_id, avatarid)
    local initial_id = current_id
    _G.InitParts(_G.get_group_id(avatarid), avatarid)
    if current_id == _G.scopes.id_reddot then current_id = _G.g_parts[avatarid]["Red Dot Sight"] or current_id
    elseif current_id == _G.scopes.id_holo then current_id = _G.g_parts[avatarid]["Holographic Sight"] or current_id
    elseif current_id == _G.scopes.id_2x then current_id = _G.g_parts[avatarid]["2x Scope"] or current_id
    elseif current_id == _G.scopes.id_3x then current_id = _G.g_parts[avatarid]["3x Scope"] or current_id
    elseif current_id == _G.scopes.id_4x then current_id = _G.g_parts[avatarid]["4x Scope"] or current_id
    elseif current_id == _G.scopes.id_6x then current_id = _G.g_parts[avatarid]["6x Scope"] or current_id
    elseif current_id == _G.scopes.id_8x then current_id = _G.g_parts[avatarid]["8x Scope"] or current_id
    else current_id = _G.GetSlotFromSkinID(avatarid, 3) or current_id
    end
    if initial_id ~= current_id then return current_id, true end
    return current_id, false
end

function _G.get_stockid(current_id, avatarid)
    local initial_id = current_id
    _G.InitParts(_G.get_group_id(avatarid), avatarid)
    if current_id == _G.stock.id_microStock then current_id = _G.g_parts[avatarid]["Stock"] or current_id
    elseif current_id == _G.stock.id_tactical then current_id = _G.g_parts[avatarid]["Tactical Stock"] or current_id
    elseif current_id == _G.stock.id_bulletloop then current_id = _G.g_parts[avatarid]["Bullet Loop"] or current_id
    elseif current_id == _G.stock.id_CheekPad then current_id = _G.g_parts[avatarid]["Cheek Pad"] or current_id
    else current_id = _G.GetSlotFromSkinID(avatarid, 2) or current_id
    end
    if initial_id ~= current_id then return current_id, true end
    return current_id, false
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
    local file = io.open(CONFIG_PATH, 'r')
    if not file then return end
    local content = file:read('*all')
    file:close()
    local newConfig = {}
    for line in content:gmatch('[^\r\n]+') do
        local key, value = line:match('(%w+)=(%d+)')
        if key and value then newConfig[key] = tonumber(value) end
    end
    
    if newConfig['Enable'] then _G.bEnable = (newConfig['Enable'] ~= 0) end
    if newConfig['LobbyTheme'] then _G.TargetLobbyThemeID = newConfig['LobbyTheme'] end
    
    if newConfig['Suit'] then _G.SuitSkin = _G.OutfitSkins.Suit[newConfig['Suit']+1] or 0 end
    if newConfig['Bag'] then _G.BagSkin = _G.OutfitSkins.Bag[newConfig['Bag']+1] or 0 end
    if newConfig['Helmet'] then _G.HelmetSkin = _G.OutfitSkins.Helmet[newConfig['Helmet']+1] or 0 end
    if newConfig['Parachute'] then _G.ParachuteSkin = _G.OutfitSkins.Parachut[newConfig['Parachute']+1] or 0 end
    if newConfig['Pet'] then _G.PetSkin = _G.OutfitSkins.Pet[newConfig['Pet']+1] or 0 end
    if newConfig['Face'] then _G.FaceSkin = _G.OutfitSkins.Face[newConfig['Face']+1] or 0 end
    if newConfig['Hair'] then _G.HairSkin = _G.OutfitSkins.Hair[newConfig['Hair']+1] or 0 end
    if newConfig['Pant'] then _G.PantSkin = _G.OutfitSkins.Pant[newConfig['Pant']+1] or 0 end
    if newConfig['Shoe'] then _G.ShoeSkin = _G.OutfitSkins.Shoe[newConfig['Shoe']+1] or 0 end
    if newConfig['Cap'] then _G.CapSkin = _G.OutfitSkins.Cap[newConfig['Cap']+1] or 0 end
    if newConfig['Glass'] then _G.GlassSkin = _G.OutfitSkins.Glass[newConfig['Glass']+1] or 0 end
    if newConfig['Mask'] then _G.MaskSkin = _G.OutfitSkins.Mask[newConfig['Mask']+1] or 0 end
    if newConfig['Gloves'] then _G.GlovesSkin = _G.OutfitSkins.Gloves[newConfig['Gloves']+1] or 0 end
    
    local wepMap = {M416=101004, AKM=101001, SCAR=101003, M16A4=101002, GROZA=101005, AUG=101006, QBZ=101007, M762=101008, MK47=101009, G36C=101010, FAMAS=101011, Kar98=103001, M24=103002, AWM=103003, SKS=103004, VSS=103005, Mini14=103006, MK14=103007, SLR=103009, QBU=103010, MK12=103011, AMR=103012, Mosin=103013, UZI=102001, UMP=102002, Vector=102003, Thompson=102004, Bizon=102005, MP5K=102007, P90=102009, S12K=104003, DBS=104004, S1897=104001, S686=104002, M249=105002, DP28=105001, MG3=105010, Pan=106001}
    for key, id in pairs(wepMap) do
        if newConfig[key] then _G.WeaponSkinIndex[id] = newConfig[key] + 1 end
    end
    _G.lastConfig = newConfig
end

function _G.get_skin_id(weaponID)
    if not weaponID then return weaponID end
    local index = _G.WeaponSkinIndex[weaponID] or 1
    local skins = _G.skinIdMappings[weaponID]
    if not skins then return weaponID end
    local skinID = skins[index] or weaponID
    if not _G.skinIdCache2[skinID] then
        _G.download_item(skinID)
        _G.skinIdCache2[skinID] = true
    end
    return skinID
end
_G.get_skin_id2 = _G.get_skin_id

function _G.getKills(weaponID)
    return weaponID and _G.killCountInfo[weaponID] or 0
end

function _G.saveKillCountToFile()
    local file = io.open(KILL_COUNTER_PATH, 'w+')
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
    local file = io.open(KILL_COUNTER_PATH, 'r')
    if not file then return end
    local content = file:read('*a')
    file:close()
    _G.lastFileContent = content
    if content ~= '' then
        content = content:gsub('\239\187\191', ''):gsub('^%s+', '')
        for weaponID, count in content:gmatch('%[(%d+)%]%s*=%s*(%d+)') do
            _G.killCountInfo[tonumber(weaponID)] = tonumber(count)
        end
    end
end

function _G.addKill(weaponID, count)
    if not weaponID or not count then return end
    _G.killCountInfo[weaponID] = (_G.killCountInfo[weaponID] or 0) + count
    _G.saveKillCountToFile()
    _G.ForceUpdateKillCounterUI()
end

function _G.ForceUpdateKillCounterUI()
    pcall(function()
        local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
        if not _G.IsPtrValid(pc) then return end
        local uChar = pc:GetPlayerCharacterSafety()
        if not _G.IsPtrValid(uChar) then return end
        local currWeapon = uChar:GetCurrentWeapon()
        if not _G.IsPtrValid(currWeapon) then return end
        local DefineID = currWeapon:GetItemDefineID().TypeSpecificID
        if DefineID == 0 then return end
        local SkinID = slua.IndexReference(currWeapon.synData:Get(7), "defineID").TypeSpecificID
        local UIManager = require("client.slua_ui_framework.manager")
        local MainKillCounter = UIManager.GetUI(UIManager.UI_Config_InGame.MainKillCounter)
        if _G.IsPtrValid(MainKillCounter) then
            local ModuleManager = require("client.module_framework.ModuleManager")
            local LogicKillCounter = ModuleManager.GetModule(ModuleManager.CommonModuleConfig.LogicKillCounter)
            local curEquipedKillCounter = LogicKillCounter:GetEquipedKillCounterId(6114302174, SkinID)
            if not curEquipedKillCounter or curEquipedKillCounter == 0 then
                curEquipedKillCounter = LogicKillCounter:GetBaseKillCounterIdByWeaponId(DefineID)
            end
            local kills = _G.getKills(DefineID)
            if curEquipedKillCounter and kills then
                MainKillCounter:SetKillCounterItemShowWithNum(curEquipedKillCounter, kills, SkinID)
            end
        end
    end)
end

function _G.FileWatcher()
    if not _G.isFileWatcherActive then return end
    pcall(function()
        local file = io.open(KILL_COUNTER_PATH, 'r')
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
        if next(tempTable) then
            _G.killCountInfo = tempTable
            _G.ForceUpdateKillCounterUI()
        end
    end)
end

function _G.equip_character_avatar(uCharacter)
    if not _G.IsPtrValid(uCharacter) or not uCharacter.AvatarComponent2 then return end
    local BackpackUtils = import("BackpackUtils")
    if not BackpackUtils then return end
    local ApplyData = uCharacter.AvatarComponent2.NetAvatarData and uCharacter.AvatarComponent2.NetAvatarData.SlotSyncData
    if not _G.IsPtrValid(ApplyData) then return end
    
    local function setSkin(idx, itemId, slot)
        if itemId and itemId ~= 0 then
            local eq = ApplyData:Get(idx)
            if eq and eq.SlotID == slot and eq.ItemId ~= itemId then
                if not _G.skinIdCache[itemId] then _G.download_item(itemId); _G.skinIdCache[itemId] = true end
                eq.ItemId = itemId
                ApplyData:Set(idx, eq)
                uCharacter.AvatarComponent2:OnRep_BodySlotStateChanged()
            end
        end
    end
    
    local function setBagSkin(idx, itemId, slot)
        local eq = ApplyData:Get(idx)
        if eq and itemId ~= 0 and eq.SlotID == slot and _G.BagSkin ~= 501001 then
            if _G.BagSkin ~= _G.LastBackApplyValue or eq.ItemId ~= _G.CurrentBagApplicationValue then
                local level = BackpackUtils.GetEquipmentBagLevel(eq.AdditionalItemID) or 1
                _G.CurrentBagApplicationValue = _G.BagSkin + (level - 1) * 1000
                if not _G.skinIdCache[_G.CurrentBagApplicationValue] then 
                    _G.download_item(_G.CurrentBagApplicationValue)
                    _G.skinIdCache[_G.CurrentBagApplicationValue] = true 
                end
                eq.ItemId = _G.CurrentBagApplicationValue
                ApplyData:Set(idx, eq)
                uCharacter.AvatarComponent2:OnRep_BodySlotStateChanged()
                _G.LastBackApplyValue = _G.BagSkin
            end
        end
    end
    
    local function setHelmetSkin(idx, itemId, slot)
        local eq = ApplyData:Get(idx)
        if eq and itemId ~= 0 and eq.SlotID == slot and _G.HelmetSkin ~= 502001 then
            if _G.HelmetSkin ~= _G.LastHelmetApplyValue or eq.ItemId ~= _G.CurrentHelmetApplicationValue then
                local level = BackpackUtils.GetEquipmentHelmetLevel(eq.AdditionalItemID) or 1
                _G.CurrentHelmetApplicationValue = _G.HelmetSkin + (level - 1) * 1000
                if not _G.skinIdCache[_G.CurrentHelmetApplicationValue] then 
                    _G.download_item(_G.CurrentHelmetApplicationValue)
                    _G.skinIdCache[_G.CurrentHelmetApplicationValue] = true 
                end
                eq.ItemId = _G.CurrentHelmetApplicationValue
                ApplyData:Set(idx, eq)
                uCharacter.AvatarComponent2:OnRep_BodySlotStateChanged()
                _G.LastHelmetApplyValue = _G.HelmetSkin
            end
        end
    end
    
    for i = 0, ApplyData:Num() - 1 do
        setSkin(i, _G.SuitSkin, _G.CustSlotType.ClothesEquipemtSlot)
        setSkin(i, _G.PantSkin, _G.CustSlotType.PantsEquipemtSlot)
        setSkin(i, _G.FaceSkin, _G.CustSlotType.FaceEquipemtSlot)
        setSkin(i, _G.ShoeSkin, _G.CustSlotType.ShoesEquipemtSlot)
        setSkin(i, _G.HairSkin, _G.CustSlotType.HairEquipemtSlot)
        setSkin(i, _G.CapSkin, _G.CustSlotType.HatEquipemtSlot)
        setSkin(i, _G.GlassSkin, _G.CustSlotType.GlassEquipemtSlot)
        setSkin(i, _G.MaskSkin, _G.CustSlotType.FaceEquipemtSlot)
        setSkin(i, _G.GlovesSkin, _G.CustSlotType.BeardEquipemtSlot)
        setBagSkin(i, _G.BagSkin, _G.CustSlotType.BackpackEquipemtSlot)
        setHelmetSkin(i, _G.HelmetSkin, _G.CustSlotType.HelmetEquipemtSlot)
        setSkin(i, _G.ParachuteSkin, _G.CustSlotType.ParachuteEquipemtSlot)
    end
end

function _G.HandlePetLogic()
    if not _G.PetSkin or _G.PetSkin == 0 or _G.PetSkin == 50000 then return end
    if _G.PetSkin == _G.LastAppliedPet then return end
    _G.download_item(_G.PetSkin)
    pcall(function()
        local ModuleManager = require("client.module_framework.ModuleManager")
        if ModuleManager then
            local logic_pet = ModuleManager.GetModule(ModuleManager.CommonModuleConfig.logic_pet)
            if logic_pet then
                if logic_pet.SetCurPetID then logic_pet:SetCurPetID(_G.PetSkin) end
                if logic_pet.EquipPet then logic_pet:EquipPet(_G.PetSkin) end
            end
        end
    end)
    local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if _G.IsPtrValid(pc) then
        if pc.InitialPetInfo then pc.InitialPetInfo.PetId = _G.PetSkin end
        if pc.PetComponent and _G.IsPtrValid(pc.PetComponent) and pc.PetComponent.SetPetID then
            pc.PetComponent:SetPetID(_G.PetSkin)
        end
    end
    _G.LastAppliedPet = _G.PetSkin
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
                        found = true
                        break
                    end
                end
                if not found then
                    local ApplySkinID = 0
                    if uCharacter.CurrentVehicle and _G.CurrentEquipVehicleID ~= 0 then
                        ApplySkinID = tostring(_G.CurrentEquipVehicleID) .. "1"
                    else
                        local currweapon = uCharacter:GetCurrentWeapon()
                        if _G.IsPtrValid(currweapon) then
                            ApplySkinID = slua.IndexReference(currweapon.synData:Get(7), "defineID").TypeSpecificID
                        end
                    end
                    if ApplySkinID ~= 0 then
                        Deadboxavatar:ResetItemAvatar()
                        Deadboxavatar:PreChangeItemAvatar(ApplySkinID)
                        Deadboxavatar:SyncChangeItemAvatar(ApplySkinID)
                        table.insert(_G.DeadBoxSkins, { location = actorLocation, SkinID = ApplySkinID })
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
    for gunId, skinIdTable in pairs(_G.VehskinIdMappings or {}) do
        if DefaultAvatarID:find(tostring(gunId)) then
            local skinId = skinIdTable[1]
            if CurrentAvatarID ~= skinId then
                VehicleAvatar:ChangeItemAvatar(skinId, true)
                _G.CurrentEquipVehicleID = skinId
                break
            end
        end
    end
end

function _G.ApplyLobbyTheme()
    local themeID = _G.TargetLobbyThemeID
    if not themeID or themeID == 0 or _G.LastAppliedThemeID == themeID then return end
    pcall(function()
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
        local HiggsBosonComponent = require("GameLua.Mod.BaseMod.Common.Security.HiggsBosonComponent")
        if HiggsBosonComponent then
            HiggsBosonComponent.StaticShowSecurityAlertInDev = function() end
        end
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
    local PlayerController = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if not PlayerController or not slua.isValid(PlayerController) then return end
    if PlayerController.HiggsBoson then
        PlayerController.HiggsBoson.bMHActive = false
        PlayerController.HiggsBoson.bCallPreReplication = false
    end
end

function _G.GameAvatarHandlerplayers()
    local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if not _G.IsPtrValid(pc) then return end
    _G.DisableHiggsBoson()
    local uChar = pc:GetPlayerCharacterSafety()
    if _G.IsPtrValid(uChar) then
        _G.equip_character_avatar(uChar)
    end
    _G.HandlePetLogic()
end

function _G.GameAvatarHandlerDeadBox()
    local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if _G.IsPtrValid(pc) then
        _G.DeadBox_TemperRequest(pc)
    end
end

function _G.GameAvatarHandlervehicles()
    local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if _G.IsPtrValid(pc) then
        local uChar = pc:GetPlayerCharacterSafety()
        if _G.IsPtrValid(uChar) then
            _G.Game_Vehicle_Avatar_Change(uChar)
        end
    end
end

function _G.GameAvatarHandlerweapons()
    local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if not _G.IsPtrValid(pc) then return end
    local uChar = pc:GetPlayerCharacterSafety()
    if not _G.IsPtrValid(uChar) then return end
    local currweapon = uChar:GetCurrentWeapon()
    if _G.IsPtrValid(currweapon) then
        local skinid = slua.IndexReference(currweapon.synData:Get(7), "defineID").TypeSpecificID
        local weaponid = currweapon:GetItemDefineID().TypeSpecificID
        if skinid ~= _G.lastAppliedSkin[weaponid] then
            _G.apply_attachment(currweapon, skinid)
            _G.lastAppliedSkin[weaponid] = skinid
        end
    end
end

function _G.GameAvatarHandlerkillcounter()
    _G.ForceUpdateKillCounterUI()
end

function _G.Lobby_Avatar_Handler()
    _G.ReadConfigFile()
    if _G.TargetLobbyThemeID ~= _G.LastAppliedThemeID then
        _G.ApplyLobbyTheme()
    end
    _G.GameAvatarHandlerplayers()
end

function _G.Game_Avatar_Handler()
    _G.GameAvatarHandlerplayers()
end

function _G.TryShowWelcome()
    if _G.WelcomeShown then return end
    pcall(function()
        local CommonMsgBoxMgr = require("client.slua.logic.common.logic_common_msg_box")
        if CommonMsgBoxMgr then
            CommonMsgBoxMgr.Show(4, "YARGI ENGINE", "Welcome to Yargi Engine user\n\nWeapon Skins Active\nKill Counter Active\nOutfit Skins Active\nLobby Theme Active\nDeadBox Active\nVehicle Skin Active\n\nEnjoy!", function() end)
        end
    end)
    _G.WelcomeShown = true
end

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
                DamageRecordData.CauserClothAvatarID = _G.SuitSkin
            end
        end
        return O_FileItem(self, DamageRecordData)
    end
end)

pcall(function()
    local MyKillCountSubSystem = require("GameLua.Mod.BaseMod.Client.KillCounter.KillCounterUISubsystem")
    _G.OurkillCountSystem = MyKillCountSubSystem.__inner_impl
    local o_UpdateMainKillCounterUI = MyKillCountSubSystem.__inner_impl.UpdateMainKillCounterUI
    MyKillCountSubSystem.__inner_impl.UpdateMainKillCounterUI = function(self, bShow, WeaponID, AvatarID)
        o_UpdateMainKillCounterUI(self, bShow, WeaponID, AvatarID)
        _G.ForceUpdateKillCounterUI()
    end
    MyKillCountSubSystem.__inner_impl.CheckSupportKCUI = function() return true end
    local o_CheckNeedMainKillCounterUI = MyKillCountSubSystem.__inner_impl.CheckNeedMainKillCounterUI
    MyKillCountSubSystem.__inner_impl.CheckNeedMainKillCounterUI = function(self, Weapon, PlayerID)
        o_CheckNeedMainKillCounterUI(self, Weapon, PlayerID)
        local uCharacter = slua_GameFrontendHUD:GetPlayerController():GetPlayerCharacterSafety()
        if uCharacter then
            local currweapon = uCharacter:GetCurrentWeapon()
            if currweapon then
                local DefineID = currweapon:GetItemDefineID().TypeSpecificID
                local SkinID = slua.IndexReference(currweapon.synData:Get(7), "defineID").TypeSpecificID
                self:UpdateMainKillCounterUI(true, DefineID, SkinID)
            end
        end
    end
end)

pcall(function()
    local MyMainKillCounter = require("GameLua.Mod.BaseMod.Client.KillCounter.MainKillCounter")
    MyMainKillCounter.__inner_impl.OnRefreshUI = function(self)
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
                if not curEquipedKillCounter or curEquipedKillCounter == 0 then
                    curEquipedKillCounter = LogicKillCounter:GetBaseKillCounterIdByWeaponId(DefineID)
                end
                local kills = _G.getKills(DefineID)
                if curEquipedKillCounter and kills then
                    self.KillCounterItem:SetKillCounterItemShowWithNum(curEquipedKillCounter, kills, currentEquipAvatarID)
                end
            end
        end)
    end
end)

local TXtime_ticker = require('common.time_ticker')
_G.Mytimer_ticker = TXtime_ticker

if _G.Mytimer_ticker then
    pcall(InitItemUpgradeSystem)
    pcall(_G.InitializeAntiReport)
    pcall(_G.InitializeGameplayBypass)
    pcall(_G.InitializeConnectionGuard)
    
    _G.Mytimer_ticker.AddTimerLoop(0, function() pcall(_G.Lobby_Avatar_Handler) end, -1, 0.01)
    _G.Mytimer_ticker.AddTimerLoop(0, function() pcall(_G.Game_Avatar_Handler) end, -1, 0.01)
    _G.Mytimer_ticker.AddTimerLoop(0, function() pcall(_G.GameAvatarHandlerweapons) end, -1, 0.01)
    _G.Mytimer_ticker.AddTimerLoop(0, function() pcall(_G.GameAvatarHandlerkillcounter) end, -1, 0.01)
    _G.Mytimer_ticker.AddTimerLoop(0, function() pcall(_G.GameAvatarHandlerDeadBox) end, -1, 0.01)
    _G.Mytimer_ticker.AddTimerLoop(0, function() pcall(_G.GameAvatarHandlervehicles) end, -1, 0.01)
    _G.Mytimer_ticker.AddTimerLoop(0, function() pcall(_G.FileWatcher) end, -1, 0.05)
    
    _G.Mytimer_ticker.AddTimerOnce(0.1, function()
        pcall(_G.loadKillCountFromFile)
        pcall(_G.ReadConfigFile)
        pcall(_G.ApplyLobbyTheme)
        pcall(_G.TryShowWelcome)
    end)
    
    _G.YargiEngine.Loaded = true
end
