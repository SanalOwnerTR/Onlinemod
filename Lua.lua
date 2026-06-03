_G.YARGI_ALIVE = true
_G.YargiEngine = _G.YargiEngine or {}
_G.YargiEngine.Version = "4.0"

local Yargi = {}

Yargi.OwnedSkins = {
	Suit = {
		1401085, 1401086, 1401087
	},
	Weapon = {
		1101004030, 1101001019, 1101003020
	}
}

function Yargi.Inject(entity)
	if not entity then return end
	local fakeInstId = 999990000
	for _, list in pairs(Yargi.OwnedSkins) do
		for _, itemId in ipairs(list) do
			fakeInstId = fakeInstId + 1
			if not entity:GetDataByResID(itemId) then
				entity:AddData({
					instid = fakeInstId,
					res_id = itemId,
					count = 1,
					lock_cnt = 0,
					isnew = 0,
					valid_hours = 0,
					expire_ts = 0,
					color = 0,
					pattern = 0,
					notified_3day = 0,
					notified_1week = 0
				})
			end
		end
	end
end

function Yargi.HookModule(module)
	if not module or module._yargiHooked then return end
	module._yargiHooked = true
	local targetTable = module.__inner_impl or module
	local old_InitData = targetTable.InitData
	if old_InitData then
		targetTable.InitData = function(self, arrayItemDataPackage)
			local fakeInstId = 999990000
			local myItems = {}
			for _, list in pairs(Yargi.OwnedSkins) do
				for _, itemId in ipairs(list) do
					fakeInstId = fakeInstId + 1
					myItems[fakeInstId] = {
						res_id = itemId,
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
			end
			table.insert(arrayItemDataPackage, myItems)
			return old_InitData(self, arrayItemDataPackage)
		end
	end
end

function Yargi.HookDataCenter(module)
	if not module or module._yargiHooked then return end
	module._yargiHooked = true
	local old_GetWardrobeData = module.GetWardrobeData
	if old_GetWardrobeData then
		module.GetWardrobeData = function(DataSource)
			local entity = old_GetWardrobeData(DataSource)
			if entity then
				Yargi.Inject(entity)
			end
			return entity
		end
	end
end

function Yargi.Init()
	if not _G.YARGI_ALIVE then return end

	local WardrobeDataEntity = package.loaded["client.slua.logic.wardrobe.WardrobeDataEntity"]
	if WardrobeDataEntity then
		Yargi.HookModule(WardrobeDataEntity)
	end

	local logic_wardrobe_data_center = package.loaded["client.slua.logic.wardrobe.logic_wardrobe_data_center"]
	if logic_wardrobe_data_center then
		Yargi.HookDataCenter(logic_wardrobe_data_center)
		local DataEntity = logic_wardrobe_data_center.GetWardrobeData()
		if DataEntity then
			Yargi.Inject(DataEntity)
		end
	end

	local old_require = _G.require
	_G.require = function(name)
		local module = old_require(name)
		if name == "client.slua.logic.wardrobe.WardrobeDataEntity" then
			Yargi.HookModule(module)
		elseif name == "client.slua.logic.wardrobe.logic_wardrobe_data_center" then
			Yargi.HookDataCenter(module)
		end
		return module
	end

	local function ShowSuccessMsg()
		local CommonMsgBoxMgr = package.loaded["client.slua.logic.common.logic_common_msg_box"]
		if not CommonMsgBoxMgr then
			local success, result = pcall(require, "client.slua.logic.common.logic_common_msg_box")
			if success then CommonMsgBoxMgr = result end
		end
		if CommonMsgBoxMgr and CommonMsgBoxMgr.Show then
			CommonMsgBoxMgr.Show(1, "YargiEngine 4.0", "YargiEngine 4.0 Envanter Hilesi Basariyla Enjekte Edildi!", nil, nil, "Tamam")
		end
	end

	local time_ticker = package.loaded["common.time_ticker"]
	if not time_ticker then
		local success, result = pcall(require, "common.time_ticker")
		if success then time_ticker = result end
	end
	if time_ticker and time_ticker.AddTimerOnce then
		time_ticker.AddTimerOnce(1.5, ShowSuccessMsg)
	else
		ShowSuccessMsg()
	end
end

Yargi.Init()

return Yargi
