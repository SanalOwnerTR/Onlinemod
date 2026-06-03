_G.YARGI_ALIVE = true
_G.YargiEngine = _G.YargiEngine or {}
_G.YargiEngine.Version = "4.0"

local Yargi = {}

Yargi.FakeInstBase = 2000000000

Yargi.Items = {
	220000, 220001, 220002, 220003, 220004,
	220005, 220006, 220007, 220008, 220009
}

Yargi.SkinItems = {
	1401085, 1401086, 1401087,
	1101004030, 1101001019, 1101003020
}

function Yargi.BuildFakePacket()
	local packet = {}
	local instId = Yargi.FakeInstBase
	for _, resId in ipairs(Yargi.SkinItems) do
		instId = instId + 1
		packet[instId] = {
			res_id = resId,
			count = 1,
			lock_cnt = 0,
			isnew = 0,
			valid_hours = 0,
			expire_ts = 0,
			color = 0,
			pattern = 0,
			notified_3day = 0,
			notified_1week = 0
		}
	end
	return packet
end

function Yargi.HookWardrobeData(module)
	if type(module) ~= "table" or module._yargiHooked then return end
	module._yargiHooked = true
	local old_InitHallDepotData = module.InitHallDepotData
	if old_InitHallDepotData then
		module.InitHallDepotData = function(self, arrayItemDataPackage)
			local fakePacket = Yargi.BuildFakePacket()
			table.insert(arrayItemDataPackage, fakePacket)
			return old_InitHallDepotData(self, arrayItemDataPackage)
		end
	end
end

function Yargi.ShowMsg()
	pcall(function()
		local mgr = package.loaded["client.slua.logic.common.logic_common_msg_box"]
		if not mgr then
			local ok, r = pcall(require, "client.slua.logic.common.logic_common_msg_box")
			if ok then mgr = r end
		end
		if mgr and mgr.Show then
			mgr.Show(1, "YARGI v4", "YargiEngine AKTIF - Skin Enjeksiyonu Tamam!", nil, nil, "OK")
		end
	end)
end

function Yargi.Init()
	if not _G.YARGI_ALIVE then return end

	local old_require = _G.require
	_G.require = function(name)
		local module = old_require(name)
		if name == "client.slua.logic.wardrobe.wardrobe_data" then
			Yargi.HookWardrobeData(module)
		end
		return module
	end

	local existing = package.loaded["client.slua.logic.wardrobe.wardrobe_data"]
	if existing then
		Yargi.HookWardrobeData(existing)
	end

	local ok, ticker = pcall(require, "common.time_ticker")
	if ok and ticker and ticker.AddTimerOnce then
		ticker.AddTimerOnce(2.0, Yargi.ShowMsg)
	end
end

Yargi.Init()

return Yargi
