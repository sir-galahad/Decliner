DeclinerSayMode = "timed"

-- Default quests to be auto-declined
QuestsToDecline = {
	[8549]="The Horde Needs Peacebloom",
	[8580]="The Horde Needs Firebloom",
	[3741]="Hilary's Necklace",
	[4866]="Mother's Milk",
	[11129]="Kyle's Gone Missing!",
	[7281]="Brotherly Love",
	[9023]="The Perfect Poison",
	[3861]="CLUCK!"
}

-- Create button to set quest as "always decline"
local adButton = CreateFrame("Button","Always Decline", QuestFrameDetailPanel,"UIPanelButtonTemplate")
adButton:SetPoint("TOPLEFT",QuestFrameDetailPanel,120,-417)
adButton:SetSize(125,25)
adButton:SetText("Always Decline")
adButton:Show()
adButton:SetScript("OnClick", function(self, button)
	questID = GetQuestID()
	questName = C_QuestLog.GetQuestInfo(questID)
	QuestsToDecline[questID]=questName
	DeclineQuest()
end)

-- create a frame to tie events to
local mainframe = CreateFrame("Frame", nil ,UIParent)
local lastSay = 0
mainframe:RegisterEvent("QUEST_DETAIL")

mainframe:SetScript("OnEvent", function(self, event, questID, success, ...)
	if event == "QUEST_DETAIL" then
		quest_id = GetQuestID()
		if QuestsToDecline[quest_id] ~= nil then
			DeclineQuest()
			now = GetTime()
			if now - lastSay > 60 and DeclinerSayMode ~= "never" then
				PhoboSay("quest \"" .. QuestsToDecline[quest_id] .. "\" auto-declined for trolling", "SAY")
				if DeclinerSayMode == "timed" then
					lastSay=now
				end
			end
		end
	end
end

) -- end function

local actions = {}
actions["SAY"] = "says "
actions["YELL"] = "yells "

function PhoboSay (msg, action)
	if actions[action] ~= nil then
		if  IsInInstance() then 
			SendChatMessage(msg, action)
		else
			SendChatMessage(actions[action]..msg,EMOTE)
		end
	else
		SendChatMessage(msg, action)
	end
end

SLASH_DEC1 = "/dec"
SLASH_DEC2 = "/decline"
SLASH_DEC3 = "/decliner"
SlashCmdList["DEC"] = function(msg)
	args = {}
	for arg in msg:gmatch("%w+") do table.insert(args, arg) end

	if args[1] == "help" then
		print("Autodecliner commands:")
		print("/dec help -- print this message")
		print("/dec list -- print a list of quests that will be autodeclined")
		print("/dec remove <questid> -- remove a quest from the autodecline list")
		print("/dec saymode [{always||never||timed}] -- when should decliner"..
			" announce a declined quest (timed means not more than once every 60 seconds)." ..
			" No argument causes decliner to print the current SayMode"
		)
	elseif args[1] == "list" then
		for questID, questName in pairs(QuestsToDecline) do
			print(questName, " = ", questID)
		end
	elseif args[1] == "remove" then
		if args[2] == nil then
			print("Which quest id did you want to remove?")
		end
		questID = tonumber(args[2])
		if questID == nil then
			print("QuestID must be numeric")
		end
		if QuestsToDecline[questID] ~= nil then
			questName = QuestsToDecline[questID]
			QuestsToDecline[questID]=nil
			print("\"", questName, "\" will no longer be autodeclined")
		else
			print("questID (", args[2],") not found in autodecline list")
		end
	elseif args[1] == "saymode" then
		if args[2] == nil then
			print("Current SayMode: ", DeclinerSayMode)
			return
		end
		if args[2] == "always" or args[2] == "never" or args[2] == "timed" then
			DeclinerSayMode=args[2]
			if args[2] == "always" then
				lastSay = 0 -- the timing stuff is still in place so set last say be far in the past if "always"
			end
		else 
			print("Invalid SayMode, valid SayMode options are 'always', 'never', or 'timed'")
		end
	else
		print("use `/decliner help` to see available commands")
	end

end