class X2Character_Vindicator extends X2Character config(GameData_CharacterStats);

//static function array<X2DataTemplate> CreateTemplates()
//{
	//local array<X2DataTemplate> Templates;
	//Templates.AddItem(CreateTemplate_Vindicator());
	//return Templates;
//}
//
//static function X2CharacterTemplate CreateTemplate_Vindicator()
//{
	//local X2CharacterTemplate CharTemplate;
//
	//CharTemplate = class'X2Character_DefaultCharacters'.static.CreateSoldierTemplate('LWR_Vindicator');
//
	//CharTemplate.bIsResistanceHero = true;
	//CharTemplate.DefaultSoldierClass = 'LWR_Vindicator';
	//CharTemplate.DefaultLoadout = 'SquaddieLWR_Vindicator';
//
	//CharTemplate.strIntroMatineeSlotPrefix = "Templar";
//
	//CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator_Vindicator';
	//CharTemplate.CustomizationManagerClass = class'XComCharacterCustomization_FactionHero';
	//CharTemplate.UICustomizationInfoClass = class'UICustomize_TemplarInfo';
	//CharTemplate.GetPawnNameFn = GetTemplarPawnName;
//
	//CharTemplate.strMatineePackages.AddItem("CIN_XP_Heroes");
//
	//return CharTemplate;
//}
//
//function name GetTemplarPawnName(optional EGender Gender)
//{
	//if (Gender == eGender_Male)
		//return 'Vindicator_M';
	//else
		//return 'Vindicator_F';
//}
//

//static function X2CharacterTemplate CreateTemplate_Vindicator()
//{
	//local X2CharacterTemplate CharTemplate;
//
	//`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'LWR_Vindicator');
//
	//CharTemplate.strPawnArchetypes.AddItem("Vindicator_ANIM.ARC_Vindicator_F"); 
	//CharTemplate.UnitSize = 1;
//
	//CharTemplate.BehaviorClass = class'XGAIBehavior';
	//CharTemplate.bCanUse_eTraversal_Normal = true;
	//CharTemplate.bCanUse_eTraversal_ClimbOver = true;
	//CharTemplate.bCanUse_eTraversal_ClimbOnto = true;
	//CharTemplate.bCanUse_eTraversal_ClimbLadder = true;
	//CharTemplate.bCanUse_eTraversal_DropDown = true;
	//CharTemplate.bCanUse_eTraversal_Grapple = false;
	//CharTemplate.bCanUse_eTraversal_Landing = true;
	//CharTemplate.bCanUse_eTraversal_BreakWindow = true;
	//CharTemplate.bCanUse_eTraversal_KickDoor = true;
	//CharTemplate.bCanUse_eTraversal_JumpUp = false;
	//CharTemplate.bCanUse_eTraversal_WallClimb = false;
	//CharTemplate.bCanUse_eTraversal_BreakWall = false;
	//CharTemplate.bCanBeCriticallyWounded = true;
	//CharTemplate.bCanBeTerrorist = false;
	//CharTemplate.bAppearanceDefinesPawn = true;
	//CharTemplate.bIsAfraidOfFire = true;
	//CharTemplate.bIsAlien = false;
	//CharTemplate.bIsCivilian = false;
	//CharTemplate.bIsPsionic = false;
	//CharTemplate.bIsRobotic = false;
	//CharTemplate.bIsSoldier = true;
	//CharTemplate.bCanTakeCover = true;
	//CharTemplate.bCanBeCarried = true;	
	//CharTemplate.bCanBeRevived = true;
	//CharTemplate.bUsePoolSoldiers = true;
	//CharTemplate.bStaffingAllowed = true;
	//CharTemplate.bAppearInBase = true;
	//CharTemplate.strMatineePackages.AddItem("CIN_Soldier");
	//CharTemplate.strIntroMatineeSlotPrefix = "Char";
	//CharTemplate.strLoadingMatineeSlotPrefix = "Soldier";
	//CharTemplate.bUsesWillSystem = true;
//
	//CharTemplate.DefaultSoldierClass = 'LWR_Vindicator';
	//CharTemplate.DefaultLoadout = 'SquaddieLWR_Vindicator';
	//CharTemplate.RequiredLoadout = 'SquaddieLWR_Vindicator';
	//CharTemplate.Abilities.AddItem('Loot');
	//CharTemplate.Abilities.AddItem('Interact_PlantBomb');
	//CharTemplate.Abilities.AddItem('Interact_TakeVial');
	//CharTemplate.Abilities.AddItem('Interact_StasisTube');
	//CharTemplate.Abilities.AddItem('Interact_MarkSupplyCrate');
	//CharTemplate.Abilities.AddItem('Interact_ActivateAscensionGate');
	//CharTemplate.Abilities.AddItem('CarryUnit');
	//CharTemplate.Abilities.AddItem('PutDownUnit');
	//CharTemplate.Abilities.AddItem('Evac');
	//CharTemplate.Abilities.AddItem('PlaceEvacZone');
	//CharTemplate.Abilities.AddItem('LiftOffAvenger');
	//CharTemplate.Abilities.AddItem('Knockout');
	//CharTemplate.Abilities.AddItem('KnockoutSelf');
	//CharTemplate.Abilities.AddItem('Panicked');
	//CharTemplate.Abilities.AddItem('Berserk');
	//CharTemplate.Abilities.AddItem('Obsessed');
	//CharTemplate.Abilities.AddItem('Shattered');
	//CharTemplate.Abilities.AddItem('HunkerDown');
	//CharTemplate.Abilities.AddItem('DisableConsumeAllPoints');
	//CharTemplate.Abilities.AddItem('Revive');
//
	//// bondmate abilities
	////CharTemplate.Abilities.AddItem('BondmateResistantWill');
	//CharTemplate.Abilities.AddItem('BondmateSolaceCleanse');
	//CharTemplate.Abilities.AddItem('BondmateSolacePassive');
	//CharTemplate.Abilities.AddItem('BondmateTeamwork');
	//CharTemplate.Abilities.AddItem('BondmateTeamwork_Improved');
	//CharTemplate.Abilities.AddItem('BondmateSpotter_Aim');
	//CharTemplate.Abilities.AddItem('BondmateSpotter_Aim_Adjacency');
	////CharTemplate.Abilities.AddItem('BondmateSpotter_Crit');
	////CharTemplate.Abilities.AddItem('BondmateSpotter_Crit_Adjacency');
	////CharTemplate.Abilities.AddItem('BondmateReturnFire_Passive');
	////CharTemplate.Abilities.AddItem('BondmateReturnFire');
	////CharTemplate.Abilities.AddItem('BondmateReturnFire_Adjacency');
	////CharTemplate.Abilities.AddItem('BondmateReturnFire_Improved_Passive');
	////CharTemplate.Abilities.AddItem('BondmateReturnFire_Improved');
	////CharTemplate.Abilities.AddItem('BondmateReturnFire_Improved_Adjacency');
	//CharTemplate.Abilities.AddItem('BondmateDualStrike');
	//
	//CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_XCom;
	//CharTemplate.strAutoRunNonAIBT = "SoldierAutoRunTree";
////	CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator';
////	CharTemplate.GetPawnNameFn = GetTemplarPawnName;
	//CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator_Vindicator';
//
////	CharTemplate.CustomizationManagerClass = class'XComCharacterCustomization_FactionHero';
	//CharTemplate.UICustomizationInfoClass = class'UICustomize_TemplarInfo';
//
//
	//return CharTemplate;
//}
//
//
//
//