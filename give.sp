#include <sourcemod>
#include <sdktools>

//insert semicolon after every statement
#pragma semicolon 1

//Enforce the new syntax in sourcemod 1.7+
#pragma newdecls required

#define NAME "[CS:S/CS:GO]sm_give Entities | Weapons & Items"
#define AUTHOR "Kiske, Kento, BallGanda"
#define DESCRIPTION "Give a weapon or item to a player from a command"
#define PLUGIN_VERSION "1.1.b7"
#define URL "http://www.sourcemod.net/"


// Registers the "sm_give" admin command with the specified parameters
public void OnPluginStart()
{
	RegAdminCmd("sm_give", smGive, ADMFLAG_BAN, "<name|#userid> <entityname>");
}

// Declare a global char array named "g_entity"
// Initialize the array with a list of strings representing different entity names in the game
// working array stores {{entity name, weaponslot, ammo offset, ammo amount},...}
char g_entity[][][] = {
	{"item_cutters","-1","-1","1"}, //csgo
	{"item_defuser","-1","-1","1"},
	{"item_exosuit","-1","-1","1"}, //csgo
	{"item_assaultsuit","-1","-1","1"},
	{"item_heavyassaultsuit","-1","-1","1"}, //csgo
	{"item_kevlar","-1","-1","1"},
	{"item_nvgs","-1","-1","1"},
	{"weapon_ak47","0","2","90"},
	{"weapon_aug","0","2","90"},
	{"weapon_awp","0","5","30"},
	{"weapon_axe","2","-1","1"}, //csgo
	{"weapon_c4","4","-1","1"},
	{"weapon_bizon","0","-1","-1"}, //csgo
	{"weapon_breachcharge","-1","-1","-1"}, //csgo
	{"weapon_bumpmine","-1","-1","-1"}, //csgo
	{"weapon_cz75a","1","-1","-1"}, //csgo
	{"weapon_deagle","1","1","35"},
	{"weapon_decoy","-1","-1","-1"}, //csgo
	{"weapon_elite","1","6","120"},
	{"weapon_famas","0","3","90"},
	{"weapon_fists","2","-1","-1"}, //csgo
	{"weapon_fiveseven","1","10","100"},
	{"weapon_flashbang","3","12","1"},
	{"weapon_g3sg1","0","2","90"},
	{"weapon_galil","0","3","90"},
	{"weapon_galilar","0","-1","-1"}, //csgo
	{"weapon_glock","1","6","120"},
	{"weapon_hammer","2","-1","-1"},//csgo
	{"weapon_healthshot","-1","-1","-1"}, //csgo
	{"weapon_hegrenade","3","11","1"},
	{"weapon_hkp2000","-1","-1","-1"}, //csgo
	{"weapon_incgrenade","-1","-1","-1"}, //csgo
	{"weapon_knife","2","-1","-1"},
	{"weapon_knifegg","2","-1","-1"}, //csgo
	{"weapon_m249","0","4","200"},
	{"weapon_m3","0","3","90"},
	{"weapon_m4a1","0","3","90"},
	{"weapon_m4a1_silencer","0","-1","-1"}, //csgo
	{"weapon_mac10","0","8","100"},
	{"weapon_mag7","-1","-1","-1"}, //csgo
	{"weapon_molotov","3","-1","-1"}, //csgo
	{"weapon_mp5navy","0","6","120"},
	{"weapon_mp5sd","-1","-1","-1"}, //csgo
	{"weapon_mp7","-1","-1","-1"}, //csgo
	{"weapon_mp9","-1","-1","-1"}, //csgo
	{"weapon_negev","-1","-1","-1"}, //csgo
	{"weapon_nova","-1","-1","-1"}, //csgo
	{"weapon_p228","1","9","52"},
	{"weapon_p250","-1","-1","-1"}, //csgo
	{"weapon_p90","0","10","100"},
	{"weapon_revolver","-1","-1","-1"}, //csgo
	{"weapon_sawedoff","-1","-1","-1"}, //csgo
	{"weapon_scar20","-1","-1","-1"}, //csgo
	{"weapon_scout","0","2","90"},
	{"weapon_sg550","0","3","90"},
	{"weapon_sg552","0","3","90"},
	{"weapon_sg556","-1","-1","-1"}, //csgo
	{"weapon_shield","-1","-1","-1"}, //csgo
	{"weapon_smokegrenade","3","13","1"},
	{"weapon_spanner","2","-1","-1"}, //csgo
	{"weapon_ssg08","-1","-1","-1"}, //csgo
	{"weapon_tagrenade","-1","-1","-1"}, //csgo
	{"weapon_taser","-1","-1","-1"}, //csgo
	{"weapon_tec9","-1","-1","-1"}, //csgo
	{"weapon_tmp","0","6","120"},
	{"weapon_ump45","0","8","120"},
	{"weapon_usp","1","8","100"},
	{"weapon_usp_silencer","-1","-1","-1"}, //csgo
	{"weapon_xm1014","0","7","32"} 
};

//Declare global int Get the size of the weapon/item array
int max_entity = sizeof(g_entity);

//Declaring the elements for a table to print in console and headers for the columns
char h_barsingle[] = "--------------------------------------------------------------------------------";
char h_bardouble[] = "================================================================================";
char h_entity_name[] = "Entity Name";
char h_weapon_slot[] = "Weapon Slot";
char h_ammo_offset[] = "Ammo Offset";
char h_ammo_reserve[] = "Ammo Reserve";


// Handles the "sm_give" admin command
public Action smGive(int client, int args) {
	// Argument check and handling
	// If there are fewer than 2 arguments, check if the first argument is "list"
	// If it is, call the smGiveList function with the client as the argument
	// If it is not, print the usage message to the client
	if(args < 2) {
		char sArg[32];
		GetCmdArg(1, sArg, sizeof(sArg));
		if(StrEqual(sArg, "list", false)) {
			smGiveList(client);
		} 
		if(StrEqual(sArg, "about", false)) {
			smGiveAbout(client);
		}
		if(!StrEqual(sArg, "list", false) && !StrEqual(sArg, "about", false)) {
			ReplyToCommand(client, "[SM] Usage: sm_give <name|#userid> <entityname>");
			ReplyToCommand(client, "[SM] Usage: sm_give list |for %i entity list", max_entity);
			ReplyToCommand(client, "[SM] Usage: sm_give about |for about info");
		}
		return Plugin_Handled;
	}
	
	// Declare and initialize variables for storing command arguments, the entity name, and whether the entity name is valid
	char sArg[255];
	char sTargetArg[32];
	char sEntityName[32], sEntityToGive[32], sEntitySlot[32];
	int iEntitySlot;
	int iEntityRemove;
	int iLengthArg1;
	int iLengthArg2;
	
	// Get the full string of command arguments and split it into two parts using BreakString
	GetCmdArgString(sArg, sizeof(sArg));
	iLengthArg1 = BreakString(sArg, sTargetArg, sizeof(sTargetArg));
	
	// Split the second part of the string out into sEntityName
	// Start the breaksrtring of sArg at the index of length arg 1 
	if((iLengthArg2 = BreakString(sArg[iLengthArg1], sEntityName, sizeof(sEntityName))) != -1) {
		iLengthArg1 += iLengthArg2;
	}
	
	//Create a vaiable to store whether the given entity name was found in the list of avialable entities
	//initialize with iValid(input valid) false
	bool iValid = false;
	
    //Step through g_entity array  
	for(int i = 0; i < max_entity; ++i) {
		// Check if the entity name is contained in the g_entity array
		if(StrContains(g_entity[i][0], sEntityName) != -1) {
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
		ReplyToCommand(client, "[SM] The entity name (%s) isn't valid", sEntityName);
		ReplyToCommand(client, "[SM] sm_give list | for entity list");
		return Plugin_Handled;
	}
	
	
	// Declare a char array to store the target name and an int array to store a list of target indices.
	char sTargetName[MAX_TARGET_LENGTH];
	int sTargetList[MAXPLAYERS], iTargetCount;
	// Declare a boolean to store whether the target name is a multiple-letter abbreviation.
	bool bTN_IsML;
	
	// Process the target string and store the result in the target list and target name variables.
	// the result is the count of matching targets to the supplied target argument input
	iTargetCount = ProcessTargetString(sTargetArg, client, sTargetList, MAXPLAYERS, COMMAND_FILTER_ALIVE, sTargetName, sizeof(sTargetName), bTN_IsML);
	
	//the function returns a target count value less than or equal to 0, it indicates an error.
	if(iTargetCount <= 0) {
		ReplyToTargetError(client, iTargetCount);
		return Plugin_Handled;
	}
	
	//This is the actual giving of weapons to the members of the target list
	for (int i = 0; i < iTargetCount; i++) {
		//get the entity value in the players target slot already
		iEntityRemove = GetPlayerWeaponSlot(sTargetList[i], iEntitySlot);

		//Perform check if the target has a weapon/item in the target slot already
		if(iEntityRemove != -1){
			//remove the item from the slot of the target player
			RemovePlayerItem(sTargetList[i], iEntityRemove);
			//remove only the entity from the player from the map
			//need to make a cvar to turn this on/off
			RemoveEntity(iEntityRemove);
		}
		
		//add option check chargeing for weapon cvar controlled 
		
		//Give the new item to the target player
		GivePlayerItem(sTargetList[i], sEntityToGive);
	}
	
	return Plugin_Handled;
}

//Function to handle the arg that requests viewing the entity list
void smGiveList(int client) {
	ReplyToCommand(client, "%s", h_bardouble);
	ReplyToCommand(client, "| %-21.21s | %-11.11s | %-11.11s | %-24.24s |", h_entity_name, h_weapon_slot, h_ammo_offset, h_ammo_reserve);
	ReplyToCommand(client, "%s", h_bardouble);
	
	for(int i = 0; i < max_entity; ++i) {
		ReplyToCommand(client, "| %-21.21s | %-11.11s | %-11.11s | %-24.24s |", g_entity[i][0], g_entity[i][1], g_entity[i][2], g_entity[i][3]);
	}
	
	ReplyToCommand(client, "%s", h_barsingle);
	ReplyToCommand(client, "*No need to put weapon_/item_ in the <entityname>*");
	ReplyToCommand(client, "*Partials substrings work if not overlapping other entity name*");
	ReplyToCommand(client, "*If in game entity name is not on list plugin needs update*");
	ReplyToCommand(client, "%s", h_barsingle);
}

void smGiveAbout(int client) {
	ReplyToCommand(client, "");
	ReplyToCommand(client, "Plugin Name.......: %s", NAME);
	ReplyToCommand(client, "Plugin Author.....: %s", AUTHOR);
	ReplyToCommand(client, "Plugin Description: %s", DESCRIPTION);
	ReplyToCommand(client, "Plugin Version....: %s", PLUGIN_VERSION);
	ReplyToCommand(client, "Plugin URL........: %s", URL);
}

public Plugin myinfo = {
	name = NAME,
	author = AUTHOR,
	description = DESCRIPTION,
	version = PLUGIN_VERSION,
	url = URL
};
