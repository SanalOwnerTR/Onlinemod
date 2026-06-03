_G.YARGI_ALIVE = true
_G.YargiEngine = _G.YargiEngine or {}
_G.YargiEngine.Version = "4.0"

local Yargi = {}

Yargi.FakeInstBase = 2000000000

function Yargi.BuildFakePacket()
	local packet = {}
	local instId = Yargi.FakeInstBase
	local CDataTable = _G.CDataTable

	if CDataTable and CDataTable.GetTableData then
		local function AddRange(start_id, end_id)
			for id = start_id, end_id do
				if CDataTable.GetTableData("Item", id) then
					instId = instId + 1
					packet[instId] = {
						res_id = id,
						count = 1,
						lock_cnt = 0,
						isnew = 0,
						valid_hours = 0,
						expire_ts = 2147483647,
						color = 0,
						pattern = 0,
						notified_3day = 0,
						notified_1week = 0
					}
				end
			end
		end

		AddRange(101000, 106015)
		AddRange(1010000, 1060100)
		AddRange(10100000, 10601000)
		AddRange(1400000, 1409000)
		AddRange(502000, 502200)
		AddRange(501000, 501200)
		AddRange(403000, 403150)
		AddRange(404000, 404150)
		AddRange(405000, 405150)
		AddRange(452000, 452100)
		AddRange(50000, 50050)
		AddRange(31000, 32000)
		AddRange(40000, 40050)
		AddRange(60000, 60050)
		AddRange(211000, 212050)
	else
		local manual = {
			1406469, 1406470, 1406471, 1406472, 1406473, 1406474, 1406475,
			1406638, 1406639, 1406640, 1406641, 1406642, 1406643, 1406711, 
			1406712, 1406713, 1406714, 1406715, 1406716, 1406810, 1406811, 
			1406812, 1406813, 1406814, 1406815, 1406872, 1406965, 1406966, 
			1406967, 1406968, 1406969, 1406970, 1406971, 1407097, 1407098, 
			1407099, 1407100, 1407101, 1407102, 1407103, 1407140, 1407141, 
			1407142, 1010041, 1010042, 1010043, 1010044, 1010045, 1010046, 
			1010047, 1010048, 1010049, 10100410, 10100411, 10100412,
			1010011, 1010012, 1010013, 1010014, 1010015, 1010016, 1010017,
			1030031, 1030032, 1030033, 1030034, 1030035, 1030036, 1030037, 
			1030039
		}
		for i = 1, #manual do
			instId = instId + 1
			packet[instId] = {
				res_id = manual[i],
				count = 1,
				lock_cnt = 0,
				isnew = 0,
				valid_hours = 0,
				expire_ts = 2147483647,
				color = 0,
				pattern = 0,
				notified_3day = 0,
				notified_1week = 0
			}
		end
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
