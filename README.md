# The test branch will often have incomplete non working code as I use it to save my work and then resume at different locations on different PCs.

Work in progress not a finished work

This will be my first time working with SourcePawn and I have never learned to code in any language. I know a little bit of Windows CMD batch and thats it.
Don't look at my code and expect the best I don't know proper ways so I just find a way.

# CS:S Give Weapons
- Give a weapon or item to a player from a command.
- After reviewing a lot of code I think pRED* version in SM Super Commands may have been the first https://forums.alliedmods.net/showthread.php?p=498802
- This plugin is edited originally from [Kiske's give weapon](https://forums.alliedmods.net/showthread.php?t=195476).  
- Forked updated by Kento https://github.com/rogeraabbccdd/CSGO-GiveWeapons
- Then I got my noob never learned to code hands on it...

# This fork adds
- all the CS:S weapons that were missing to make CS:S compatible
- entity checking if player has a weapon/item in the slot the plugin is trying to give to. 
- Drops and removes that weapon/item before giving new
- Code comments for days otherwise i have no clue whats going on
- Option to drop but not remove item from game
- Chat input option * turns out SM does this automatically ex if sm_give is registered then chat !give and /give are automatically registered
- ~~Planned - Non admin can give to themself(if enabled)~~ separate plugin
- ~~Planned - Cost for giving to yourself option. Can be marked up in cost from base price or free~~ separate plugin
- Plugin engine checking
- CSGO support removed

## Console Commands for admins
- `sm_give` Gives the usage and options in console.
- `sm_give <target> <entityname>` Give weapon or item to user.
- `sm_give list` Display in console a table of all the weapon names,weapon slot,ammo offset, ammo reserve
- `sm_give about` Display the myinfo section of the code
- ~~`sm_give_version` for showing the version specifically~~ added to the about command
## Chat commands for admin
- `!give <target> <entityname>` or silent `/give <target> <entityname>`
## Chat commands for non admin
- ~~Planned - `!<entityname>` Give the weapon/item to the requester if they have enough $$ or free~~ separate plugin
- ~~Planned - `!guns` list of guns and prices user can buy(will only have available for Ts the CT guns they can't get from normal buy menu and vice versa)~~ separate plugin

## Items
- *No need to put weapon_/item_ in the <entityname>*
- *Partials substrings work if not overlapping other entity name* Example:> `sm_give ball ass` will give all players with `ball` in there name the `item_assaultsuit` 
- *If in game entity name is not on list plugin needs update*

## To compile so you can add to your server
- use the compiler include with the sourcemod file
- use the SourceMod website https://www.sourcemod.net/compiler.php
- note the SourceMod version on your server vs. the compiler version
<details>
  <summary>Click to show</summary>
	gotcha... MAybe next time though
</details>

## Credits
- pRED* version in SM Super Commands https://forums.alliedmods.net/showthread.php?p=498802
- [Kiske](https://forums.alliedmods.net/showthread.php?t=195476), who made the original plugin.
- Kento https://github.com/rogeraabbccdd/CSGO-GiveWeapons
