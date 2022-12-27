#include <sourcemod>
#include <sdktools>

//insert semicolon after every statement
#pragma semicolon 1

//Enforce the new syntax in sourcemod 1.7+
#pragma newdecls required

#define NAME "[CS:S/CS:GO]sm_give Entities | Weapons & Items"
#define AUTHOR "Kiske, Kento, BallGanda"
#define DESCRIPTION "Give a weapon or item to a player from a command"
#define PLUGIN_VERSION "1.1.b8"
#define URL "http://www.sourcemod.net/"

int iEnableCol;

// Registers the "sm_give" admin command with the specified parameters
public void OnPluginStart()
{
	// Set the iEnableCol variable depending on the game
	if (GetEngineVersion() == Engine_CSS) {
		iEnableCol = 4; // for available in CSS column of g_entity
	}
	else if (GetEngineVersion() == Engine_CSGO) {
		iEnableCol = 5; // for available in CSGO column of g_entity
	}
	else {
		// The plugin is not running in either CSS or CSGO
		SetFailState("Error Neither CS:S or CS:GO detected");
		return ;
	}
	
	RegAdminCmd("sm_give", smGive, ADMFLAG_BAN, "<name|#userid> <entityname>");
	CreateConVar("sm_give_version", PLUGIN_VERSION, NAME, FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY);
}

// Declare a global char array named "g_entity"
// Initialize the array with a list of strings representing different entity names in the game
// array stores {{entity name, slot, ammo offset, ammo amount, available in CSS, available in CSGO},...}
char g_entity[][][] = {
	{"item_cash","-1","-1","-1","0","1"}, //csgo
	{"item_cutters","-1","-1","1","0","1"}, //csgo
	{"item_defuser","-1","-1","1","1","1"},
	{"item_dogtags","-1","-1","-1","0","1"}, //csgo
	{"item_exosuit","-1","-1","1","0","1"}, //csgo
	{"item_assaultsuit","-1","-1","1","1","1"},
	{"item_heavyassaultsuit","-1","-1","1","0","1"}, //csgo
	{"item_kevlar","-1","-1","1","1","1"},
	{"item_nvgs","-1","-1","1","1","1"},
	{"item_sodacan","-1","-1","1","0","1"},  //csgo
	{"weapon_ak47","0","2","90","1","1"},
	{"weapon_aug","0","2","90","1","1"},
	{"weapon_awp","0","5","30","1","1"},
	{"weapon_axe","2","-1","1","0","1"}, //csgo
	{"weapon_c4","4","-1","1","1","1"},
	{"weapon_bizon","0","-1","-1","0","1"}, //csgo
	{"weapon_breachcharge","-1","-1","-1","0","1"}, //csgo
	{"weapon_bumpmine","-1","-1","-1","0","1"}, //csgo
	{"weapon_cz75a","1","-1","-1","0","1"}, //csgo
	{"weapon_deagle","1","1","35","1","1"},
	{"weapon_decoy","-1","-1","-1","0","1"}, //csgo
	{"weapon_elite","1","6","120","1","1"},
	{"weapon_famas","0","3","90","1","1"},
	{"weapon_fists","2","-1","-1","0","1"}, //csgo
	{"weapon_fiveseven","1","10","100","1","1"},
	{"weapon_flashbang","3","12","1","1","1"},
	{"weapon_g3sg1","0","2","90","1","1"},
	{"weapon_galil","0","3","90","1","0"},
	{"weapon_galilar","0","-1","-1","0","1"}, //csgo
	{"weapon_glock","1","6","120","1","1"},
	{"weapon_hammer","2","-1","-1","0","1"},//csgo
	{"weapon_healthshot","-1","-1","-1","0","1"}, //csgo
	{"weapon_hegrenade","3","11","1","1","1"},
	{"weapon_hkp2000","-1","-1","-1","0","1"}, //csgo
	{"weapon_incgrenade","-1","-1","-1","0","1"}, //csgo
	{"weapon_knife","2","-1","-1","1","1"},
	{"weapon_knife_ghost","2","-1","-1","0","1"}, //csgo
	{"weapon_knifegg","2","-1","-1","0","1"}, //csgo
	{"weapon_m249","0","4","200","1","1"},
	{"weapon_m3","0","3","90","1","0"},
	{"weapon_m4a1","0","3","90","1","1"},
	{"weapon_m4a1_silencer","0","-1","-1","0","1"}, //csgo
	{"weapon_mac10","0","8","100","1","1"},
	{"weapon_mag7","-1","-1","-1","0","1"}, //csgo
	{"weapon_molotov","3","-1","-1","0","1"}, //csgo
	{"weapon_mp5navy","0","6","120","1","0"},
	{"weapon_mp5sd","-1","-1","-1","0","1"}, //csgo
	{"weapon_mp7","-1","-1","-1","0","1"}, //csgo
	{"weapon_mp9","-1","-1","-1","0","1"}, //csgo
	{"weapon_negev","-1","-1","-1","0","1"}, //csgo
	{"weapon_nova","-1","-1","-1","0","1"}, //csgo
	{"weapon_p228","1","9","52","1","0"},
	{"weapon_p250","-1","-1","-1","0","1"}, //csgo
	{"weapon_p90","0","10","100","1","1"},
	{"weapon_revolver","-1","-1","-1","0","1"}, //csgo
	{"weapon_sawedoff","-1","-1","-1","0","1"}, //csgo
	{"weapon_scar20","-1","-1","-1","0","1"}, //csgo
	{"weapon_scout","0","2","90","1","0"},
	{"weapon_sg550","0","3","90","1","0"},
	{"weapon_sg552","0","3","90","1","0"},
	{"weapon_sg556","-1","-1","-1","0","1"}, //csgo
	{"weapon_shield","-1","-1","-1","0","1"}, //csgo
	{"weapon_smokegrenade","3","13","1","1","1"},
	{"weapon_snowball","-1","-1","-1","0","1"}, //csgo
	{"weapon_spanner","2","-1","-1","0","1"}, //csgo
	{"weapon_ssg08","-1","-1","-1","0","1"}, //csgo
	{"weapon_tablet","-1","-1","-1","0","1"}, //csgo
	{"weapon_tagrenade","-1","-1","-1","0","1"}, //csgo
	{"weapon_taser","-1","-1","-1","0","1"}, //csgo
	{"weapon_tec9","-1","-1","-1","0","1"}, //csgo
	{"weapon_tmp","0","6","120","1","0"},
	{"weapon_ump45","0","8","120","1","1"},
	{"weapon_usp","1","8","100","1","1"},
	{"weapon_usp_silencer","-1","-1","-1","0","1"}, //csgo
	{"weapon_xm1014","0","7","32","1","1"},
	{"weapon_zone_repulsor","-1","-1","-1","0","1"}  //csgo
};

//Declare global int iSizeg_entity and Get the size of the weapon/item array
int iSizeg_entity = sizeof(g_entity);

//Declaring the elements for a table to print in console and headers for the columns
// Declare and initialize variables for storing command arguments, the entity name, and whether the entity name is valid
//Global Strings
char h_barsingle[] = "--------------------------------------------------------------------------------------";
char h_bardouble[] = "======================================================================================";
char h_entity_name[] = "Entity Name";
char h_weapon_slot[] = "Weapon Slot";
char h_ammo_offset[] = "Ammo Offset";
char h_ammo_reserve[] = "Ammo Reserve";
char h_css[] = "CS:S";
char h_csgo[] = "CS:GO";
char sArg[255]; //what should max size be??
char sTargetArg[MAX_TARGET_LENGTH]; 
char sEntityName[32], sEntityToGive[32], sEntitySlot[32]; //should set to some max size
// Declare a char array to store the target name and an int array to store a list of target indices.
char sTargetName[MAX_TARGET_LENGTH];
//Global integers
int iEntitySlot;
int iEntityRemove;
int iLengthArg1;
int iTargetList[MAXPLAYERS]; //should it be MAXP. + 1?
int iTargetCount; 
//Global booleans 
//Create a vaiable to store whether the given entity name was found in the list of avialable entities
//initialize with iValid (input valid) false
bool iValid = false;
// Declare a boolean to store whether the target name is a multiple-letter abbreviation.
bool bTN_IsML;


// Handles the "sm_give" admin command
public Action smGive(int client, int args) {
	
	// Get the full string of command arguments
	GetCmdArgString(sArg, sizeof(sArg));
	
	//Call function to check if function has less than 2 args and handle if help requested
	ArgsCheck(client, sArg);
	
	// Get the length of the first argument to get offset to second arg
	iLengthArg1 = BreakString(sArg, sTargetArg, sizeof(sTargetArg));
	
	//Use the iLengthArg1 offset to set the second arg to sEntityName
	BreakString(sArg[iLengthArg1], sEntityName, sizeof(sEntityName));
	
    //Validate the weapon/item input arg against g_entity array  
	for(int i = 0; i < iSizeg_entity; ++i) {
		// Check if the entity name is contained in the g_entity array
		if(g_entity[i][iEnableCol] == 1 && StrContains(g_entity[i][0], sEntityName) != -1) {
			//Set valid variable to true because it was found in g_entity
			iValid = true;
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
	if(!iValid) {
		InvalidEntity(client, sEntityName);
	}
	
	// Process the target string and store the result in the target list and target name variables.
	// the result is the count of matching targets to the supplied target argument input
	iTargetCount = ProcessTargetString(sTargetArg, client, iTargetList, MAXPLAYERS, COMMAND_FILTER_ALIVE, sTargetName, sizeof(sTargetName), bTN_IsML);
	
	//the function returns a target count value less than or equal to 0, it indicates an error.
	if(iTargetCount <= 0) {
		InvalidTarget(client, sTargetArg)
	}
	
	//This is the actual giving of weapons to the members of the target list
	for (int i = 0; i < iTargetCount; i++) {
		//get the entity value in the players target slot already
		iEntityRemove = GetPlayerWeaponSlot(iTargetList[i], iEntitySlot);
		
		//Check that player is alive
		//Perform check if the target has a weapon/item in the target slot already
		if(IsPlayerAlive(iTargetList[i]) && iEntityRemove != -1){

			//remove the item from the slot of the target player
			RemovePlayerItem(iTargetList[i], iEntityRemove);
		}
		
		//Give the new item to the target player
		if(IsPlayerAlive(iTargetList[i])) {
			GivePlayerItem(iTargetList[i], sEntityToGive);
		}
		
		// Retrieve the entity number of the item in the player's weapon slot after give
		int iEntityCheckGive;
		iEntityCheckGive = GetPlayerWeaponSlot(iTargetList[i], iEntitySlot);
		char sEntityCheckClassName;
		GetEdictClassname(iEntityCheckGive, sEntityCheckClassName, sizeof(sEntityCheckClassName));
		
		//Remove the weapon from the map if this feature enabled(need to add that cvar)
		//Checking that entity is in player slot now and class name matches the give classname
		if(iEntityRemove != -1 && iEntityCheckGive != -1 && sEntityCheckClassName == sEntityToGive) {
			//player has the weapon given ...probably or they picked up the same weapon from the ground
			RemoveEntity(iEntityRemove);
		}
		
		//check to detect failed give
		if(iEntityRemove != -1 && iEntityCheckGive == -1) {
			//attempt giving the removed entity back to the player
			EquipPlayerWeapon(iTargetList[i], iEntityRemove);
			//float fClientEyePosition[3];
			//GetClientEyePosition(iTargetList[i], fClientEyePosition);
			//TeleportEntity(iEntityRemove,fClientEyePosition);
			//AcceptEntityInput(iEntityRemove, "Use", iTargetList[i],iTargetList[i]);
		}
		//There is possibly a hole here in the last 2 checks and leaves the removed gun on the gound and possibly
		//the player empty handed.
	}
	return Plugin_Handled;
}

/ Argument check and handling
void ArgsCheck(int client, int args) {
	// If there are fewer than 2 arguments, check if the first argument is "list"
	// If it is, call the ListInputOptions function with the client as the argument
	// If it is not, print the usage message to the client
	if(args < 2) {
		char sArgCheck[255]; //should find proper max length to use here
		GetCmdArg(1, sArgCheck, sizeof(sArgCheck));
		if(StrEqual(sArgCheck, "list", false)) {
			ListInputOptions(client);
		} 
		if(StrEqual(sArgCheck, "about", false)) {
			AboutThisPlugin(client);
		}
		if(!StrEqual(sArgCheck, "list", false) && !StrEqual(sArgCheck, "about", false)) {
			ReplyToCommand(client, "[SM] Usage: sm_give <name|#userid> <entityname>");
			ReplyToCommand(client, "[SM] Usage: sm_give list |for %i entity list", iSizeg_entity);
			ReplyToCommand(client, "[SM] Usage: sm_give about |for about info");
		}
		return Plugin_Handled;
	} else {
		return Plugin_Continue;
	}
}

//Function to handle the arg that requests viewing the entity list
void ListInputOptions(int client) {
	ReplyToCommand(client, "%s", h_bardouble);
	ReplyToCommand(client, "| %-21.21s | %-11.11s | %-11.11s | %-12.12s | %-4.4s | %-5.5s |", h_entity_name, h_weapon_slot, h_ammo_offset, h_ammo_reserve, h_css, h_csgo);
	ReplyToCommand(client, "%s", h_bardouble);
	
	for(int i = 0; i < iSizeg_entity; ++i) {
		ReplyToCommand(client, "| %-21.21s | %-11.11s | %-11.11s | %-12.12s | %-4.4s | %-5.5s |", g_entity[i][0], g_entity[i][1], g_entity[i][2], g_entity[i][3], g_entity[i][4], g_entity[i][5]);
	}
	
	ReplyToCommand(client, "%s", h_barsingle);
	ReplyToCommand(client, "*No need to put weapon_/item_ in the <entityname>*");
	ReplyToCommand(client, "*Partials substrings work if not overlapping other entity name*");
	ReplyToCommand(client, "*If in game entity name is not on list plugin needs update*");
	ReplyToCommand(client, "%s", h_barsingle);
}

void AboutThisPlugin(int client) {
	ReplyToCommand(client, "");
	ReplyToCommand(client, "Plugin Name.......: %s", NAME);
	ReplyToCommand(client, "Plugin Author.....: %s", AUTHOR);
	ReplyToCommand(client, "Plugin Description: %s", DESCRIPTION);
	ReplyToCommand(client, "Plugin Version....: %s", PLUGIN_VERSION);
	ReplyToCommand(client, "Plugin URL........: %s", URL);
}

void InvalidEntity(int client, char sEntityInvalidName) {
	ReplyToCommand(client, "[SM] The entity name (%s) isn't valid", sEntityInvalidName);
	ReplyToCommand(client, "[SM] sm_give list | for entity list");
	return Plugin_Handled;
}

void InvalidTarget(int client, char sTargetInvalidName) {
	ReplyToCommand(client, "[SM] The target name (%s) isn't valid to give at this time", sTargetInvalidName);
	return Plugin_Handled;
}

public Plugin myinfo = {
	name = NAME,
	author = AUTHOR,
	description = DESCRIPTION,
	version = PLUGIN_VERSION,
	url = URL
}
