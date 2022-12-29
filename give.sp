#include <sourcemod>
#include <sdktools>
#include <cstrike>

//insert semicolon after every statement
#pragma semicolon 1

//Enforce the newer syntax in sourcemod 1.7+
#pragma newdecls required

#define NAME "[CS:S/CS:GO]sm_give Entities | Weapons & Items"
#define AUTHOR "Kiske, Kento, BallGanda"
#define DESCRIPTION "Give a weapon or item to a player from a command"
#define PLUGIN_VERSION "1.1.b9"
#define URL "http://www.sourcemod.net/"

//needs to be set before OnPluginStart function
int iEnableCol = -1;
ConVar g_cvEnabled = null;
bool g_bEnabled = false;
ConVar g_cvRemoveItems = null;


public void OnPluginStart() {
	//Checks the game version and sets the column to check in the weapon/item array
	// Set the iEnableCol variable depending on the game
	if (GetEngineVersion() == Engine_CSS) {
		iEnableCol = 2; // for available in CSS column of g_entity
	} else if (GetEngineVersion() == Engine_CSGO) {
		iEnableCol = 3; // for available in CSGO column of g_entity
	} else {
		// The plugin is not running in either CSS or CSGO
		SetFailState("Error Neither CS:S or CS:GO detected");
		return ;
	}
	
	// Registers the "sm_give" admin command with the specified parameters
	RegAdminCmd("sm_give", smGive, ADMFLAG_BAN, "<name|#userid> <entityname>");
	//public plugin version can be see from outside
	CreateConVar("sm_give_version", PLUGIN_VERSION, NAME, FCVAR_DONTRECORD|FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY);
	
	//Setup cvars that are for customizing the plugin
	g_cvEnabled = CreateConVar("sm_give_enable", "1", "sm_give Enable=1 Disable=0");
	g_cvRemoveItems = CreateConVar("sm_give_removeolditem", "0", "Enabled removes items from map instead of dropping Enable=1 Disable=0");
	
	//setup a hook for if the value of g_cvEnabled is changed
	g_cvEnabled.AddChangeHook(ConVarChange_sm_give_enable);
	
	//Set a boolean frothe eable that will be controlled by the sm_give_enable cvar in a function 
	//Set the plugin to enabled initially as a boolean. the autoexec config may change the setting and get detected by the hook
	g_bEnabled = true;
	
	//will create a file named cfg/sourcemod/sm_give.cfg
	//this execs the file if already created
	AutoExecConfig(true, "sm_give");
}

//Function that runs if the enabled cvar is changed
//I think this should be in any plugin that wants to be able to turn on and off on cvar change real time
public void ConVarChange_sm_give_enable(ConVar convar, char[] oldValue, char[] newValue) {
	int iNewVal = StringToInt(newValue);
	
	if (g_bEnabled && iNewVal != 1) {
		g_bEnabled = false;
	} else if (!g_bEnabled && iNewVal == 1) {
		g_bEnabled = true;		
	}
}

// Declare a global char array named "g_entity"
// Initialize the array with a list of strings representing different entity names in the game
// array stores {{entity name, slot, available in CSS, available in CSGO},...}
char g_entity[][][] = {
	{"item_cash","-1","0","1"}, //csgo
	{"item_cutters","-1","0","1"}, //csgo
	{"item_defuser","-1","1","1"},
	{"item_dogtags","-1","0","1"}, //csgo
	{"item_exosuit","-1","0","1"}, //csgo
	{"item_assaultsuit","-1","1","1"},
	{"item_heavyassaultsuit","-1","0","1"}, //csgo
	{"item_kevlar","-1","1","1"},
	{"item_nvgs","-1","1","1"},
	{"item_sodacan","-1","0","1"},  //csgo
	{"weapon_ak47","0","1","1"},
	{"weapon_aug","0","1","1"},
	{"weapon_awp","0","1","1"},
	{"weapon_axe","2","0","1"}, //csgo
	{"weapon_c4","4","1","1"},
	{"weapon_bizon","0","0","1"}, //csgo
	{"weapon_breachcharge","4","0","1"}, //csgo
	{"weapon_bumpmine","4","0","1"}, //csgo
	{"weapon_cz75a","1","0","1"}, //csgo
	{"weapon_deagle","1","1","1"},
	{"weapon_decoy","3","0","1"}, //csgo
	{"weapon_elite","1","1","1"},
	{"weapon_famas","0","1","1"},
	{"weapon_fists","2","0","1"}, //csgo
	{"weapon_fiveseven","1","1","1"},
	{"weapon_flashbang","3","1","1"},
	{"weapon_g3sg1","0","1","1"},
	{"weapon_galil","0","1","0"},
	{"weapon_galilar","0","0","1"}, //csgo
	{"weapon_glock","1","1","1"},
	{"weapon_hammer","2","0","1"},//csgo
	{"weapon_healthshot","4","0","1"}, //csgo
	{"weapon_hegrenade","3","1","1"},
	{"weapon_hkp2000","1","0","1"}, //csgo
	{"weapon_incgrenade","3","0","1"}, //csgo
	{"weapon_knife","2","1","1"},
	{"weapon_knife_ghost","2","0","1"}, //csgo
	{"weapon_knifegg","2","0","1"}, //csgo
	{"weapon_m249","0","1","1"},
	{"weapon_m3","0","1","0"},
	{"weapon_m4a1","0","1","1"},
	{"weapon_m4a1_silencer","0","0","1"}, //csgo
	{"weapon_mac10","0","1","1"},
	{"weapon_mag7","0","0","1"}, //csgo
	{"weapon_molotov","3","0","1"}, //csgo
	{"weapon_mp5navy","0","1","0"},
	{"weapon_mp5sd","0","0","1"}, //csgo
	{"weapon_mp7","0","0","1"}, //csgo
	{"weapon_mp9","0","0","1"}, //csgo
	{"weapon_negev","0","0","1"}, //csgo
	{"weapon_nova","0","0","1"}, //csgo
	{"weapon_p228","1","1","0"},
	{"weapon_p250","1","0","1"}, //csgo
	{"weapon_p90","0","1","1"},
	{"weapon_revolver","1","0","1"}, //csgo
	{"weapon_sawedoff","0","0","1"}, //csgo
	{"weapon_scar20","0","0","1"}, //csgo
	{"weapon_scout","0","1","0"},
	{"weapon_sg550","0","1","0"},
	{"weapon_sg552","0","1","0"},
	{"weapon_sg556","0","0","1"}, //csgo
	{"weapon_shield","6","0","1"}, //csgo
	{"weapon_smokegrenade","3","1","1"},
	{"weapon_snowball","3","0","1"}, //csgo
	{"weapon_spanner","2","0","1"}, //csgo
	{"weapon_ssg08","0","0","1"}, //csgo
	{"weapon_tablet","6","0","1"}, //csgo
	{"weapon_tagrenade","3","0","1"}, //csgo
	{"weapon_taser","10","0","1"}, //csgo
	{"weapon_tec9","1","0","1"}, //csgo
	{"weapon_tmp","0","1","0"},
	{"weapon_ump45","0","1","1"},
	{"weapon_usp","1","1","1"},
	{"weapon_usp_silencer","1","0","1"}, //csgo
	{"weapon_xm1014","0","1","1"},
	{"weapon_zone_repulsor","-1","0","1"}  //csgo
};

//Declare global int iSizeg_entity and Get the size of the weapon/item array
int iSizeg_entity = sizeof(g_entity);

//Declaring the elements for a table to print in console and headers for the columns
//Declare and initialize variables for storing command arguments, the entity name, and whether the entity name is valid
//Global Strings
char h_barsingle[] = "-------------------------------------------------------------";
char h_bardouble[] = "=============================================================";
char h_entity_name[] = "Entity Name";
char h_weapon_slot[] = "Weapon Slot";
char h_css[] = "CS:S";
char h_csgo[] = "CS:GO";
char sTargetArg[MAX_TARGET_LENGTH]; 
char sEntityName[32], sEntityToGive[32], sEntitySlot[32]; //should set to some max size
// Declare a char array to store the target name and an int array to store a list of target indices.
char sTargetName[MAX_TARGET_LENGTH];
//Global integers
int iEntitySlot;
int iEntityRemove = -1;
//int iLengthArg1;
int iTargetList[MAXPLAYERS]; //should it be MAXP. + 1?
int iTargetCount; 
//Global booleans 
//Create a vaiable to store whether the given entity name was found in the list of avialable entities
//initialize with bValid (input valid) false
bool bValid = false;
// Declare a boolean to store whether the target name is a multiple-letter abbreviation.
bool bTN_IsML;


// Handles the "sm_give" admin command
public Action smGive(int client, int args) {
	
	//checks if the plugin is enabled by cvar
	if(!g_bEnabled) {
		ReplyToCommand(client, "[sm_give] is installed but Disabled");
		return Plugin_Handled;
	}
	
	if(args < 2) {
		char sArgCheck[255]; //should find proper max length to use here
		GetCmdArg(1, sArgCheck, sizeof(sArgCheck));
		if(StrEqual(sArgCheck, "list", false)) {
			ReplyToCommand(client, "%s", h_bardouble);
			ReplyToCommand(client, "| %-21.21s | %-11.11s | %-4.4s | %-5.5s |", h_entity_name, h_weapon_slot, h_css, h_csgo);
			ReplyToCommand(client, "%s", h_bardouble);
			
			for(int i = 0; i < iSizeg_entity; ++i) {
				ReplyToCommand(client, "| %-21.21s | %-11.11s | %-4.4s | %-5.5s |", g_entity[i][0], g_entity[i][1], g_entity[i][2], g_entity[i][3]);
			}
			
			ReplyToCommand(client, "%s", h_barsingle);
			ReplyToCommand(client, "*No need to put weapon_/item_ in the <entityname>*");
			ReplyToCommand(client, "*Partials substrings work if not overlapping other entity name*");
			ReplyToCommand(client, "*If in game entity name is not on list plugin needs update*");
			ReplyToCommand(client, "%s", h_barsingle);
		} 
		if(StrEqual(sArgCheck, "about", false)) {
			ReplyToCommand(client, "");
			ReplyToCommand(client, "Plugin Name.......: %s", NAME);
			ReplyToCommand(client, "Plugin Author.....: %s", AUTHOR);
			ReplyToCommand(client, "Plugin Description: %s", DESCRIPTION);
			ReplyToCommand(client, "Plugin Version....: %s", PLUGIN_VERSION);
			ReplyToCommand(client, "Plugin URL........: %s", URL);
		}
		if(!StrEqual(sArgCheck, "list", false) && !StrEqual(sArgCheck, "about", false)) {
			ReplyToCommand(client, "[SM] Usage: sm_give <name|#userid> <entityname>");
			ReplyToCommand(client, "[SM] Usage: sm_give list |for %i entity list", iSizeg_entity);
			ReplyToCommand(client, "[SM] Usage: sm_give about |for about info");
		}
		return Plugin_Handled;
	}
	
	GetCmdArg(1, sTargetArg, sizeof(sTargetArg));
	//iLengthArg1 = sizeof(sTargetArg);
	GetCmdArg(2, sEntityName, sizeof(sEntityName));
	
    //Validate the weapon/item input arg against g_entity array  
	for(int i = 0; i < iSizeg_entity; ++i) {
		// Check if the entity name is contained in the g_entity array
		if(StrEqual(g_entity[i][iEnableCol], "1", true) && StrContains(g_entity[i][0], sEntityName) != -1) {
			//Set valid variable to true because it was found in g_entity
			bValid = true;
			// Copy the matching entity name to sEntityToGive
			strcopy(sEntityToGive, sizeof(sEntityToGive), g_entity[i][0]);
			// Copy the matching entity name to sEntitySlot
			strcopy(sEntitySlot, sizeof(sEntitySlot), g_entity[i][1]);
			//Convert the string to an int and store in iEntitySlot
			iEntitySlot = StringToInt(sEntitySlot);
			// Break out of the for loop now once entity matched
			break;
		}
	}
	
	// Error handle for when the input did not find a valid match
	if(!bValid) {
		ReplyToCommand(client, "[SM] The entity name (%s) isn't valid", sEntityName);
		ReplyToCommand(client, "[SM] sm_give list | for entity list");
		return Plugin_Handled;
	}
	
	// Process the target string and store the result in the target list and target name variables.
	// the result is the count of matching targets to the supplied target argument input
	iTargetCount = ProcessTargetString(sTargetArg, client, iTargetList, MAXPLAYERS, COMMAND_FILTER_ALIVE, sTargetName, sizeof(sTargetName), bTN_IsML);
	
	//the function returns a target count value less than or equal to 0, it indicates an error.
	if(iTargetCount <= 0) {
		ReplyToCommand(client, "[SM] The target name (%s) isn't valid to give at this time", sTargetArg);
		return Plugin_Handled;
	}
	
	//This is the actual giving of weapons to the members of the target list
	for (int i = 0; i < iTargetCount; i++) {
		//get the entity value in the players target slot already
		iEntityRemove = GetPlayerWeaponSlot(iTargetList[i], iEntitySlot);
		
		//Check drop or remove setting and that player is alive
		//Perform check if the target has a weapon/item in the target slot already
		if(GetConVarInt(g_cvRemoveItems) == 0 && IsPlayerAlive(iTargetList[i]) && iEntityRemove != -1){
			//drop the weapon that in current in the target slot to ground
			CS_DropWeapon(iTargetList[i], iEntityRemove, false);
		}
		
		if(GetConVarInt(g_cvRemoveItems) == 1 && IsPlayerAlive(iTargetList[i]) && iEntityRemove != -1){
			//remove the item from the target slot of the target player and remove from map
			RemovePlayerItem(iTargetList[i], iEntityRemove);
			RemoveEntity(iEntityRemove);
		}
		
		//Give the new item to the target player
		if(IsPlayerAlive(iTargetList[i])) {
			GivePlayerItem(iTargetList[i], sEntityToGive);
		}
	
	}
	iEntityRemove = -1;
	bValid = false;
	return Plugin_Handled;
}

public Plugin myinfo = {
	name = NAME,
	author = AUTHOR,
	description = DESCRIPTION,
	version = PLUGIN_VERSION,
	url = URL
}
