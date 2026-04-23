local status, err = pcall(function()
local SkinManager = require("client.module_framework.SkinManager")
    local UI_Mgr = require("client.slua_ui_framework.manager")


    local TargetSkins = {
        [101001] = 1101001265, 
        [102002] = 1102002424, 
        [101003] = 1101003219, 
        [101004] = 1101004046, 
        [101008] = 1101008163,  
        [101006] = 1101006085   
    }

    if SkinManager then
        for weaponID, skinID in pairs(TargetSkins) do
    
            if SkinManager.AddSkinData then
                SkinManager.AddSkinData(weaponID, skinID)
            end
            
         
            if SkinManager.SetSkinOwned then
                SkinManager.SetSkinOwned(weaponID, skinID, true)
            end

         
            if SkinManager.SelectSkin then
                SkinManager.SelectSkin(weaponID, skinID)
            end
        end
    end

   
    local LobbyUI = UI_Mgr.GetUI(UI_Mgr.UI_Config.Lobby_Main_UIBP)
    if LobbyUI then
        if LobbyUI.RefreshInventory then
            LobbyUI:RefreshInventory()
        end
        if LobbyUI.UpdateWeaponDisplay then
            LobbyUI:UpdateWeaponDisplay()
        end
    end
end)

if not status then
   
end