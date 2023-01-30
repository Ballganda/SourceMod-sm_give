#include <sourcemod>
#include <sdktools>
#include <cstrike>

#pragma semicolon 1
#pragma newdecls required

#define NAME "[CS:S]sm_give Entities | Weapons & Items"
#define AUTHOR "pRED*, Kiske, Kento, BallGanda"
#define DESCRIPTION "Give a weapon or item to a player from a command"
#define PLUGIN_VERSION "1.1.b11"
#define URL "https://github.com/Ballganda/SourceMod-sm_give"

ConVar g_cvEnabled = null;
ConVar g_cvDropItems = null;
ConVar g_cvRemoveItems = null;

public void OnPluginStart()
{
	CheckGameVersion();
	
	RegAdminCmd("sm_give", smGive, ADMFLAG_BAN, "<name|#userid> <entityname>");
	
	CreateConVar("sm_give_version", PLUGIN_VERSION, NAME, FCVAR_DONTRECORD|FCVAR_NOTIFY);
	
	g_cvEnabled = CreateConVar("sm_give_enable", "1", "sm_give Enables the plugin <1|0>");
	g_cvDropItems = CreateConVar("sm_give_drop", "1", "sm_give_drop Enabled forces dropping weapon in hand before give <1|0>");
	g_cvRemoveItems = CreateConVar("sm_give_removeolditem", "0", "sm_give_removeolditem Enabled removes items from map <1|0>");
	
	AutoExecConfig(true, "sm_give");
}

// Declare a global char array named "g_entity"
// array stores {{col 0 entity name, col 1 slot},...}
char g_entity[][][] = {
	// column 0 |  1 |
	{"item_defuser","-1"},
	{"item_assaultsuit","-1"},
	{"item_kevlar","-1"},
	{"item_nvgs","-1"},
	{"weapon_ak47","0"},
	{"weapon_aug","0"},
	{"weapon_awp","0"},
	{"weapon_c4","4"},
	{"weapon_deagle","1"},
	{"weapon_elite","1"},
	{"weapon_famas","0"},
	{"weapon_fiveseven","1"},
	{"weapon_flashbang","3"},
	{"weapon_g3sg1","0"},
	{"weapon_galil","0"},
	{"weapon_glock","1"},
	{"weapon_hegrenade","3"},
	{"weapon_knife","2"},
	{"weapon_m249","0"},
	{"weapon_m3","0"},
	{"weapon_m4a1","0"},
	{"weapon_mac10","0"},
	{"weapon_mp5navy","0"},
	{"weapon_p228","1"},
	{"weapon_p90","0"},
	{"weapon_scout","0"},
	{"weapon_sg550","0"},
	{"weapon_sg552","0"},
	{"weapon_smokegrenade","3"},
	{"weapon_tmp","0"},
	{"weapon_ump45","0"},
	{"weapon_usp","1"},
	{"weapon_xm1014","0"}
};

//Declare global int iSizeg_entity and Get the size of the weapon/item array
int iSizeg_entity = sizeof(g_entity);

public Action smGive(int client, int args)
{
	if(!g_cvEnabled.BoolValue) 
	{
		ReplyToCommand(client, "[sm_give] is installed but Disabled");
		return Plugin_Handled;
	}
	
	if(args < 2) 
	{
		char sArgCheck[MAX_TARGET_LENGTH];
		GetCmdArg(1, sArgCheck, sizeof(sArgCheck));
		if(StrEqual(sArgCheck, "list", false))
		{
			char h_barsingle[] = "------------------------------------------------------";
			char h_bardouble[] = "======================================================";
			char h_entity_name[] = "Entity Name";
			char h_weapon_slot[] = "Weapon Slot";
			PrintToConsole(client, "%s", h_bardouble);
			PrintToConsole(client, "| %-21.21s | %-26.26s |", h_entity_name, h_weapon_slot);
			PrintToConsole(client, "%s", h_bardouble);
			
			for(int i = 0; i < iSizeg_entity; ++i)
			{
				PrintToConsole(client, "| %-21.21s | %-26.26s |", g_entity[i][0], g_entity[i][1]);
			}
			
			PrintToConsole(client, "%s", h_barsingle);
			PrintToConsole(client, "*No need to put weapon_/item_ in the <entityname>*");
			PrintToConsole(client, "*Partials substrings work if not overlapping other entity name*");
			PrintToConsole(client, "*If in game entity name is not on list plugin needs update*");
			PrintToConsole(client, "%s", h_barsingle);
		}
		
		if(StrEqual(sArgCheck, "about", false))
		{
			PrintToConsole(client, "");
			PrintToConsole(client, "Plugin Name.......: %s", NAME);
			PrintToConsole(client, "Plugin Author.....: %s", AUTHOR);
			PrintToConsole(client, "Plugin Description: %s", DESCRIPTION);
			PrintToConsole(client, "Plugin Version....: %s", PLUGIN_VERSION);
			PrintToConsole(client, "Plugin URL........: %s", URL);
		}
		
		if(!StrEqual(sArgCheck, "list", false) && !StrEqual(sArgCheck, "about", false))
		{
			ReplyToCommand(client, "[SM] Usage: sm_give <name|#userid|@all|@ct|@t> <entityname>");
			ReplyToCommand(client, "[SM] Usage: sm_give list |for %i entity list in console", iSizeg_entity);
			ReplyToCommand(client, "[SM] Usage: sm_give about |for about info in console");
		}
		return Plugin_Handled;
	}
	
	char sTargetArg[MAX_TARGET_LENGTH];
	char sEntityNameArg[MAX_TARGET_LENGTH];
	GetCmdArg(1, sTargetArg, sizeof(sTargetArg));
	GetCmdArg(2, sEntityNameArg, sizeof(sEntityNameArg));
	
    //Validate the weapon/item input arg against g_entity array
	bool bValid = false;
	char sEntityToGive[MAX_TARGET_LENGTH];
	char sEntitySlot[MAX_TARGET_LENGTH];
	int iEntitySlot;
	for(int i = 0; i < iSizeg_entity; ++i)
	{
		if(StrContains(g_entity[i][0], sEntityNameArg) != -1)
		{
			bValid = true;
			strcopy(sEntityToGive, sizeof(sEntityToGive), g_entity[i][0]);
			strcopy(sEntitySlot, sizeof(sEntitySlot), g_entity[i][1]);
			iEntitySlot = StringToInt(sEntitySlot);
			break;
		}
	}
	
	// Error handling for when the input did not find a valid match
	if(!bValid)
	{
		int iEntityArgCheck;
		iEntityArgCheck = CreateEntityByName(sEntityNameArg, -1);
		if(iEntityArgCheck == -1)
		{
			ReplyToCommand(client, "[SM] The entity name <%s> is not valid", sEntityNameArg);
			ReplyToCommand(client, "[SM] sm_give list | for known entity list");
		}
		
		if(iEntityArgCheck > 0)
		{
			ReplyToCommand(client, "[SM] The entity name <%s> is valid but not in the give list", sEntityNameArg);
			ReplyToCommand(client, "[SM] sm_give list | for known entity list");
			RemoveEntity(iEntityArgCheck);
		}
		return Plugin_Handled;
	}
	
	// Process the target string and store the result in the target list count
	int iTargetCount;
	int iTargetList[MAXPLAYERS]; //should it be MAXP. + 1?
	char sTargetName[MAX_TARGET_LENGTH];
	bool bTN_IsML; // Declare a boolean to store whether the target name is a multiple-letter abbreviation.
	iTargetCount = ProcessTargetString(sTargetArg,
										client,
										iTargetList,
										MAXPLAYERS,
										COMMAND_FILTER_ALIVE,
										sTargetName,
										sizeof(sTargetName),
										bTN_IsML);
	
	//the function returns a target count value less than or equal to 0, it indicates an error.
	if(iTargetCount < 1)
	{
		ReplyToCommand(client, "[SM] The target name <%s> isn't valid to give at this time", sTargetArg);
		return Plugin_Handled;
	}
	
	//This is the actual giving of weapons to the members of the target list
	int iEntityRemove = -1;
	for (int i = 0; i < iTargetCount; i++)
	{
		iEntityRemove = GetPlayerWeaponSlot(iTargetList[i], iEntitySlot);
		
		if(g_cvDropItems.BoolValue && IsPlayerAlive(iTargetList[i]) && iEntityRemove != -1)
		{
			//drop weapon if in the target slot to ground
			CS_DropWeapon(iTargetList[i], iEntityRemove, false);
		}
		
		if(g_cvRemoveItems.BoolValue && IsPlayerAlive(iTargetList[i]) && iEntityRemove != -1)
		{
			//remove the item from the target player and remove from map
			RemovePlayerItem(iTargetList[i], iEntityRemove);
			RemoveEntity(iEntityRemove);
		}
		
		//This is it... the actual Give command to the target player/s
		if(IsPlayerAlive(iTargetList[i]))
		{
			GivePlayerItem(iTargetList[i], sEntityToGive);
		}
		
		iEntityRemove = -1;
	}
	return Plugin_Handled;
}

void CheckGameVersion()
{
	if(GetEngineVersion() != Engine_CSS)
	{
		SetFailState("Only CS:S Supported");
	}
}

public Plugin myinfo = {
	name = NAME,
	author = AUTHOR,
	description = DESCRIPTION,
	version = PLUGIN_VERSION,
	url = URL
}
