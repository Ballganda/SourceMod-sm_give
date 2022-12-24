Work in progress not a finished work

This will be my first time working with SourcePawn and I have never learned to code in any language. I know a little bit of Windows CMD batch and thats it.
Don't look at my code and expect the best I don't know proper ways so I just find a way.

# CS:S / CSGO Give Weapons
- Give a weapon or item to a player from a command.  
- This plugin is edited originally from [Kiske's give weapon](https://forums.alliedmods.net/showthread.php?t=195476).  
- Forked updated by Kento https://github.com/rogeraabbccdd/CSGO-GiveWeapons
- Then I got my noob never learned to code hands on it...

# This fork adds
- all the CS:S weapons that were missing to make CS:S compatible
- entity checking if player has a weapon/item in the slot the plugin is trying to give to. 
- Drops and removes that weapon/item before giving new
- Code comments for days otherwise i have no clue whats going on
- Planned - Option to drop but not remove item from game
- Chat input option * turns out SM does this automatically ex if sm_give is registered then caht !give and /give are automatically registered
- Planned - Non admin can give to themself(if enabled)
- Planned - Cost for giving to yourself option. Can be marked up in cost from base price or free
- Planned - Plugin engine checking
- Planned - weapon/item available in current game(css/csgo) bool in item array. Helps on partial substr input for a few entities and stops successful finds in codes array of items to things that are not available in current game.

## Console Commands for admins
- `sm_give` Gives the usage and options in console.
- `sm_give <target> <entityname>` Give weapon or item to user.
- `sm_give list` Display in console a table of all the weapon names,weapon slot,ammo offset, ammo reserve
- `sm_give about` Display the myinfo section of the code
- Planned - `sm_give_version` for showing the version specifically
## Chat commands for admin
- `!give <target> <entityname>` or silent `/give <target> <entityname>`
## Chat commands for non admin
- Planned - `!<entityname>` Give the weapon/item to the requester if they have enough $$ or free
- Planned - `!guns` list of guns and prices user can buy(will only have available for Ts the CT guns they can't get from normal buy menu and vice versa)

## Items
- *No need to put weapon_/item_ in the <entityname>*
- *Partials substrings work if not overlapping other entity name* Example:> `sm_give ball ass` will give all players with `ball` in there name the `item_assaultsuit` 
- *If in game entity name is not on list plugin needs update*
For example:> `sm_give @all healthshot` gives all players `weapon_healthshot`, including bots.

## To compile so you can add to your server
- use the compiler include with the sourcemod file
- use the SourceMod website https://www.sourcemod.net/compiler.php
- note the SourceMod version on your server vs. the compiler version
<details>
  <summary>Click to show</summary>
	gotcha... MAybe next time though
</details>

## Credits
- [Kiske](https://forums.alliedmods.net/showthread.php?t=195476), who made the original plugin.
- Kento https://github.com/rogeraabbccdd/CSGO-GiveWeapons
