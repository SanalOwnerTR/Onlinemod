_G.YARGI_ALIVE = true
_G.YargiEngine = _G.YargiEngine or {}
_G.YargiEngine.Version = "4.0"

local Yargi = {}

Yargi.FakeInstBase = 2000000000

Yargi.SkinItems = {
	1401085, 1401086, 1401087, 1401088, 1401089,
	1401090, 1401091, 1401092, 1401093, 1401094,
	1401095, 1401096, 1401097, 1401098, 1401099,
	1401100, 1401101, 1401102, 1401103, 1401104,
	1401105, 1401106, 1401107, 1401108, 1401109,
	1401110, 1401111, 1401112, 1401113, 1401114,
	1401115, 1401116, 1401117, 1401118, 1401119,
	1401120, 1401121, 1401122, 1401123, 1401124,
	1401125, 1401126, 1401127, 1401128, 1401129,
	1401130, 1401131, 1401132, 1401133, 1401134,
	1401135, 1401136, 1401137, 1401138, 1401139,
	1401140, 1401141, 1401142, 1401143, 1401144,

	1101004030, 1101004044, 1101004111, 1101004052, 1101004060,
	1101004070, 1101004080, 1101004090, 1101004100, 1101004120,
	1101001019, 1101001029, 1101001039, 1101001049, 1101001059,
	1101001069, 1101001079, 1101001089, 1101001099, 1101001109,
	1101003020, 1101003030, 1101003040, 1101003050, 1101003060,
	1101003070, 1101003080, 1101003090, 1101003100, 1101003110,
	1101002011, 1101002021, 1101002031, 1101002041, 1101002051,
	1101002061, 1101002071, 1101002081, 1101002091, 1101002101,
	1101005010, 1101005020, 1101005030, 1101005040, 1101005050,
	1101006010, 1101006020, 1101006030, 1101006040, 1101006050,
	1101007010, 1101007020, 1101007030, 1101007040, 1101007050,
	1101008010, 1101008020, 1101008030, 1101008040, 1101008050,
	1101009010, 1101009020, 1101009030, 1101009040, 1101009050,
	1101010010, 1101010020, 1101010030, 1101011010, 1101011020,
	1101012010, 1101012020, 1101013010, 1101013020, 1101014010,

	1301001, 1301002, 1301003, 1301004, 1301005,
	1301006, 1301007, 1301008, 1301009, 1301010,
	1301011, 1301012, 1301013, 1301014, 1301015,
	1301016, 1301017, 1301018, 1301019, 1301020,

	1201001, 1201002, 1201003, 1201004, 1201005,
	1201006, 1201007, 1201008, 1201009, 1201010,
	1201011, 1201012, 1201013, 1201014, 1201015,
	1201016, 1201017, 1201018, 1201019, 1201020,

	1501001, 1501002, 1501003, 1501004, 1501005,
	1501006, 1501007, 1501008, 1501009, 1501010,
	1501011, 1501012, 1501013, 1501014, 1501015,
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
			mgr.Show(1, "YARGI v4", "YargiEngine AKTIF - Full Envanter Acildi!", nil, nil, "OK")
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
