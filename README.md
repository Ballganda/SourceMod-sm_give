Work in progress not a finished work

# CS:S / CSGO Give Weapons
- Give a weapon or item to a player from a command.  
- This plugin is edited originally from [Kiske's give weapon](https://forums.alliedmods.net/showthread.php?t=195476).  
- Forked updated by Kento https://github.com/rogeraabbccdd/CSGO-GiveWeapons
- This I got my noob never learned to code hands on it

# This fork adds
- all the CS:S weapons that were missing to make CS:S compatible
- entity checking if player has a weapon/item in the slot the plugin is trying to give to. 
- Drops and removes that weapon/item before giving new
- Planned - Option to drop but not remove item from game
- Planned - Chat input option
- Planned - Non admin can give to themself(if enabled)
- Planned - Cost for giving to yourself option. Can be marked up in cost from base price or free

## Console Commands for admins
- `sm_give` Gives the usage and options in console.
- `sm_give <target> <entityname>` Give weapon or item to user.
- `sm_give list` Display in console a table of all the weapon names,weapon slot,ammo offset, ammo reserve
- `sm_give about` Display the myinfo section of the code
- Planned - `sm_give_version` for showing the version specifically
## Chat commands for admin
- Planned - `!give <target> <entityname>`
## Chat commands for non admin
- Planned - `!<entityname>` Give the weapon/item to the requester if they have enough $$ or free
- Planned - `!guns` list of guns and prices user can buy(will only have available for Ts the CT guns they can't get from normal buy menu and vice versa)

## Items
- *No need to put weapon_/item_ in the <entityname>*
- *Partials substrings work if not overlapping other entity name*
- *If in game entity name is not on list plugin needs update*
For example, `sm_give @all healthshot` gives all player `weapon_healthshot`, including bots.
<details>
  <summary>Click to show</summary>
	Gotcha	
</details>

## Credits
- [Kiske](https://forums.alliedmods.net/showthread.php?t=195476), who made the original plugin.
- Kento https://github.com/rogeraabbccdd/CSGO-GiveWeapons
