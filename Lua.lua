_G.YARGI_ALIVE = true
_G.YargiEngine = _G.YargiEngine or {}
_G.YargiEngine.Version = "4.0"

local Yargi = {}

-- Lobi Envanterinde "Sahip Olunmuş" (Owned) gibi gösterilecek eşyaların listesi
Yargi.OwnedSkins = {
    Suit = {
        -- Orijinal luadan alınmış test kıyafetleri (Örnek: X-Suit Firavun vb.)
        1400001, 1400002, 1400003, 
        1401085, 1401086, 1401087, 
    },
    Weapon = {
        -- Direkt skin ID'lerini ekliyoruz
        1101004030, -- M416 Buz Diyarı (Glacier)
        1101001019, -- AKM Cehennem Ateşi (Hellfire)
        1101003020  -- SCAR-L Su Tabancası (Water Blaster)
    }
}

-- Lobideki envanter (Inventory) verisine bizim eşyaları "sanki bizimmiş" gibi ekleyen fonksiyon
function Yargi.SpoofLobbyInventory(originalInventoryList)
    if not originalInventoryList then originalInventoryList = {} end
    
    -- Kıyafetleri envantere ekle
    for _, suitId in ipairs(Yargi.OwnedSkins.Suit) do
        -- PUBG'nin lua yapısındaki eşya formatına uygun bir obje oluşturuyoruz
        -- Gerçek oyundaki tablo anahtarları (key) değişiklik gösterebilir (örneğin: id, count, is_owned)
        -- Eğer oyun "item_id" yerine sadece sayılar bekliyorsa burayı ona göre ayarlayacağız.
        table.insert(originalInventoryList, {
            item_id = suitId,
            item_count = 1,
            is_owned = true,
            is_unlocked = true,
            time_limit = -1 -- Sınırsız
        })
    end
    
    -- Silahları envantere ekle
    for _, weaponId in ipairs(Yargi.OwnedSkins.Weapon) do
        table.insert(originalInventoryList, {
            item_id = weaponId,
            item_count = 1,
            is_owned = true,
            is_unlocked = true,
            time_limit = -1 -- Sınırsız
        })
    end
    
    return originalInventoryList
end

function Yargi.Init()
    if not _G.YARGI_ALIVE then return end
    print("[YargiEngine] Lobi Envanter Full Kilit Açma Sistemi Başlatılıyor...")
    
    -- Burada oyunun lobi envanterini çeken fonksiyonuna Hook atılacak (Örn: GetPlayerInventory veya LoadInventory)
    -- Orijinal liste çekildiğinde Yargi.SpoofLobbyInventory(liste) üzerinden geçirilip oyuna geri verilecek.
end

return Yargi
