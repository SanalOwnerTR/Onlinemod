_G.TargetLobbyThemeID = 202408001
_G.LastAppliedThemeID = nil

local function ReadLobbyThemeConfig()
    -- Array of all supported versions
    local possiblePaths = {
        '/storage/emulated/0/Android/data/com.tencent.ig/files/config.ini',       -- Global
        '/storage/emulated/0/Android/data/com.pubg.krmobile/files/config.ini',    -- Korea
        '/storage/emulated/0/Android/data/com.vng.pubgmobile/files/config.ini',   -- Vietnam
        '/storage/emulated/0/Android/data/com.rekoo.pubgm/files/config.ini'       -- Taiwan
    }
    
    local path = nil
    local file = nil
    
    -- Find valid config file
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
        local key, value = line:match('([%w_]+)%s*=%s*(%d+)')
        if key == 'LobbyTheme' then
            local newID = tonumber(value)
            if newID and newID ~= _G.TargetLobbyThemeID then
                print('[LobbyTheme] Config changed to: ' .. tostring(newID) .. ' (Path: '..path..')')
                _G.TargetLobbyThemeID = newID
            end
        end
    end
end

function _G.ApplyLobbyTheme()
    pcall(function()
        local themeID = _G.TargetLobbyThemeID
        if not themeID or themeID == 0 or _G.LastAppliedThemeID == themeID then 
            return 
        end
        //esp maaz @maaz_xd
        print('[LobbyTheme] ========== Applying: ' .. tostring(themeID) .. ' ==========')
        
        local ModuleManager = require('client.module_framework.ModuleManager')
        if not ModuleManager then return end
          //esp maaz @maaz_xd
        local LobbyThemeManager = ModuleManager.GetModule(ModuleManager.LobbyModuleConfig.LobbyThemeManager)
        if LobbyThemeManager then
            if LobbyThemeManager.ShowThemeByItemID then
                print('[LobbyTheme] Using ShowThemeByItemID')
                LobbyThemeManager:ShowThemeByItemID(themeID)
                _G.LastAppliedThemeID = themeID
            elseif LobbyThemeManager.SetTheme then
                print('[LobbyTheme] Using SetTheme')
                LobbyThemeManager:SetTheme(themeID)
                _G.LastAppliedThemeID = themeID
            end
              //esp maaz @maaz_xd
            local ThemeVehicleManager = ModuleManager.GetModule(ModuleManager.LobbyModuleConfig.ThemeVehicleManager)
            if ThemeVehicleManager then
                local GarageThemeSystem = ModuleManager.GetModule(ModuleManager.LobbyModuleConfig.GarageThemeSystem)
                if GarageThemeSystem and GarageThemeSystem.IsGarageTheme and GarageThemeSystem:IsGarageTheme(themeID) then
                    print('[LobbyTheme] Garage theme detected, showing vehicles')
                    ThemeVehicleManager:ShowThemeVehicle()
                    ThemeVehicleManager:RefreshSpecialEffect()
                else
                    print('[LobbyTheme] Regular theme')
                    ThemeVehicleManager:ShowThemeVehicle()
                end
            end
            
            print('[LobbyTheme] Theme applied successfully!')
        else
            print('[LobbyTheme] ERROR: LobbyThemeManager not found')
        end
        
        local HallThemeUtils = require('client.logic.lobby.hall_theme_utils')
        if HallThemeUtils then
            HallThemeUtils.themeVehicleShow = true
            print('[LobbyTheme] HallThemeUtils updated')
        end
        
        local logic_lobby = require('client.slua.logic.lobby.logic_lobby_main')
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
            print('[LobbyTheme] Change detected!')
            _G.ApplyLobbyTheme()
        end
    end)
end

pcall(function()
    local EventSystem = require('client.slua.event.EventSystem')
    if EventSystem then
        EventSystem:RegisterEvent(EVENTTYPE_LOBBY_SKIN, EVENTID_LOBBY_SKIN_LOADED, function()
            print('[LobbyTheme] EVENTID_LOBBY_SKIN_LOADED triggered')
            _G.ApplyLobbyTheme()
        end)
        
        EventSystem:RegisterEvent(EVENTTYPE_LOBBY_SKIN, EVENTID_LOBBY_SKIN_CHANGE, function()
            print('[LobbyTheme] EVENTID_LOBBY_SKIN_CHANGE triggered')
            _G.ApplyLobbyTheme()
        end)
        
        print('[LobbyTheme] Events registered')
    end
end)

ReadLobbyThemeConfig()
print('[LobbyTheme] System ready. Theme ID: ' .. tostring(_G.TargetLobbyThemeID))
_G.OutfitSkins = {
    Suit = {403003,1406469,1405870,1407140,1407141,1407142,1407550,1406638,1406872,1406971,1407103,1407512,1407391,1407366,1407330,1407329,1407286,1407285,1407277,1407276,1407275,1407225,1407224,1407259,1407161,1407160,1407107,1407106,1407079,1407048,1406977,1406976,1406898,1400569,1404000,1404049,1400119,1400117,1406060,1406891,1400687,1405160,1405145,1405436,1405435,1405434,1405064,1405207,1406895,1400333,1400377,1405092,1405121,1406889,1407278,1407279,1407381,1407380,1407385,1406389,1406388,1406387,1406386,1406385,1406140,1400782,1407392,1407318,1407317,1407404,1407402,1407401,1407387,1404434,1404437,1404440,1404448,1400324,1400708,1404043,1404048,1405953,1400101,1404153,1407440,1407441},
    Bag = {501001,1501001174,1501001220,1501001051,1501001443,1501001265,1501001321,1501001277,1501001550,1501001592,1501001608,1501001024,1501001019,1501001195,1501001179,1501001194,1501001346,1501001097,1501001081,1501001093,1501001022,1501001639,1501001640,1501001625},
    Helmet = {502001,1502001014,1502001349,1502001012,1502001009,1502001397,1502001390,1502001381,1502001358,1502001350,1502001342,1502001336,1502001333,1502001327,1502001325,1502001299,1502001295,1502001222,1502001069,1502001054,1502001033,1502001016,1502001031,1502001023,1502001018,1502001408,1502001410},
    Parachut = {703001,1401619,1401625,1401624,1401836,1401833,1401287,1401282,1401385,1401549,1401336,1401335,1401629,1401628},
	
       Pet = {
        50000,  -- Default (No Pet)
        50001,  -- Falcon
        50002,  -- German Shepherd
        50003,  -- Buddy Godzilla
        50004,  -- Buddy Kong
        50005,  -- Poro
        50006,  -- Cathy
        50007,  -- Buddy Tyl Regor
        50008,  -- Kitten
        50009,  -- Shiba Inu
        50010,  -- Buddy Pen Pen
        50011,  -- GB Teddy Bear
        50012,  -- Robin Hood Teddy Bear
        50013,  -- Sherlock Holmes Teddy Bear
        50014,  -- Spirit Kitty
        50015,  -- Baron Pumpkin Buddy
        50016,  -- Fiery Scarecrow Buddy
        50017,  -- Arctic Wolf
        50018,  -- Panda Disciple Buddy
        50019,  -- Drunkfist Panda Buddy
        50020,  -- Fighter Panda Buddy
        50021,  -- Lv. 3 Helmet BE@RBRICK Buddy
        50022,  -- Ghillie Suit BE@RBRICK Buddy
        50023,  -- Air Drop BE@RBRICK Buddy
        50024,  -- Underworld Guide BE@RBRICK Buddy
        50025,  -- Roaming Raptor
        50026,  -- Baby Bones
        50027,  -- Buddy Karin
        50028,  -- Buddy Pilaf
        50029,  -- Buddy Pilaf (Kid)
        50030,  -- Ghosty Jr. Buddy
        50031,  -- Snowrascal Buddy
        50032,  -- LINE FRIENDS Buddy SALLY
        50033,  -- Lion Buddy
        50034,  -- Leopard Buddy
        50035,  -- Zanmang Loopy Buddy
        50036,  -- Grizzly Bear Buddy
        50037,  -- Panda Buddy
        50038,  -- King Ghidorah Buddy
        50039,  -- Burning Godzilla Buddy
        50040,  -- Mini Colossal Titan Buddy
        50041,  -- Tiger Buddy
        50042,  -- Sonic Buddy
        50043,  -- Puffy Penguin Buddy
        50044,  -- Cocoa Cub Buddy
		}
}

_G.SuitSkinsMap = _G.OutfitSkins.Suit
_G.BagSkinsMap = _G.OutfitSkins.Bag
_G.HelmetSkinsMap = _G.OutfitSkins.Helmet
_G.ParachutSkinsMap = _G.OutfitSkins.Parachut
_G.PetSkinsMap = _G.OutfitSkins.Pet -- New Map

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

_G.LastBackApplyValue = 0
_G.CurrentBagApplicationValue = 0
_G.LastHelmetApplyValue = 0
_G.CurrentHelmetApplicationValue = 0
_G.UpdateMyKillCounter = false
_G.OutfitIndex = _G.OutfitIndex or {Suit=1,Bag=1,Helmet=1,Parachut=1,Pet=1}
_G.WeaponSkinIndex = _G.WeaponSkinIndex or {}

_G.SuitSkin = 0
_G.BagSkin = 0
_G.HelmetSkin = 0
_G.ParachuteSkin = 0
_G.GliderSkin = 0
_G.PetSkin = 0 -- Init Pet

local lastConfig = {}

local function ReadConfigFile()
    -- Include all possible paths for Global, KR, VN, TW
    local possiblePaths = {
        '/storage/emulated/0/Android/data/com.tencent.ig/files/config.ini',
        '/storage/emulated/0/Android/data/com.pubg.krmobile/files/config.ini',
        '/storage/emulated/0/Android/data/com.vng.pubgmobile/files/config.ini',
        '/storage/emulated/0/Android/data/com.rekoo.pubgm/files/config.ini',
        '/storage/emulated/0/config.ini' -- Backup
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
        print('[Config] SuitSkin updated to: ' .. tostring(_G.SuitSkin))
    end
    
    if newConfig['Bag'] and newConfig['Bag'] ~= lastConfig['Bag'] then
        local bagIdx = newConfig['Bag'] + 1
        _G.BagSkin = _G.BagSkinsMap and _G.BagSkinsMap[bagIdx] or 0
        lastConfig['Bag'] = newConfig['Bag']
        print('[Config] BagSkin updated to: ' .. tostring(_G.BagSkin))
    end
    
    if newConfig['Helmet'] and newConfig['Helmet'] ~= lastConfig['Helmet'] then
        local helmetIdx = newConfig['Helmet'] + 1
        _G.HelmetSkin = _G.HelmetSkinsMap and _G.HelmetSkinsMap[helmetIdx] or 0
        lastConfig['Helmet'] = newConfig['Helmet']
        print('[Config] HelmetSkin updated to: ' .. tostring(_G.HelmetSkin))
    end
    
    if newConfig['Parachute'] and newConfig['Parachute'] ~= lastConfig['Parachute'] then
        local paraIdx = newConfig['Parachute'] + 1
        _G.ParachuteSkin = _G.ParachutSkinsMap and _G.ParachutSkinsMap[paraIdx] or 0
        lastConfig['Parachute'] = newConfig['Parachute']
        print('[Config] ParachuteSkin updated to: ' .. tostring(_G.ParachuteSkin))
    end

    -- Pet Config Reader
    if newConfig['Pet'] and newConfig['Pet'] ~= lastConfig['Pet'] then
        local petIdx = newConfig['Pet'] + 1
        _G.PetSkin = _G.PetSkinsMap and _G.PetSkinsMap[petIdx] or 0
        lastConfig['Pet'] = newConfig['Pet']
        print('[Config] PetSkin updated to: ' .. tostring(_G.PetSkin))
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

local function get_skin_id(weaponID)
    if not weaponID then return nil end
    local index = (_G.WeaponSkinIndex and _G.WeaponSkinIndex[weaponID]) or 1
    local weaponSkins = _G.skinIdMappings[weaponID]
    if not weaponSkins then return weaponID end
    local skinID = weaponSkins[index]
    if not skinID then return weaponID end
    if not _G.skinIdCache2[skinID] then
        pcall(_G.download_item, skinID) 
        _G.skinIdCache2[skinID] = true
    end
    return skinID
end
_G.get_skin_id = get_skin_id
_G.get_skin_id2 = get_skin_id
-- ============================================================
-- AVATAR HANDLERS: PLAYER, PET, DEADBOX, BACKPACK, DAMAGE UI
-- ============================================================

-- 1. Helper Functions
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

-- 2. Player Avatar Equip
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
            setMakeSkin(i, _G.PantSkin, _G.CustSlotType.PantsEquipemtSlot)
            setMakeSkin(i, _G.FaceSkin, _G.CustSlotType.HeadEquipemtSlot)
            setMakeSkin(i, _G.ShoeSkin, _G.CustSlotType.ShoesEquipemtSlot)
            setMakeSkin(i, _G.HairSkin, _G.CustSlotType.HairEquipemtSlot)
            setMakeSkin(i, _G.CapSkin, _G.CustSlotType.HatEquipemtSlot)
            setMakeSkin(i, _G.GlassSkin, _G.CustSlotType.GlassEquipemtSlot)
            setMakeSkin(i, _G.MaskSkin, _G.CustSlotType.FaceEquipemtSlot)
            setMakeBagSkin(i, _G.BagSkin, _G.CustSlotType.BackpackEquipemtSlot)
            setMakeHelmetSkin(i, _G.HelmetSkin, _G.CustSlotType.HelmetEquipemtSlot)
            setMakeSkin(i, _G.GliderSkin, _G.CustSlotType.GlideEquipemtSlot)
            setMakeSkin(i, _G.ParachuteSkin, _G.CustSlotType.ParachuteEquipemtSlot)
        end
    end
end

-- 3. Pet Handler
_G.LastAppliedPet = 0
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

-- 4. DeadBox Handler
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

-- 5. Main Handlers (Called by Timers)
function _G.GameAvatarHandlerplayers()
    local pc = slua_GameFrontendHUD:GetPlayerController()
    if not pc then return end
    
    if pc.HiggsBoson then
        pc.HiggsBoson.bMHActive = false
        pc.HiggsBoson.bCallPreReplication = false
    end
    
    local uChar = pc:GetPlayerCharacterSafety()
    if uChar and slua.isValid(uChar) then
        equip_character_avatar(uChar)
    end
    _G.HandlePetLogic()
end

function _G.GameAvatarHandlerBagPack()
    local PlayerController = slua_GameFrontendHUD:GetPlayerController()
    if PlayerController then
        -- This function needs to be defined in your weapon/backpack logic script if not here
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
    if PlayerController then
        local uCharacter = PlayerController:GetPlayerCharacterSafety()
        if uCharacter and _G.Game_Vehicle_Avatar_Change then
            _G.Game_Vehicle_Avatar_Change(uCharacter)
        end
    end
end

-- 6. Damage Number UI Hook
pcall(function()
    local MyDamageNumMainUI = require("GameLua.Mod.Library.Client.UI.DamageNumMainUI")
    if MyDamageNumMainUI then
        local UWidgetLayoutLibrary = import("WidgetLayoutLibrary")
        local GameplayData = require("GameLua.GameCore.Data.GameplayData")
        
        MyDamageNumMainUI.__inner_impl.ShowDamage = function(self, Damage, X, Y, Z, uFSlateColor, nFontSize)
            if not self.FlyNumItemPool or Damage == 0 then return end
            
            local Item = self.FlyNumItemPool:GetOneItem()
            self.UIRoot.CanvasPanel_28:AddChild(Item)
            
            local damageInfo = { item = Item, worldPosition = FVector(X, Y, Z), updateHandle = nil }
            local uPlayerController = GameplayData.GetPlayerController()
            
            local function UpdateScreenPosition()
                if slua.isValid(damageInfo.item) then
                    local ScreenPos = UWidgetLayoutLibrary.ProjectWorldLocationToWidgetPositionReturnValue(uPlayerController, damageInfo.worldPosition)
                    if ScreenPos then damageInfo.item:SetRenderTranslation(ScreenPos) end
                end
            end
            
            UpdateScreenPosition()
            
            damageInfo.updateHandle = self:AddGameTimer(0.016, true, function()
                if slua.isValid(damageInfo.item) then UpdateScreenPosition()
                else if damageInfo.updateHandle then self:RemoveGameTimer(damageInfo.updateHandle) end end
            end)
            
            Item.DamageText:SetText(tostring(Damage))
            
            if slua.isValid(uFSlateColor) then Item.DamageText:SetColorAndOpacity(uFSlateColor)
            else Item.DamageText:SetColorAndOpacity(FSlateColor(FLinearColor(1, 1, 1, 1))) end
            
            local Font = Item.DamageText.Font
            Font.Size = (nFontSize and type(nFontSize) == "number") and nFontSize or 18
            Item.DamageText:SetFont(Font)
            
            local animTime = 5.0
            if _G.bFadeAnim then
                Item:PlayAnimation(Item.Fadein, 0, 1, 0, 1)
                animTime = Item.Fadein:GetEndTime()
            end
            
            self:AddGameTimer(animTime, false, function()
                if slua.isValid(Item) then
                    if damageInfo.updateHandle then self:RemoveGameTimer(damageInfo.updateHandle) end
                    self.FlyNumItemPool:FreeOneItem(Item)
                end
            end)
        end
    end
end)

print('[AvatarHandler] Player, Pet, DeadBox, BackPack & DamageUI Ready!')
function _G.InitializeAntiReport()
    print('[AntiReport] Initializing System...')

    pcall(function()
        local paths = {
            "GameLua.Mod.BaseMod.Client.Security.ClientReportPlayerSubsystem",
            "Client.Security.ClientReportPlayerSubsystem" -- Short path backup
        }
        
        local ClientReport = nil
        for _, path in ipairs(paths) do
            if package.loaded[path] then ClientReport = package.loaded[path] break end
            local status, lib = pcall(require, path)
            if status and lib then ClientReport = lib break end
        end

        if ClientReport then
            print('[AntiReport] Found ClientReportPlayerSubsystem')
            
            ClientReport.OnInit = function(self) print('[Block] Client:OnInit') return end
            
            ClientReport._OnPlayerKilledOtherPlayer = function() print('[Block] _OnPlayerKilledOtherPlayer') return end
            ClientReport._RecordFatalDamager = function() return end
            ClientReport._OnDeathReplayDataWhenFatalDamaged = function() return end
            ClientReport._RecordMurdererFromDeathReplayData = function() return end
            
            ClientReport._RecordTeammatePlayerInfo = function() return end
            ClientReport._OnBattleResult = function() print('[Block] Client:_OnBattleResult') return end
            
            ClientReport._OnShowQuickReportMutualExclusiveUI = function() return end
            
            ClientReport.GetFatalDamagerMap = function() return {} end
            ClientReport.GetCachedTeammateName2InfoMap = function() return {} end
            ClientReport.GetTeammateName2InfoMapDuringBattle = function() return {} end
            ClientReport.GetCurrentNotInTeamHistoricalTeammateMap = function() return {} end
            ClientReport.GetInTeamIndexFromHistoricalTeammateInfo = function() return -1 end
        end
    end)

    pcall(function()
        local paths = {
            "GameLua.Mod.BaseMod.DS.Security.DSReportPlayerSubsystem", -- From your provided code class name
            "GameLua.Mod.BaseMod.Client.Security.DSReportPlayerSubsystem" -- Common path
        }
        
        local DSReport = nil
        for _, path in ipairs(paths) do
            if package.loaded[path] then DSReport = package.loaded[path] break end
            local status, lib = pcall(require, path)
            if status and lib then DSReport = lib break end
        end

        if DSReport then
            print('[AntiReport] Found DSReportPlayerSubsystem')
            
            DSReport.OnInit = function(self) print('[Block] DS:OnInit') return end
            DSReport._OnNearDeathOrRescued = function() print('[Block] DS:_OnNearDeathOrRescued') return end
            DSReport._OnCharacterDied = function() print('[Block] DS:_OnCharacterDied') return end
            DSReport._OnTeammateDamage = function() return end
            DSReport._OnPlayerSettlementStart = function() print('[Block] DS:_OnPlayerSettlementStart') return end
            
            DSReport._AddKnockDownerToBattleResult = function() return end
            DSReport._AddKillerToBattleResult = function() return end
            DSReport._AddTeammateMurderToBattleResult = function() return end
            DSReport._AddFatalDamagerMapToBattleResult = function() return end
            DSReport._AddMLKillerUIDToBattleResult = function() return end
            DSReport._SaveHistoricalTeammateInfo = function() return end
            DSReport._RecordFatalDamager = function() return end
            DSReport._RecordTeammateMurderer = function() return end
        end
    end)

    pcall(function()
        local ReportPlayerUtils = require("GameLua.Mod.BaseMod.Common.Security.ReportPlayerUtils")
        if ReportPlayerUtils then
            ReportPlayerUtils.RecordFatalDamager = function() print('[Block] ReportPlayerUtils:RecordFatalDamager') return end
            ReportPlayerUtils.IsUsingHistoricalTeammateInfo = function() return false end
            ReportPlayerUtils.IsCharacterDeliverAI = function() return false end
        end
    end)

    pcall(function()
        local SecurityCommonUtils = require("GameLua.Mod.BaseMod.Common.Security.SecurityCommonUtils")
        if SecurityCommonUtils then
            SecurityCommonUtils.ExtractPlayerBasicInfo = function() return {} end
            SecurityCommonUtils.LogIf = function() return false end
        end
    end)

    pcall(function()
        local HiggsBosonComponent = require("GameLua.Mod.BaseMod.Common.Security.HiggsBosonComponent")
        if HiggsBosonComponent then
            HiggsBosonComponent.StaticShowSecurityAlertInDev = function() return end
        end
    end)

    pcall(function()
        local QuickReport = require("GameLua.Mod.BaseMod.Client.Security.ClientQuickReportMaliciousTeammate")
        if QuickReport then
            QuickReport.OnShowMutualExclusiveUI = function() return end
            QuickReport.OnHideMutualExclusiveUI = function() return end
        end
    end)

    print('[AntiReport] System Fully Active!')
end

_G.InitializeAntiReport()
-- one-time guard
_G.WelcomeShown = _G.WelcomeShown or false
function _G.TryShowWelcome()
    if _G.WelcomeShown then
        return
    end
    pcall(function()
        local CommonMsgBoxMgr = require("client.slua.logic.common.logic_common_msg_box")
        local WebviewSDK = require("client.slua.logic.url.logic_webview_sdk")
        
        if not CommonMsgBoxMgr then
            print("[Lua] Error: CommonMsgBoxMgr not found!")
            return
        end
        
        -- click callback 2
        local function onClick2()
            for i = 1, 1 do
                ShowNotice("[CHEAT ENGINE] " .. i)
            end
        end
        
        local function onClick1()
            -- Open website using WebviewSDK
            if WebviewSDK then
                WebviewSDK:OpenURL("https://t.me/XD_SAITMA")
            end
            
            CommonMsgBoxMgr.Show(
                1,
                "PUBG",
                "[ LET THE FUN BEGIN ]",
                onClick2
            )
            ShowNotice("[PUBG] NOW ENJOY.")
        end
        
        CommonMsgBoxMgr.Show(
            4,
            "Hack XD",
            "Welcome to Hack XD\n\n" ..
            "Join To Channle First...\n\n" ..
            "[ NEED TO ENJOY ]",
            onClick1
        )
        -- mark as shown
        _G.WelcomeShown = true
    end)
end
_G.killCountInfo = {}
_G.lastAppliedSkin = {}
_G.lastAppliedAttachments = {}
_G.killCounterUIUpdateQueue = {}
_G.lastFileContent = ""
_G.isFileWatcherActive = false

-- Dynamic path detection for KillCounter (Writing)
function _G.GetKillCounterPath()
    local possiblePaths = {
        '/storage/emulated/0/Android/data/com.tencent.ig/files/NumberUpdate.txt',
        '/storage/emulated/0/Android/data/com.pubg.krmobile/files/NumberUpdate.txt',
        '/storage/emulated/0/Android/data/com.vng.pubgmobile/files/NumberUpdate.txt',
        '/storage/emulated/0/Android/data/com.rekoo.pubgm/files/NumberUpdate.txt'
    }
    
    -- Try to find existing file
    for _, path in ipairs(possiblePaths) do
        local file = io.open(path, 'r')
        if file then
            file:close()
            return path
        end
    end
    
    -- If no file, try to find writable directory
    for _, path in ipairs(possiblePaths) do
        local dir = path:match("(.*)/NumberUpdate.txt")
        -- Simple check: try open config in that dir to see if folder exists
        local f = io.open(dir .. "/config.ini", 'r') -- check if config exists in that folder
        if f then
            f:close()
            return path -- Return this path to write new file
        end
    end
    
    -- Default fallback
    return '/storage/emulated/0/Android/data/com.tencent.ig/files/NumberUpdate.txt'
end

_G.ActiveKillCounterPath = nil

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

function _G.ForceUpdateKillCounterUI()
    pcall(function()
        local PlayerController = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
        if not PlayerController or not slua.isValid(PlayerController) then return end
        
        local uCharacter = PlayerController:GetPlayerCharacterSafety()
        if not uCharacter or not slua.isValid(uCharacter) then return end
        
        local currweapon = uCharacter:GetCurrentWeapon()
        if not currweapon or not slua.isValid(currweapon) then return end
        
        local DefineID = currweapon:GetItemDefineID() and 
                         currweapon:GetItemDefineID().TypeSpecificID or 0
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
            
            local kills = _G.getKills(DefineID)
            
            MainKillCounter:SetKillCounterItemShowWithNum(
                curEquipedKillCounter, 
                kills,
                currentEquipAvatarID
            )
            
            if MainKillCounter.KillCounterItem and MainKillCounter.KillCounterItem.SetVisibility then
                local ESlateVisibility = import("ESlateVisibility")
                MainKillCounter.KillCounterItem:SetVisibility(ESlateVisibility.Collapsed)
                MainKillCounter.KillCounterItem:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            end
            
            print('[KillCounter] UI Refreshed! Kills: ' .. kills)
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
        
        -- Parse Content
        local tempTable = {}
        for weaponID, count in currentContent:gmatch('%[(%d+)%]%s*=%s*(%d+)') do
            tempTable[tonumber(weaponID)] = tonumber(count)
        end
        
        if not next(tempTable) then return end
        
        _G.killCountInfo = tempTable
        
        _G.ForceUpdateKillCounterUI()
        
        print('[FileWatcher] File changed! Force updating UI...')
    end)
end

function _G.addKill(weaponID, count)
    if not weaponID or not count then return end

    _G.killCountInfo[weaponID] =
        (_G.killCountInfo[weaponID] or 0) + count

    pcall(saveKillCountToFile)

    local PlayerController = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if PlayerController then
        local uCharacter = PlayerController:GetPlayerCharacterSafety()
        if uCharacter then
            local currweapon = uCharacter:GetCurrentWeapon()
            if currweapon then
                local SkinID = slua.IndexReference(
                    currweapon.synData:Get(7),
                    "defineID"
                ).TypeSpecificID

                _G.OurkillCountSystem:UpdateMainKillCounterUI(
                    true,
                    weaponID,
                    SkinID
                )
            end
        end
    end
end


local SKillInfo = require("GameLua.Mod.BaseMod.Client.KillInfoTips.KillInfo")
local ECharacterHealthStatus = import("ECharacterHealthStatus")

local SKillInfoModuleManager = require("client.module_framework.ModuleManager")
local O_FileItem = SKillInfo.__inner_impl.FileItem

SKillInfo.__inner_impl.FileItem = function(self, DamageRecordData)
    if not self or not DamageRecordData then 
        return O_FileItem(self, DamageRecordData) 
    end

    local LogicKillCounter = SKillInfoModuleManager.GetModule(
        SKillInfoModuleManager.CommonModuleConfig.LogicKillCounter
    )
    if not LogicKillCounter then 
        return O_FileItem(self, DamageRecordData) 
    end

    local uCharacter = slua_GameFrontendHUD and 
                       slua_GameFrontendHUD:GetPlayerController() and
                       slua_GameFrontendHUD:GetPlayerController():GetPlayerCharacterSafety()
    if not uCharacter or not slua.isValid(uCharacter) then 
        return O_FileItem(self, DamageRecordData) 
    end

    local SelfName = uCharacter:GetPlayerNameSafety()
    if DamageRecordData.Causer == SelfName then
        local currWeapon = uCharacter:GetCurrentWeapon()
        if currWeapon and slua.isValid(currWeapon) then
            local DefineID = currWeapon:GetItemDefineID() and 
                             currWeapon:GetItemDefineID().TypeSpecificID or 0
            
            if DefineID ~= 0 then
                local ExpandData = slua.LuaArchiverDecode(
                    LuaStateWrapper, 
                    DamageRecordData.ExpandDataContent
                ) or {}
                
                local SupportKillCounter = LogicKillCounter:GetBaseKillCounterIdByWeaponId(DefineID)
                
                if SupportKillCounter and 
                   DamageRecordData.ResultHealthStatus == ECharacterHealthStatus.FinishedLastBreath then
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
                
                DamageRecordData.ExpandDataContent = slua.LuaArchiverEncode(
                    LuaStateWrapper, 
                    ExpandData
                )
            end
        end
    end

    O_FileItem(self, DamageRecordData)
end

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
            
            self.KillCounterItem:SetKillCounterItemShowWithNum(
                curEquipedKillCounter, 
                _G.getKills(DefineID),
                currentEquipAvatarID
            )
        end
    end)
end

MyKillCountSubSystem.__inner_impl.CheckSupportKCUI = function(self)
    return true
end

o_CheckNeedMainKillCounterUI = MyKillCountSubSystem.__inner_impl.CheckNeedMainKillCounterUI
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
                        MainKillCounter:SetKillCounterItemShowWithNum(
                            curEquipedKillCounter, 
                            _G.getKills(DefineID),
                            currentEquipAvatarID
                        )
                    end
                else
                    MainKillCounter:UpdateWeaponID(DefineID, currentEquipAvatarID)
                    MainKillCounter:SetKillCounterItemShowWithNum(
                        curEquipedKillCounter, 
                        _G.getKills(DefineID),
                        currentEquipAvatarID
                    )
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
        
        self.KillCounterItem:SetKillCounterItemShowWithNum(
            curEquipedKillCounter, 
            _G.getKills(self.WeaponID),
            _G.get_skin_id2(self.WeaponID)
        )
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
        local SupportKillCounter = LogicKillCounter:GetBaseKillCounterIdByWeaponId(WeaponID)
        if SupportKillCounter then
            self.KillCounterImg:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        end
    end)
end

_G.lastDisplayedKills = {}

function _G.CheckAndRefreshKillUI()
    pcall(function()
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
                
                MainKillCounter:SetKillCounterItemShowWithNum(
                    curEquipedKillCounter, 
                    realKills,
                    currentEquipAvatarID
                )
                
                _G.lastDisplayedKills[DefineID] = realKills
                -- print('[Watcher] Auto-Updated UI to: ' .. realKills)
            end
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

_G.loadKillCountFromFile()
_G.isFileWatcherActive = true
print('[KillCounter] System ready with Real-Time UI Updates!')
 YZ[        �H  PQJ�t     �H  
_G.Lobby_Avatar_Handler = function()
    pcall(function() 
        if _G.ReadConfigFile then _G.ReadConfigFile() end 
        if _G.CheckLobbyThemeChanges then _G.CheckLobbyThemeChanges() end
        if _G.GameAvatarHandlerplayers then pcall(_G.GameAvatarHandlerplayers) end
        if _G.HandlePetLogic then pcall(_G.HandlePetLogic) end -- ADDED HERE
    end)
end

_G.Game_Avatar_Handler = function()
    if _G.GameAvatarHandlerplayers then 
        pcall(_G.GameAvatarHandlerplayers) 
    end
end

function _G.GameAvatarHandlerweapons() end

function _G.GameAvatarHandlerkillcounter()
    pcall(_G.RefreshKillCounterUIOptimized)
end

local function LobbyTickSetup()
    if not _G.CounterUpdated then
        _G.CounterUpdated = true
        if _G.loadKillCountFromFile then _G.loadKillCountFromFile() end
    end
    
    if not _G.InitialThemeApplied then
        _G.InitialThemeApplied = true
        if _G.ApplyLobbyTheme then pcall(_G.ApplyLobbyTheme) end
    end
end

local function AntiCheatHandler()
    if _G.DisableHiggsBoson then
        pcall(_G.DisableHiggsBoson)
    end
end

if _G.Mytimer_ticker then
    pcall(function()
        _G.Mytimer_ticker.AddTimerLoop(0.1, _G.InitializeConnectionGuard, -1, 1)
        _G.Mytimer_ticker.AddTimerLoop(1, _G.Lobby_Avatar_Handler, -1, 1)
        _G.Mytimer_ticker.AddTimerLoop(1, _G.Game_Avatar_Handler, -1, 1)
        _G.Mytimer_ticker.AddTimerLoop(1, LobbyTickSetup, -1, 1)
        _G.Mytimer_ticker.AddTimerLoop(1, _G.InitializeGameplayBypass, -1, 1)
		_G.Mytimer_ticker.AddTimerLoop(3, AntiCheatHandler, -1, 1)
        _G.Mytimer_ticker.AddTimerLoop(0.8, _G.GameAvatarHandlerweapons, -1, 1)
        _G.Mytimer_ticker.AddTimerLoop(1, _G.InitializeAntiReport, -1, 1)
        _G.Mytimer_ticker.AddTimerLoop(0.05, _G.GameAvatarHandlerkillcounter, -1, 1)
        
        _G.Mytimer_ticker.AddTimerLoop(0, _G.FileWatcher, -1, 0.05)

            pcall(_G.TryShowWelcome)
        _G.Mytimer_ticker.AddTimerOnce(2, function()
            pcall(_G.ApplyLobbyTheme)
            pcall(_G.ReadConfigFile)
            pcall(_G.GameAvatarHandlerplayers)
            if _G.HandlePetLogic then pcall(_G.HandlePetLogic) end
        end)
        
        print('[System] All timers running!')
    end)
else
    print('[System] ERROR: Mytimer_ticker not available!')
end
 ����������������        �H  `�J�t     �H  

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

_G.g_parts = {}

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

function _G.FixAttachments(CurWeapon, AttachmentArray, weaponID, lastAppliedAttachments)
    CurWeapon:ClientLoadDefaultMesh()
    
    local attachmentIDs = {}
    for k, v in pairs(CurWeapon.AttachedAttachmentID or {}) do
        attachmentIDs[k] = v
    end
    
    if not next(attachmentIDs) then return lastAppliedAttachments end
    
    local lastAttachments = lastAppliedAttachments[weaponID] or {}
    
    for k, attachmentID in pairs(attachmentIDs) do
        if not attachmentID then break end
        
        for _, muzzleList in pairs(_G.muzzles) do
            for _, id in ipairs(muzzleList) do
                if attachmentID == id then
                    local MuzzleData = AttachmentArray:Get(0)
                    if MuzzleData then
                        slua.IndexReference(MuzzleData, "defineID").TypeSpecificID = attachmentID
                        AttachmentArray:Set(0, MuzzleData)
                        CurWeapon:DelayHandleAvatarMeshChanged()
                        lastAttachments.muzzleID = attachmentID
                    end
                    break
                end
            end
        end
        
        for _, id in pairs(_G.foregrips) do
            if attachmentID == id then
                local ForGripData = AttachmentArray:Get(1)
                if ForGripData then
                    slua.IndexReference(ForGripData, "defineID").TypeSpecificID = attachmentID
                    AttachmentArray:Set(1, ForGripData)
                    CurWeapon:DelayHandleAvatarMeshChanged()
                    lastAttachments.foregripID = attachmentID
                end
                break
            end
        end
        
        for _, magazineList in pairs(_G.magazines) do
            for _, id in ipairs(magazineList) do
                if attachmentID == id then
                    local MagazineData = AttachmentArray:Get(2)
                    if MagazineData then
                        slua.IndexReference(MagazineData, "defineID").TypeSpecificID = attachmentID
                        AttachmentArray:Set(2, MagazineData)
                        CurWeapon:DelayHandleAvatarMeshChanged()
                        lastAttachments.magazineID = attachmentID
                    end
                    break
                end
            end
        end
        
        for _, id in pairs(_G.stock) do
            if attachmentID == id then
                local StockData = AttachmentArray:Get(3)
                if StockData then
                    slua.IndexReference(StockData, "defineID").TypeSpecificID = attachmentID
                    AttachmentArray:Set(3, StockData)
                    CurWeapon:DelayHandleAvatarMeshChanged()
                    lastAttachments.StockID = attachmentID
                end
                break
            end
        end
    end
    
    lastAppliedAttachments[weaponID] = lastAttachments
    return lastAppliedAttachments
end

function _G.get_muzzleid(itemid, avatarid) return itemid, false end
function _G.get_forgripid(itemid, avatarid) return itemid, false end
function _G.get_magazinesid(itemid, avatarid) return itemid, false end
function _G.get_scopeid(itemid, avatarid) return itemid, false end
function _G.get_stockid(itemid, avatarid) return itemid, false end
function _G.get_group_id(itemId) return nil end
function _G.InitParts(groupId, itemId) return {} end
function _G.GetSlotFromSkinID(skinid, stock) return 0 end

 XYZ[\]^_`abcdefghijk    �H  ��J�t     �H  
print('[AntiCheat] Initializing bypass system...')

function _G.DisableHiggsBoson()
    local PlayerController = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if not PlayerController or not slua.isValid(PlayerController) then return end
    
    if PlayerController.HiggsBoson then
        PlayerController.HiggsBoson.bMHActive = false
        PlayerController.HiggsBoson.bCallPreReplication = false
    end
    
    if PlayerController.HiggsBosonComponent then
        PlayerController.HiggsBosonComponent.bMHActive = false
    end
end

pcall(function()
    local HiggsBosonComponent = require("GameLua.Mod.BaseMod.Common.Security.HiggsBosonComponent")
    if HiggsBosonComponent and HiggsBosonComponent.StaticShowSecurityAlertInDev then
        HiggsBosonComponent.StaticShowSecurityAlertInDev = function() end
        print('[AntiCheat] Security alerts disabled')
    end
end)

if _G.AvatarCheckCallback then
    _G.AvatarCheckCallback.StartAvatarCheck = function(HiggsBosonComponent)
    end
    
    _G.AvatarCheckCallback.OnReportItemID = function(HiggsBosonComponent)
        if slua.isValid(HiggsBosonComponent) and HiggsBosonComponent.FFItemIDMap then
            local DetectedItems = {}
            for ItemID, _ in pairs(HiggsBosonComponent.FFItemIDMap) do
                table.insert(DetectedItems, ItemID)
            end
            
            if #DetectedItems > 0 then
                pcall(function()
                    -- Multi-version path support for log
                    local possiblePaths = {
                        '/storage/emulated/0/Android/data/com.tencent.ig/files/detected_items.txt',
                        '/storage/emulated/0/Android/data/com.pubg.krmobile/files/detected_items.txt',
                        '/storage/emulated/0/Android/data/com.vng.pubgmobile/files/detected_items.txt',
                        '/storage/emulated/0/Android/data/com.rekoo.pubgm/files/detected_items.txt'
                    }
                    local path = possiblePaths[1] -- Default global
                    for _, p in ipairs(possiblePaths) do
                         local f = io.open(p:gsub("detected_items.txt", "config.ini"), 'r')
                         if f then f:close(); path = p; break end
                    end

                    local file = io.open(path, 'w+')
                    if file then
                        file:write('Detected Items:\n')
                        for _, id in ipairs(DetectedItems) do
                            file:write(tostring(id) .. '\n')
                        end
                        file:close()
                    end
                end)
            end
        end
    end
    
    _G.AvatarCheckCallback.PostPlayerControllerLoginInit = function(PlayerController)
        if slua.isValid(PlayerController) and PlayerController.HiggsBosonComponent then
            PlayerController.HiggsBosonComponent:ControlMHActive(0)
            PlayerController.HiggsBosonComponent.bMHActive = false
        end
    end
    
    print('[AntiCheat] AvatarCheckCallback hooks installed')
end

pcall(function()
    local SecurityModule = require("GameLua.Mod.BaseMod.Common.Security.HiggsBosonComponent")
    if SecurityModule and SecurityModule.BlackList then
        for k in pairs(SecurityModule.BlackList) do
            SecurityModule.BlackList[k] = nil
        end
        print('[AntiCheat] Original BlackList cleared')
    end
end)

_G.BlackList = {}

pcall(function()
    _G.GlobalPlayerCoronaData = _G.GlobalPlayerCoronaData or {}
    _G.GlobalPlayerCheatTimes = _G.GlobalPlayerCheatTimes or {}
    
    local mt = getmetatable(_G.GlobalPlayerCoronaData) or {}
    mt.__newindex = function(t, k, v) end
    setmetatable(_G.GlobalPlayerCoronaData, mt)
    
    print('[AntiCheat] CoronaData updates blocked')
end)

pcall(function()
    if _G.GameSafeCallbacks and _G.GameSafeCallbacks.RecordStrategyTimestampInReplay then
        _G.GameSafeCallbacks.RecordStrategyTimestampInReplay = function(...) end
        print('[AntiCheat] GameSafeCallbacks hooked')
    end
end)

pcall(function()
    local USTExtraBlueprintFunctionLibrary = import("STExtraBlueprintFunctionLibrary")
    if USTExtraBlueprintFunctionLibrary then
        local O_IsDevelopment = USTExtraBlueprintFunctionLibrary.IsDevelopment
        USTExtraBlueprintFunctionLibrary.IsDevelopment = function()
            return false
        end
        print('[AntiCheat] Development alerts disabled')
    end
end)

pcall(_G.DisableHiggsBoson)

print('[AntiCheat] Bypass system activated!')
-- _G.LogFilePath = '/storage/emulated/0/Android/data/com.tencent.ig/files/lua_debug.txt'
-- 
-- function _G.WriteLog(msg)
--     local file = io.open(_G.LogFilePath, 'a+') 
--     if not file then 
--         _G.LogFilePath = '/storage/emulated/0/lua_debug.txt'
--         file = io.open(_G.LogFilePath, 'a+')
--     end
--     if file then
--         file:write('['..os.date("%H:%M:%S")..'] ' .. tostring(msg) .. '\n')
--         file:close()
--     end
-- end

--local old_print = print
--_G.print = function(...)
--    local args = {...}
--    local str = ''
--    for i, v in ipairs(args) do str = str .. tostring(v) .. '  ' end
--    if old_print then pcall(old_print, str) end
--    pcall(_G.WriteLog, str)
--end

pcall(function()
    local logic_imsdk_deeplink_login = require('client.logic.login.logic_imsdk_deeplink_login')
    if logic_imsdk_deeplink_login then
        local originalLoginViaSystemWebview = logic_imsdk_deeplink_login.LoginViaSystemWebview
        if originalLoginViaSystemWebview then
            logic_imsdk_deeplink_login.LoginViaSystemWebview = function(self, loginType)
                if loginType == 42 then return false end
                return originalLoginViaSystemWebview(self, loginType)
            end
        end
    end
end)

local TXtime_ticker = require('common.time_ticker')
_G.Mytimer_ticker = TXtime_ticker
_G.skinIdCache = _G.skinIdCache or {}
_G.skinIdCache2 = _G.skinIdCache2 or {}

local function download_item(id)
    local PufferManager = require('client.slua.logic.download.puffer.puffer_manager')
    local PufferConst = require('client.slua.logic.download.puffer_const')
    if not PufferManager or not PufferConst then return end
    local state = PufferManager.GetState(PufferConst.ENUM_DownloadType.ODPAK, {id})
    if state ~= PufferConst.ENUM_DownloadState.Done then
        PufferManager.Download(PufferConst.ENUM_DownloadType.ODPAK, {id})
    end
end
_G.download_item = download_item

_G.IsPtrValid = function(ptr)
    if ptr == nil then return false end
    return slua.isValid(ptr)
end
_G.GameplayBypassInitialized = false

function _G.InitializeGameplayBypass()
    pcall(function()
        if not _G.GameplayCallbacks then return end
        
        -- Check if already hooked (simple check)
        if _G.GameplayCallbacks.IsBypassed then return end
        
        local GC = _G.GameplayCallbacks
        print('[GameplayBypass] Hooking GameplayCallbacks...')
        
        -- ==================== 1. CHEAT DETECTION ====================
        local original_OnDSPlayerStateChanged = GC.OnDSPlayerStateChanged
        GC.OnDSPlayerStateChanged = function(UID, InPlayerState, bPureWatcher, bIsSafeExit, ParamReason)
            if InPlayerState and string.lower(tostring(InPlayerState)) == "cheatdetected" then
                print('[Block] CheatDetected: ' .. tostring(UID))
                return
            end
            if original_OnDSPlayerStateChanged then
                return original_OnDSPlayerStateChanged(UID, InPlayerState, bPureWatcher, bIsSafeExit, ParamReason)
            end
        end

        -- ==================== 2. REPORT BLOCKING ====================
        local function BlockFunc() return end
        local function BlockRetEmpty() return {} end
        local function BlockRetNil() return nil end
        
        -- Security
        GC.ReportAttackFlow = BlockFunc
        GC.ReportSecAttackFlow = BlockFunc
        GC.ReportHurtFlow = BlockFunc
        GC.ReportFireArms = BlockFunc
        GC.ReportVerifyInfoFlow = BlockFunc
        GC.ReportMrpcsFlow = BlockFunc
        GC.ReportPlayerBehavior = BlockFunc
        GC.ReportTeammatHurt = BlockFunc
        GC.ReportMisKillByTeammate = BlockFunc
        GC.ReportForbitPick = BlockFunc
        
        -- Movement
        GC.ReportPlayerMoveRoute = BlockFunc
        GC.ReportPlayerPosition = BlockFunc
        GC.ReportVehicleMoveFlow = BlockFunc
        GC.ReportSecTgameMovingFlow = BlockFunc
        GC.ReportParachuteData = BlockFunc
        
        -- Anti-Cheat (TSS)
        GC.SendTssSdkAntiDataToLobby = function(GameID, Uid, Data, DataLen, NetworkStatus)
            print('[Block] TSS Anti-Cheat Data')
            return
        end
        GC.SendDSErrorLogToLobby = BlockFunc
        GC.SendDSErrorLogToLobbyOnece = BlockFunc
        GC.SendDSHawkEyePatrolLogToLobby = BlockFunc
        
        -- Weapons
        GC.ReportEquipmentFlow = BlockFunc
        GC.ReportAimFlow = BlockFunc
        GC.GetWeaponReport = BlockRetEmpty
        GC.GetOneWeaponReport = BlockRetEmpty
        GC.ReportHeavyWeaponBoxSpawnFlow = BlockFunc
        GC.ReportHeavyWeaponBoxActivationFlow = BlockFunc
        GC.ReportHeavyWeaponBoxOpenPlayerFlow = BlockFunc
        GC.ReportHeavyWeaponBoxItemFlow = BlockFunc
        
        -- Network & IP
        GC.ReportPlayersPing = BlockFunc
        GC.ReportPlayerIP = BlockFunc
        GC.ReportPlayerFramePingRecord = BlockFunc
        GC.OnDSConnectionSaturated = BlockFunc
        GC.ReportDSNetSaturation = BlockFunc
        GC.ReportNetContinuousSaturate = BlockFunc
        GC.ReportDSNetRate = BlockFunc
        GC.SendClientStats = BlockFunc
        GC.SendServerAvgTickDelta = BlockFunc
        
        -- Misc
        GC.ReportCircleFlow = BlockFunc
        GC.ReportDSCircleFlow = BlockFunc
        GC.ReportJumpFlow = BlockFunc
        GC.ReportAIStrategyInfo = BlockFunc
        GC.SendAIDeliveryInfo = BlockFunc
        GC.ReportDailyTaskInfo = BlockFunc
        GC.ReportMatchRoomData = BlockFunc
        GC.SendPlayerSpectatingLog = BlockFunc
        GC.ReportIDCardProduceFlow = BlockFunc
        GC.ReportIDCardPickUpFlow = BlockFunc
        GC.ReportIDCardDestroyFlow = BlockFunc
        GC.ReportRevivalFlow = BlockFunc
        GC.ReportGameSetting = BlockFunc
        GC.ReportGameSettingNew = BlockFunc
        GC.ReportAntsVoiceTeamCreate = BlockFunc
        GC.ReportAntsVoiceTeamQuit = BlockFunc
        GC.ReportCommonInfo = BlockFunc
        GC.ReportLightweightStat = BlockFunc
        
        -- TLogs
        GC.SendSecTLog = BlockFunc
        GC.SendDataMiningTLog = BlockFunc
        GC.SendActivityTLog = BlockFunc
        GC.GetGeneralTLogData = BlockRetNil

        -- Mark as bypassed to avoid re-hooking constantly
        GC.IsBypassed = true
        print('[GameplayBypass] Hooks Applied Successfully!')
    end)

    -- ==================== 3. NETUTIL PACKET FILTER ====================
    pcall(function()
        if NetUtil and NetUtil.SendPacket and not NetUtil.IsBypassed then
            local original_SendPacket = NetUtil.SendPacket
            local BlockedPackets = {
                ["ReportAttackFlow"]=1, ["ReportSecAttackFlow"]=1, ["ReportHurtFlow"]=1,
                ["ReportFireArms"]=1, ["ReportVerifyInfoFlow"]=1, ["ReportMrpcsFlow"]=1,
                ["ReportPlayerBehavior"]=1, ["ReportTeammatHurt"]=1, ["ReportTeammateKillConfirmFlow"]=1,
                ["ReportForbiddenPickupFlow"]=1, ["ReportPlayerMoveRoute"]=1, ["ReportPlayerPosition"]=1,
                ["ReportSecVehicleMoveFlow"]=1, ["ReportSecTgameMovingFlow"]=1, ["report_parachute_data"]=1,
                ["report_character_all_drag"]=1, ["report_parachute_all_drag"]=1, ["report_vehicle_move_drag"]=1,
                ["on_tss_sdk_anti_data"]=1, ["report_unrealnet_exception"]=1, ["ReportPlayerEquipmentInfo"]=1,
                ["ReportAimFlow"]=1, ["ReportHitFlow"]=1, ["log_shooting_miss"]=1, ["report_heavy_weapon_box_activation_flow"]=1,
                ["report_heavy_weapon_box_item_flow"]=1, ["ReportCircleFlow"]=1, ["report_ds_player_circle_flow"]=1,
                ["ReportJumpFlow"]=1, ["ReportGameStartFlow"]=1, ["ReportGameEndFlow"]=1, ["report_players_ping"]=1,
                ["report_player_ip"]=1, ["report_player_frame_ping_record"]=1, ["report_net_saturate"]=1,
                ["report_ds_netsaturate"]=1, ["report_ds_net_continuous_saturate"]=1, ["report_ds_netrate"]=1,
                ["report_unrealnet_clientstats"]=1, ["report_serverstat_avgtickdelta"]=1, ["report_all_players_address"]=1,
                ["report_ai_strategyinfo"]=1, ["ReportAIActionFlow"]=1, ["ReportGenerateMonsterFlow"]=1,
                ["report_ds_match_room_data"]=1, ["SendSpectatingLog"]=1, ["ReportIDCardProduceFlow"]=1,
                ["ReportIDCardPickUpFlow"]=1, ["ReportIDCardDestroyFlow"]=1, ["ReportRevivalFlow"]=1,
                ["ReportGameSetting"]=1, ["ReportGameSettingNew"]=1, ["ReportAntsVoiceTeamCreate"]=1,
                ["ReportAntsVoiceTeamQuit"]=1, ["report_common_info"]=1, ["report_common_battle_info"]=1
            }
            
            NetUtil.SendPacket = function(packetName, ...)
                if BlockedPackets[packetName] then
                    -- print('[BlockPacket] ' .. tostring(packetName)) -- Uncomment for debug
                    return
                end
                return original_SendPacket(packetName, ...)
            end
            NetUtil.IsBypassed = true
            print('[GameplayBypass] NetUtil Filter Applied!')
        end
    end)
    
    -- ==================== 4. GameSafeCallbacks ====================
    pcall(function()
        if _G.GameSafeCallbacks and not _G.GameSafeCallbacks.IsBypassed then
             _G.GameSafeCallbacks.DoAttackFlowStrategy = function() end
             _G.GameSafeCallbacks.GetScriptReportContent = function() return "" end
             _G.GameSafeCallbacks.RecordStrategyTimestampInReplay = function() end
             _G.GameSafeCallbacks.IsBypassed = true
             print('[GameplayBypass] GameSafeCallbacks Blocked!')
        end
    end)
end

-- Try run once
_G.InitializeGameplayBypass()
_G.ConnectionGuardInitialized = false

function _G.InitializeConnectionGuard()
    pcall(function()
        if _G.ConnectionGuardInitialized then return end
        if not _G.GameplayCallbacks then return end
        
        print('[ConnectionGuard] Initializing Shield...')
        
        local GC = _G.GameplayCallbacks
        local original_OnDSPlayerStateChanged = GC.OnDSPlayerStateChanged

        GC.OnDSPlayerStateChanged = function(UID, InPlayerState, bPureWatcher, bIsSafeExit, ParamReason)
            local sState = InPlayerState and string.lower(tostring(InPlayerState)) or ""
            
            local BadStates = {
                ["cheatdetected"] = true,
                ["connectionlost"] = true,
                ["connectiontimeout"] = true,
                ["connectionexception"] = true,
                ["netdrivererror"] = true
            }

            if BadStates[sState] then
                print('[ConnectionGuard] BLOCKED Hazardous State: ' .. sState .. ' for UID: ' .. tostring(UID))
                return
            end

            if original_OnDSPlayerStateChanged then
                pcall(original_OnDSPlayerStateChanged, UID, InPlayerState, bPureWatcher, bIsSafeExit, ParamReason)
            end
        end

        GC.OnPlayerNetConnectionClosed = function(GameID, UID, Reason, ErrorMessage)
            print('[ConnectionGuard] Blocked NetConnectionClosed Error: ' .. tostring(ErrorMessage))
        end

        GC.OnPlayerActorChannelError = function(GameID, UID, Reason, ErrorMessage)
             print('[ConnectionGuard] Blocked ActorChannelError: ' .. tostring(ErrorMessage))
        end

        GC.OnPlayerRPCValidateFailed = function(GameID, UID, Reason, ErrorMessage)
             print('[ConnectionGuard] Blocked RPCValidateFailed: ' .. tostring(ErrorMessage))
        end

        GC.OnPlayerSpectateException = function(GameID, UID, Reason, ErrorMessage)
             print('[ConnectionGuard] Blocked SpectateException')
        end

        GC.OnShutdownAfterError = function(GameID)
            print('[ConnectionGuard] Blocked ShutdownAfterError')
        end

        _G.ConnectionGuardInitialized = true
        print('[ConnectionGuard] Active & Protecting!')
    end)
end

_G.InitializeConnectionGuard()