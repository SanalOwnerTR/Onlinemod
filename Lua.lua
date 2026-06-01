
_G.YargiEngine = _G.YargiEngine or {}
_G.YargiEngine.Loaded = false
_G.YargiEngine.Version = "3.0"

local Yargi = {}

-- =============================================================================
-- PATHS
-- =============================================================================

local PACKAGE_LIST = {
    "com.tencent.ig", "com.pubg.krmobile", "com.vng.pubgmobile",
    "com.rekoo.pubgm", "com.rekoo.pubgmobile", "com.pubg.imobile"
}

local function buildConfigPaths()
    local paths = {}
    for _, pkg in ipairs(PACKAGE_LIST) do
        paths[#paths + 1] = "/storage/emulated/0/Android/data/" .. pkg .. "/files/config.ini"
    end
    paths[#paths + 1] = "/storage/emulated/0/config.ini"
    return paths
end

local CONFIG_PATHS = buildConfigPaths()

local function resolveDataPath()
    for _, pkg in ipairs(PACKAGE_LIST) do
        local path = "/storage/emulated/0/Android/data/" .. pkg .. "/files"
        local f = io.open(path .. "/config.ini", "r")
        if f then f:close(); return path end
    end
    return "/storage/emulated/0/Android/data/com.pubg.krmobile/files"
end

local KILL_COUNTER_PATHS = {}
for _, pkg in ipairs(PACKAGE_LIST) do
    KILL_COUNTER_PATHS[#KILL_COUNTER_PATHS + 1] =
        "/storage/emulated/0/Android/data/" .. pkg .. "/files/NumberUpdate.txt"
end

local function resolveKillCounterPath()
    for _, p in ipairs(KILL_COUNTER_PATHS) do
        local f = io.open(p, "r")
        if f then f:close(); return p end
    end
    return KILL_COUNTER_PATHS[1]
end

-- =============================================================================
-- SKIN DATA TABLES
-- =============================================================================

_G.OutfitSkins = {
    Suit = {403003,1406469,1405870,1407140,1407141,1407142,1407550,1406638,1406872,1406971,1407103,1407512,1407391,1407366,1407330,1407329,1407286,1407285,1407277,1407276,1407275,1407225,1407224,1407259,1407161,1407160,1407107,1407106,1407079,1407048,1406977,1406976,1406898,1400569,1404000,1404049,1400119,1400117,1406060,1406891,1400687,1405160,1405145,1405436,1405435,1405434,1405064,1405207,1406895,1400333,1400377,1405092,1405121,1406889,1407278,1407279,1407381,1407380,1407385,1406389,1406388,1406387,1406386,1406385,1406140,1400782,1407392,1407318,1407317,1407404,1407402,1407401,1407387,1404434,1404437,1404440,1404448,1400324,1400708,1404043,1404048,1405953,1400101,1404153,1407440,1407441},
    Bag = {501001,1501001174,1501001220,1501001051,1501001443,1501001265,1501001321,1501001277,1501001550,1501001592,1501001608,1501001024,1501001019,1501001195,1501001179,1501001194,1501001346,1501001097,1501001081,1501001093,1501001022,1501001639,1501001640,1501001625},
    Helmet = {502001,1502001014,1502001349,1502001012,1502001009,1502001397,1502001390,1502001381,1502001358,1502001350,1502001342,1502001336,1502001333,1502001327,1502001325,1502001299,1502001295,1502001222,1502001069,1502001054,1502001033,1502001016,1502001031,1502001023,1502001018,1502001408,1502001410},
    Parachute = {703001,1401619,1401625,1401624,1401836,1401833,1401287,1401282,1401385,1401549,1401336,1401335,1401629,1401628},
    Glider = {703001,4151050,4151049,4151048,4151047,4151046,4151045,4151044,4151043,4151042,4151041,4151040,4151039,4151038,4151037,4151036},
    Pet = {50000,50001,50002,50003,50004,50005,50006,50007,50008,50009,50010,50011,50012,50013,50014,50015,50016,50017,50018,50019,50020,50021,50022,50023,50024,50025,50026,50027,50028,50029,50030,50031,50032,50033,50034,50035,50036,50037,50038,50039,50040,50041,50042,50043,50044},
    PetDress = {0,50001001,50001002,50001003,50001004,50001005,50001006,50001007,50001008,50001009,50001010},
    Head = {0,1402543,1402690,1407618,1407625,1403224},
    Hair = {0,1403224,1407618,1407625,1405703,1405983},
    Hat = {0,404015,404026,404017,404018,404019},
    Face = {0,403017,403016,403015,403014,403013},
    Armor = {0,1405703,1405983,1407625,1407618,1406872},
    Gloves = {0,402009,402024,402010,402011,402012,402013,402014,402015,402016},
    HandEffect = {0,1406889,1406891,1406895,1406898,1406971},
    LastKill = {6114302174,6114302175,6114302176,6114302177,6114302178},
    FinalKill = {6114302174,6114302180,6114302181,6114302182,6114302183},
    VehicleEffect = {7303001,7303002,7303003,7303004,7303005}
}

_G.LobbyThemeSkins = _G.LobbyThemeSkins or {
    202408001, 202408002, 202408003, 202407001, 202406001, 202405001,
    202404001, 202403001, 202402001, 202401001, 202312001, 202311001
}

_G.SuitSkinsMap = _G.OutfitSkins.Suit
_G.BagSkinsMap = _G.OutfitSkins.Bag
_G.HelmetSkinsMap = _G.OutfitSkins.Helmet
_G.ParachutSkinsMap = _G.OutfitSkins.Parachute
_G.GliderSkinsMap = _G.OutfitSkins.Glider
_G.PetSkinsMap = _G.OutfitSkins.Pet

_G.skinIdMappings = {
    [101004]={101004,1101004046,1101004226,1101004236,1101004062,1101004078,1101004086,1101004098,1101004138,1101004163,1101004201,1101004209,1101004218},
    [101001]={101001,1101001089,1101001213,1101001172,1101001127,1101001142,1101001153,1101001115,1101001102,1101001230,1101001241},
    [101003]={101003,1103003208,1101003195,1101003187,1101003098,1101003166,1101003069,1101003218,1101003079,1101003118,1101003145,1101003180,1101003056},
    [101002]={101002,1101002081,1101002105,1101002128},
    [101005]={101005,1101005052,1101005073,1101005091},
    [101006]={101006,1101006061,1101006074,1101006043,1101006032,1101006084,1101006096},
    [101007]={101007,1101007046,1101007068,1101007089},
    [101008]={101008,1101008079,1101008126,1101008104,1101008146,1101008026,1101008061,1101008116,1101008051},
    [101009]={101009,1101009035,1101009058,1101009079},
    [101010]={101010,1101010022,1101010043},
    [101011]={101011,1101011019,1101011038},
    [102001]={102001,1102001103,1102001124,1102001148},
    [102002]={102002,1102002136,1102002043,1102002061,1102002424,1102002198},
    [102003]={102003,1102003019,1102003030,1102003064,1102003079},
    [102004]={102004,1102004017,1102004033,1102004048},
    [102005]={102005,1102005018,1102005037},
    [102006]={102006,1102006015,1102006031},
    [102009]={102009,1102009001,1102009002,1102009003,1102009004,1102009005},
    [103001]={103001,1103001191,1103001101,1103001178,1103001145,1103001230,1103001213},
    [103002]={103002,1103002030,1103002087,1103002105,1103002112,1103002201},
    [103003]={103003,1103003042,1103003087,1103003062,1103003022,1103003051,1103003030,1103003079},
    [103004]={103004,1103004001,1103004022,1103004047},
    [103006]={103006,1103006030,1103006055,1103006079},
    [103007]={103007,1103007028,1103007049},
    [103008]={103008,1103008015,1103008035},
    [103009]={103009,1103009018,1103009037},
    [103011]={103011,1103011010,1103011022},
    [103012]={103012,1103012010,1103012025},
    [104002]={104002,1104002001,1104002002,1104002003,1104002004},
    [104003]={104003,1104003027,1104003048},
    [104004]={104004,1104004034,1104004015,1104004040},
    [104005]={104005,1104005012,1104005025},
    [105001]={105001,1105001047,1105001068,1105001033,1105001061},
    [105002]={105002,1105002090,1105002075,1105002018,1105002034,1105002057,1105002062},
    [105010]={105010,1105010018,1105010007,1105010025},
    [106001]={106001,1108004356,1108004415,1108004416},
    [106002]={106002,1108001101,1108001102,1108001103,1108001098,1108001097},
    [106003]={106003,1108001062,1108001063,1108001064,1108001067,1108001068},
    [106004]={106004,1108001069,1108001080,1108001081,1108001083,1108001084},
    [106005]={106005,1108001085,1108001093,1108001095},
    [108001]={108001,1108001001,1108001002,1108001003},
    [108002]={108002,1108002001,1108002002,1108002003},
    [108003]={108003,1108003001,1108003002,1108003003},
    [108004]={108004,1108004001,1108004002,1108004003},
    [108005]={108005,1108005001,1108005002,1108005003},
    [108006]={108006,1108006001,1108006002,1108006003},
    [108007]={108007,1108007001,1108007002,1108007003},
    [108008]={108008,1108008001,1108008002,1108008003},
    [602004]={602004,612004188,612004196,612004197,612004198,612004199},
    [602002]={602002,612002188,612002196,612002197},
    [602003]={602003,612003188,612003196,612003197},
    [602005]={602005,612005188,612005196,612005197},
    [602001]={602001,612001188,612001196}
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

-- =============================================================================
-- RUNTIME STATE
-- =============================================================================

_G.WeaponSkinIndex = _G.WeaponSkinIndex or {}
_G.VehicleSkinIndex = _G.VehicleSkinIndex or {}
_G.GrenadeSkinIndex = _G.GrenadeSkinIndex or {}
_G.ExtraWeaponSkinIndex = _G.ExtraWeaponSkinIndex or {}
_G.skinIdCache = _G.skinIdCache or {}
_G.matchAvatarFullApplied = false
_G.ActiveHitEffectResId = 0
_G.SkinLoadedCache = _G.SkinLoadedCache or {}
_G.BackpackSkinHooked = false
_G.killCountInfo = _G.killCountInfo or {}
_G.lastFileContent = ""
_G.isFileWatcherActive = true
_G.UpdateMyKillCounter = false
_G.WeaponEvents = _G.WeaponEvents or { onWeaponChanged = function() end }
_G.ActiveKillCounterPath = resolveKillCounterPath()

_G.SuitSkin = 0
_G.BagSkin = 0
_G.HelmetSkin = 0
_G.ParachuteSkin = 0
_G.GliderSkin = 0
_G.PetSkin = 0
_G.PetDressSkin = 0
_G.HeadSkin = 0
_G.HairSkin = 0
_G.HatSkin = 0
_G.FaceSkin = 0
_G.ArmorSkin = 0
_G.GlovesSkin = 0
_G.HandEffectSkin = 0
_G.LastKillEffectSkin = 6114302174
_G.FinalKillEffectSkin = 6114302174
_G.VehicleSwitchEffectId = 7303001
_G.TargetLobbyThemeID = 202408001
_G.LastAppliedThemeID = nil

local lastConfig = {}
local applyCache = {
    bag = {base = 0, value = 0},
    helmet = {base = 0, value = 0},
    pet = 0, petDress = 0,
    vehicle = {},
    weapon = {},
    avatar = {}
}

-- =============================================================================
-- SLOT TYPES (dynamic + fallback)
-- =============================================================================

local function initSlotTypes()
    local fallback = {
        HeadEquipemtSlot = 1,
        HairEquipemtSlot = 2,
        HatEquipemtSlot = 3,
        FaceEquipemtSlot = 4,
        ClothesEquipemtSlot = 5,
        ArmorEquipemtSlot = 6,
        BackpackEquipemtSlot = 8,
        HelmetEquipemtSlot = 9,
        ParachuteEquipemtSlot = 11,
        HandEffectEquipemtSlot = 12,
        GlideEquipemtSlot = 15,
        HandleEquipmentSlot = 16
    }
    local slots = {}
    pcall(function()
        local E = import("EAvatarSlotType")
        if E then
            for name, fb in pairs(fallback) do
                local key = "EAvatarSlotType_" .. name
                slots[name] = E[key] or fb
            end
            return
        end
    end)
    if not next(slots) then slots = fallback end
    _G.CustSlotType = slots
end

initSlotTypes()

-- =============================================================================
-- UTILITIES
-- =============================================================================

_G.IsPtrValid = function(ptr) return ptr ~= nil and slua.isValid(ptr) end

function Yargi.download_item(id)
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
_G.download_item = Yargi.download_item

function Yargi.ensureDownload(id)
    if id and id ~= 0 then
        _G.SkinLoadedCache[id] = true
        if not _G.skinIdCache[id] then
            Yargi.download_item(id)
            _G.skinIdCache[id] = true
        end
    end
end

function _G.rawGetTableData(tableName, id)
    local ok, CDataTable = pcall(require, "client.slua.config.ClientConfig.data_mgr")
    if not ok or not CDataTable then return nil end
    return CDataTable.GetTableData(tableName, id)
end

function Yargi.pickFromMap(map, index)
    if not map or not index then return 0 end
    local idx = index + 1
    return map[idx] or 0
end

function Yargi.readConfigContent()
    for _, path in ipairs(CONFIG_PATHS) do
        local file = io.open(path, "r")
        if file then
            local content = file:read("*all") or ""
            file:close()
            return content, path
        end
    end
    return nil, nil
end

function Yargi.parseConfig(content)
    local cfg = {}
    if not content then return cfg end
    for line in content:gmatch("[^\r\n]+") do
        local key, value = line:match("([%w_]+)%s*=%s*(%d+)")
        if key and value then cfg[key] = tonumber(value) end
    end
    return cfg
end

function Yargi.resetApplyCaches()
    applyCache.bag = {base = 0, value = 0}
    applyCache.helmet = {base = 0, value = 0}
    applyCache.pet = 0
    applyCache.petDress = 0
    applyCache.vehicle = {}
    applyCache.weapon = {}
    applyCache.avatar = {}
    _G.LastAppliedThemeID = nil
end

Yargi.persistLoaded = false
Yargi.PERSIST_PATH = nil

function Yargi.buildDynamicWeaponSkins(baseId)
    local list = {baseId}
    pcall(function()
        local CDataTable = require("client.slua.config.ClientConfig.data_mgr")
        local tableData = CDataTable.GetTable("WeaponSkinMapping")
        if not tableData then return end
        for skinId, cfg in pairs(tableData) do
            if cfg and cfg.WeaponId == baseId then
                local sid = tonumber(skinId) or cfg.ItemId or cfg.SkinID
                if sid and sid ~= baseId then list[#list + 1] = sid end
            end
        end
    end)
    return list
end

function Yargi.getBaseWeaponId(itemId)
    if not itemId or itemId == 0 then return itemId end
    if _G.skinIdMappings[itemId] then return itemId end
    local baseFromTable = nil
    pcall(function()
        local CDataTable = require("client.slua.config.ClientConfig.data_mgr")
        local cfg = CDataTable.GetTableData("WeaponSkinMapping", itemId)
        if cfg and cfg.WeaponId then baseFromTable = cfg.WeaponId end
    end)
    if baseFromTable then return baseFromTable end
    for baseId, skins in pairs(_G.skinIdMappings) do
        for _, sid in ipairs(skins) do
            if sid == itemId then return baseId end
        end
    end
    return itemId
end

function Yargi.isGrenadeId(id)
    return id and id >= 602001 and id <= 602099
end

function Yargi.isMeleeId(id)
    return id and id >= 106001 and id <= 106099
end

function Yargi.isPistolId(id)
    return id and id >= 108001 and id <= 108099
end

-- =============================================================================
-- CONFIG READER
-- =============================================================================

local WEAPON_CONFIG = {
    {"M416",101004},{"AKM",101001},{"SCAR",101003},{"M16A4",101002},
    {"GROZA",101005},{"AUG",101006},{"QBZ",101007},{"M762",101008},
    {"HONEY",101009},{"ACE32",101011},{"FAMAS",101010},
    {"UZI",102001},{"UMP",102002},{"Vector",102003},{"Thompson",102004},
    {"Bizon",102005},{"MP5K",102006},{"P90",102009},
    {"Kar98",103001},{"M24",103002},{"AWM",103003},{"SKS",103004},
    {"Mini14",103006},{"MK14",103007},{"SLR",103009},{"QBU",103011},
    {"AMR",103012},{"VSS",103008},
    {"S686",104002},{"S12K",104003},{"DBS",104004},{"S1897",104005},
    {"M249",105002},{"DP28",105001},{"MG3",105010},
    {"Pan",106001},{"Machete",106002},{"Crowbar",106003},{"Sickle",106004},{"Crossbow",106005},
    {"P92",108001},{"P18C",108002},{"R1895",108003},{"P1911",108004},
    {"R45",108005},{"SawedOff",108006},{"Skorpion",108007},{"Deagle",108008},
    {"Frag",602004},{"Smoke",602002},{"Molotov",602003},{"Stun",602005},{"Burn",602001}
}

local WEAPON_ID_TO_KEY = {}
for _, entry in ipairs(WEAPON_CONFIG) do
    WEAPON_ID_TO_KEY[entry[2]] = entry[1]
end

local VEHICLE_CONFIG = {
    {"Vehicle_UAZ",101},{"Vehicle_Buggy",102},{"Vehicle_Bike",103},
    {"Vehicle_Boat",104},{"Vehicle_Pickup",108},{"Vehicle_Mirado",109},
    {"Vehicle_ATV",111},{"Vehicle_Coupe",112},{"Vehicle_Dacia",113}
}

local OUTFIT_CONFIG = {
    {"Suit","SuitSkin","SuitSkinsMap"},
    {"Bag","BagSkin","BagSkinsMap"},
    {"Helmet","HelmetSkin","HelmetSkinsMap"},
    {"Parachute","ParachuteSkin","ParachutSkinsMap"},
    {"Glider","GliderSkin","GliderSkinsMap"},
    {"Pet","PetSkin","PetSkinsMap"},
    {"PetDress","PetDressSkin","PetDress"},
    {"Head","HeadSkin","Head"},
    {"Hair","HairSkin","Hair"},
    {"Hat","HatSkin","Hat"},
    {"Face","FaceSkin","Face"},
    {"Armor","ArmorSkin","Armor"},
    {"Gloves","GlovesSkin","Gloves"},
    {"HandEffect","HandEffectSkin","HandEffect"},
    {"LastKill","LastKillEffectSkin","LastKill"},
    {"FinalKill","FinalKillEffectSkin","FinalKill"},
    {"VehicleEffect","VehicleSwitchEffectId","VehicleEffect"}
}

-- =============================================================================
-- PERSIST STATE (lobby selection = match = lobby return)
-- =============================================================================

function Yargi.getPersistPath()
    if not Yargi.PERSIST_PATH then
        Yargi.PERSIST_PATH = resolveDataPath() .. "/yargi_state.ini"
    end
    return Yargi.PERSIST_PATH
end

function Yargi.resolveHitEffectFromItem(itemId)
    if not itemId or itemId == 0 then return 0 end
    local hitId = 0
    pcall(function()
        local CDataTable = require("client.slua.config.ClientConfig.data_mgr")
        local featuresItems = CDataTable.GetTableData("FeaturesItems", itemId)
        if not featuresItems or not featuresItems.Features or featuresItems.Features == "" then return end
        local StringUtil = require("common.string_util")
        local features = StringUtil.Split(featuresItems.Features, ";")
        for _, featureIDStr in ipairs(features) do
            local featureID = tonumber(featureIDStr)
            if featureID and ENUM_FeatureType then
                local featureCfg = CDataTable.GetTableData("FeaturesConfig", featureID)
                if featureCfg and featureCfg.FeatureType == ENUM_FeatureType.HitEffect then
                    hitId = itemId
                    break
                end
            end
        end
        if hitId == 0 then
            local eff = CDataTable.GetTableData("AvatarWeaponHitFXData", itemId)
            if eff then hitId = itemId end
        end
    end)
    return hitId
end

function Yargi.updateHitEffectFromSuit()
    _G.ActiveHitEffectResId = Yargi.resolveHitEffectFromItem(_G.SuitSkin)
end

function Yargi.savePersistState()
    local lines = {"PersistVersion=3"}
    for _, entry in ipairs(OUTFIT_CONFIG) do
        local cfgKey, globalKey = entry[1], entry[2]
        local list = _G[entry[3]] or _G.OutfitSkins[entry[3]]
        if list and _G[globalKey] and _G[globalKey] ~= 0 then
            for i, id in ipairs(list) do
                if id == _G[globalKey] then
                    lines[#lines + 1] = cfgKey .. "=" .. tostring(i - 1)
                    break
                end
            end
        end
    end
    if _G.TargetLobbyThemeID and _G.TargetLobbyThemeID ~= 0 then
        lines[#lines + 1] = "LobbyTheme=" .. tostring(_G.TargetLobbyThemeID)
    end
    for _, entry in ipairs(WEAPON_CONFIG) do
        local key, id = entry[1], entry[2]
        local idxTable = Yargi.isGrenadeId(id) and _G.GrenadeSkinIndex or _G.WeaponSkinIndex
        local idx = idxTable[id]
        if idx then lines[#lines + 1] = "W_" .. key .. "=" .. tostring(idx - 1) end
    end
    for gunID, idx in pairs(_G.ExtraWeaponSkinIndex) do
        if idx and idx > 0 then
            lines[#lines + 1] = "ExtraW_" .. tostring(gunID) .. "=" .. tostring(idx - 1)
        end
    end
    for _, entry in ipairs(VEHICLE_CONFIG) do
        local key, id = entry[1], entry[2]
        local idx = _G.VehicleSkinIndex[id]
        if idx then lines[#lines + 1] = "V_" .. key .. "=" .. tostring(idx - 1) end
    end
    local file = io.open(Yargi.getPersistPath(), "w")
    if file then
        file:write(table.concat(lines, "\n") .. "\n")
        file:close()
    end
    Yargi.persistLoaded = true
end

function Yargi.loadPersistState()
    local file = io.open(Yargi.getPersistPath(), "r")
    if not file then return false end
    local content = file:read("*a") or ""
    file:close()
    if not content:find("PersistVersion=3") then return false end
    local cfg = Yargi.parseConfig(content)
    for _, entry in ipairs(OUTFIT_CONFIG) do
        local key, globalKey, mapKey = entry[1], entry[2], entry[3]
        if cfg[key] ~= nil then
            local list = _G[mapKey] or _G.OutfitSkins[mapKey]
            _G[globalKey] = Yargi.pickFromMap(list, cfg[key])
            lastConfig[key] = cfg[key]
        end
    end
    if cfg.LobbyTheme then
        _G.TargetLobbyThemeID = cfg.LobbyTheme
        lastConfig.LobbyTheme = cfg.LobbyTheme
    end
    for _, entry in ipairs(WEAPON_CONFIG) do
        local key, id = entry[1], entry[2]
        local cfgKey = "W_" .. key
        if cfg[cfgKey] ~= nil then
            local idxTable = Yargi.isGrenadeId(id) and _G.GrenadeSkinIndex or _G.WeaponSkinIndex
            idxTable[id] = cfg[cfgKey] + 1
            lastConfig[key] = cfg[cfgKey]
        end
    end
    for k, v in pairs(cfg) do
        local gunID = k:match("^ExtraW_(%d+)$")
        if gunID then
            _G.ExtraWeaponSkinIndex[tonumber(gunID)] = v + 1
        end
    end
    for _, entry in ipairs(VEHICLE_CONFIG) do
        local key, id = entry[1], entry[2]
        local cfgKey = "V_" .. key
        if cfg[cfgKey] ~= nil then
            _G.VehicleSkinIndex[id] = cfg[cfgKey] + 1
            lastConfig[key] = cfg[cfgKey]
        end
    end
    Yargi.updateHitEffectFromSuit()
    Yargi.persistLoaded = true
    return true
end

function Yargi.downloadEquippedBatch()
    local ids = {}
    local function add(id)
        id = tonumber(id)
        if id and id > 0 and not ids[id] then ids[id] = true end
    end
    add(_G.SuitSkin)
    add(_G.BagSkin)
    add(_G.HelmetSkin)
    add(_G.ParachuteSkin)
    add(_G.GliderSkin)
    add(_G.PetSkin)
    add(_G.PetDressSkin)
    add(_G.HeadSkin)
    add(_G.HairSkin)
    add(_G.HatSkin)
    add(_G.FaceSkin)
    add(_G.ArmorSkin)
    add(_G.GlovesSkin)
    add(_G.HandEffectSkin)
    add(_G.TargetLobbyThemeID)
    add(_G.LastKillEffectSkin)
    add(_G.FinalKillEffectSkin)
    for baseId, idx in pairs(_G.WeaponSkinIndex) do
        local skins = _G.skinIdMappings[baseId]
        if skins and skins[idx] then add(skins[idx]) end
    end
    for baseId, idx in pairs(_G.GrenadeSkinIndex) do
        local skins = _G.skinIdMappings[baseId]
        if skins and skins[idx] then add(skins[idx]) end
    end
    for baseId, idx in pairs(_G.ExtraWeaponSkinIndex) do
        local skins = _G.skinIdMappings[baseId]
        if skins and skins[idx] then add(skins[idx]) end
    end
    for vType, idx in pairs(_G.VehicleSkinIndex) do
        local skins = _G.VehskinIdMappings[vType]
        if skins and skins[idx] then add(skins[idx]) end
    end
    for id in pairs(ids) do
        Yargi.ensureDownload(id)
    end
end

function Yargi.applyOutfitKey(key, globalKey, mapKey, newConfig, changed)
    if newConfig[key] == nil then return end
    if newConfig[key] ~= lastConfig[key] then
        local list = _G[mapKey] or _G.OutfitSkins[mapKey]
        _G[globalKey] = Yargi.pickFromMap(list, newConfig[key])
        lastConfig[key] = newConfig[key]
        changed.outfit = true
    end
end

function Yargi.applyWeaponKey(key, weaponId, newConfig, indexTable, changed)
    if newConfig[key] == nil then return end
    if newConfig[key] ~= lastConfig[key] then
        indexTable[weaponId] = newConfig[key] + 1
        lastConfig[key] = newConfig[key]
        changed.weapon = true
    end
end

function _G.ReadConfigFile()
    local content = Yargi.readConfigContent()
    if not content then return false end

    local newConfig = Yargi.parseConfig(content)
    local changed = {outfit = false, weapon = false, vehicle = false, theme = false}
    local persistMaster = Yargi.persistLoaded

    for _, entry in ipairs(OUTFIT_CONFIG) do
        if not persistMaster or (newConfig[entry[1]] ~= nil and newConfig[entry[1]] ~= lastConfig[entry[1]]) then
            Yargi.applyOutfitKey(entry[1], entry[2], entry[3], newConfig, changed)
        end
    end

    for _, entry in ipairs(WEAPON_CONFIG) do
        local key, id = entry[1], entry[2]
        if not persistMaster or (newConfig[key] ~= nil and newConfig[key] ~= lastConfig[key]) then
            local idxTable = Yargi.isGrenadeId(id) and _G.GrenadeSkinIndex or _G.WeaponSkinIndex
            Yargi.applyWeaponKey(key, id, newConfig, idxTable, changed)
        end
    end

    for _, entry in ipairs(VEHICLE_CONFIG) do
        local key, id = entry[1], entry[2]
        if newConfig[key] ~= nil and newConfig[key] ~= lastConfig[key] then
            if not persistMaster then
                _G.VehicleSkinIndex[id] = newConfig[key] + 1
                lastConfig[key] = newConfig[key]
                changed.vehicle = true
            end
        end
    end

    if newConfig.LobbyTheme and newConfig.LobbyTheme ~= lastConfig.LobbyTheme then
        _G.TargetLobbyThemeID = newConfig.LobbyTheme
        lastConfig.LobbyTheme = newConfig.LobbyTheme
        changed.theme = true
    end

    if changed.outfit then Yargi.updateHitEffectFromSuit() end

    if changed.outfit or changed.weapon or changed.vehicle then
        Yargi.resetApplyCaches()
        _G.UpdateMyKillCounter = true
        Yargi.savePersistState()
        Yargi.downloadEquippedBatch()
    end

    if changed.outfit or changed.weapon or changed.vehicle or changed.theme then
        _G.RefreshAllSkins()
        return true
    end
    return false
end

-- =============================================================================
-- SKIN RESOLVER & WEAPON APPLICATION
-- =============================================================================

_G.g_parts = _G.g_parts or {}

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

_G.muzzles = {
    id_flash_hider = {201010,201005,201004},
    id_compensator = {201009,201003,201002},
    id_suppressor = {201011,201006,201007}
}
_G.foregrips = {
    id_Angledforegrip = 202001, id_thumb_grip = 202006, id_vertical_grip = 202002,
    id_light_grip = 202004, id_half_grip = 202005, id_ergonomic_grip = 202051, id_laser_sight = 202007
}
_G.magazines = {
    id_expanded_mag = {204011,204007,204004},
    id_quick_mag = {204012,204008,204005},
    id_expanded_quick_mag = {204013,204009,204006}
}
_G.scopes = {
    id_reddot = 203001, id_holo = 203002, id_2x = 203003, id_3x = 203014,
    id_4x = 203004, id_6x = 203015, id_8x = 203005
}
_G.stock = {
    id_microStock = 205001, id_tactical = 205002, id_bulletloop = 204014, id_CheekPad = 205003
}

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
        [202001]="Angled Foregrip",[202006]="Thumb Grip",[202002]="Vertical Foregrip",
        [202004]="Light Grip",[202005]="Half Grip",[202051]="Ergonomic Grip",[202007]="Laser Sight"
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
        [203001]="Red Dot Sight",[203002]="Holographic Sight",[203003]="2x Scope",
        [203014]="3x Scope",[203004]="4x Scope",[203015]="6x Scope",[203005]="8x Scope"
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
        [205001]="Stock",[205002]="Tactical Stock",[204014]="Bullet Loop",[205003]="Cheek Pad"
    }
    if map[current_id] and p[map[current_id]] then
        current_id = p[map[current_id]]
    else
        current_id = _G.GetSlotFromSkinID(avatarid, 2) or current_id
    end
    return current_id, initial_id ~= current_id
end

function _G.apply_attachment(CurWeapon, avatarid)
    if not CurWeapon or not CurWeapon.synData then return end
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
    local baseId = Yargi.getBaseWeaponId(weaponID)
    local indexTable = Yargi.isGrenadeId(baseId) and _G.GrenadeSkinIndex or _G.WeaponSkinIndex
    local index = indexTable[baseId] or 1
    local skins = _G.skinIdMappings[baseId]
    if not skins or #skins <= 1 then
        skins = Yargi.buildDynamicWeaponSkins(baseId)
        if #skins > 1 then _G.skinIdMappings[baseId] = skins end
    end
    local skinID = skins[index] or skins[1] or weaponID
    Yargi.ensureDownload(skinID)
    if skinID and skinID > 0 then _G.SkinLoadedCache[skinID] = true end
    return skinID
end
_G.get_skin_id2 = _G.get_skin_id

function Yargi.applyWeaponSkin(weapon, force)
    if not _G.IsPtrValid(weapon) then return end
    pcall(function()
        local define = weapon:GetItemDefineID()
        if not define then return end
        local weaponid = define.TypeSpecificID
        if not weaponid or weaponid == 0 then return end
        local baseId = Yargi.getBaseWeaponId(weaponid)
        local targetSkin = _G.get_skin_id(baseId)
        local cacheKey = tostring(weapon) .. "_" .. tostring(baseId)
        if not force and applyCache.weapon[cacheKey] == targetSkin then return end
        if targetSkin and targetSkin ~= 0 then
            define.TypeSpecificID = targetSkin
            weapon:SetWeaponSkin(define)
            if weapon.synData then
                pcall(function()
                    local slotData = weapon.synData:Get(7)
                    if slotData then
                        local skinDefine = slua.IndexReference(slotData, "defineID")
                        if skinDefine and skinDefine.TypeSpecificID ~= targetSkin then
                            skinDefine.TypeSpecificID = targetSkin
                            weapon.synData:Set(7, slotData)
                        end
                    end
                end)
            end
            if not Yargi.isGrenadeId(baseId) then
                _G.apply_attachment(weapon, targetSkin)
            end
            if weapon.DelayHandleAvatarMeshChanged then
                weapon:DelayHandleAvatarMeshChanged()
            end
            applyCache.weapon[cacheKey] = targetSkin
        end
    end)
end

-- =============================================================================
-- AVATAR EQUIP (lobby + match)
-- =============================================================================

function Yargi.ensureSlot(applyData, slotId)
    for i = 0, applyData:Num() - 1 do
        local eq = applyData:Get(i)
        if eq and eq.SlotID == slotId then return end
    end
    applyData:Add({SlotID = slotId, ItemId = 0})
end

function Yargi.setSlotSkin(avatarComp, applyData, idx, itemId, slotId, cacheKey)
    if not itemId or itemId == 0 then return end
    local eq = applyData:Get(idx)
    if not eq or eq.SlotID ~= slotId then return end
    local key = cacheKey .. "_" .. tostring(slotId)
    if eq.ItemId == itemId and applyCache.avatar[key] == itemId then return end
    Yargi.ensureDownload(itemId)
    eq.ItemId = itemId
    applyData:Set(idx, eq)
    avatarComp:OnRep_BodySlotStateChanged()
    applyCache.avatar[key] = itemId
end

function Yargi.setLevelSkin(avatarComp, applyData, idx, baseSkin, defaultId, slotId, levelFn, cache)
    local eq = applyData:Get(idx)
    if not eq or eq.SlotID ~= slotId or not baseSkin or baseSkin == 0 or baseSkin == defaultId then return end
    local level = 1
    if eq.AdditionalItemID and levelFn then level = levelFn(eq.AdditionalItemID) or 1 end
    if level < 1 then level = 1 end
    if level > 3 then level = 3 end
    local applied = baseSkin + (level - 1) * 1000
    if cache.value == applied and eq.ItemId == applied then return end
    Yargi.ensureDownload(baseSkin)
    eq.ItemId = applied
    applyData:Set(idx, eq)
    avatarComp:OnRep_BodySlotStateChanged()
    cache.base = baseSkin
    cache.value = applied
end

function _G.equip_character_avatar_match(uCharacter)
    if not _G.IsPtrValid(uCharacter) or not uCharacter.AvatarComponent2 then return end
    if _G.matchAvatarFullApplied then
        return _G.equip_character_avatar_light(uCharacter)
    end
    _G.equip_character_avatar(uCharacter)
    _G.matchAvatarFullApplied = true
end

function _G.equip_character_avatar_light(uCharacter)
    if not _G.IsPtrValid(uCharacter) or not uCharacter.AvatarComponent2 then return end
    local BackpackUtils = import("BackpackUtils")
    if not BackpackUtils then return end
    local avatarComp = uCharacter.AvatarComponent2
    local applyData = avatarComp.NetAvatarData and avatarComp.NetAvatarData.SlotSyncData
    if not applyData or not _G.IsPtrValid(applyData) then return end
    local S = _G.CustSlotType
    for i = 0, applyData:Num() - 1 do
        Yargi.setLevelSkin(avatarComp, applyData, i, _G.BagSkin, 501001, S.BackpackEquipemtSlot,
            BackpackUtils.GetEquipmentBagLevel, applyCache.bag)
        Yargi.setLevelSkin(avatarComp, applyData, i, _G.HelmetSkin, 502001, S.HelmetEquipemtSlot,
            BackpackUtils.GetEquipmentHelmetLevel, applyCache.helmet)
        Yargi.setSlotSkin(avatarComp, applyData, i, _G.GlovesSkin, S.HandleEquipmentSlot, "glove")
        Yargi.setSlotSkin(avatarComp, applyData, i, _G.ParachuteSkin, S.ParachuteEquipemtSlot, "chute")
    end
end

function _G.equip_character_avatar(uCharacter)
    if not _G.IsPtrValid(uCharacter) or not uCharacter.AvatarComponent2 then return end
    local BackpackUtils = import("BackpackUtils")
    if not BackpackUtils then return end
    local avatarComp = uCharacter.AvatarComponent2
    local applyData = avatarComp.NetAvatarData and avatarComp.NetAvatarData.SlotSyncData
    if not applyData or not _G.IsPtrValid(applyData) then return end

    local S = _G.CustSlotType
    Yargi.ensureSlot(applyData, S.GlideEquipemtSlot)
    if _G.GlovesSkin ~= 0 then Yargi.ensureSlot(applyData, S.HandleEquipmentSlot) end
    if _G.HandEffectSkin ~= 0 then Yargi.ensureSlot(applyData, S.HandEffectEquipemtSlot) end
    if _G.HatSkin ~= 0 then Yargi.ensureSlot(applyData, S.HatEquipemtSlot) end
    if _G.HairSkin ~= 0 then Yargi.ensureSlot(applyData, S.HairEquipemtSlot) end
    if _G.FaceSkin ~= 0 then Yargi.ensureSlot(applyData, S.FaceEquipemtSlot) end
    if _G.HeadSkin ~= 0 then Yargi.ensureSlot(applyData, S.HeadEquipemtSlot) end
    if _G.ArmorSkin ~= 0 then Yargi.ensureSlot(applyData, S.ArmorEquipemtSlot) end

    for i = 0, applyData:Num() - 1 do
        Yargi.setSlotSkin(avatarComp, applyData, i, _G.SuitSkin, S.ClothesEquipemtSlot, "suit")
        Yargi.setLevelSkin(avatarComp, applyData, i, _G.BagSkin, 501001, S.BackpackEquipemtSlot,
            BackpackUtils.GetEquipmentBagLevel, applyCache.bag)
        Yargi.setLevelSkin(avatarComp, applyData, i, _G.HelmetSkin, 502001, S.HelmetEquipemtSlot,
            BackpackUtils.GetEquipmentHelmetLevel, applyCache.helmet)
        Yargi.setSlotSkin(avatarComp, applyData, i, _G.ParachuteSkin, S.ParachuteEquipemtSlot, "chute")
        Yargi.setSlotSkin(avatarComp, applyData, i, _G.GliderSkin, S.GlideEquipemtSlot, "glide")
        Yargi.setSlotSkin(avatarComp, applyData, i, _G.GlovesSkin, S.HandleEquipmentSlot, "glove")
        Yargi.setSlotSkin(avatarComp, applyData, i, _G.HandEffectSkin, S.HandEffectEquipemtSlot, "handfx")
        Yargi.setSlotSkin(avatarComp, applyData, i, _G.HatSkin, S.HatEquipemtSlot, "hat")
        Yargi.setSlotSkin(avatarComp, applyData, i, _G.HairSkin, S.HairEquipemtSlot, "hair")
        Yargi.setSlotSkin(avatarComp, applyData, i, _G.FaceSkin, S.FaceEquipemtSlot, "face")
        Yargi.setSlotSkin(avatarComp, applyData, i, _G.HeadSkin, S.HeadEquipemtSlot, "head")
        Yargi.setSlotSkin(avatarComp, applyData, i, _G.ArmorSkin, S.ArmorEquipemtSlot, "armor")
    end
end

-- =============================================================================
-- PET
-- =============================================================================

function Yargi.applyPetDressToActor(petActor)
    if not _G.IsPtrValid(petActor) or not _G.PetDressSkin or _G.PetDressSkin == 0 then return end
    pcall(function()
        local comp = petActor.PetAvatarComponent_BP
        if comp and comp.PetEquipItemById then
            Yargi.ensureDownload(_G.PetDressSkin)
            comp:PetEquipItemById(_G.PetDressSkin)
        end
    end)
end

function _G.HandlePetLogic()
    pcall(function()
        if not _G.PetSkin or _G.PetSkin == 0 or _G.PetSkin == 50000 then return end
        local needUpdate = (_G.PetSkin ~= applyCache.pet) or (_G.PetDressSkin ~= applyCache.petDress)
        if not needUpdate then return end

        Yargi.ensureDownload(_G.PetSkin)
        if _G.PetDressSkin ~= 0 then Yargi.ensureDownload(_G.PetDressSkin) end

        local ModuleManager = require("client.module_framework.ModuleManager")
        if ModuleManager then
            local logic_pet = ModuleManager.GetModule(ModuleManager.CommonModuleConfig.logic_pet)
            if logic_pet then
                if logic_pet.SetCurPetID then logic_pet:SetCurPetID(_G.PetSkin) end
                if logic_pet.EquipPet then logic_pet:EquipPet(_G.PetSkin) end
            end
        end

        local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
        if _G.IsPtrValid(pc) then
            if pc.InitialPetInfo then pc.InitialPetInfo.PetId = _G.PetSkin end
            if pc.PetComponent and _G.IsPtrValid(pc.PetComponent) then
                if pc.PetComponent.SetPetID then pc.PetComponent:SetPetID(_G.PetSkin) end
                if pc.PetComponent.PetPawn then Yargi.applyPetDressToActor(pc.PetComponent.PetPawn) end
            end
        end

        pcall(function()
            local TeamAvatarManager = require("client.logic.avatar.logic_team_avatar_manager")
            if TeamAvatarManager then
                local mainAvatar = TeamAvatarManager.GetMainAvatar()
                if _G.IsPtrValid(mainAvatar) and mainAvatar.GetPetModel then
                    Yargi.applyPetDressToActor(mainAvatar:GetPetModel())
                end
            end
        end)

        applyCache.pet = _G.PetSkin
        applyCache.petDress = _G.PetDressSkin
    end)
end

-- =============================================================================
-- WEAPONS / BACKPACK COATING
-- =============================================================================

function Yargi.applyGrenadesInBackpack(uChar, force)
    if not _G.IsPtrValid(uChar) then return end
    pcall(function()
        local bp = uChar.BackpackComponent
        if not bp or not bp.GetItemListByType then return end
        local itemList = bp:GetItemListByType(6)
        if not itemList then return end
        for i = 0, itemList:Num() - 1 do
            local item = itemList:Get(i)
            if item and item.DefineID then
                local tid = item.DefineID.TypeSpecificID
                if Yargi.isGrenadeId(Yargi.getBaseWeaponId(tid)) then
                    local skinId = _G.get_skin_id(Yargi.getBaseWeaponId(tid))
                    if skinId and skinId ~= tid then
                        item.DefineID.TypeSpecificID = skinId
                    end
                end
            end
        end
    end)
end

function Yargi.applyAllPlayerWeapons(uChar, force)
    if not _G.IsPtrValid(uChar) then return end
    local curr = uChar:GetCurrentWeapon()
    if _G.IsPtrValid(curr) then Yargi.applyWeaponSkin(curr, force) end

    local bp = uChar.BackpackComponent
    if bp and bp.GetWeaponList then
        local list = bp:GetWeaponList()
        if list then
            for i = 0, list:Num() - 1 do
                Yargi.applyWeaponSkin(list:Get(i), force)
            end
        end
    end
    Yargi.applyGrenadesInBackpack(uChar, force)
end

function Yargi.applyExtraLobbyWeapons()
    pcall(function()
        local WardrobeGunLogic = require("client.slua.logic.wardrobe.logic_wardrobe_gun")
        if not WardrobeGunLogic or not WardrobeGunLogic.UpdateExtraGunAvatar then return end
        for gunID, idx in pairs(_G.ExtraWeaponSkinIndex) do
            local skins = _G.skinIdMappings[gunID]
            if skins and skins[idx] then
                local skinRes = skins[idx]
                local fake = Yargi.getFakeDepotByResID(skinRes)
                local insID = fake and fake.insID or (Yargi.FAKE_INS_BASE + skinRes)
                WardrobeGunLogic:UpdateExtraGunAvatar(gunID, insID)
            end
        end
    end)
end

function _G.UpdateWeapon_BackPack_Appearance(PlayerController, force)
    pcall(function()
        if not _G.IsPtrValid(PlayerController) then return end
        local uCharacter = PlayerController:GetPlayerCharacterSafety()
        Yargi.applyAllPlayerWeapons(uCharacter, force)
    end)
end

function _G.GameAvatarHandlerweapons()
    pcall(function()
        local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
        local uChar = _G.IsPtrValid(pc) and pc:GetPlayerCharacterSafety()
        if _G.IsPtrValid(uChar) then Yargi.applyAllPlayerWeapons(uChar, false) end

        local TeamAvatarManager = require("client.logic.avatar.logic_team_avatar_manager")
        if TeamAvatarManager then
            local mainAvatar = TeamAvatarManager.GetMainAvatar()
            if _G.IsPtrValid(mainAvatar) and mainAvatar.GetWeaponAvatar then
                Yargi.applyWeaponSkin(mainAvatar:GetWeaponAvatar(), false)
            end
        end
    end)
end

function _G.GameAvatarHandlerBagPack()
    local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
    if _G.IsPtrValid(pc) then _G.UpdateWeapon_BackPack_Appearance(pc, false) end
end

-- =============================================================================
-- VEHICLES
-- =============================================================================

function Yargi.matchVehicleType(defaultId, vehicleType)
    local idStr = tostring(defaultId)
    local typeStr = tostring(vehicleType)
    if idStr == typeStr then return true end
    if idStr:sub(-#typeStr) == typeStr then return true end
    local pattern = "[^%d]" .. typeStr .. "[^%d]"
    if idStr:find(typeStr .. "$") then return true end
    if #typeStr == 3 and idStr:find(typeStr, 1, true) then return true end
    return false
end

function _G.GameAvatarHandlervehicles()
    pcall(function()
        local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
        if not _G.IsPtrValid(pc) then return end
        local uChar = pc:GetPlayerCharacterSafety()
        if not _G.IsPtrValid(uChar) then return end
        local vehicle = uChar.CurrentVehicle
        if not _G.IsPtrValid(vehicle) then return end
        local vehAvatar = vehicle.VehicleAvatar
        if not _G.IsPtrValid(vehAvatar) then return end

        vehAvatar.curSwitchEffectId = _G.VehicleSwitchEffectId or 7303001
        local defaultId = tostring(vehAvatar:GetDefaultAvatarID())
        local currentId = vehicle:GetAvatarId()

        local sortedTypes = {}
        for vType in pairs(_G.VehskinIdMappings) do sortedTypes[#sortedTypes + 1] = vType end
        table.sort(sortedTypes, function(a, b) return a > b end)

        for _, vType in ipairs(sortedTypes) do
            if Yargi.matchVehicleType(defaultId, vType) then
                local skins = _G.VehskinIdMappings[vType]
                local idx = _G.VehicleSkinIndex[vType] or 1
                if idx > #skins then idx = 1 end
                local skinId = skins[idx]
                local cacheKey = vType .. "_" .. defaultId
                if skinId and (currentId ~= skinId or applyCache.vehicle[cacheKey] ~= skinId) then
                    Yargi.ensureDownload(skinId)
                    vehAvatar:ChangeItemAvatar(skinId, true)
                    applyCache.vehicle[cacheKey] = skinId
                end
                break
            end
        end
    end)
end

-- =============================================================================
-- LOBBY THEME
-- =============================================================================

function _G.ApplyLobbyTheme()
    pcall(function()
        local themeID = _G.TargetLobbyThemeID
        if not themeID or themeID == 0 or _G.LastAppliedThemeID == themeID then return end
        local ModuleManager = require("client.module_framework.ModuleManager")
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
                if ThemeVehicleManager.ShowThemeVehicle then ThemeVehicleManager:ShowThemeVehicle() end
                if ThemeVehicleManager.RefreshSpecialEffect then ThemeVehicleManager:RefreshSpecialEffect() end
                if ThemeVehicleManager.RefreshGarageThemeVehicle then
                    ThemeVehicleManager:RefreshGarageThemeVehicle()
                end
            end
            _G.LastAppliedThemeID = themeID
        end
        local HallThemeUtils = require("client.logic.lobby.hall_theme_utils")
        if HallThemeUtils then
            HallThemeUtils.themeVehicleShow = true
            if HallThemeUtils.ShowThemeVehicle then HallThemeUtils.ShowThemeVehicle() end
        end
        pcall(function()
            local GarageThemeSystem = ModuleManager.GetModule(ModuleManager.LobbyModuleConfig.GarageThemeSystem)
            if GarageThemeSystem and GarageThemeSystem.RefreshGarageVehicles then
                GarageThemeSystem:RefreshGarageVehicles()
            end
        end)
        local logic_lobby = require("client.slua.logic.lobby.logic_lobby_main")
        if logic_lobby and logic_lobby.RefreshLobbyUI then logic_lobby:RefreshLobbyUI() end
    end)
end

function _G.CheckLobbyThemeChanges()
    pcall(function()
        local old = _G.TargetLobbyThemeID
        local content = Yargi.readConfigContent()
        if content then
            local cfg = Yargi.parseConfig(content)
            if cfg.LobbyTheme and cfg.LobbyTheme ~= old then
                _G.TargetLobbyThemeID = cfg.LobbyTheme
            end
        end
        if _G.TargetLobbyThemeID ~= old then _G.ApplyLobbyTheme() end
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

-- =============================================================================
-- HANDLERS
-- =============================================================================

function Yargi.applyAvatarToModel(model)
    if _G.IsPtrValid(model) then
        if Yargi.isInLobby() then
            _G.equip_character_avatar(model)
        else
            _G.equip_character_avatar_match(model)
        end
    end
end

function _G.GameAvatarHandlerplayers()
    pcall(function()
        local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
        if not _G.IsPtrValid(pc) then return end
        if pc.HiggsBoson then
            pc.HiggsBoson.bMHActive = false
            pc.HiggsBoson.bCallPreReplication = false
        end
        local uChar = pc:GetPlayerCharacterSafety()
        if not _G.IsPtrValid(uChar) then return end
        if Yargi.isInLobby() then
            _G.equip_character_avatar(uChar)
        else
            _G.equip_character_avatar_match(uChar)
        end
    end)
end

function _G.Lobby_Avatar_Handler()
    pcall(function()
        _G.CheckLobbyThemeChanges()
        local TeamAvatarManager = require("client.logic.avatar.logic_team_avatar_manager")
        if TeamAvatarManager then
            local mainAvatar = TeamAvatarManager.GetMainAvatar()
            if _G.IsPtrValid(mainAvatar) then
                Yargi.applyAvatarToModel(mainAvatar.GetModel and mainAvatar:GetModel())
            end
            if DataMgr and DataMgr.roleData and TeamAvatarManager.GetAvatarByUid then
                local myAvatar = TeamAvatarManager.GetAvatarByUid(DataMgr.roleData.uid)
                if _G.IsPtrValid(myAvatar) and myAvatar ~= mainAvatar then
                    Yargi.applyAvatarToModel(myAvatar.GetModel and myAvatar:GetModel())
                end
            end
        end
        _G.GameAvatarHandlerplayers()
        _G.HandlePetLogic()
        _G.GameAvatarHandlerweapons()
        Yargi.applyExtraLobbyWeapons()
    end)
end

function _G.Game_Avatar_Handler()
    pcall(function()
        _G.GameAvatarHandlerplayers()
        _G.HandlePetLogic()
        _G.GameAvatarHandlerweapons()
    end)
end

function _G.RefreshAllSkins()
    pcall(function()
        _G.Lobby_Avatar_Handler()
        _G.Game_Avatar_Handler()
        _G.GameAvatarHandlerweapons()
        local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
        if _G.IsPtrValid(pc) then _G.UpdateWeapon_BackPack_Appearance(pc, true) end
        _G.GameAvatarHandlervehicles()
        _G.UpdateMyKillCounter = true
        _G.GameAvatarHandlerkillcounter()
        _G.ApplyLobbyTheme()
    end)
end

-- =============================================================================
-- KILL COUNTER
-- =============================================================================

function _G.getKills(weaponID) return weaponID and _G.killCountInfo[weaponID] or 0 end

local function saveKillCountToFile()
    local file = io.open(_G.ActiveKillCounterPath, "w+")
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
    local file = io.open(_G.ActiveKillCounterPath, "r")
    if not file then return end
    local content = file:read("*a") or ""
    file:close()
    _G.lastFileContent = content
    if content == "" then return end
    content = content:gsub("\239\187\191", ""):gsub("^%s+", "")
    local temp = {}
    for wid, cnt in content:gmatch("%[(%d+)%]%s*=%s*(%d+)") do
        temp[tonumber(wid)] = tonumber(cnt)
    end
    if next(temp) then _G.killCountInfo = temp end
end

function _G.addKill(weaponID, count)
    if not weaponID or not count then return end
    _G.killCountInfo[weaponID] = (_G.killCountInfo[weaponID] or 0) + count
    pcall(saveKillCountToFile)
    _G.UpdateMyKillCounter = true
    _G.GameAvatarHandlerkillcounter()
end

function _G.FileWatcher()
    if not _G.isFileWatcherActive then return end
    pcall(function()
        local file = io.open(_G.ActiveKillCounterPath, "r")
        if not file then return end
        local cur = file:read("*a") or ""
        file:close()
        cur = cur:gsub("\239\187\191", ""):gsub("^%s+", ""):gsub("%s+$", "")
        if cur == "" or cur == _G.lastFileContent then return end
        _G.lastFileContent = cur
        local temp = {}
        for wid, cnt in cur:gmatch("%[(%d+)%]%s*=%s*(%d+)") do
            temp[tonumber(wid)] = tonumber(cnt)
        end
        if next(temp) then
            _G.killCountInfo = temp
            _G.UpdateMyKillCounter = true
            _G.GameAvatarHandlerkillcounter()
        end
    end)
end

function Yargi.installKillInfoHook()
    pcall(function()
        local SKillInfo = require("GameLua.Mod.BaseMod.Client.KillInfoTips.KillInfo")
        local ECharacterHealthStatus = import("ECharacterHealthStatus")
        if not SKillInfo or not SKillInfo.__inner_impl or not SKillInfo.__inner_impl.FileItem then return end
        local o_FileItem = SKillInfo.__inner_impl.FileItem
        SKillInfo.__inner_impl.FileItem = function(self, DamageRecordData)
            if not self or not DamageRecordData then return o_FileItem(self, DamageRecordData) end
            pcall(function()
                local MM = require("client.module_framework.ModuleManager")
                local LogicKillCounter = MM.GetModule(MM.CommonModuleConfig.LogicKillCounter)
                if not LogicKillCounter then return end
                local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
                local uCharacter = pc and pc:GetPlayerCharacterSafety()
                if not _G.IsPtrValid(uCharacter) then return end
                if DamageRecordData.Causer ~= uCharacter:GetPlayerNameSafety() then return end
                if _G.SuitSkin and _G.SuitSkin > 0 then
                    DamageRecordData.CauserClothAvatarID = _G.SuitSkin
                end
                local currWeapon = uCharacter:GetCurrentWeapon()
                if not _G.IsPtrValid(currWeapon) then return end
                local DefineID = currWeapon:GetItemDefineID()
                local typeId = DefineID and DefineID.TypeSpecificID or 0
                if typeId == 0 then return end
                local ItemUpgradeSystem = MM.GetModule(MM.CommonModuleConfig.ItemUpgradeSystem)
                if ItemUpgradeSystem then
                    local maxItem = ItemUpgradeSystem:GetMaxLevelItem(typeId)
                    if maxItem and maxItem ~= -1 then
                        DamageRecordData.CauserWeaponAvatarID = maxItem
                    end
                end
                local ExpandData = slua.LuaArchiverDecode(LuaStateWrapper, DamageRecordData.ExpandDataContent) or {}
                local SupportKillCounter = LogicKillCounter:GetBaseKillCounterIdByWeaponId(typeId)
                if SupportKillCounter and DamageRecordData.ResultHealthStatus == ECharacterHealthStatus.FinishedLastBreath then
                    ExpandData.KillCounterItemId = typeId
                    ExpandData.KillCounterNum = (ExpandData.KillCounterNum or 0) + 1
                    _G.addKill(typeId, 1)
                end
                DamageRecordData.ExpandDataContent = slua.LuaArchiverEncode(LuaStateWrapper, ExpandData)
            end)
            return o_FileItem(self, DamageRecordData)
        end
    end)
end

function _G.InstallKillCounterUIHooks()
    pcall(function()
        local MyMainKillCounter = require("GameLua.Mod.BaseMod.Client.KillCounter.MainKillCounter")
        local MyKillCountSubSystem = require("GameLua.Mod.BaseMod.Client.KillCounter.KillCounterUISubsystem")
        if not MyMainKillCounter or not MyKillCountSubSystem then return end

        MyMainKillCounter.__inner_impl.OnRefreshUI = function(self, _, _, UID)
            pcall(function()
                local MM = require("client.module_framework.ModuleManager")
                local LogicKillCounter = MM.GetModule(MM.CommonModuleConfig.LogicKillCounter)
                local pc = slua_GameFrontendHUD:GetPlayerController()
                local uCharacter = pc and pc:GetPlayerCharacterSafety()
                if not uCharacter then return end
                local currweapon = uCharacter:GetCurrentWeapon()
                if not currweapon then return end
                local DefineID = currweapon:GetItemDefineID().TypeSpecificID
                local curSkin = slua.IndexReference(currweapon.synData:Get(7), "defineID").TypeSpecificID
                local curEquiped = LogicKillCounter:GetEquipedKillCounterId(_G.LastKillEffectSkin, curSkin)
                if not curEquiped or curEquiped == 0 then
                    curEquiped = LogicKillCounter:GetBaseKillCounterIdByWeaponId(DefineID)
                end
                self.KillCounterItem:SetKillCounterItemShowWithNum(curEquiped, _G.getKills(DefineID), curSkin)
            end)
        end

        MyKillCountSubSystem.__inner_impl.CheckSupportKCUI = function(self) return true end

        MyKillCountSubSystem.__inner_impl.CheckNeedMainKillCounterUI = function(self, Weapon, PlayerID)
            pcall(function()
                local pc = slua_GameFrontendHUD:GetPlayerController()
                local uCharacter = pc and pc:GetPlayerCharacterSafety()
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
                local pc = slua_GameFrontendHUD:GetPlayerController()
                local uCharacter = pc and pc:GetPlayerCharacterSafety()
                if not uCharacter then return end
                local currweapon = uCharacter:GetCurrentWeapon()
                if not bShow and MainKillCounter then
                    UIManager.CloseUI(UIManager.UI_Config_InGame.MainKillCounter)
                elseif bShow and currweapon then
                    local DefineID = currweapon:GetItemDefineID().TypeSpecificID
                    local curSkin = slua.IndexReference(currweapon.synData:Get(7), "defineID").TypeSpecificID
                    local MM = require("client.module_framework.ModuleManager")
                    local LogicKillCounter = MM.GetModule(MM.CommonModuleConfig.LogicKillCounter)
                    local SupportKillCounter = LogicKillCounter:GetBaseKillCounterIdByWeaponId(DefineID)
                    if SupportKillCounter == nil and MainKillCounter then
                        UIManager.CloseUI(UIManager.UI_Config_InGame.MainKillCounter)
                    elseif DefineID == curSkin and MainKillCounter then
                        UIManager.CloseUI(UIManager.UI_Config_InGame.MainKillCounter)
                    else
                        local curEquiped = LogicKillCounter:GetEquipedKillCounterId(_G.LastKillEffectSkin, curSkin)
                        if not MainKillCounter then
                            UIManager.ShowUI(UIManager.UI_Config_InGame.MainKillCounter, DefineID, curSkin)
                            MainKillCounter = UIManager.GetUI(UIManager.UI_Config_InGame.MainKillCounter)
                        else
                            MainKillCounter:UpdateWeaponID(DefineID, curSkin)
                        end
                        if MainKillCounter then
                            MainKillCounter:SetKillCounterItemShowWithNum(curEquiped, _G.getKills(DefineID), curSkin)
                        end
                    end
                end
            end)
        end
    end)
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

-- =============================================================================
-- COSMETIC HOOKS (upgrade, kill effects, emote, final kill)
-- =============================================================================

function _G.InstallOriginalHooks()
    pcall(function()
        local ModuleManager = require("client.module_framework.ModuleManager")
        local ItemUpgradeModule = ModuleManager.GetModule(ModuleManager.CommonModuleConfig.ItemUpgradeModule)
        if ItemUpgradeModule then
            ItemUpgradeModule.GetCurLevelByGroupID = function(self, groupID)
                local groupList = self:GetUpgradeGroupByID(groupID)
                return groupList and #groupList or 7
            end
            ItemUpgradeModule.GetLevelByGroupIDFull = function(self, groupID)
                local groupList = self:GetUpgradeGroupByID(groupID)
                return groupList and #groupList or 7
            end
            ItemUpgradeModule.IsUnlockWeapon = function() return true end
        end

        local XSuitAvatarDataUtil = require("GameLua.Activity.Commercialize.GamePlay.XSuit.XSuitAvatarDataUtil")
        if XSuitAvatarDataUtil then
            XSuitAvatarDataUtil.GetUnlockLevel = function() return 7 end
            XSuitAvatarDataUtil.GetShowLevel = function() return 7 end
        end

        local SKillInfo = require("GameLua.Mod.BaseMod.Client.KillInfoTips.KillInfo")
        if SKillInfo and SKillInfo.__inner_impl then
            local o_UpdateKillEffect = SKillInfo.__inner_impl.UpdateKillEffect
            SKillInfo.__inner_impl.UpdateKillEffect = function(self, WeaponAvatarID, DamageRecordData)
                if ItemUpgradeModule and WeaponAvatarID ~= 0 then
                    local maxItem = ItemUpgradeModule:GetMaxLevelItem(WeaponAvatarID)
                    if maxItem and maxItem ~= -1 then WeaponAvatarID = maxItem end
                end
                return o_UpdateKillEffect(self, WeaponAvatarID, DamageRecordData)
            end
        end

        local DeadBoxFeature = require("GameLua.Mod.BaseMod.GamePlay.Feature.Common.DeadBoxClientShowFeature")
        if DeadBoxFeature and DeadBoxFeature.RPC_Multicast_PawnDie then
            local o_Die = DeadBoxFeature.RPC_Multicast_PawnDie
            DeadBoxFeature.RPC_Multicast_PawnDie = function(self, Loc, AvatarID)
                local boxAvatar = (_G.SuitSkin and _G.SuitSkin > 0) and _G.SuitSkin or AvatarID
                if ItemUpgradeModule and boxAvatar ~= 0 then
                    local maxItem = ItemUpgradeModule:GetMaxLevelItem(boxAvatar)
                    if maxItem and maxItem ~= -1 then boxAvatar = maxItem end
                end
                return o_Die(self, Loc, boxAvatar)
            end
        end

        pcall(function()
            local XSuitAvatarDataUtil = require("GameLua.Activity.Commercialize.GamePlay.XSuit.XSuitAvatarDataUtil")
            if XSuitAvatarDataUtil and XSuitAvatarDataUtil.GenerateKillBroadcastItemID then
                local o_KillBroadcast = XSuitAvatarDataUtil.GenerateKillBroadcastItemID
                XSuitAvatarDataUtil.GenerateKillBroadcastItemID = function(self, ClothAvatarID, PlayerUID)
                    if _G.SuitSkin and _G.SuitSkin > 0 then
                        ClothAvatarID = _G.SuitSkin
                    end
                    return o_KillBroadcast(self, ClothAvatarID, PlayerUID)
                end
            end
        end)

        pcall(function()
            local FeatureHitEffect = require("client.slua.traits.DetailComponent.FeatureComponent.FeatureTraits.FeatureHitEffect")
            if FeatureHitEffect and FeatureHitEffect.PlayHitEffect then
                local o_PlayHit = FeatureHitEffect.PlayHitEffect
                FeatureHitEffect.PlayHitEffect = function(self, data)
                    if _G.ActiveHitEffectResId and _G.ActiveHitEffectResId > 0 and data and data.config then
                        local CDataTable = require("client.slua.config.ClientConfig.data_mgr")
                        local eff = CDataTable.GetTableData("AvatarWeaponHitFXData", _G.ActiveHitEffectResId)
                        if eff and eff.HitEffect and eff.HitEffect ~= "" then
                            data.config.HitEffect = eff.HitEffect
                        end
                    end
                    return o_PlayHit(self, data)
                end
            end
        end)

        pcall(function()
            local wardrobe_data = require("client.slua.logic.wardrobe.wardrobe_data")
            if wardrobe_data and wardrobe_data.CheckHasPermanentItem then
                local o_Check = wardrobe_data.CheckHasPermanentItem
                wardrobe_data.CheckHasPermanentItem = function(self, itemId, source)
                    if Yargi.isFakeRes(itemId) then return true end
                    return o_Check(self, itemId, source)
                end
            end
        end)

        pcall(function()
            local LogicParticleEmote = require("client.slua.logic.wardrobe.LogicParticleEmote")
            if LogicParticleEmote then
                if LogicParticleEmote.HasUnlockParticle then
                    LogicParticleEmote.HasUnlockParticle = function() return true end
                end
                if LogicParticleEmote.IsUnLockProp then
                    LogicParticleEmote.IsUnLockProp = function() return true end
                end
            end
        end)

        pcall(function()
            local ItemUpgradeModule = ModuleManager.GetModule(ModuleManager.CommonModuleConfig.ItemUpgradeModule)
            if ItemUpgradeModule then
                if ItemUpgradeModule.IsWeaponEmoteUnlocked then
                    ItemUpgradeModule.IsWeaponEmoteUnlocked = function() return true end
                end
                if ItemUpgradeModule.IsWeaponEmoteUnlockedWithOutCheckWeapon then
                    ItemUpgradeModule.IsWeaponEmoteUnlockedWithOutCheckWeapon = function() return true end
                end
            end
        end)

        pcall(function()
            local GrenadeAvatarComponent = require("GameLua.Mod.Library.GamePlay.Avatar.Component.GrenadeAvatarComponent")
            if GrenadeAvatarComponent and GrenadeAvatarComponent.CheckHasOverrideFx then
                local o_Check = GrenadeAvatarComponent.CheckHasOverrideFx
                GrenadeAvatarComponent.CheckHasOverrideFx = function(self, PlayerController, GrenadeSkinID)
                    if GrenadeSkinID and GrenadeSkinID > 0 then
                        local baseId = Yargi.getBaseWeaponId(GrenadeSkinID)
                        local mapped = _G.get_skin_id(baseId)
                        if mapped and mapped ~= GrenadeSkinID then
                            GrenadeSkinID = mapped
                        end
                    end
                    return o_Check(self, PlayerController, GrenadeSkinID)
                end
            end
        end)

        local function hookKillEffect(mod)
            if not mod then return end
            mod.CheckHasEffect = function() return true end
            local o_Get = mod.GetCurEquipedEffectId
            mod.GetCurEquipedEffectId = function(self)
                if _G.LastKillEffectSkin and _G.LastKillEffectSkin > 0 then
                    return _G.LastKillEffectSkin
                end
                local id = o_Get and o_Get(self)
                return id or 6114302174
            end
        end

        hookKillEffect(require("client.logic.kill_features.LogicLastKillEffecs"))
        hookKillEffect(require("client.logic.kill_features.LogicEliminationKingEffect"))

        pcall(function()
            local FinalKillEffectSubsystem = require("GameLua.Mod.Library.GamePlay.Subsystem.FinalKillEffectSubsystem")
            if FinalKillEffectSubsystem and FinalKillEffectSubsystem.GetFinalKillEffectItemId then
                local o_Get = FinalKillEffectSubsystem.GetFinalKillEffectItemId
                FinalKillEffectSubsystem.GetFinalKillEffectItemId = function(self, PlayerCharacter, TestItemId)
                    if _G.FinalKillEffectSkin and _G.FinalKillEffectSkin > 0 then
                        return _G.FinalKillEffectSkin
                    end
                    return o_Get(self, PlayerCharacter, TestItemId)
                end
            end
        end)

        local ActorVoiceSystem = require("client.slua.logic.actor_voice.logic_actor_voice")
        if ActorVoiceSystem then
            ActorVoiceSystem.CheckIsActorUnLocked = function() return true end
            ActorVoiceSystem.CheckIsVoiceUnLock = function() return true end
            ActorVoiceSystem.CheckIsActorValid = function() return true end
        end

        pcall(function()
            local QuickExpressionUtils = require("GameLua.Mod.BaseMod.Client.Emote.QuickExpressionUtils")
            if QuickExpressionUtils and QuickExpressionUtils.CheckEmoteUnlocked then
                QuickExpressionUtils.CheckEmoteUnlocked = function() return true end
            end
        end)
    end)
end

-- =============================================================================
-- SECURITY BYPASS
-- =============================================================================

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
    if not _G.IsPtrValid(pc) or not pc.HiggsBoson then return end
    pc.HiggsBoson.bMHActive = false
    pc.HiggsBoson.bCallPreReplication = false
end

-- =============================================================================
-- WARDROBE / ARMORY INTEGRATION v2.4
-- =============================================================================

Yargi.fakeDepot = {}
Yargi.fakeResSet = {}
Yargi.wardrobeHooksInstalled = false
Yargi.depotInjectReady = false
Yargi.FAKE_INS_BASE = 8800000000
Yargi.lastDepotInject = 0
Yargi.lastArmoryRebuild = 0
Yargi.dumpSkinLoaded = false
Yargi.dumpSkinInProgress = false
Yargi.statusHooksInstalled = false

function Yargi.isInLobby()
    local ok, ret = pcall(function()
        local GameStatus = require("client.logic.gamestatus.GameStatus")
        return GameStatus and GameStatus.IsInLobbyOrMainCity and GameStatus.IsInLobbyOrMainCity()
    end)
    return ok and ret == true
end

function Yargi.getNetOkRes()
    if NetErrorCode_NONE ~= nil then return NetErrorCode_NONE end
    return "ok"
end

function Yargi.applySkinsNow()
    pcall(function()
        applyCache.weapon = {}
        Yargi.savePersistState()
        Yargi.downloadEquippedBatch()
        if Yargi.isInLobby() then
            _G.Lobby_Avatar_Handler()
        else
            local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
            local uChar = _G.IsPtrValid(pc) and pc:GetPlayerCharacterSafety()
            if _G.IsPtrValid(uChar) then _G.equip_character_avatar_match(uChar) end
            _G.GameAvatarHandlerweapons()
            _G.GameAvatarHandlerBagPack()
            if _G.IsPtrValid(pc) then _G.UpdateWeapon_BackPack_Appearance(pc, true) end
        end
    end)
end

function Yargi.matchRealtimeTick()
    if Yargi.isInLobby() then return end
    pcall(function()
        local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
        if not _G.IsPtrValid(pc) then return end
        local uChar = pc:GetPlayerCharacterSafety()
        if _G.IsPtrValid(uChar) then
            Yargi.applyAllPlayerWeapons(uChar, true)
            _G.equip_character_avatar_match(uChar)
        end
    end)
end

function Yargi.isFakeIns(insID)
    insID = tonumber(insID)
    return insID and insID >= Yargi.FAKE_INS_BASE
end

function Yargi.isFakeRes(resID)
    return resID and Yargi.fakeResSet[tonumber(resID)] ~= nil
end

function Yargi.ensureItemFields(item)
    if not item or item.bConfigLoaded then return item end
    pcall(function()
        local CDataTable = require("client.slua.config.ClientConfig.data_mgr")
        local cfg = CDataTable.GetTableData("Item", item.resID)
        if cfg then
            item.itemType = cfg.ItemType
            item.itemSubType = cfg.ItemSubType
            item.mainTabType = cfg.WardrobeMainTab
            item.subTabType = cfg.WardrobeTab
            item.itemQuality = cfg.ItemQuality
            item.bConfigLoaded = true
        end
    end)
    return item
end

function Yargi.buildFakeDepotItem(resID)
    resID = tonumber(resID)
    if not resID or resID == 0 then return nil end
    local insID = Yargi.FAKE_INS_BASE + resID
    local item = {
        insID = insID,
        resID = resID,
        expireTS = 0,
        count = 1,
        lock_cnt = 0,
        colorID = 0,
        patternID = 0,
        validHours = 0,
        isNew = false,
        bConfigLoaded = false
    }
    return Yargi.ensureItemFields(item)
end

function Yargi.registerFakeResID(resID)
    resID = tonumber(resID)
    if not resID or resID == 0 then return end
    if Yargi.fakeResSet[resID] then
        _G.SkinLoadedCache[resID] = true
        return
    end
    local item = Yargi.buildFakeDepotItem(resID)
    if not item then return end
    Yargi.fakeDepot[item.insID] = item
    Yargi.fakeResSet[resID] = item.insID
    _G.SkinLoadedCache[resID] = true
end

function Yargi.registerAllFakeItems()
    for _, skins in pairs(_G.skinIdMappings) do
        for _, resID in ipairs(skins) do Yargi.registerFakeResID(resID) end
    end
    for _, list in pairs(_G.OutfitSkins) do
        for _, resID in ipairs(list) do Yargi.registerFakeResID(resID) end
    end
    for _, skins in pairs(_G.VehskinIdMappings) do
        for _, resID in ipairs(skins) do Yargi.registerFakeResID(resID) end
    end
    if _G.LobbyThemeSkins then
        for _, resID in ipairs(_G.LobbyThemeSkins) do Yargi.registerFakeResID(resID) end
    end
end

function Yargi.refreshOutfitMaps()
    _G.SuitSkinsMap = _G.OutfitSkins.Suit
    _G.BagSkinsMap = _G.OutfitSkins.Bag
    _G.HelmetSkinsMap = _G.OutfitSkins.Helmet
    _G.ParachutSkinsMap = _G.OutfitSkins.Parachute
    _G.GliderSkinsMap = _G.OutfitSkins.Glider
    _G.PetSkinsMap = _G.OutfitSkins.Pet
end

function Yargi.appendSkinToMapping(baseId, skinId)
    baseId = tonumber(baseId)
    skinId = tonumber(skinId)
    if not baseId or not skinId or skinId == baseId then return end
    local list = _G.skinIdMappings[baseId]
    if not list then
        list = { baseId }
        _G.skinIdMappings[baseId] = list
    end
    for _, v in ipairs(list) do
        if v == skinId then return end
    end
    list[#list + 1] = skinId
end

function Yargi.appendOutfitId(listKey, resID)
    resID = tonumber(resID)
    if not resID or resID == 0 then return end
    local list = _G.OutfitSkins[listKey]
    if not list then
        _G.OutfitSkins[listKey] = { resID }
        return
    end
    for _, v in ipairs(list) do
        if v == resID then return end
    end
    list[#list + 1] = resID
end

function Yargi.categorizeDumpItem(id, itemCfg)
    id = tonumber(id)
    if not id or id < 100000 or not itemCfg then return false end
    if itemCfg.ItemType and ENUM_ITEM_TYPE and itemCfg.ItemType == ENUM_ITEM_TYPE.Hall_Theme then
        _G.LobbyThemeSkins = _G.LobbyThemeSkins or {}
        for _, v in ipairs(_G.LobbyThemeSkins) do
            if v == id then return true end
        end
        _G.LobbyThemeSkins[#_G.LobbyThemeSkins + 1] = id
    elseif id >= 1501001000 and id < 1501016000 then
        Yargi.appendOutfitId("Bag", id)
    elseif id >= 1502001000 and id < 1502016000 then
        Yargi.appendOutfitId("Helmet", id)
    elseif (id >= 402000 and id < 403000) or (id >= 452000 and id < 453000) then
        Yargi.appendOutfitId("Gloves", id)
    elseif id >= 1405000 and id < 1410000 and itemCfg.WardrobeMainTab == 1 then
        Yargi.appendOutfitId("Suit", id)
    elseif id >= 703000 and id < 704000 then
        Yargi.appendOutfitId("Parachute", id)
    elseif id >= 4151000 and id < 4152000 then
        Yargi.appendOutfitId("Glider", id)
    elseif itemCfg.WardrobeMainTab and itemCfg.WardrobeMainTab > 0 then
        if itemCfg.WardrobeMainTab == 1 or (itemCfg.ItemSubType and itemCfg.ItemSubType >= 400) then
            Yargi.appendOutfitId("Suit", id)
        end
    else
        return false
    end
    return true
end

function Yargi.processDumpItemId(id, itemCfg, CDataTable)
    id = tonumber(id)
    if not id then return false end
    local wmap = CDataTable.GetTableData("WeaponSkinMapping", id)
    if wmap and (wmap.WeaponID or wmap.WeaponId) then
        local baseId = wmap.WeaponID or wmap.WeaponId
        Yargi.appendSkinToMapping(baseId, id)
        Yargi.registerFakeResID(id)
        return true
    end
    if not itemCfg then itemCfg = CDataTable.GetTableData("Item", id) end
    if not itemCfg or not itemCfg.BPID or itemCfg.BPID == 0 then return false end
    Yargi.registerFakeResID(id)
    Yargi.categorizeDumpItem(id, itemCfg)
    return true
end

function Yargi.runMemorySkinDump(force)
    if Yargi.dumpSkinInProgress then return end
    if Yargi.dumpSkinLoaded and not force then return end
    pcall(function()
        local async = require("client.common.async")
        Yargi.dumpSkinInProgress = true
        async.Run(function(co)
            local CDataTable = require("client.slua.config.ClientConfig.data_mgr")
            local added, batch, batchSize = 0, 0, 200

            local wTable = CDataTable.GetTable("WeaponSkinMapping")
            if wTable then
                for skinId, cfg in pairs(wTable) do
                    local sid = tonumber(skinId)
                    local wid = cfg and (cfg.WeaponID or cfg.WeaponId)
                    if sid and wid then
                        Yargi.appendSkinToMapping(wid, sid)
                        Yargi.registerFakeResID(sid)
                        added = added + 1
                    end
                    batch = batch + 1
                    if batch >= batchSize then batch = 0; async.Yield(co) end
                end
            end

            local ItemTable = CDataTable.GetTable("Item")
            if ItemTable then
                for id, v in pairs(ItemTable) do
                    local itemId = tonumber(v.ID or id)
                    if itemId and v.BPID and v.BPID ~= 0 then
                        if Yargi.processDumpItemId(itemId, v, CDataTable) then
                            added = added + 1
                        end
                    end
                    batch = batch + 1
                    if batch >= batchSize then batch = 0; async.Yield(co) end
                end
            end

            pcall(function()
                local backpack = UE4 and UE4.UBackpackUtils and UE4.UBackpackUtils.StaticClass()
                if backpack and backpack.GetItemIDs then
                    local items = backpack:GetItemIDs()
                    if items then
                        for i = 0, items:Num() - 1 do
                            local itemID = items:Get(i)
                            if Yargi.processDumpItemId(itemID, nil, CDataTable) then
                                added = added + 1
                            end
                            batch = batch + 1
                            if batch >= batchSize then batch = 0; async.Yield(co) end
                        end
                    end
                end
            end)

            Yargi.refreshOutfitMaps()
            Yargi.dumpSkinLoaded = true
            Yargi.dumpSkinInProgress = false
            print("[YARGI] Memory skin dump done, items=" .. tostring(added))
            pcall(function()
                Yargi.injectFakeItemsToDepot()
                Yargi.injectArmorySkinList(true)
            end)
        end)
    end)
end

function Yargi.installBackpackSkinHook()
    if _G.BackpackSkinHooked then return end
    pcall(function()
        local function wrapWeaponUI(WIIB)
            if not WIIB or not WIIB.__inner_impl or not WIIB.__inner_impl.UpdateWeaponAppearanceInfo then return end
            local old_UpdateWeaponAppearanceInfo = WIIB.__inner_impl.UpdateWeaponAppearanceInfo
            WIIB.__inner_impl.UpdateWeaponAppearanceInfo = function(self, TypeSpecificID, BattleData, DragOrigin)
                local baseId = Yargi.getBaseWeaponId(TypeSpecificID)
                local skin_id = _G.get_skin_id(baseId)
                local ItemData = _G.rawGetTableData("Item", TypeSpecificID)
                if not skin_id or skin_id == 0 or not ItemData then
                    return old_UpdateWeaponAppearanceInfo(self, TypeSpecificID, BattleData, DragOrigin)
                end
                _G.SkinLoadedCache[skin_id] = true
                if self.__last_skin_applied == skin_id then return end
                self.__last_skin_applied = skin_id
                old_UpdateWeaponAppearanceInfo(self, skin_id, BattleData, DragOrigin)
                pcall(function()
                    self.TypeSpecificIDTemp = TypeSpecificID
                    self.ItemID = TypeSpecificID
                    if self.UIRoot then
                        self.UIRoot.ItemID = TypeSpecificID
                        if self.UIRoot.TextBlock_WeaponName and ItemData.ItemName then
                            self.UIRoot.TextBlock_WeaponName:SetText(ItemData.ItemName)
                        end
                    end
                    if self.UpdateBullet then self:UpdateBullet() end
                    if self.UpdateWeaponAttachment then self:UpdateWeaponAttachment() end
                end)
            end
        end
        local ok, WIIB = pcall(require, "GameLua.Mod.BaseMod.Client.Backpack.WeaponInfoItemBase")
        if ok then wrapWeaponUI(WIIB) end
        pcall(function()
            local ok2, GLIB = pcall(require, "GameLua.Mod.BaseMod.Client.InGameUI.NewCircleChooseUI.GrenadeListItemBP")
            if ok2 and GLIB and GLIB.SetData then
                local o_SetData = GLIB.SetData
                GLIB.SetData = function(self, BattleItemData, bIsMedThrow)
                    if BattleItemData and BattleItemData.DefineID then
                        local tid = BattleItemData.DefineID.TypeSpecificID
                        local baseId = Yargi.getBaseWeaponId(tid)
                        if Yargi.isGrenadeId(baseId) then
                            local skinId = _G.get_skin_id(baseId)
                            if skinId and skinId > 0 then
                                BattleItemData.DefineID.TypeSpecificID = skinId
                            end
                        end
                    end
                    return o_SetData(self, BattleItemData, bIsMedThrow)
                end
            end
        end)
        _G.BackpackSkinHooked = true
    end)
end

function Yargi.onReturnToLobby()
    applyCache.weapon = {}
    applyCache.avatar = {}
    _G.matchAvatarFullApplied = false
    Yargi.depotInjectReady = false
    Yargi.lastDepotInject = 0
    Yargi.lastArmoryRebuild = 0
    Yargi.loadPersistState()
    Yargi.runMemorySkinDump(true)
    if Yargi.wardrobeHooksInstalled then
        Yargi.injectFakeItemsToDepot()
        Yargi.injectArmorySkinList(true)
    end
    pcall(_G.ReadConfigFile)
    Yargi.downloadEquippedBatch()
    pcall(_G.Lobby_Avatar_Handler)
    pcall(_G.ApplyLobbyTheme)
end

function Yargi.installStatusHooks()
    if Yargi.statusHooksInstalled then return end
    pcall(function()
        local EventSystem = require("client.slua.event.EventSystem")
        local GameStatus = require("client.logic.gamestatus.GameStatus")
        EventSystem:RegisterEvent(EVENTTYPE_STATE, EVENTID_ON_MODE_POST_SWITCH, function(_, preState, nextState)
            pcall(function()
                if GameStatus.IsInLobbyOrMainCity and GameStatus.IsInLobbyOrMainCity() then
                    Yargi.onReturnToLobby()
                elseif nextState == GameStatus.Fighting then
                    applyCache.weapon = {}
                    applyCache.avatar = {}
                    _G.matchAvatarFullApplied = false
                    Yargi.loadPersistState()
                    Yargi.downloadEquippedBatch()
                end
            end)
        end)
        Yargi.statusHooksInstalled = true
    end)
end

function Yargi.ensureDepotInjected()
    local now = os.clock()
    if Yargi.depotInjectReady and (now - (Yargi.lastDepotInject or 0)) < 8 then return end
    Yargi.injectFakeItemsToDepot()
    Yargi.lastDepotInject = now
end

function Yargi.getFakeDepotByInsID(insID)
    insID = tonumber(insID)
    if not insID then return nil end
    local item = Yargi.fakeDepot[insID]
    return item and Yargi.ensureItemFields(item) or nil
end

function Yargi.getFakeDepotByResID(resID)
    resID = tonumber(resID)
    if not resID then return nil end
    local insID = Yargi.fakeResSet[resID]
    return insID and Yargi.getFakeDepotByInsID(insID) or nil
end

function Yargi.getDepotEntity()
    local ok, dc = pcall(require, "client.slua.logic.wardrobe.logic_wardrobe_data_center")
    if not ok or not dc then return nil end
    return dc.GetWardrobeData()
end

function Yargi.injectFakeItemsToDepot()
    Yargi.registerAllFakeItems()
    pcall(function()
        local entity = Yargi.getDepotEntity()
        if not entity or not entity.AddData then return end
        for resID, insID in pairs(Yargi.fakeResSet) do
            if not entity.InsIDToIndexMap[insID] then
                entity:AddData({
                    instid = insID,
                    res_id = resID,
                    count = 1,
                    lock_cnt = 0,
                    expire_ts = 0,
                    valid_hours = 0,
                    color = 0,
                    pattern = 0,
                    isnew = 0
                })
            end
        end
        Yargi.depotInjectReady = true
    end)
end

function Yargi.mergeGunSkinList(gunID, skinList)
    gunID = tonumber(gunID)
    if not gunID or gunID == 0 then return skinList end
    skinList = skinList or {}
    local skins = _G.skinIdMappings[gunID]
    if not skins then return skinList end
    for _, skinId in ipairs(skins) do
        if skinId ~= gunID then
            skinList[skinId] = skinList[skinId] or { is_open = 1, weaponID = gunID }
            Yargi.registerFakeResID(skinId)
        end
    end
    return skinList
end

function Yargi.mergeAllWeaponSkinMap(result)
    result = result or {}
    for gunID, skins in pairs(_G.skinIdMappings) do
        for _, skinId in ipairs(skins) do
            if skinId ~= gunID then
                result[skinId] = result[skinId] or { skinInfo = { is_open = 1 }, weaponID = gunID }
                Yargi.registerFakeResID(skinId)
            end
        end
    end
    return result
end

function Yargi.writeConfigValue(key, value)
    local content, path = Yargi.readConfigContent()
    if not path then
        path = "/storage/emulated/0/Android/data/com.tencent.ig/files/config.ini"
    end
    content = content or ""
    local lines, found = {}, false
    for line in content:gmatch("[^\r\n]+") do
        local k = line:match("([%w_]+)%s*=")
        if k == key then
            lines[#lines + 1] = key .. "=" .. tostring(value)
            found = true
        else
            lines[#lines + 1] = line
        end
    end
    if not found then lines[#lines + 1] = key .. "=" .. tostring(value) end
    local file = io.open(path, "w")
    if file then
        file:write(table.concat(lines, "\n") .. "\n")
        file:close()
    end
    lastConfig[key] = tonumber(value)
end

function Yargi.syncWeaponFromResId(weaponId, skinResId)
    weaponId = tonumber(weaponId)
    skinResId = tonumber(skinResId)
    if not weaponId then return end
    local baseId = weaponId
    if skinResId and skinResId > 0 then
        baseId = Yargi.getBaseWeaponId(skinResId)
    end
    local idxTable = Yargi.isGrenadeId(baseId) and _G.GrenadeSkinIndex or _G.WeaponSkinIndex
    local skins = _G.skinIdMappings[baseId] or Yargi.buildDynamicWeaponSkins(baseId)
    local pickedIndex = 1
    if skinResId and skinResId > 0 then
        for i, sid in ipairs(skins) do
            if sid == skinResId then pickedIndex = i; break end
        end
    end
    idxTable[baseId] = pickedIndex
    local cfgKey = WEAPON_ID_TO_KEY[baseId]
    if cfgKey then
        Yargi.writeConfigValue(cfgKey, pickedIndex - 1)
    end
    Yargi.resetApplyCaches()
    _G.UpdateMyKillCounter = true
    Yargi.updateHitEffectFromSuit()
    Yargi.applySkinsNow()
end

function Yargi.syncExtraWeaponFromResId(weaponId, skinResId)
    weaponId = tonumber(weaponId)
    skinResId = tonumber(skinResId)
    if not weaponId then return end
    local baseId = weaponId
    if skinResId and skinResId > 0 then
        baseId = Yargi.getBaseWeaponId(skinResId)
    end
    local skins = _G.skinIdMappings[baseId] or Yargi.buildDynamicWeaponSkins(baseId)
    local pickedIndex = 1
    if skinResId and skinResId > 0 then
        for i, sid in ipairs(skins) do
            if sid == skinResId then pickedIndex = i; break end
        end
    end
    _G.ExtraWeaponSkinIndex[baseId] = pickedIndex
    Yargi.applyExtraLobbyWeapons()
    Yargi.savePersistState()
    Yargi.downloadEquippedBatch()
end

function Yargi.syncOutfitFromResId(resID)
    resID = tonumber(resID)
    if not resID or resID == 0 then return end
    for _, entry in ipairs(OUTFIT_CONFIG) do
        local key, globalKey, mapKey = entry[1], entry[2], entry[3]
        local list = _G[mapKey] or _G.OutfitSkins[mapKey]
        if list then
            for i, id in ipairs(list) do
                if id == resID then
                    _G[globalKey] = resID
                    Yargi.writeConfigValue(key, i - 1)
                    if globalKey == "SuitSkin" then Yargi.updateHitEffectFromSuit() end
                    Yargi.resetApplyCaches()
                    Yargi.applySkinsNow()
                    if key == "LobbyTheme" or (_G.TargetLobbyThemeID and resID == _G.TargetLobbyThemeID) then
                        _G.TargetLobbyThemeID = resID
                        _G.LastAppliedThemeID = nil
                        _G.ApplyLobbyTheme()
                    end
                    return
                end
            end
        end
    end
    if _G.LobbyThemeSkins then
        for _, tid in ipairs(_G.LobbyThemeSkins) do
            if tid == resID then
                _G.TargetLobbyThemeID = resID
                _G.LastAppliedThemeID = nil
                Yargi.writeConfigValue("LobbyTheme", resID)
                _G.ApplyLobbyTheme()
                return
            end
        end
    end
    pcall(function()
        local CDataTable = require("client.slua.config.ClientConfig.data_mgr")
        local itemCfg = CDataTable.GetTableData("Item", resID)
        if not itemCfg then return end
        if itemCfg.WardrobeMainTab == 1 or (itemCfg.ItemSubType and itemCfg.ItemSubType >= 400) then
            _G.SuitSkin = resID
            Yargi.updateHitEffectFromSuit()
            Yargi.resetApplyCaches()
            Yargi.applySkinsNow()
        elseif itemCfg.ItemType and ENUM_ITEM_TYPE and itemCfg.ItemType == ENUM_ITEM_TYPE.Hall_Theme then
            _G.TargetLobbyThemeID = resID
            _G.LastAppliedThemeID = nil
            _G.ApplyLobbyTheme()
        end
    end)
end

function Yargi.injectArmorySkinList(heavy)
    pcall(function()
        Yargi.registerAllFakeItems()
        local ArmorySystem = require("client.logic.armory.logic_armory")
        if not ArmorySystem.rsp_list then ArmorySystem.rsp_list = {} end
        if not ArmorySystem.rsp_list.skin_list then ArmorySystem.rsp_list.skin_list = {} end
        if not ArmorySystem.rsp_list.install_list then ArmorySystem.rsp_list.install_list = {} end
        local skin_list = ArmorySystem.rsp_list.skin_list
        for baseId, skins in pairs(_G.skinIdMappings) do
            if not skin_list[baseId] then skin_list[baseId] = {} end
            for _, skinId in ipairs(skins) do
                if skinId ~= baseId then
                    skin_list[baseId][skinId] = skin_list[baseId][skinId] or { is_open = 1 }
                    skin_list[baseId][skinId].is_open = 1
                    Yargi.registerFakeResID(skinId)
                end
            end
        end
        if heavy then
            if ArmorySystem.ContructResIdToWardrobeInsID then
                ArmorySystem.ContructResIdToWardrobeInsID()
            end
            if ArmorySystem.ReBuildInitData then
                ArmorySystem.ReBuildInitData(ArmorySystem.rsp_list)
            end
            local wardrobeGunLogic = require("client.slua.logic.wardrobe.logic_wardrobe_gun")
            if wardrobeGunLogic and wardrobeGunLogic.OnGunSkinListRes then
                wardrobeGunLogic:OnGunSkinListRes()
            end
            pcall(function()
                EventSystem:postEvent(EVENTTYPE_WARDROBE, EVENTID_WARDROBE_UPDATE_GUN_LIST, -1)
            end)
            Yargi.lastArmoryRebuild = os.clock()
        end
    end)
end

function Yargi.localEquipOutfit(fake, insID, extra)
    Yargi.ensureDepotInjected()
    local resOK = Yargi.getNetOkRes()
    local item = {
        res_id = fake.resID,
        resID = fake.resID,
        count = fake.count or 1,
        color = fake.colorID or 0,
        pattern = fake.patternID or 0,
        instid = insID,
        insID = insID
    }
    local WardRobeHandler = require("client.network.Protocol.WardRobeHandler")
    WardRobeHandler.on_depot_put_on_rsp(resOK, item, nil, 1, insID, 0, extra)

    pcall(function()
        local CDataTable = require("client.slua.config.ClientConfig.data_mgr")
        local itemCfg = CDataTable.GetTableData("Item", fake.resID)
        if not itemCfg then return end
        local WardrobeAvatarLogic = require("client.slua.logic.wardrobe.logic_wardrobe_avatar")
        local displayResID = fake.resID
        local LogicXSuit = require("client.slua.logic.XSuit.logic_xsuit")
        if LogicXSuit and LogicXSuit.IsXSuit and LogicXSuit.IsXSuit(fake.resID) then
            displayResID = LogicXSuit.GetItemShowID(insID) or fake.resID
        end
        if WardrobeAvatarLogic.AddToWearInfo then
            WardrobeAvatarLogic:AddToWearInfo(itemCfg.ItemSubType, insID, fake.resID, 0, 0)
        end
        if itemCfg.ItemType and ENUM_ITEM_TYPE and itemCfg.ItemType == ENUM_ITEM_TYPE.Hall_Theme then
            _G.TargetLobbyThemeID = fake.resID
            _G.LastAppliedThemeID = nil
            local HallThemeUtils = require("client.logic.lobby.hall_theme_utils")
            if HallThemeUtils and HallThemeUtils.ProcPutOnHallTheme then
                HallThemeUtils.ProcPutOnHallTheme(item, nil)
            end
            _G.ApplyLobbyTheme()
        elseif itemCfg.itemSubType == ENUM_ITEM_SUBTYPE.Helmet or (ENUM_ITEM_SUBTYPE.Helmet_NoLevel and itemCfg.itemSubType == ENUM_ITEM_SUBTYPE.Helmet_NoLevel) then
            local HallThemeUtils = require("client.logic.lobby.hall_theme_utils")
            if HallThemeUtils and HallThemeUtils.ProcPutOnHelmet then HallThemeUtils.ProcPutOnHelmet(item, nil) end
            if DataMgr and DataMgr.UpdateEquipmentSkin then DataMgr.UpdateEquipmentSkin(itemCfg.ItemSubType, insID) end
        elseif itemCfg.itemSubType == ENUM_ITEM_SUBTYPE.Upgrade_Backpack or itemCfg.itemSubType == ENUM_ITEM_SUBTYPE.Backpack then
            local HallThemeUtils = require("client.logic.lobby.hall_theme_utils")
            if HallThemeUtils and HallThemeUtils.ProcPutOnBagSkin then HallThemeUtils.ProcPutOnBagSkin(item, nil) end
            if DataMgr and DataMgr.UpdateEquipmentSkin then DataMgr.UpdateEquipmentSkin(itemCfg.ItemSubType, insID) end
        else
            if DataMgr and DataMgr.UpdateRoleWearData then DataMgr.UpdateRoleWearData(insID, 0) end
            WardrobeAvatarLogic:AvatarChange(displayResID, true, item.color, item.pattern)
        end
    end)

    Yargi.syncOutfitFromResId(fake.resID)
    Yargi.savePersistState()
    Yargi.downloadEquippedBatch()
    return true
end

function Yargi.localPutOnItem(insID, extra)
    local fake = Yargi.getFakeDepotByInsID(insID)
    if not fake then return false end
    return Yargi.localEquipOutfit(fake, insID, extra)
end

function Yargi.localInstallWeaponSkin(client_data, weapon_id, instanceID)
    local fake = Yargi.getFakeDepotByInsID(instanceID)
    if not fake then return false end
    Yargi.ensureDepotInjected()
    local ArmoryHandler = require("client.network.Protocol.ArmoryHandler")
    ArmoryHandler.on_install_weapon_skin_rsp(client_data, 0, weapon_id, instanceID)
    Yargi.syncWeaponFromResId(weapon_id, fake.resID)
    return true
end

function Yargi.wardrobeMaintainTick()
    if not _G.BackpackSkinHooked then Yargi.installBackpackSkinHook() end
    if not Yargi.wardrobeHooksInstalled then
        Yargi.InstallWardrobeHooks()
        return
    end
    if not Yargi.dumpSkinLoaded and not Yargi.dumpSkinInProgress then
        Yargi.runMemorySkinDump()
    end
    if not Yargi.isInLobby() then return end
    local now = os.clock()
    if not Yargi.depotInjectReady or (now - (Yargi.lastDepotInject or 0)) > 20 then
        Yargi.injectFakeItemsToDepot()
        Yargi.lastDepotInject = now
    end
    if (now - (Yargi.lastArmoryRebuild or 0)) > 25 then
        Yargi.injectArmorySkinList(true)
    end
end

function Yargi.InstallWardrobeHooks()
    if Yargi.wardrobeHooksInstalled then return end
    local ok, err = pcall(function()
        Yargi.registerAllFakeItems()

        local wardrobe_data = require("client.slua.logic.wardrobe.wardrobe_data")

        local o_InitDepot = wardrobe_data.InitHallDepotData
        wardrobe_data.InitHallDepotData = function(self, arrayItemDataPackage)
            o_InitDepot(self, arrayItemDataPackage)
            Yargi.depotInjectReady = false
            Yargi.injectFakeItemsToDepot()
            Yargi.injectArmorySkinList(true)
        end

        local o_GetByIns = wardrobe_data.GetHallDepotItemDataByInsID
        wardrobe_data.GetHallDepotItemDataByInsID = function(self, insID)
            local fake = Yargi.getFakeDepotByInsID(insID)
            if fake then return fake end
            return o_GetByIns(self, insID)
        end

        local o_GetValid = wardrobe_data.GetValidHallDepotItemDataByInsID
        wardrobe_data.GetValidHallDepotItemDataByInsID = function(self, insID)
            local fake = Yargi.getFakeDepotByInsID(insID)
            if fake then return fake end
            return o_GetValid(self, insID)
        end

        local o_GetCount = wardrobe_data.GetHallDepotItemCountByResID
        wardrobe_data.GetHallDepotItemCountByResID = function(self, resID, valid, DataSource)
            if Yargi.isFakeRes(resID) then return 1 end
            return o_GetCount(self, resID, valid, DataSource)
        end

        local o_GetList = wardrobe_data.GetHallDepotItemListByResID
        wardrobe_data.GetHallDepotItemListByResID = function(self, resID)
            local fake = Yargi.getFakeDepotByResID(resID)
            if fake then return { { insID = fake.insID, resID = fake.resID } } end
            return o_GetList(self, resID)
        end

        local o_GetByResID = wardrobe_data.GetHallDepotItemDataByResID
        wardrobe_data.GetHallDepotItemDataByResID = function(self, resID, source)
            local fake = Yargi.getFakeDepotByResID(resID)
            if fake then return fake end
            return o_GetByResID(self, resID, source)
        end

        local o_GetByResIDValid = wardrobe_data.GetHallDepotItemDataByResIDAndValidExpireTime
        wardrobe_data.GetHallDepotItemDataByResIDAndValidExpireTime = function(self, resID, source)
            local fake = Yargi.getFakeDepotByResID(resID)
            if fake then return fake end
            return o_GetByResIDValid(self, resID, source)
        end

        local o_GetListValid = wardrobe_data.GetHallDepotItemListByResIDValidExpireTime
        wardrobe_data.GetHallDepotItemListByResIDValidExpireTime = function(self, resID)
            local fake = Yargi.getFakeDepotByResID(resID)
            if fake then return { { insID = fake.insID, resID = fake.resID } } end
            return o_GetListValid(self, resID)
        end

        local o_GetArray = wardrobe_data.GetArrayHallDepotItemInfo
        wardrobe_data.GetArrayHallDepotItemInfo = function(self, DataSource)
            if not Yargi.depotInjectReady then Yargi.ensureDepotInjected() end
            local data = o_GetArray(self, DataSource)
            if not data then data = {} end
            for insID, item in pairs(Yargi.fakeDepot) do
                if not data[insID] then
                    data[insID] = Yargi.ensureItemFields(item)
                end
            end
            return data
        end

        local WardrobeLogic = require("client.slua.logic.wardrobe.logic_wardrobe_new")

        local o_PutonReq = WardrobeLogic.wardrobe_puton_req
        WardrobeLogic.wardrobe_puton_req = function(self, insID, extra)
            if Yargi.localPutOnItem(insID, extra) then return end
            return o_PutonReq(self, insID, extra)
        end

        local o_GetInsByRes = WardrobeLogic.GetWardrobeInsIdByResId
        WardrobeLogic.GetWardrobeInsIdByResId = function(self, resid)
            local fake = Yargi.getFakeDepotByResID(resid)
            if fake then return fake.insID end
            return o_GetInsByRes(self, resid)
        end

        local o_Isolated = WardrobeLogic.IsItemIsolated
        WardrobeLogic.IsItemIsolated = function(self, resId)
            if Yargi.isFakeRes(resId) then return false end
            return o_Isolated(self, resId)
        end

        local o_IsCanUse = WardrobeLogic.IsCanUse
        WardrobeLogic.IsCanUse = function(self, resId)
            if Yargi.isFakeRes(resId) then return true end
            return o_IsCanUse(self, resId)
        end

        local o_IsCharUse = WardrobeLogic.IsCharacterUse
        WardrobeLogic.IsCharacterUse = function(self, resId)
            if Yargi.isFakeRes(resId) then return true end
            return o_IsCharUse(self, resId)
        end

        local WardrobeAvatarLogic = require("client.slua.logic.wardrobe.logic_wardrobe_avatar")
        local o_AvatarChange = WardrobeAvatarLogic.AvatarChange
        WardrobeAvatarLogic.AvatarChange = function(self, itemResID, puton, colorID, patternID)
            local ret = o_AvatarChange(self, itemResID, puton, colorID, patternID)
            if puton and itemResID and itemResID > 0 then
                Yargi.syncOutfitFromResId(itemResID)
            end
            return ret
        end

        local WardrobeGunLogic = require("client.slua.logic.wardrobe.logic_wardrobe_gun")

        local o_GunListReq = WardrobeGunLogic.GetGunSkinListReq
        WardrobeGunLogic.GetGunSkinListReq = function(self)
            Yargi.ensureDepotInjected()
            Yargi.injectArmorySkinList(false)
            return o_GunListReq(self)
        end

        local o_GetSkinList = WardrobeGunLogic.GetSkinList
        WardrobeGunLogic.GetSkinList = function(self, skinList, sortViaTime, gunID, DataSource, tExtraData)
            gunID = gunID or self:GetGunID()
            if gunID == 0 then gunID = self:GetKeepGunID() end
            skinList = Yargi.mergeGunSkinList(gunID, skinList)
            return o_GetSkinList(self, skinList, sortViaTime, gunID, DataSource, tExtraData)
        end

        local o_GetAllSkins = WardrobeGunLogic.GetAllWeaponSkinList
        WardrobeGunLogic.GetAllWeaponSkinList = function(self, skinList, sortViaTime, bFilterTime, bFilterDiy, bFilterLock, bIgnoreSort)
            skinList = Yargi.mergeAllWeaponSkinMap(skinList)
            return o_GetAllSkins(self, skinList, sortViaTime, bFilterTime, bFilterDiy, bFilterLock, bIgnoreSort)
        end

        local o_PutOnGun = WardrobeGunLogic.PutOnGunAvatar
        WardrobeGunLogic.PutOnGunAvatar = function(self, gunID, skinID, planID)
            o_PutOnGun(self, gunID, skinID, planID)
            if gunID and skinID and skinID > 0 then
                Yargi.syncWeaponFromResId(gunID, skinID)
            end
        end

        local o_PutOnExtraGun = WardrobeGunLogic.PutOnExtraGunAvatar
        WardrobeGunLogic.PutOnExtraGunAvatar = function(self, gunID, skinID, planID)
            local ret = o_PutOnExtraGun(self, gunID, skinID, planID)
            if gunID and skinID and skinID > 0 then
                Yargi.syncExtraWeaponFromResId(gunID, skinID)
            end
            return ret
        end

        local ArmorySystem = require("client.logic.armory.logic_armory")

        local o_GetSkinByWeapon = ArmorySystem.GetSkinListByWeaponID
        ArmorySystem.GetSkinListByWeaponID = function(WeaponID)
            local list = o_GetSkinByWeapon(WeaponID) or {}
            return Yargi.mergeGunSkinList(WeaponID, list)
        end

        local o_GetAllWeaponSkins = ArmorySystem.GetAllWeaponSkinList
        ArmorySystem.GetAllWeaponSkinList = function()
            return Yargi.mergeAllWeaponSkinMap(o_GetAllWeaponSkins() or {})
        end

        local o_GetSkinRsp = ArmorySystem.get_weapon_skin_list_rsp
        ArmorySystem.get_weapon_skin_list_rsp = function(client_data, errorCode, rsp_list, if_skin_list_saved)
            if errorCode == 0 then
                o_GetSkinRsp(client_data, errorCode, rsp_list, if_skin_list_saved)
            else
                if not ArmorySystem.rsp_list then ArmorySystem.rsp_list = {} end
            end
            Yargi.injectArmorySkinList(true)
        end

        local o_InstallSkin = ArmorySystem.install_weapon_skin
        ArmorySystem.install_weapon_skin = function(client_data, weapon_id, instanceID)
            if Yargi.localInstallWeaponSkin(client_data, weapon_id, instanceID) then return end
            return o_InstallSkin(client_data, weapon_id, instanceID)
        end

        local ArmoryHandler = require("client.network.Protocol.ArmoryHandler")
        local o_SendInstall = ArmoryHandler.send_install_weapon_skin
        ArmoryHandler.send_install_weapon_skin = function(client_data, weapon_id, instanceID)
            if Yargi.localInstallWeaponSkin(client_data, weapon_id, instanceID) then return end
            return o_SendInstall(client_data, weapon_id, instanceID)
        end

        local WardRobeHandler = require("client.network.Protocol.WardRobeHandler")
        local o_PutOnReq = WardRobeHandler.send_depot_put_on_req
        WardRobeHandler.send_depot_put_on_req = function(insID, extra)
            if Yargi.localPutOnItem(insID, extra) then return end
            return o_PutOnReq(insID, extra)
        end

        local o_OnPutOnRsp = WardrobeLogic.on_puton_rsp
        WardrobeLogic.on_puton_rsp = function(self, res, item, olditem, index, extra)
            o_OnPutOnRsp(self, res, item, olditem, index, extra)
            local resOK = Yargi.getNetOkRes()
            if item and (res == resOK or res == 0 or res == "ok") then
                local resId = item.res_id or item.resID
                if resId then Yargi.syncOutfitFromResId(resId) end
            end
        end

        local o_HandleWeapon = ArmorySystem.HandleWeaponSkinChange
        ArmorySystem.HandleWeaponSkinChange = function(client_data, weapon_id, instanceID)
            o_HandleWeapon(client_data, weapon_id, instanceID)
            pcall(function()
                local itemData = wardrobe_data:GetValidHallDepotItemDataByInsID(instanceID)
                local resID = itemData and itemData.resID or 0
                if resID > 0 then Yargi.syncWeaponFromResId(weapon_id, resID) end
            end)
        end

        local entity = Yargi.getDepotEntity()
        if entity and entity.GetItemCountByResID then
            local o_EntityCount = entity.GetItemCountByResID
            entity.GetItemCountByResID = function(self, resID, bCheckValidTime)
                if Yargi.isFakeRes(resID) then return 1 end
                return o_EntityCount(self, resID, bCheckValidTime)
            end
        end

        Yargi.injectFakeItemsToDepot()
        Yargi.injectArmorySkinList(true)
        Yargi.wardrobeHooksInstalled = true
    end)
    if not ok then
        Yargi.wardrobeHooksInstalled = false
    end
end

_G.InstallWardrobeHooks = function() Yargi.InstallWardrobeHooks() end

-- =============================================================================
-- INIT & TIMERS
-- =============================================================================

pcall(function()
    local ModuleManager = require("client.module_framework.ModuleManager")
    _G.ItemUpgradeSystem = ModuleManager.GetModule(ModuleManager.CommonModuleConfig.ItemUpgradeSystem)
    if _G.ItemUpgradeSystem then
        _G.ItemUpgradeSystem:DefineAndResetData()
        _G.ItemUpgradeSystem:OnInitialize()
    end
end)

Yargi.installKillInfoHook()
_G.loadKillCountFromFile()
Yargi.registerAllFakeItems()
Yargi.loadPersistState()
_G.ReadConfigFile()
Yargi.updateHitEffectFromSuit()
Yargi.downloadEquippedBatch()
_G.ApplyLobbyTheme()
_G.InstallOriginalHooks()
Yargi.InstallWardrobeHooks()
Yargi.installStatusHooks()
Yargi.installBackpackSkinHook()
Yargi.runMemorySkinDump()

local TXtime_ticker = require("common.time_ticker")
_G.Mytimer_ticker = TXtime_ticker

if _G.Mytimer_ticker then
    _G.Mytimer_ticker.AddTimerLoop(0, function() pcall(Yargi.matchRealtimeTick) end, -1, 0.15)
    _G.Mytimer_ticker.AddTimerLoop(0, function() pcall(_G.GameAvatarHandlervehicles) end, -1, 0.35)
    _G.Mytimer_ticker.AddTimerLoop(0, function() pcall(_G.GameAvatarHandlerkillcounter) end, -1, 0.25)
    _G.Mytimer_ticker.AddTimerLoop(0, function() pcall(_G.FileWatcher) end, -1, 0.25)
    _G.Mytimer_ticker.AddTimerLoop(0, function() pcall(_G.DisableHiggsBoson) end, -1, 0.50)
    _G.Mytimer_ticker.AddTimerLoop(0, function() pcall(_G.ReadConfigFile) end, -1, 0.30)
    _G.Mytimer_ticker.AddTimerLoop(0, function()
        pcall(function()
            if Yargi.isInLobby() then
                _G.Lobby_Avatar_Handler()
            else
                _G.GameAvatarHandlerplayers()
                _G.HandlePetLogic()
            end
        end)
    end, -1, 0.25)
    _G.Mytimer_ticker.AddTimerLoop(0, function() pcall(Yargi.wardrobeMaintainTick) end, -1, 10.0)
    _G.Mytimer_ticker.AddTimerLoop(1, function() pcall(_G.InitializeConnectionGuard) end, -1, 1)
    _G.Mytimer_ticker.AddTimerLoop(1, function() pcall(_G.InitializeGameplayBypass) end, -1, 1)
    _G.Mytimer_ticker.AddTimerOnce(0.5, function() pcall(Yargi.InstallWardrobeHooks) end)
    _G.Mytimer_ticker.AddTimerOnce(1, function() pcall(_G.InstallKillCounterUIHooks) end)
    _G.Mytimer_ticker.AddTimerOnce(2, function() pcall(_G.InstallKillCounterUIHooks) end)
    _G.Mytimer_ticker.AddTimerOnce(3, function() pcall(Yargi.InstallWardrobeHooks) end)
    _G.Mytimer_ticker.AddTimerOnce(2, function() pcall(Yargi.installBackpackSkinHook) end)
    _G.Mytimer_ticker.AddTimerOnce(5, function() pcall(Yargi.runMemorySkinDump) end)
    _G.YargiEngine.Loaded = true
end

_G.YargiEngine.Start = function()
    print("[YARGI ENGINE v3.0] Persist lobby picks | match suit | grenade | extras")
end
