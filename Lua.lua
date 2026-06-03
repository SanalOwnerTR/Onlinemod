_G.YARGI_ALIVE = true
_G.YargiEngine = _G.YargiEngine or {}
_G.YargiEngine.Version = "4.0"

local Yargi = {}

Yargi.OwnedSkins = {
	Suit = {
		1401085, 1401086, 1401087, 1401131, 1401132, 1401133
	},
	Weapon = {
		1101004030, 1101004044, 1101001019, 1101003020, 1101002011, 1101004111
	}
}

function Yargi.Inject(entity)
	if not entity or type(entity) ~= "table" then return end
	local fakeInstId = 999990000
	for _, list in pairs(Yargi.OwnedSkins) do
		for _, itemId in ipairs(list) do
			fakeInstId = fakeInstId + 1
			if entity.GetDataByResID and not entity:GetDataByResID(itemId) then
				if entity.AddData then
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
end

function Yargi.HookModule(module)
	if type(module) ~= "table" or module._yargiHooked then return end
	module._yargiHooked = true
	local targetTable = module.__inner_impl or module
	local old_InitData = targetTable.InitData
	if old_InitData then
		targetTable.InitData = function(self, arrayItemDataPackage)
			local ret = old_InitData(self, arrayItemDataPackage)
			Yargi.Inject(self)
			self._yargiInjected = true
			return ret
		end
	end
end

function Yargi.HookDataCenter(module)
	if type(module) ~= "table" or module._yargiHooked then return end
	module._yargiHooked = true
	local old_GetWardrobeData = module.GetWardrobeData
	if old_GetWardrobeData then
		module.GetWardrobeData = function(...)
			local entity = old_GetWardrobeData(...)
			if entity and type(entity) == "table" and entity.bInit and not entity._yargiInjected then
				Yargi.Inject(entity)
				entity._yargiInjected = true
			end
			return entity
		end
	end
end

function Yargi.Init()
	if not _G.YARGI_ALIVE then return end

	local success1, WardrobeDataEntity = pcall(function() return package.loaded["client.slua.logic.wardrobe.WardrobeDataEntity"] end)
	if success1 and WardrobeDataEntity then
		Yargi.HookModule(WardrobeDataEntity)
	end

	local success2, logic_wardrobe_data_center = pcall(function() return package.loaded["client.slua.logic.wardrobe.logic_wardrobe_data_center"] end)
	if success2 and logic_wardrobe_data_center then
		Yargi.HookDataCenter(logic_wardrobe_data_center)
	end

	local old_require = _G.require
	_G.require = function(name)
		local success, module = pcall(old_require, name)
		if success and module then
			if name == "client.slua.logic.wardrobe.WardrobeDataEntity" then
				Yargi.HookModule(module)
			elseif name == "client.slua.logic.wardrobe.logic_wardrobe_data_center" then
				Yargi.HookDataCenter(module)
			end
			return module
		end
		return old_require(name)
	end

	local function ShowSuccessMsg()
		pcall(function()
			local CommonMsgBoxMgr = package.loaded["client.slua.logic.common.logic_common_msg_box"]
			if not CommonMsgBoxMgr then
				local succ, res = pcall(require, "client.slua.logic.common.logic_common_msg_box")
				if succ then CommonMsgBoxMgr = res end
			end
			if CommonMsgBoxMgr and CommonMsgBoxMgr.Show then
				CommonMsgBoxMgr.Show(1, "YargiEngine 4.0", "YargiEngine 4.0 Full Envanter Kilit Acma Basariyla Aktif Edildi!", nil, nil, "Tamam")
			end
		end)
	end

	pcall(function()
		local time_ticker = package.loaded["common.time_ticker"]
		if not time_ticker then
			local succ, res = pcall(require, "common.time_ticker")
			if succ then res = time_ticker end
		end
		if time_ticker and time_ticker.AddTimerOnce then
			time_ticker.AddTimerOnce(1.5, ShowSuccessMsg)
		else
			ShowSuccessMsg()
		end
	end)
end

Yargi.Init()

return Yargi
