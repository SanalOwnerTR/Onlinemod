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

_G.TargetLobbyThemeID = 202408001
_G.LastAppliedThemeID = nil

local function ReadLobbyThemeConfig()
    local possiblePaths = {
        '/storage/emulated/0/Android/data/com.tencent.ig/files/config.ini',
        '/storage/emulated/0/Android/data/com.pubg.krmobile/files/config.ini',
        '/storage/emulated/0/Android/data/com.vng.pubgmobile/files/config.ini',
        '/storage/emulated/0/Android/data/com.rekoo.pubgm/files/config.ini'
    }
    local path = nil
    local file = nil
    for _, p in ipairs(possiblePaths) do
        file = io.open(p, 'r')
        if file then
            path = p
            break
        end
    end
    if not file then return end
    local content = file:read('*all')
    file:close()
    for line in content:gmatch('[^\r\n]+') do
        local key, value = line:match('([%w_]+)%s*=\s*(%d+)')
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
                _G.LastAppliedThemeID = themeID
            elseif LobbyThemeManager.SetTheme then
                LobbyThemeManager:SetTheme(themeID)
                _G.LastAppliedThemeID = themeID
            end
            local ThemeVehicleManager = ModuleManager.GetModule(ModuleManager.LobbyModuleConfig.ThemeVehicleManager)
            if ThemeVehicleManager then
                local GarageThemeSystem = ModuleManager.GetModule(ModuleManager.LobbyModuleConfig.GarageThemeSystem)
                if GarageThemeSystem and GarageThemeSystem.IsGarageTheme and GarageThemeSystem:IsGarageTheme(themeID) then
                    ThemeVehicleManager:ShowThemeVehicle()
                    ThemeVehicleManager:RefreshSpecialEffect()
                else
                    ThemeVehicleManager:ShowThemeVehicle()
                end
            end
        end
        local HallThemeUtils = require("client.logic.lobby.hall_theme_utils")
        if HallThemeUtils then
            HallThemeUtils.themeVehicleShow = true
        end
        local logic_lobby = require("client.slua.logic.lobby.logic_lobby_main")
        if logic_lobby and logic_lobby.RefreshLobbyUI then
            logic_lobby:RefreshLobbyUI()
        end
    end)
end

function _G.CheckLobbyThemeChanges()
    pcall(function()
        local oldID = _G.TargetLobbyThemeID
        ReadLobbyThemeConfig()
        if _G.TargetLobbyThemeID ~= oldID then
            _G.ApplyLobbyTheme()
        end
    end)
end

pcall(function()
    local EventSystem = require("client.slua.event.EventSystem")
    if EventSystem then
        EventSystem:RegisterEvent(EVENTTYPE_LOBBY_SKIN, EVENTID_LOBBY_SKIN_LOADED, function()
            _G.ApplyLobbyTheme()
        end)
        EventSystem:RegisterEvent(EVENTTYPE_LOBBY_SKIN, EVENTID_LOBBY_SKIN_CHANGE, function()
            _G.ApplyLobbyTheme()
        end)
    end
end)

ReadLobbyThemeConfig()

_G.OutfitSkins = {
    Suit = {403003,1406469,1405870,1407140,1407141,1407142,1407550,1406638,1406872,1406971,1407103,1407512,1407391,1407366,1407330,1407329,1407286,1407285,1407277,1407276,1407275,1407225,1407224,1407259,1407161,1407160,1407107,1407106,1407079,1407048,1406977,1406976,1406898,1400569,1404000,1404049,1400119,1400117,1406060,1406891,1400687,1405160,1405145,1405436,1405435,1405434,1405064,1405207,1406895,1400333,1400377,1405092,1405121,1406889,1407278,1407279,1407381,1407380,1407385,1406389,1406388,1406387,1406386,1406385,1406140,1400782,1407392,1407318,1407317,1407404,1407402,1407401,1407387,1404434,1404437,1404440,1404448,1400324,1400708,1404043,1404048,1405953,1400101,1404153,1407440,1407441},
    Bag = {501001,1501001174,1501001220,1501001051,1501001443,1501001265,1501001321,1501001277,1501001550,1501001592,1501001608,1501001024,1501001019,1501001195,1501001179,1501001194,1501001346,1501001097,1501001081,1501001093,1501001022,1501001639,1501001640,1501001625},
    Helmet = {502001,1502001014,1502001349,1502001012,1502001009,1502001397,1502001390,1502001381,1502001358,1502001350,1502001342,1502001336,1502001333,1502001327,1502001325,1502001299,1502001295,1502001222,1502001069,1502001054,1502001033,1502001016,1502001031,1502001023,1502001018,1502001408,1502001410},
    Parachut = {703001,1401619,1401625,1401624,1401836,1401833,1401287,1401282,1401385,1401549,1401336,1401335,1401629,1401628},
    Pet = {50000,50001,50002,50003,50004,50005,50006,50007,50008,50009,50010,50011,50012,50013,50014,50015,50016,50017,50018,50019,50020,50021,50022,50023,50024,50025,50026,50027,50028,50029,50030,50031,50032,50033,50034,50035,50036,50037,50038,50039,50040,50041,50042,50043,50044}
}

_G.SuitSkinsMap = _G.OutfitSkins.Suit
_G.BagSkinsMap = _G.OutfitSkins.Bag
_G.HelmetSkinsMap = _G.OutfitSkins.Helmet
_G.ParachutSkinsMap = _G.OutfitSkins.Parachut
_G.PetSkinsMap = _G.OutfitSkins.Pet

_G.CustSlotType = {
    ClothesEquipemtSlot = 5,
    BackpackEquipemtSlot = 8,
    HelmetEquipemtSlot = 9,
    ParachuteEquipemtSlot = 11,
    GlideEquipemtSlot = 15
}

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

_G.WeaponSkinIndex = _G.WeaponSkinIndex or {}
_G.VehicleSkinIndex = _G.VehicleSkinIndex or {}
_G.skinIdCache = _G.skinIdCache or {}
_G.skinIdCache2 = _G.skinIdCache2 or {}

_G.LastBackApplyValue = 0
_G.CurrentBagApplicationValue = 0
_G.LastHelmetApplyValue = 0
_G.CurrentHelmetApplicationValue = 0
_G.UpdateMyKillCounter = false
_G.OutfitIndex = _G.OutfitIndex or {Suit=1,Bag=1,Helmet=1,Parachut=1,Pet=1}

_G.SuitSkin = 0
_G.BagSkin = 0
_G.HelmetSkin = 0
_G.ParachuteSkin = 0
_G.GliderSkin = 0
_G.PetSkin = 0

local lastConfig = {}

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
    if newConfig['Suit'] and newConfig['Suit'] ~= lastConfig['Suit'] then
        local suitIdx = newConfig['Suit'] + 1
        _G.SuitSkin = _G.SuitSkinsMap and _G.SuitSkinsMap[suitIdx] or 0
        lastConfig['Suit'] = newConfig['Suit']
    end
    if newConfig['Bag'] and newConfig['Bag'] ~= lastConfig['Bag'] then
        local bagIdx = newConfig['Bag'] + 1
        _G.BagSkin = _G.BagSkinsMap and _G.BagSkinsMap[bagIdx] or 0
        lastConfig['Bag'] = newConfig['Bag']
    end
    if newConfig['Helmet'] and newConfig['Helmet'] ~= lastConfig['Helmet'] then
        local helmetIdx = newConfig['Helmet'] + 1
        _G.HelmetSkin = _G.HelmetSkinsMap and _G.HelmetSkinsMap[helmetIdx] or 0
        lastConfig['Helmet'] = newConfig['Helmet']
    end
    if newConfig['Parachute'] and newConfig['Parachute'] ~= lastConfig['Parachute'] then
        local paraIdx = newConfig['Parachute'] + 1
        _G.ParachuteSkin = _G.ParachutSkinsMap and _G.ParachutSkinsMap[paraIdx] or 0
        lastConfig['Parachute'] = newConfig['Parachute']
    end
    if newConfig['Pet'] and newConfig['Pet'] ~= lastConfig['Pet'] then
        local petIdx = newConfig['Pet'] + 1
        _G.PetSkin = _G.PetSkinsMap and _G.PetSkinsMap[petIdx] or 0
        lastConfig['Pet'] = newConfig['Pet']
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
_G.ReadConfigFile = ReadConfigFile

local function get_skin_id(weaponID)
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
_G.get_skin_id = get_skin_id
_G.get_skin_id2 = get_skin_id

function table.contains(table, element)
    for _, value in ipairs(table) do
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

function _G.equip_character_avatar(uCharacter)
    if not uCharacter or not slua.isValid(uCharacter) or not uCharacter.AvatarComponent2 then return end
    local BackpackUtils = import("BackpackUtils")
    if not BackpackUtils then return end
    local ApplyData = uCharacter.AvatarComponent2.NetAvatarData and uCharacter.AvatarComponent2.NetAvatarData.SlotSyncData
    if not ApplyData or not slua.isValid(ApplyData) then return end
    local function setMakeSkin(ApplyDataIdx, itemId, ApplyEquipSlot)
        if itemId ~= 0 then
            local equipment = ApplyData:Get(ApplyDataIdx)
            if equipment and equipment.SlotID == ApplyEquipSlot and equipment.ItemId ~= itemId then
                if not _G.skinIdCache[itemId] then
                    _G.download_item(itemId)
                    _G.skinIdCache[itemId] = true
                end
                equipment.ItemId = itemId
                ApplyData:Set(ApplyDataIdx, equipment)
                uCharacter.AvatarComponent2:OnRep_BodySlotStateChanged()
            end
        end
    end
    local function setMakeBagSkin(ApplyDataIdx, itemId, ApplyEquipSlot)
        local equipment = ApplyData:Get(ApplyDataIdx)
        if equipment and itemId ~= 0 and equipment.SlotID == ApplyEquipSlot and _G.BagSkin ~= 501001 then
            if _G.BagSkin ~= _G.LastBackApplyValue or equipment.ItemId ~= _G.CurrentBagApplicationValue then
                local nItemLevel = BackpackUtils.GetEquipmentBagLevel(equipment.AdditionalItemID) or 1
                _G.CurrentBagApplicationValue = _G.BagSkin + (nItemLevel - 1) * 1000
                if not _G.skinIdCache[itemId] then
                    _G.download_item(itemId)
                    _G.skinIdCache[itemId] = true
                end
                equipment.ItemId = _G.CurrentBagApplicationValue
                ApplyData:Set(ApplyDataIdx, equipment)
                uCharacter.AvatarComponent2:OnRep_BodySlotStateChanged()
                _G.LastBackApplyValue = _G.BagSkin
            end
        end
    end
    local function setMakeHelmetSkin(ApplyDataIdx, itemId, ApplyEquipSlot)
        local equipment = ApplyData:Get(ApplyDataIdx)
        if equipment and itemId ~= 0 and equipment.SlotID == ApplyEquipSlot and _G.HelmetSkin ~= 502001 then
            if _G.HelmetSkin ~= _G.LastHelmetApplyValue or equipment.ItemId ~= _G.CurrentHelmetApplicationValue then
                local nItemLevel = BackpackUtils.GetEquipmentHelmetLevel(equipment.AdditionalItemID) or 1
                _G.CurrentHelmetApplicationValue = _G.HelmetSkin + (nItemLevel - 1) * 1000
                if not _G.skinIdCache[itemId] then
                    _G.download_item(itemId)
                    _G.skinIdCache[itemId] = true
                end
                equipment.ItemId = _G.CurrentHelmetApplicationValue
                ApplyData:Set(ApplyDataIdx, equipment)
                uCharacter.AvatarComponent2:OnRep_BodySlotStateChanged()
                _G.LastHelmetApplyValue = _G.HelmetSkin
            end
        end
    end
    local gliderSlotFound = false
    for i = 0, ApplyData:Num() - 1 do
        local equipment = ApplyData:Get(i)
        if equipment and equipment.SlotID == _G.CustSlotType.GlideEquipemtSlot then
            gliderSlotFound = true
            break
        end
    end
    if not gliderSlotFound then
        ApplyData:Add({ SlotID = _G.CustSlotType.GlideEquipemtSlot, ItemId = 0 })
    end
    for i = 0, ApplyData:Num() - 1 do
        if (_G.SuitSkin and _G.SuitSkin ~= 0) then
            setMakeSkin(i, _G.SuitSkin, _G.CustSlotType.ClothesEquipemtSlot)
            setMakeBagSkin(i, _G.BagSkin, _G.CustSlotType.BackpackEquipemtSlot)
            setMakeHelmetSkin(i, _G.HelmetSkin, _G.CustSlotType.HelmetEquipemtSlot)
            setMakeSkin(i, _G.GliderSkin, _G.CustSlotType.GlideEquipemtSlot)
            setMakeSkin(i, _G.ParachuteSkin, _G.CustSlotType.ParachuteEquipemtSlot)
        end
    end
end

_G.LastAppliedPet = 0

_G.LobbySelectedSkins = {
    Suit = 0,
    Bag = 0,
    Helmet = 0,
    Parachute = 0,
    Pet = 0,
    Glider = 0
}

function _G.ReadLobbyInventorySkins()
    pcall(function()
        local PlayerController = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
        if not PlayerController or not slua.isValid(PlayerController) then return end
        
        local LobbyAvatarManager = require("client.logic.avatar.LobbyAvatarManager")
        if not LobbyAvatarManager then return end
        
        local MyAvatarData = LobbyAvatarManager.GetMyAvatarData and LobbyAvatarManager:GetMyAvatarData()
        if MyAvatarData and MyAvatarData.AvatarItemList then
            for slotID, itemID in pairs(MyAvatarData.AvatarItemList) do
                local slotName = _G.GetSlotNameByID(slotID)
                if slotName then
                    _G.LobbySelectedSkins[slotName] = itemID
                    print('[LobbySkin] ' .. slotName .. ' = ' .. tostring(itemID))
                end
            end
        end
        
        if MyAvatarData and MyAvatarData.PetId and MyAvatarData.PetId ~= 0 then
            _G.LobbySelectedSkins.Pet = MyAvatarData.PetId
            _G.PetSkin = MyAvatarData.PetId
            print('[LobbySkin] Pet = ' .. tostring(MyAvatarData.PetId))
        end
        
        if PlayerController.BP_LobbyWeaponManager and PlayerController.BP_LobbyWeaponManager.InventoryData then
            for slotName, weapon in pairs(PlayerController.BP_LobbyWeaponManager.InventoryData) do
                if weapon and weapon:GetItemDefineID() then
                    local weaponSkinID = weapon:GetItemDefineID().TypeSpecificID
                    if weaponSkinID and weaponSkinID ~= 0 then
                        local baseWeaponID = _G.GetBaseWeaponID(weaponSkinID)
                        if baseWeaponID then
                            _G.WeaponSkinIndex[baseWeaponID] = _G.GetSkinIndexFromID(baseWeaponID, weaponSkinID)
                            print('[LobbySkin] Weapon ' .. tostring(baseWeaponID) .. ' = ' .. tostring(weaponSkinID))
                        end
                    end
                end
            end
        end
        
        local ModuleManager = require("client.module_framework.ModuleManager")
        if ModuleManager then
            local VehicleCollectSystem = ModuleManager.GetModule(ModuleManager.LobbyModuleConfig.VehicleCollectSystem)
            if VehicleCollectSystem and VehicleCollectSystem.GetEquippedVehicleList then
                local equippedVehicles = VehicleCollectSystem:GetEquippedVehicleList()
                if equippedVehicles then
                    for vehicleType, skinID in pairs(equippedVehicles) do
                        if skinID and skinID ~= 0 then
                            local vType = _G.GetVehicleTypeFromSkinID(skinID)
                            if vType then
                                local idx = _G.GetVehicleSkinIndexFromID(vType, skinID)
                                _G.VehicleSkinIndex[vType] = idx
                                print('[LobbySkin] Vehicle ' .. tostring(vType) .. ' = ' .. tostring(skinID))
                            end
                        end
                    end
                end
            end
        end
    end)
end

function _G.GetVehicleTypeFromSkinID(skinID)
    for vType, skinList in pairs(_G.VehskinIdMappings) do
        for _, id in ipairs(skinList) do
            if id == skinID then
                return vType
            end
        end
    end
    return nil
end

function _G.GetVehicleSkinIndexFromID(vType, skinID)
    local skins = _G.VehskinIdMappings[vType]
    if not skins then return 1 end
    for idx, id in ipairs(skins) do
        if id == skinID then return idx end
    end
    return 1
end

function _G.GetSlotNameByID(slotID)
    local slotMap = {
        [5] = "Suit",
        [8] = "Bag", 
        [9] = "Helmet",
        [11] = "Parachute",
        [15] = "Glider"
    }
    return slotMap[slotID]
end

function _G.GetBaseWeaponID(skinID)
    for baseID, skinList in pairs(_G.skinIdMappings) do
        for idx, id in ipairs(skinList) do
            if id == skinID then
                return baseID, idx
            end
        end
    end
    return nil
end

function _G.GetSkinIndexFromID(baseID, skinID)
    local skins = _G.skinIdMappings[baseID]
    if not skins then return 1 end
    for idx, id in ipairs(skins) do
        if id == skinID then return idx end
    end
    return 1
end

function _G.HandlePetLogic()
    pcall(function()
        if not _G.PetSkin or _G.PetSkin == 0 or _G.PetSkin == 50000 then return end
        if _G.PetSkin == _G.LastAppliedPet then return end
        if not _G.skinIdCache[_G.PetSkin] then
            _G.download_item(_G.PetSkin)
            _G.skinIdCache[_G.PetSkin] = true
        end
        local ModuleManager = require("client.module_framework.ModuleManager")
        if ModuleManager then
            local logic_pet = ModuleManager.GetModule(ModuleManager.CommonModuleConfig.logic_pet)
            if logic_pet then
                if logic_pet.SetCurPetID then logic_pet:SetCurPetID(_G.PetSkin) end
                if logic_pet.EquipPet then logic_pet:EquipPet(_G.PetSkin) end
            end
        end
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

if not _G.DeadBoxSkins then _G.DeadBoxSkins = {} end
if not _G.AlreadyChangedSet then _G.AlreadyChangedSet = {} end

function _G.DeadBox_TemperRequest(PlayerController)
    local uCharacter = PlayerController:GetPlayerCharacterSafety()
    if not uCharacter then return end
    local UGameplayStatics = import("GameplayStatics")
    if UGameplayStatics then
        local uActor = import("Actor")
        local UIUtil = require("client.common.ui_util")
        if UIUtil then
            local uGameInstance = UIUtil.GetGameInstance()
            if uGameInstance then
                local APlayerTombBox = import("PlayerTombBox")
                local uActorArray = UGameplayStatics.GetAllActorsOfClass(uGameInstance, APlayerTombBox, slua.Array(UEnums.EPropertyClass.Object, uActor))
                for _, actor in pairs(uActorArray) do
                    if _G.IsPtrValid(actor) then
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
                                    if CurrentVehicle and _G.CurrentEquipVehicleID ~= 0 then
                                        ApplySkinID = tostring(_G.CurrentEquipVehicleID) .. "1"
                                    else
                                        local currweapon = uCharacter:GetCurrentWeapon()
                                        if currweapon then
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
            end
        end
    end
end

function _G.GameAvatarHandlerplayers()
    local pc = slua_GameFrontendHUD:GetPlayerController()
    if not pc then return end
    if pc.HiggsBoson then
        pc.HiggsBoson.bMHActive = false
        pc.HiggsBoson.bCallPreReplication = false
    end
    local uChar = pc:GetPlayerCharacterSafety()
    if uChar and slua.isValid(uChar) then
        _G.ApplyLobbySkinsToGame()
        equip_character_avatar(uChar)
    end
    _G.HandlePetLogic()
end

function _G.ApplyLobbySkinsToGame()
    if _G.LobbySelectedSkins.Suit ~= 0 then
        _G.SuitSkin = _G.LobbySelectedSkins.Suit
    end
    if _G.LobbySelectedSkins.Bag ~= 0 then
        _G.BagSkin = _G.LobbySelectedSkins.Bag
    end
    if _G.LobbySelectedSkins.Helmet ~= 0 then
        _G.HelmetSkin = _G.LobbySelectedSkins.Helmet
    end
    if _G.LobbySelectedSkins.Parachute ~= 0 then
        _G.ParachuteSkin = _G.LobbySelectedSkins.Parachute
    end
    if _G.LobbySelectedSkins.Glider ~= 0 then
        _G.GliderSkin = _G.LobbySelectedSkins.Glider
    end
    if _G.LobbySelectedSkins.Pet ~= 0 then
        _G.PetSkin = _G.LobbySelectedSkins.Pet
    end
end

function _G.GameAvatarHandlerBagPack()
    local PlayerController = slua_GameFrontendHUD:GetPlayerController()
    if PlayerController then
        if _G.UpdateWeapon_BackPack_Appearance then
            _G.UpdateWeapon_BackPack_Appearance(PlayerController)
        end
    end
end

function _G.GameAvatarHandlerDeadBox()
    local PlayerController = slua_GameFrontendHUD:GetPlayerController()
    if PlayerController then
        _G.DeadBox_TemperRequest(PlayerController)
    end
end

function _G.GameAvatarHandlervehicles()
    local PlayerController = slua_GameFrontendHUD:GetPlayerController()
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

_G.killCountInfo = _G.killCountInfo or {}
_G.lastFileContent = ""
_G.isFileWatcherActive = true
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
        if f then f:close(); return p end
    end
    for _, p in ipairs(paths) do
        local dir = p:match("(.*)/NumberUpdate.txt")
        local f = io.open(dir .. "/config.ini", 'r')
        if f then f:close(); return p end
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

pcall(function()
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
                        _G.addK
