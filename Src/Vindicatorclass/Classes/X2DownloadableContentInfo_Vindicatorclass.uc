//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_Vindicatorclass.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_Vindicatorclass extends X2DownloadableContentInfo config (game);

var config array<name> IncludeCharacterTemplates;

/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the 
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
static event OnLoadedSavedGame()
{}

/// <summary>
/// Called when the player starts a new campaign while this DLC / Mod is installed
/// </summary>
static event InstallNewCampaign(XComGameState StartState)
{}



static function UpdateAnimations(out array<AnimSet> CustomAnimSets, XComGameState_Unit UnitState, XComUnitPawn Pawn)
{
//	local X2WeaponTemplate PrimaryWeaponTemplate;
	local int TemplateCheck;

	if (UnitState == none || !UnitState.IsSoldier())
	{
		return;
	}
	TemplateCheck = default.IncludeCharacterTemplates.FIND(UnitState.GetSoldierClassTemplateName());
	if (TemplateCheck != INDEX_NONE)
	{
	CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("Templar_ANIM.Anims.AS_Templar")));
	CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("Templar_ANIM.Anims.AS_Templar_F")));
	CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("HQ_ANIM.Anims.AS_Armory_Unarmed")));
//	CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("Soldier_Unarmed_ANIM.Anims.AS_UB_Death")));
//	CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("Human_ANIM.Anims.AS_Util")));
//	CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("Soldier_Unarmed_ANIM.Anims.AS_UB_Medkit")));
//	CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("Soldier_Unarmed_ANIM.Anims.AS_UB_Carry")));
//	CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("Soldier_Unarmed_ANIM.Anims.AS_UB_Body")));


	CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("Templar_ANIM.Anims.AS_UB_Grenade")));
	CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("Templar_ANIM.Anims.AS_UB_Grenade_F")));
	CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("Soldier_Unarmed_ANIM.Anims.AS_UB_SOLDIER")));
    
	CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("Vindicator_ANIM.Anims.AS_VindicatorArmory")));
	CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("Vindicator_ANIM.Anims.AS_Vindicator_Poses")));
	CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("Vindicator_ANIM.Anims.AS_Vindicator_TLEArmory")));
			//CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("Vindicator_ANIM.Anims.AS_VindicatorArmory")));
			//CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("Vindicator_ANIM.Anims.AS_Vindicator_Poses")));
			//CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("Vindicator_ANIM.Anims.AS_Vindicator_TLEArmory")));
	}
}

exec function AddVindicatorRecruit()
{
	local XComGameState_Unit NewSoldierState;
	local XComOnlineProfileSettings ProfileSettings;
	local X2CharacterTemplate CharTemplate;
	local X2CharacterTemplateManager    CharTemplateMgr;
	local XComGameState NewGameState;
	local XComGameState_HeadquartersXCom XComHQ;
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Adding Allies Unknown State Objects");

	XComHQ = XComGameState_HeadquartersXCom(class'XComGameStateHistory'.static.GetGameStateHistory().GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));


		//assert(NewGameState != none);
		ProfileSettings = `XPROFILESETTINGS;

		CharTemplateMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
		//Tuple = TupleMgr.GetRandomTuple();

		CharTemplate = CharTemplateMgr.FindCharacterTemplate('LWR_Vindicator');
		if(CharTemplate == none)
		{
			return; //if we don't get any valid templates, that means the user has yet to install any species mods
		}

		NewSoldierState = `CHARACTERPOOLMGR.CreateCharacter(NewGameState, ProfileSettings.Data.m_eCharPoolUsage, CharTemplate.DataName);
		if(!NewSoldierState.HasBackground())
			NewSoldierState.GenerateBackground();
		NewSoldierState.GiveRandomPersonality();
		NewSoldierState.ApplyInventoryLoadout(NewGameState);
		NewSoldierState.SetHQLocation(eSoldierLoc_Barracks);
		XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
		XComHQ.AddToCrew(NewGameState, NewSoldierState);

	if(NewGameState.GetNumGameStateObjects() > 0)
	{
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	}
	else
	{
		`XCOMHistory.CleanupPendingGameState(NewGameState);
	}
}

