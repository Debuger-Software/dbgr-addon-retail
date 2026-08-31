local ADDON_NAME = "DBGR"
local ADDON_VERSION = format("%s rev.%s", C_AddOns.GetAddOnMetadata(ADDON_NAME, "Version"), C_AddOns.GetAddOnMetadata(ADDON_NAME, "X-Revision"))
local ADDON_REL_TYPE = C_AddOns.GetAddOnMetadata(ADDON_NAME, "X-Release")

local TIME_REQ = false;
local UpdateTimer = 0;
local AFKTimer = nil;

local LOGO = function(size)
    size = size or 16
    return string.format("|TInterface\\AddOns\\DBGR\\img\\d:%d:%d:0:0|t", size, size)
end


function _L(key)
	if lang_exist(DBGROPT.locale) == false then DBGROPT.locale = "EN" end
	return _Lang[DBGROPT.locale][key] or "**str_not_found**"
end


function AddLootIcons(self, event, msg, ...)
    local function iconForLink(link)
        local itemID = link:match("item:(%d+)")
        local icon

        if itemID then
            icon = C_Item.GetItemIconByID(tonumber(itemID))
        end

        icon = icon or 134400

        local size = DBGROPT and DBGROPT.icon_size or 24

        return string.format("%s |T%s:%d:%d:0:0|t", link, icon, size, size)
    end

    msg = msg:gsub("You receive loot: ", "Loot: ")
    msg = msg:gsub("You receive item: ", "Loot: ")
    msg = msg:gsub("You create: ", "Make: ")

    msg = msg:gsub("(|c%x+|Hitem.-|h.-|h|r)", iconForLink)

    if not msg:find("|T") then
        msg = msg:gsub("(|Hitem.-|h.-|h)", iconForLink)
    end

    return false, msg, ...
end


local function showAlertOnScreen(text,r,g,b,t,f,top)
	local	msg = CreateFrame("MessageFrame", "DBGRalert", UIParent)
			msg:SetWidth(1000);
			msg:SetHeight(500);
			msg:SetPoint("TOP", 0, -200);
			msg:SetPoint("CENTER", 0, top);
			msg:SetInsertMode("TOP")
			msg:SetFrameStrata("HIGH")
			msg:SetTimeVisible(t)
			msg:SetFadeDuration(f)
			msg:SetScale(1.2)
			msg:SetFont(STANDARD_TEXT_FONT, 25, "THICKOUTLINE")
			msg:AddMessage(text, r, g, b)
end


local function SecondsToTime(time)
	local hours = floor(mod(time, 86400)/3600) + floor(time/86400)*24
	local minutes = floor(mod(time,3600)/60)
	local seconds = floor(mod(time,60))

	return format("  %02dh   %02dm   %02ds",hours,minutes,seconds)
end


local function displayMailsInfo(self)
	local numItems, totalItems = GetInboxNumItems();
	local numAttach, totalGold = CountItemsAndMoney(self);
	local itemy, gold = " "," ";

	if numAttach ~= 0 then
		itemy = _L("ITEMS_IN_MAILS") .. "|cFF33FF33" .. numAttach .. "|r"
	end

	if totalGold ~= 0 then
		gold = _L("GOLD_IN_MAILS") .. "|cFF33FF33" .. tostring(GetMoneyString(math.abs(totalGold))) .. "|r"
	end

	if totalItems > 0 then
		MsgBox.opener="MAIL"
		MsgBox:showMsgBox(
			format(_L("MAIL_INFO_TEXT"),totalItems,itemy,gold),
			_L("MAILBOX")
		);
	else
		if MsgBox:IsShown() and MsgBox.opener == "MAIL" then
			MsgBox:showMsgBox(_L("EMPTY_INBOX"), _L("MAILBOX"));
		else
			print("|cFFFF99FF" .. _L("EMPTY_INBOX") .. "|r");
		end
	end
end


function CountItemsAndMoney(self)
	local numAttach = 0;
	local numGold = 0;

	self:UnregisterEvent("MAIL_INBOX_UPDATE");

	for i = 1, GetInboxNumItems() do
		local _, msgMoney, _, _, msgItem = select(4, GetInboxHeaderInfo(i))

		numAttach = numAttach + (msgItem or 0);
		numGold = numGold + msgMoney;
	end

	self:RegisterEvent("MAIL_INBOX_UPDATE");

	return numAttach, numGold
end


local function CheckUnspentTalents()
	C_Timer.After(0.1, function()
		local hasUnspent, classPoints, specPoints =
			C_ClassTalents.HasUnspentTalentPoints()

		if hasUnspent then
			local free_talent = classPoints + specPoints

			MsgBox:showMsgBox(
				string.format(_L("UNSPENT_TALENTS"), free_talent),
				_L("UNSPENT_TALENTS_TITLE")
			)

			MsgBox.opener = "UNSPENT_TALENTS"
		end
	end)
end


local function HookMailFrame()
	if MailFrame and not MailFrame.DBGRHooked then
		MailFrame:HookScript("OnHide", function()
			if MsgBox:IsShown() and MsgBox.opener == "MAIL" then
				MsgBox:Hide()
			end
		end)

		MailFrame.DBGRHooked = true
	end
end


local function eventHandler(self, event, ...)

	if event == "ADDON_LOADED" then
		local loadedAddon = ...

		if loadedAddon == ADDON_NAME then
			if DBGROPT == nil then
				OnClick_RestoreDef();
			end

			CheckUnspentTalents()
		end


	elseif event == "PLAYER_ENTERING_WORLD" then
		local is_init_login, is_reloading_UI = ...

		if is_init_login then
			showAlertOnScreen(
				format("%s %s (%s)", ADDON_NAME, ADDON_VERSION, ADDON_REL_TYPE),
				255,75,0,8,5,500
			)
		end

		if is_init_login or is_reloading_UI then
			print(
				format(
					"%1$s%2$s%s %s (%s)%2$s%1$s",
					LOGO(20),
					(" "):rep(10),
					ADDON_NAME,
					ADDON_VERSION,
					ADDON_REL_TYPE,
					LOGO(20)
				)
			);
		end


	elseif event == "CHAT_MSG_COMBAT_XP_GAIN" and DBGROPT.xpinfo then
		local text, _ = ...
		local xpgained = text:match("(%d+)")
		local xp = UnitXP("player")
		local maxXp = UnitXPMax("player")
		local percent = (xpgained / maxXp) * 100
		local percent_total = (xp / maxXp) * 100

		print(
			string.format(
				"\r\nEXP:|cFFFFEE00 +%d|r|cFFEE0000 (-%.1fx)|r       |cFF22FF15 +%.1f%%|r        TOTAL:|cFF00FFFF %.1f%%|r \r\n",
				xpgained,
				(100 - percent_total)/percent,
				percent,
				percent_total
			)
		)

		showAlertOnScreen(
			string.format("+%.1f%%",percent),
			0,255,0,3,1,50
		)


	elseif event == "PLAYER_LEVEL_UP" then
		CheckUnspentTalents()


	elseif event == "TIME_PLAYED_MSG" then
		if TIME_REQ then
			local timeTotal, timeCurLvl = ...

			MsgBox:showMsgBox(
				string.format(
					"%s:  %s\nLevel:  %s",
					_L("TOTAL"),
					SecondsToTime(timeTotal),
					SecondsToTime(timeCurLvl)
				),
				_L("PLAY_TIME_STATS")
			)

			MsgBox.opener = "TIME_PLAYED_MSG"
			TIME_REQ = false
		end


	elseif event == "PLAYER_FLAGS_CHANGED" then
		local unit = ...

		if unit == "player" then

			if UnitIsAFK("player") then

				if AFKTimer then
					AFKTimer:Cancel()
				end

				AFKTimer = C_Timer.NewTimer(20 * 60, function()
					AFKTimer = nil

					if UnitIsAFK("player") and DBGROPT.afk then
						MsgBox:showMsgBox(
							_L("AFK_WARN"),
							"! ! !  AFK  WARNING  ! ! !"
						)

						MsgBox.opener = "AFK_WARNING"
					end
				end)

			else

				if AFKTimer then
					AFKTimer:Cancel()
					AFKTimer = nil
				end

			end

		end


	elseif event == "AUCTION_HOUSE_SHOW_FORMATTED_NOTIFICATION" then

		-- Tu spoczywa diffowanie listy aukcji.
		-- Żyło krótko, cierpiało długo.
		-- Zostało pokonane przez jeden właściwy event.
		-- Anno Domini 2026 (po kilku dniach walki z API Blizzarda i niewłaściwą pomocą).

		if not DBGROPT.ah then
			return
		end

		local notification, text, auctionID = ...

		-- Auction sold
		if notification == Enum.AuctionHouseNotification.AuctionSold then
			local soldItem

			-- Try to get the item directly from the auction.
			if auctionID and C_AuctionHouse.GetAuctionInfoByID then
				local auctionInfo = C_AuctionHouse.GetAuctionInfoByID(auctionID)

				if auctionInfo then
					soldItem = auctionInfo.itemLink
				end
			end

			-- Fallback: use the formatted notification text.
			if not soldItem or soldItem == "" then
				soldItem = text
			end

			if MsgBox:IsShown() and MsgBox.opener == "AH_SELL" then
				MsgBox:showMsgBox(
					string.format("%s, %s", MsgBox.text:GetText(), soldItem),
					"Auction House"
				)
			else
				MsgBox:showMsgBox(
					string.format(_L("AH_ITEM_SELL"), soldItem),
					"Auction House"
				)
			end

			MsgBox.opener = "AH_SELL"


		-- Auction outbid
		elseif notification == Enum.AuctionHouseNotification.AuctionOutbid then
			local outbidItem

			-- Try to get the item directly from the auction.
			if auctionID and C_AuctionHouse.GetAuctionInfoByID then
				local auctionInfo = C_AuctionHouse.GetAuctionInfoByID(auctionID)

				if auctionInfo then
					outbidItem = auctionInfo.itemLink
				end
			end

			-- Fallback: use the formatted notification text.
			if not outbidItem or outbidItem == "" then
				outbidItem = text
			end

			if MsgBox:IsShown() and MsgBox.opener == "AH_OUTBID" then
				MsgBox:showMsgBox(
					string.format("%s, %s", MsgBox.text:GetText(), outbidItem),
					"Auction House"
				)
			else
				MsgBox:showMsgBox(
					string.format(_L("AH_OUTBID"), outbidItem),
					"Auction House"
				)
			end

			MsgBox.opener = "AH_OUTBID"
		end


	elseif event == "MAIL_SHOW" then
		HookMailFrame()


	elseif event == "MAIL_INBOX_UPDATE" then
		displayMailsInfo(self);


	elseif event == "MAIL_CLOSED" and MsgBox.opener == "MAIL" then
		MsgBox:Hide();


	elseif event == "PLAYER_INTERACTION_MANAGER_FRAME_SHOW" then
		-- INTERNAL USE ONLY BASED ON CHARACTER NAME

		local interactionType = ...;
		local char_name = UnitName("player");

		if (char_name == "Vellcia" or char_name == "Posiekany")
			and interactionType == Enum.PlayerInteractionType.GuildBanker then

			C_Timer.After(0.5, function()
				local moneyToDeposit = floor(GetMoney()/500)

				if moneyToDeposit > 0 then
					DepositGuildBankMoney(moneyToDeposit);
				end
			end)

		end
	end
end


function OnShow_SettingsFrame(obj)
	Title:SetText(
		format(
			"%1$s%2$s%s %s (%s) - %s%2$s%1$s",
			LOGO(30),
			(" "):rep(5),
			ADDON_NAME,
			ADDON_VERSION,
			ADDON_REL_TYPE,
			_L("SETTINGS"),
			LOGO(30)
		)
	)

	SetNotifySounds:SetChecked(DBGROPT.sound);
	SetAHNotify:SetChecked(DBGROPT.ah);
	SetAfkNotify:SetChecked(DBGROPT.afk);
	SetXPNotify:SetChecked(DBGROPT.xpinfo);

	SetNotifySoundsText:SetText(_L("SET_LABEL_NOTIFY_SND"));
	SetAHNotifyText:SetText(_L("SET_LABEL_AH_RELATED"));
	SetAfkNotifyText:SetText(_L("SET_LABEL_AFK_WARNS"));
	SetXPNotifyText:SetText(_L("SET_LABEL_EXP_INFO"));
	BtnRestoreDef:SetText(_L("SET_BTN_RESTORE_DEF"));
	BtnSaveReload:SetText(_L("SET_BTN_SAVE"));
end


function OnClick_SetNotifySounds(obj, _)
	DBGROPT.sound = obj:GetChecked();
end

function OnClick_SetAHNotify(obj, _)
	DBGROPT.ah = obj:GetChecked();
end

function OnClick_SetAfkNotify(obj, _)
	DBGROPT.afk = obj:GetChecked();
end

function OnClick_SetXPNotify(obj, _)
	DBGROPT.xpinfo = obj:GetChecked();
end


function IconSizeSlider_OnLoad()
	IconSizeSlider.Low:SetText('5');
	IconSizeSlider.High:SetText('50');
	IconSizeSlider:SetValueStep(1);
end


function IconSizeSlider_OnShow()
	IconSizeSlider.Text:SetText(
		format(
			"%s: %d",
			_L("CHAT_ICON_SIZE_LABEL"),
			DBGROPT.icon_size
		)
	);

	IconSizeSlider:SetValue(DBGROPT.icon_size);
end


function IconSizeSlider_OnValueChanged(self,value,user)

	if DBGROPT == nil then
		return
	end

	DBGROPT.icon_size = floor(value);

	IconSizeSlider.Text:SetText(
		format(
			"%s: %d",
			_L("CHAT_ICON_SIZE_LABEL"),
			DBGROPT.icon_size
		)
	);
end


function OnClick_RestoreDef()
	DBGROPT = {
		sound=true,
		xpinfo=true,
		ah=true,
		afk=true,
		icon_size=24,
		locale="EN"
	};  --TODO: CHANGE TO "EN"

	if SettingsFrame:IsShown() then
		SettingsFrame:Hide();
		SettingsFrame:Show();
	end

	print("DBGR Addon - ".._L("DEFAULT_SETTINGS_LOADED"));
end


function OnClick_SaveReload()
	ReloadUI();
end


function Select_Lang(lang)
	DBGROPT.locale = tostring(lang);
	ReloadUI();
end


function onUpdate(self, elapsed)
	UpdateTimer = UpdateTimer + elapsed

	if UpdateTimer < 5 then
		return
	end

	print("[ DEBUG ]: \ttest onUpdate");

	UpdateTimer = 0
end


-- ===================================================================================================================================================================================================

local	frame = CreateFrame("Frame", "DBGRframe")

		frame:RegisterEvent("ADDON_LOADED")
		frame:RegisterEvent("PLAYER_ENTERING_WORLD")
		frame:RegisterEvent("CHAT_MSG_COMBAT_XP_GAIN")
		frame:RegisterEvent("PLAYER_LEVEL_UP")
		frame:RegisterEvent("PLAYER_FLAGS_CHANGED")
		frame:RegisterEvent("TIME_PLAYED_MSG")
		frame:RegisterEvent("MAIL_SHOW")
		frame:RegisterEvent("MAIL_INBOX_UPDATE")
		frame:RegisterEvent("MAIL_CLOSED")
		frame:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_SHOW")
		frame:RegisterEvent("AUCTION_HOUSE_SHOW_FORMATTED_NOTIFICATION")

		frame:SetScript("OnEvent", eventHandler)

		-- frame:SetScript("OnUpdate", onUpdate)


MsgBox = MainFrame
MsgBox.header = MainFrame_Title
MsgBox.text = MainFrame_Text

tinsert(UISpecialFrames, MsgBox:GetName())

MsgBox.showMsgBox = function (self,text,title)

	if title and title ~= "" then
		self.header:SetText(tostring(title))
	end

	if text and text ~= "" then
		self.text:SetText(tostring(text))
	end

	if DBGROPT.sound == true and self.opener ~= "MAIL" then
		PlaySoundFile("Interface\\AddOns\\DBGR\\snd\\msg.wav");
	end

	self:Show()
end


ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", AddLootIcons);


ChatFrame1EditBox:SetAltArrowKeyMode(false);

SLASH_DBFRAME1 = "/dbgr"

function SlashCmdList.DBFRAME(msg, editbox)

	if msg == "" then
		MsgBox:Show();
	end

	if msg == "config" then
		SettingsFrame:Show();
	end

	if msg == "playtime" then
		TIME_REQ = true;
		RequestTimePlayed();
	end

	if msg == "get" then
		for k, v in pairs(DBGROPT) do
			print(k.." : "..tostring(v));
		end
	end

end
