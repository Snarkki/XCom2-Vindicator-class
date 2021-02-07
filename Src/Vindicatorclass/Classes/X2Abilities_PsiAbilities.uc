class X2Abilities_PsiAbilities extends X2Ability config(LWRAbility);

var config int LWR_SOULFIRE_COOLDOWN;
var config int LWR_STASIS_COOLDOWN;
var config int LWR_INSANITY_COOLDOWN;
var config int LWR_DOMINATION_COOLDOWN;
var config int LWR_NULL_LANCE_COOLDOWN_PLAYER;
var config int LWR_VOID_RIFT_COOLDOWN;
var config int LWR_VOID_RIFT_RADIUS;
var config int LWR_VOID_RIFT_RANGE;
var config int LWR_VOID_RIFT_INSANITY_CHANCE;
var config float LWR_VOID_RIFT_INSANITY_FX_VISUALIZATION_DELAY;

var config int LWR_PHASEWALK_ACTIONPOINTS;
var config int LWR_PHASEWALK_COOLDOWN_TURNS;
var config int LWR_PHASEWALK_CHARGES;
var config int LWR_PHASEWALK_CAST_RANGE_TILES;
var config bool LWR_PHASEWALK_TARGET_TILE_MUST_BE_REVEALED;
var config bool LWR_PHASEWALK_IS_FREE_ACTION;
var config bool LWR_PHASEWALK_ENDS_TURN;
var config bool LWR_PHASEWALK_CAN_BE_USED_WHILE_DISORIENTED;
var config bool LWR_PHASEWALK_CAN_BE_USED_WHILE_BURNING;

var config int LWR_NULLWARD_ACTIONPOINTS;
var config bool LWR_NULLWARD_IS_FREE_ACTION;
var config bool LWR_NULLWARD_ENDS_TURN;
var config int LWR_NULLWARD_COOLDOWN_TURNS;
var config int LWR_NULLWARD_CHARGES;
var config bool LWR_NULLWARD_CAN_BE_USED_WHILE_DISORIENTED;
var config bool LWR_NULLWARD_CAN_BE_USED_WHILE_BURNING;
var config int LWR_NULLWARD_CAST_RADIUS_METERS;
var config int LWR_NULL_WARD_BASE_SHIELD;
var config int LWR_NULL_WARD_AMP_MG_SHIELD_BONUS;
var config int LWR_NULL_WARD_AMP_BM_SHIELD_BONUS;

var config int LWR_SOULFIRE_FOCUS_COST;
var config int LWR_STASIS_FOCUS_COST;
var config int LWR_INSANITY_FOCUS_COST;
var config int LWR_INSANITY_MIND_CONTROL_DURATION;
var config int LWR_FUSE_FOCUS_COST;
var config int LWR_DOMINATION_FOCUS_COST;
var config int LWR_NULL_LANCE_FOCUS_COST;
var config int LWR_VOIDRIFT_FOCUS_COST;
var config int LWR_NULLWARD_FOCUS_COST;
var config int LWR_PHASEWALK_FOCUS_COST;

var privatewrite name FuseEventName;
var privatewrite name FusePostEventName;
var privatewrite name VoidRiftInsanityEventName;
var privatewrite name EndVoidRiftDurationFXEventName;
var privatewrite name VoidRiftDurationFXEffectName;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(LWR_Soulfire());
	Templates.AddItem(Create_AnimSet_Passive('LWR_Soulfire_Anim', "Vindicator_ANIM.Anims.AS_Spells"));
	Templates.AddItem(LWR_Stasis());
	Templates.AddItem(Create_AnimSet_Passive('LWR_Stasis_Anim', "Vindicator_ANIM.Anims.AS_Spells"));
	Templates.AddItem(LWR_Insanity());
	Templates.AddItem(Create_AnimSet_Passive('LWR_Insanity_Anim', "Vindicator_ANIM.Anims.AS_Spells"));
	Templates.AddItem(LWR_Fuse());
	Templates.AddItem(Create_AnimSet_Passive('LWR_Fuse_Anim', "Vindicator_ANIM.Anims.AS_Spells"));
	Templates.AddItem(FusePostActivationConcealmentBreaker());
	Templates.AddItem(LWR_Domination());
	Templates.AddItem(Create_AnimSet_Passive('LWR_Domination_Anim', "Vindicator_ANIM.Anims.AS_Spells"));
	Templates.AddItem(LWR_NullLance());
	Templates.AddItem(Create_AnimSet_Passive('LWR_NullLance_Anim', "Vindicator_ANIM.Anims.AS_Spells"));
	Templates.AddItem(LWR_VoidRift());	
	Templates.AddItem(LWR_VoidRiftInsanity());
	Templates.AddItem(Create_AnimSet_Passive('LWR_VoidRift_Anim', "VIND_VOIDRIFT.Anims.AS_Vind_VoidRift"));
	Templates.AddItem(Create_AnimSet_Passive('LWR_VoidRiftInsanity_Anim', "VIND_VOIDRIFT.Anims.AS_Vind_VoidRift"));
	Templates.AddItem(LWR_VoidRiftEndDurationFX());
	Templates.AddItem(Create_LWR_PhaseWalk());
	Templates.AddItem(Create_AnimSet_Passive('LWR_PhaseWalk_Anim', "LW_PsiOverhaul.Anims.AS_Teleport"));
	Templates.AddItem(Create_LWR_NullWard());
	Templates.AddItem(Create_AnimSet_Passive('LWR_NullWard_Anim', "LW_PsiOverhaul.Anims.AS_NullWard"));
	return Templates;
}

static function X2AbilityTemplate LWR_Soulfire()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Condition_UnitProperty          TargetProperty;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityCooldown                 Cooldown;
	local X2AbilityCost_Focus				FocusCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LWR_Soulfire');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.LWR_SOULFIRE_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	TargetProperty = new class'X2Condition_UnitProperty';
	TargetProperty.ExcludeRobotic = true;
	TargetProperty.FailOnNonUnits = true;
	TargetProperty.TreatMindControlledSquadmateAsHostile = true;
	Template.AbilityTargetConditions.AddItem(TargetProperty);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	FocusCost = new class'X2AbilityCost_Focus';
	FocusCost.FocusAmount = default.LWR_SOULFIRE_FOCUS_COST;
	Template.AbilityCosts.AddItem(FocusCost);
	
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bIgnoreBaseDamage = true;
	WeaponDamageEffect.DamageTag = 'LWR_Soulfire';
	WeaponDamageEffect.bBypassShields = true;
	WeaponDamageEffect.bIgnoreArmor = true;
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.Hostility = eHostility_Offensive;

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_soulfire";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.bShowActivation = false;
	Template.CustomFireAnim = 'HL_Projectile';

	Template.ActivationSpeech = 'Mindblast';

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CinescriptCameraType = "Psionic_FireAtUnit";

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'Soulfire'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'Soulfire'

	Template.AdditionalAbilities.AddItem('LWR_Soulfire_Anim');

	return Template;
}

static function X2DataTemplate LWR_Stasis( Name TemplateName='LWR_Stasis' )
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_Stasis                   StasisEffect;
	local X2AbilityCooldown                 Cooldown;
	local X2Effect_RemoveEffects            RemoveEffects;
	local X2AbilityCost_Focus				FocusCost;
	local X2Condition_UnitProperty			UnitPropertyCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	Template.Hostility = eHostility_Offensive;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_stasis";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	Template.AbilityCosts.AddItem(ActionPointCost);
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.LWR_STASIS_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	FocusCost = new class'X2AbilityCost_Focus';
	FocusCost.FocusAmount = default.LWR_STASIS_FOCUS_COST;
	Template.AbilityCosts.AddItem(FocusCost);

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetConditions.AddItem(new class'X2Condition_StasisTarget');
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	RemoveEffects = new class'X2Effect_RemoveEffects';
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2Ability_Viper'.default.BindSustainedEffectName);
	Template.AddTargetEffect(RemoveEffects);

	UnitPropertyCondition = new class 'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeLargeUnits = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	StasisEffect = new class'X2Effect_Stasis';
	StasisEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
	StasisEffect.bUseSourcePlayerState = true;
	StasisEffect.bRemoveWhenTargetDies = true;          //  probably shouldn't be possible for them to die while in stasis, but just in case
	StasisEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage);
	Template.AddTargetEffect(StasisEffect);

	Template.AbilityTargetStyle = default.SingleTargetWithSelf;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
		
	Template.bShowActivation = true;
	Template.CustomFireAnim = 'HL_Stasis';
	Template.ActivationSpeech = 'NullShield';

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = Stasis_BuildVisualization;
	Template.CinescriptCameraType = "Psionic_FireAtUnit";

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'Stasis'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'Stasis'

	Template.AdditionalAbilities.AddItem('LWR_Stasis_Anim');

	return Template;
}

function Stasis_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameState_Effect RemovedEffect;
	local VisualizationActionMetadata ActionMetadata, EmptyTrack;

	TypicalAbility_BuildVisualization(VisualizeGameState);
	History = `XCOMHISTORY;

	foreach VisualizeGameState.IterateByClassType(class'XComGameState_Effect', RemovedEffect)
	{
		if (RemovedEffect.bRemoved)
		{
			ActionMetadata = EmptyTrack;
			ActionMetadata.VisualizeActor = History.GetVisualizer(RemovedEffect.ApplyEffectParameters.SourceStateObjectRef.ObjectID);
			ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(RemovedEffect.ApplyEffectParameters.SourceStateObjectRef.ObjectID, , VisualizeGameState.HistoryIndex -1);
			ActionMetadata.StateObject_NewState = History.GetGameStateForObjectID(RemovedEffect.ApplyEffectParameters.SourceStateObjectRef.ObjectID);

			RemovedEffect.GetX2Effect().AddX2ActionsForVisualization_RemovedSource(VisualizeGameState, ActionMetadata, 'AA_Success', RemovedEffect);
		}
	}
}

static function X2AbilityTemplate LWR_Insanity()
{
	local X2AbilityTemplate             Template;
	local X2AbilityCost_ActionPoints    ActionPointCost;
	local X2Condition_UnitProperty      UnitPropertyCondition;
	local X2Condition_UnitImmunities	UnitImmunityCondition;
	local X2Effect_PersistentStatChange DisorientedEffect;
	local X2Effect_MindControl          MindControlEffect;
	local X2Effect_RemoveEffects        MindControlRemoveEffects;
	local X2Effect_Panicked             PanicEffect;
	local X2AbilityCooldown             Cooldown;
	local X2AbilityToHitCalc_StatCheck_UnitVsUnit StatCheck;
	local X2AbilityCost_Focus			FocusCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LWR_Insanity');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.LWR_INSANITY_COOLDOWN;
	Template.AbilityCooldown = Cooldown;
	
	StatCheck = new class'X2AbilityToHitCalc_StatCheck_UnitVsUnit';
	StatCheck.BaseValue = 50;
	Template.AbilityToHitCalc = StatCheck;

	FocusCost = new class'X2AbilityCost_Focus';
	FocusCost.FocusAmount = default.LWR_INSANITY_FOCUS_COST;
	Template.AbilityCosts.AddItem(FocusCost);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = true;
	UnitPropertyCondition.ExcludeRobotic = true;
	UnitPropertyCondition.FailOnNonUnits = true;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);	
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('Mental');
	UnitImmunityCondition.bOnlyOnCharacterTemplate = true;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

	//  Disorient effect for 1 unblocked psi hit
	DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect();
	DisorientedEffect.iNumTurns = 2;
	DisorientedEffect.MinStatContestResult = 1;
	DisorientedEffect.MaxStatContestResult = 3;     
	DisorientedEffect.DamageTypes.AddItem('Psi');
	Template.AddTargetEffect(DisorientedEffect);

	//  Panic effect for 3-4 unblocked psi hits
	PanicEffect = class'X2StatusEffects'.static.CreatePanickedStatusEffect();
	PanicEffect.MinStatContestResult = 4;
	PanicEffect.MaxStatContestResult = 24;
	PanicEffect.DamageTypes.AddItem('Psi');
	Template.AddTargetEffect(PanicEffect);

	//  Mind control effect for 5+ unblocked psi hits
	MindControlEffect = class'X2StatusEffects'.static.CreateMindControlStatusEffect(1, false, false);
	MindControlEffect.iNumTurns = default.LWR_INSANITY_MIND_CONTROL_DURATION;
	MindControlEffect.MinStatContestResult = 25;
	MindControlEffect.MaxStatContestResult = 0;
	MindControlEffect.DamageTypes.AddItem('Psi');
	Template.AddTargetEffect(MindControlEffect);

	MindControlRemoveEffects = class'X2StatusEffects'.static.CreateMindControlRemoveEffects();
	MindControlRemoveEffects.MinStatContestResult = 25;
	MindControlRemoveEffects.MaxStatContestResult = 0;
	Template.AddTargetEffect(MindControlRemoveEffects);

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.CustomFireAnim = 'HL_Mind';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CinescriptCameraType = "Psionic_FireAtUnit";

	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_insanity";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;

	Template.ActivationSpeech = 'Insanity';

	// This action is considered 'hostile' and can be interrupted!
	Template.Hostility = eHostility_Offensive;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'Insanity'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'Insanity'
	
	Template.AdditionalAbilities.AddItem('LWR_Insanity_Anim');

	return Template;
}


static function X2AbilityTemplate LWR_Fuse()
{
	local X2AbilityTemplate             Template;
	local X2AbilityCost_ActionPoints    ActionPointCost;
	local X2AbilityCost_Focus				FocusCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LWR_Fuse');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_fuse";
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_MAJOR_PRIORITY;
	Template.Hostility = eHostility_Offensive;
	Template.bLimitTargetIcons = true;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 0;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityToHitCalc = default.DeadEye;

	FocusCost = new class'X2AbilityCost_Focus';
	FocusCost.FocusAmount = default.LWR_FUSE_FOCUS_COST;
	Template.AbilityCosts.AddItem(FocusCost);
	
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);	
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	Template.AbilityTargetConditions.AddItem(new class'X2Condition_FuseTarget');	
	Template.AddShooterEffectExclusions();

	Template.PostActivationEvents.AddItem(default.FuseEventName);
	Template.PostActivationEvents.AddItem(default.FusePostEventName);

	Template.bShowActivation = true;
	Template.CustomFireAnim = 'HL_Projectile';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.TargetingMethod = class'X2TargetingMethod_Fuse';
	Template.CinescriptCameraType = "Psionic_FireAtUnit";
	Template.DamagePreviewFn = FuseDamagePreview;

	//Retain concealment when activating Fuse - then break it after the explosions have occurred.
	Template.ConcealmentRule = eConceal_Always;
	Template.AdditionalAbilities.AddItem('FusePostActivationConcealmentBreaker');
//BEGIN AUTOGENERATED CODE: Template Overrides 'Fuse'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'Fuse'

	Template.AdditionalAbilities.AddItem('LWR_Fuse_Anim');

	return Template;
}

static function X2AbilityTemplate FusePostActivationConcealmentBreaker()
{
	local X2AbilityTemplate             Template;
	local X2AbilityTrigger_EventListener EventListener;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'FusePostActivationConcealmentBreaker');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_fuse";
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Offensive;

	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityToHitCalc = default.DeadEye;

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	EventListener.ListenerData.EventID = default.FusePostEventName;
	EventListener.ListenerData.Filter = eFilter_Unit;
	Template.AbilityTriggers.AddItem(EventListener);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//No visualization. Concealment break will trigger its own change container.
//BEGIN AUTOGENERATED CODE: Template Overrides 'FusePostActivationConcealmentBreaker'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'FusePostActivationConcealmentBreaker'

	return Template;
}

function bool FuseDamagePreview(XComGameState_Ability AbilityState, StateObjectReference TargetRef, out WeaponDamageValue MinDamagePreview, out WeaponDamageValue MaxDamagePreview, out int AllowsShield)
{
	local XComGameStateHistory History;
	local XComGameState_Ability FuseTargetAbility;
	local XComGameState_Unit TargetUnit;
	local StateObjectReference EmptyRef, FuseRef;

	History = `XCOMHISTORY;
	TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(TargetRef.ObjectID));
	if (TargetUnit != none)
	{
		if (class'X2Condition_FuseTarget'.static.GetAvailableFuse(TargetUnit, FuseRef))
		{
			FuseTargetAbility = XComGameState_Ability(History.GetGameStateForObjectID(FuseRef.ObjectID));
			if (FuseTargetAbility != None)
			{
				//  pass an empty ref because we assume the ability will use multi target effects.
				FuseTargetAbility.GetDamagePreview(EmptyRef, MinDamagePreview, MaxDamagePreview, AllowsShield);
				return true;
			}
		}
	}
	return false;
}

static function X2AbilityTemplate LWR_Domination()
{
	local X2AbilityTemplate             Template;
	local X2AbilityCost_ActionPoints    ActionPointCost;
	local X2Condition_UnitProperty      UnitPropertyCondition;
	local X2Effect_MindControl          MindControlEffect;
	local X2Effect_StunRecover			StunRecoverEffect;
	local X2Condition_UnitEffects       EffectCondition;
	local X2AbilityCooldown             Cooldown;
	local X2Condition_UnitImmunities	UnitImmunityCondition;
	local X2AbilityToHitCalc_StatCheck_UnitVsUnit StatCheck;
	local X2AbilityCost_Focus				FocusCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LWR_Domination');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_domination";
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_MAJOR_PRIORITY;
	Template.Hostility = eHostility_Offensive;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	FocusCost = new class'X2AbilityCost_Focus';
	FocusCost.FocusAmount = default.LWR_DOMINATION_FOCUS_COST;
	Template.AbilityCosts.AddItem(FocusCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.LWR_DOMINATION_COOLDOWN;
	Cooldown.bDoNotApplyOnHit = true;
	Template.AbilityCooldown = Cooldown;
	
	StatCheck = new class'X2AbilityToHitCalc_StatCheck_UnitVsUnit';
	StatCheck.BaseValue = 50;
	Template.AbilityToHitCalc = StatCheck;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = true;
	UnitPropertyCondition.ExcludeRobotic = true;
	UnitPropertyCondition.FailOnNonUnits = true;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);	
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	EffectCondition = new class'X2Condition_UnitEffects';
	EffectCondition.AddExcludeEffect(class'X2Effect_MindControl'.default.EffectName, 'AA_UnitIsMindControlled');
	Template.AbilityTargetConditions.AddItem(EffectCondition);

	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('Mental');
	UnitImmunityCondition.bOnlyOnCharacterTemplate = true;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

	//  mind control target
	MindControlEffect = class'X2StatusEffects'.static.CreateMindControlStatusEffect(1, false, true);
	Template.AddTargetEffect(MindControlEffect);

	StunRecoverEffect = class'X2StatusEffects'.static.CreateStunRecoverEffect();
	Template.AddTargetEffect(StunRecoverEffect);

	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateMindControlRemoveEffects());

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.ActivationSpeech = 'Domination';
	Template.SourceMissSpeech = 'SoldierFailsControl';

	Template.CustomFireAnim = 'HL_Mind';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.CinescriptCameraType = "Psionic_FireAtUnit";

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'Domination'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'Domination'
	
	Template.AdditionalAbilities.AddItem('LWR_Domination_Anim');

	return Template;
}

static function X2AbilityTemplate LWR_NullLance()
{
	local X2AbilityTemplate					Template;
	local X2AbilityTarget_Cursor			CursorTarget;
	local X2AbilityMultiTarget_Line         LineMultiTarget;
	local X2Condition_UnitProperty          TargetCondition;
	local X2AbilityCost_ActionPoints        ActionCost;
	local X2Effect_ApplyWeaponDamage        DamageEffect;
	local X2AbilityCooldown_PerPlayerType	Cooldown;
	local X2AbilityCost_Focus				FocusCost;
		
	`CREATE_X2ABILITY_TEMPLATE(Template, 'LWR_NullLance');

	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Offensive;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_nulllance";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	FocusCost = new class'X2AbilityCost_Focus';
	FocusCost.FocusAmount = default.LWR_NULL_LANCE_FOCUS_COST;
	Template.AbilityCosts.AddItem(FocusCost);

	ActionCost = new class'X2AbilityCost_ActionPoints';
	ActionCost.iNumPoints = 1;   // Updated 8/18/15 to 1 action point only per Jake request.  
	ActionCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionCost);

	Cooldown = new class'X2AbilityCooldown_PerPlayerType';
	Cooldown.iNumTurns = default.LWR_NULL_LANCE_COOLDOWN_PLAYER;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);	
	Template.AbilityToHitCalc = default.DeadEye;

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.FixedAbilityRange = 15;
	Template.AbilityTargetStyle = CursorTarget;

	LineMultiTarget = new class'X2AbilityMultiTarget_Line';
	Template.AbilityMultiTargetStyle = LineMultiTarget;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	TargetCondition = new class'X2Condition_UnitProperty';
	TargetCondition.ExcludeFriendlyToSource = false;
	TargetCondition.ExcludeDead = true;
	Template.AbilityMultiTargetConditions.AddItem(TargetCondition);

	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.DamageTag = 'LWR_NullLance';
	DamageEffect.bIgnoreArmor = true;
	Template.AddMultiTargetEffect(DamageEffect);

	Template.TargetingMethod = class'X2TargetingMethod_Line';
	Template.CinescriptCameraType = "Psionic_FireAtLocation";

	Template.ActivationSpeech = 'NullLance';

	Template.CustomFireAnim = 'HL_Nulllance';
	Template.bOverrideAim = true;
	Template.bUseSourceLocationZToAim = true;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'NullLance'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'NullLance'

	Template.AdditionalAbilities.AddItem('LWR_NullLance_Anim');

	return Template;
}

static function X2AbilityTemplate LWR_VoidRift()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
	local X2AbilityCooldown                 Cooldown;
	local X2Effect_ApplyWeaponDamage        DamageEffect;
	local X2Effect_TriggerEvent             InsanityEvent;
	local X2Effect_PerkAttachForFX          DurationFXEffect;
	local X2Effect_TriggerEvent             EndDurationFXEffect;
	local X2AbilityCost_Focus				FocusCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LWR_VoidRift');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.LWR_VOID_RIFT_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	FocusCost = new class'X2AbilityCost_Focus';
	FocusCost.FocusAmount = default.LWR_VOIDRIFT_FOCUS_COST;
	Template.AbilityCosts.AddItem(FocusCost);

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToSquadsightRange = true;
	CursorTarget.FixedAbilityRange = default.LWR_VOID_RIFT_RANGE;
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.LWR_VOID_RIFT_RADIUS;
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	DurationFXEffect = new class 'X2Effect_PerkAttachForFX';
	DurationFXEffect.BuildPersistentEffect(1, false, true, , eGameRule_PlayerTurnEnd);
	DurationFXEffect.EffectName = default.VoidRiftDurationFXEffectName;
	Template.AddShooterEffect(DurationFXEffect);
	EndDurationFXEffect = new class'X2Effect_TriggerEvent';
	EndDurationFXEffect.TriggerEventName = default.EndVoidRiftDurationFXEventName;
	Template.AddShooterEffect(EndDurationFXEffect);


	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.DamageTag = 'LWR_VoidRift';
	DamageEffect.bIgnoreArmor = true;
	Template.AddMultiTargetEffect(DamageEffect);

	InsanityEvent = new class'X2Effect_TriggerEvent';
	InsanityEvent.TriggerEventName = default.VoidRiftInsanityEventName;
	InsanityEvent.ApplyChance = default.LWR_VOID_RIFT_INSANITY_CHANCE;
	Template.AddMultiTargetEffect(InsanityEvent);



	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_voidrift";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.bShowActivation = true;
//	Template.CustomFireAnim = 'HL_BigSingularity';
	Template.CustomFireAnim = 'HL_Voidrift';

	Template.TargetingMethod = class'X2TargetingMethod_VoidRift';

	Template.ActivationSpeech = 'VoidRift';

	Template.AdditionalAbilities.AddItem('LWR_VoidRiftInsanity');
	Template.AdditionalAbilities.AddItem('LWR_VoidRiftEndDurationFX');
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = Voidrift_BuildVisualization;;
	Template.CinescriptCameraType = "Psionic_FireAtLocation";

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'VoidRift'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'VoidRift'

	Template.AdditionalAbilities.AddItem('LWR_VoidRift_Anim');

	return Template;
}

simulated function Voidrift_BuildVisualization(XComGameState VisualizeGameState)
{
//Loaned from biotic redux mod
	local XComGameStateHistory History;
	local XComGameStateContext_Ability Context;
	local StateObjectReference InteractingUnitRef;
	local VisualizationActionMetadata EmptyTrack, ActionMetadata, BuildTrack;
	local XComGameState_Unit Shooter;
	local XComGameState_Effect EffectState;
	local int i, j;
	//local int TrackIndex;
	local X2VisualizerInterface TargetVisualizerInterface;
	local Actor TargetVisualizer;
	local bool bSelfTarget;
	local X2Effect_Persistent Effect;
	local name EffectApplyResult;
	local X2Action ExitCoverAction;
	local X2Action_PlayEffect EffectAction;
	local X2Action_StartStopSound SoundAction;
	local vector TargetLocation;
	local TTile TargetTile;
	local XComWorldData World;

	History = `XCOMHISTORY;
	World = `XWORLD;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = Context.InputContext.SourceObject; 
	
	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);


	Shooter = XComGameState_Unit(ActionMetadata.StateObject_NewState);
	if(Shooter != none)
	{

	ExitCoverAction = class'X2Action_ExitCover'.static.AddToVisualizationTree(ActionMetadata, Context);

		//If we were interrupted, insert a marker node for the interrupting visualization code to use. In the move path version above, it is expected for interrupts to be 
		//done during the move.
		if (Context.InterruptionStatus != eInterruptionStatus_None)
		{
			//Insert markers for the subsequent interrupt to insert into
			class'X2Action'.static.AddInterruptMarkerPair(ActionMetadata, Context, ExitCoverAction);
		}
		class'X2Action_Fire'.static.AddToVisualizationTree(ActionMetadata, Context);
	}

	
	// Play the Collapse FX
	EffectAction = X2Action_PlayEffect(class'X2Action_PlayEffect'.static.AddToVisualizationTree(ActionMetaData, Context));
	EffectAction.EffectName = "FX_Psi_Dimensional_Rift.P_Psi_Dimensional_Build_Up";
	EffectAction.EffectLocation = Context.InputContext.TargetLocations[0];
	EffectAction.bWaitForCompletion = false;
	EffectAction.bWaitForCameraCompletion = false;
	
	for( i = 0; i < Context.InputContext.MultiTargets.Length; ++i )
	{
		InteractingUnitRef = Context.InputContext.MultiTargets[i];

		if(InteractingUnitRef == Shooter.GetReference() )
		{
			bSelfTarget = true;
		}
	}
	If(!bSelfTarget) class'X2Action_EnterCover'.static.AddToVisualizationTree(ActionMetadata, Context);
	//class'X2Action_AbilityPerkEnd'.static.AddToVisualizationTrack(ShooterTrack, Context);

	// Play the Collapsing audio
	SoundAction = X2Action_StartStopSound(class'X2Action_StartStopSound'.static.AddToVisualizationTree(ActionMetaData, Context));
	SoundAction.Sound = new class'SoundCue';
	SoundAction.Sound.AkEventOverride = AkEvent'SoundX2AvatarFX.Avatar_Ability_Dimensional_Rift_Collapse';
	SoundAction.bIsPositional = true;
	SoundAction.vWorldPosition = Context.InputContext.TargetLocations[0];

	// Play the Collapse FX
	EffectAction = X2Action_PlayEffect(class'X2Action_PlayEffect'.static.AddToVisualizationTree(ActionMetaData, Context));
	EffectAction.EffectName = "FX_Psi_Dimensional_Rift.P_Psi_Dimensional_Build_Up";
	EffectAction.EffectLocation = Context.InputContext.TargetLocations[0];
	EffectAction.bWaitForCompletion = false;
	EffectAction.bWaitForCameraCompletion = false;

	// Configure the visualization track for the multi targets
	//******************************************************************************************
	for( i = 0; i < Context.InputContext.MultiTargets.Length; ++i )
	{
		InteractingUnitRef = Context.InputContext.MultiTargets[i];

		if( InteractingUnitRef == Shooter.GetReference() )
		{
			BuildTrack = ActionMetaData;
		}
		else
		{
			BuildTrack = EmptyTrack;
			BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
			BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
			BuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);
		}

		if( InteractingUnitRef != Shooter.GetReference() )
		{
			class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(BuildTrack, Context);
		}

		for( j = 0; j < Context.ResultContext.MultiTargetEffectResults[i].Effects.Length; ++j )
		{
			Context.ResultContext.MultiTargetEffectResults[i].Effects[j].AddX2ActionsForVisualization(VisualizeGameState, BuildTrack, Context.ResultContext.MultiTargetEffectResults[i].ApplyResults[j]);
		}

		TargetVisualizerInterface = X2VisualizerInterface(BuildTrack.VisualizeActor);
		if( TargetVisualizerInterface != none )
		{
			//Allow the visualizer to do any custom processing based on the new game state. For example, units will create a death action when they reach 0 HP.
			TargetVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, BuildTrack);
		}

		//OutVisualizationTracks.AddItem(BuildTrack);
	}

	//OutVisualizationTracks.AddItem(ShooterTrack);

	foreach VisualizeGameState.IterateByClassType(class'XComGameState_Effect', EffectState)
    {
        if (EffectState.bRemoved)
        {
            TargetVisualizer = History.GetVisualizer(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID);
 
            BuildTrack = EmptyTrack;
            BuildTrack.VisualizeActor = TargetVisualizer;
            BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
            BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID);
 
            Effect = EffectState.GetX2Effect();
            EffectApplyResult = Context.FindTargetEffectApplyResult(Effect);
            Effect.AddX2ActionsForVisualization_Removed(VisualizeGameState, BuildTrack, EffectApplyResult, EffectState);
 
            //OutVisualizationTracks.AddItem(BuildTrack);
        }
    }   



}


static function X2AbilityTemplate LWR_VoidRiftInsanity()
{
	local X2AbilityTemplate             Template;
	local X2Condition_UnitProperty      UnitPropertyCondition;
	local X2Effect_PersistentStatChange DisorientedEffect;
	local X2Effect_MindControl          MindControlEffect;
	local X2Effect_RemoveEffects        MindControlRemoveEffects;
	local X2Effect_Panicked             PanicEffect;
	local X2Condition_UnitType			UnitTypeCondition;
	local X2AbilityTrigger_EventListener EventListener;
	local X2AbilityToHitCalc_StatCheck_UnitVsUnit StatCheck;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LWR_VoidRiftInsanity');
	
	StatCheck = new class'X2AbilityToHitCalc_StatCheck_UnitVsUnit';
	StatCheck.BaseValue = 50;
	Template.AbilityToHitCalc = StatCheck;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = true;
	UnitPropertyCondition.ExcludeRobotic = true;
	UnitPropertyCondition.FailOnNonUnits = true;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	UnitTypeCondition = new class'X2Condition_UnitType';
	UnitTypeCondition.ExcludeTypes.AddItem('ChosenAssassin');
	UnitTypeCondition.ExcludeTypes.AddItem('ChosenWarlock');
	UnitTypeCondition.ExcludeTypes.AddItem('ChosenSniper');
	Template.AbilityTargetConditions.AddItem(UnitTypeCondition);

	//  Disorient effect for 1 unblocked psi hit
	DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect();
	DisorientedEffect.iNumTurns = 2;
	DisorientedEffect.MinStatContestResult = 1;
	DisorientedEffect.MaxStatContestResult = 3;     
	DisorientedEffect.DamageTypes.AddItem('Psi');
	Template.AddTargetEffect(DisorientedEffect);

	
	//  Panic effect for 3-4 unblocked psi hits
	PanicEffect = class'X2StatusEffects'.static.CreatePanickedStatusEffect();
	PanicEffect.MinStatContestResult = 4;
	PanicEffect.MaxStatContestResult = 24;
	PanicEffect.DamageTypes.AddItem('Psi');
	Template.AddTargetEffect(PanicEffect);

	//  Mind control effect for 5+ unblocked psi hits
	MindControlEffect = class'X2StatusEffects'.static.CreateMindControlStatusEffect(1, false, false);
	MindControlEffect.iNumTurns = default.LWR_INSANITY_MIND_CONTROL_DURATION;
	MindControlEffect.MinStatContestResult = 25;
	MindControlEffect.MaxStatContestResult = 0;
	MindControlEffect.DamageTypes.AddItem('Psi');
	Template.AddTargetEffect(MindControlEffect);

	MindControlRemoveEffects = class'X2StatusEffects'.static.CreateMindControlRemoveEffects();
	MindControlRemoveEffects.MinStatContestResult = 25;
	MindControlRemoveEffects.MaxStatContestResult = 0;
	Template.AddTargetEffect(MindControlRemoveEffects);

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.EventID = default.VoidRiftInsanityEventName;
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.Filter = eFilter_Unit;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.VoidRiftInsanityListener;
	Template.AbilityTriggers.AddItem(EventListener);

	Template.CustomFireAnim = 'HL_Mind';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CinescriptCameraType = "Psionic_FireAtUnit";

	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_insanity";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Offensive;
//BEGIN AUTOGENERATED CODE: Template Overrides 'VoidRiftInsanity'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'VoidRiftInsanity'
	
//	Template.PostActivationEvents.AddItem(default.EndVoidRiftDurationFXEventName);

	Template.AdditionalAbilities.AddItem('LWR_VoidRiftInsanity_Anim');

	return Template;
}

static function X2AbilityTemplate LWR_VoidRiftEndDurationFX()
{
	local X2AbilityTemplate             Template;
	local X2Effect_RemoveEffects        VoidRiftRemoveEffects;
	local X2AbilityTrigger_EventListener EventListener;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LWR_VoidRiftEndDurationFX');
	
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.EventID = default.EndVoidRiftDurationFXEventName;
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.Filter = eFilter_Unit;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_VoidRiftEndDurrationFX;
	Template.AbilityTriggers.AddItem(EventListener);

	VoidRiftRemoveEffects = new class'X2Effect_RemoveEffects';
	VoidRiftRemoveEffects.EffectNamesToRemove.AddItem(default.VoidRiftDurationFXEffectName);
	Template.AddShooterEffect(VoidRiftRemoveEffects);

	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_insanity";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	
	return Template;
}

static function X2DataTemplate Create_LWR_NullWard()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;
	local X2AbilityCooldown					Cooldown;
	local X2Condition_UnitProperty			UnitPropertyCondition;
	local X2Effect_NullWard					ShieldedEffect;
	local X2AbilityMultiTarget_Radius		MultiTarget;
	local array<name>						SkipExclusions;
	local X2AbilityCost_Focus				FocusCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LWR_NullWard');

	//Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_adventshieldbearer_energyshield";
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_aethershift";
	
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_CannotAfford_Charges');
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.Hostility = eHostility_Defensive;
	Template.ConcealmentRule = eConceal_Never;
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.LWR_NULLWARD_ACTIONPOINTS;
	ActionPointCost.bConsumeAllPoints = default.LWR_NULLWARD_ENDS_TURN;
	ActionPointCost.bFreeCost = default.LWR_NULLWARD_IS_FREE_ACTION;
	Template.AbilityCosts.AddItem(ActionPointCost);

	FocusCost = new class'X2AbilityCost_Focus';
	FocusCost.FocusAmount = default.LWR_NULLWARD_FOCUS_COST;
	Template.AbilityCosts.AddItem(FocusCost);

	if (default.LWR_NULLWARD_CHARGES > 0)
	{
		Charges = new class 'X2AbilityCharges';
		Charges.InitialCharges = default.LWR_NULLWARD_CHARGES;
		Template.AbilityCharges = Charges;

		ChargeCost = new class'X2AbilityCost_Charges';
		ChargeCost.NumCharges = 1;
		Template.AbilityCosts.AddItem(ChargeCost);
	}

	if (default.LWR_NULLWARD_COOLDOWN_TURNS > 0)
	{
		Cooldown = new class'X2AbilityCooldown';
		Cooldown.iNumTurns = default.LWR_NULLWARD_COOLDOWN_TURNS;
		Template.AbilityCooldown = Cooldown;
	}

	//Can't use while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	if (default.LWR_NULLWARD_CAN_BE_USED_WHILE_BURNING) SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	if (default.LWR_NULLWARD_CAN_BE_USED_WHILE_DISORIENTED) SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Add dead eye to guarantee
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	// Multi target
	MultiTarget = new class'X2AbilityMultiTarget_Radius';
	MultiTarget.fTargetRadius = default.LWR_NULLWARD_CAST_RADIUS_METERS;
	MultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = MultiTarget;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// The Targets must be within the AOE, LOS, and friendly
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeHostileToSource = true;
	UnitPropertyCondition.ExcludeCivilian = true;
	UnitPropertyCondition.FailOnNonUnits = true;
	Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

	// Friendlies in the radius receives a shield receives a shield
	ShieldedEffect = new class'X2Effect_NullWard';
	ShieldedEffect.BaseShieldHPIncrease = default.LWR_NULL_WARD_BASE_SHIELD;
	ShieldedEffect.AmpMGShieldHPBonus= default.LWR_NULL_WARD_AMP_MG_SHIELD_BONUS;
	ShieldedEffect.AmpBMShieldHPBonus= default.LWR_NULL_WARD_AMP_BM_SHIELD_BONUS;
	ShieldedEffect.BuildPersistentEffect (3, false, true, false, eGameRule_PlayerTurnBegin);
	ShieldedEffect.SetDisplayInfo (ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName);

	Template.AddShooterEffect(ShieldedEffect);
	Template.AddMultiTargetEffect(ShieldedEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_AdventShieldBearer'.static.Shielded_BuildVisualization;
	Template.CinescriptCameraType = "AdvShieldBearer_EnergyShieldArmor";

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	Template.AdditionalAbilities.AddItem('LWR_NullWard_Anim');
	
	return Template;
}

	static function X2DataTemplate Create_LWR_PhaseWalk()
{
	local X2AbilityTemplate				Template;
	local X2AbilityCost_ActionPoints	ActionPointCost;
	local X2AbilityCooldown				Cooldown;
	local X2AbilityCharges				Charges;
	local X2AbilityCost_Charges			ChargeCost;
	local X2AbilityTarget_Cursor		CursorTarget;
	local X2AbilityMultiTarget_Radius	RadiusMultiTarget;
	local array<name>                   SkipExclusions;
	local X2AbilityCost_Focus				FocusCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LWR_PhaseWalk');

	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_CannotAfford_Charges');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_codex_teleport";
	Template.Hostility = eHostility_Neutral;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.LWR_PHASEWALK_ACTIONPOINTS;
	ActionPointCost.bConsumeAllPoints = default.LWR_PHASEWALK_ENDS_TURN;
	ActionPointCost.bFreeCost = default.LWR_PHASEWALK_IS_FREE_ACTION;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	FocusCost = new class'X2AbilityCost_Focus';
	FocusCost.FocusAmount = default.LWR_PHASEWALK_FOCUS_COST;
	Template.AbilityCosts.AddItem(FocusCost);

	if (default.LWR_PHASEWALK_COOLDOWN_TURNS > 0)
	{
		Cooldown = new class'X2AbilityCooldown';
		Cooldown.iNumTurns = default.LWR_PHASEWALK_COOLDOWN_TURNS;
		Template.AbilityCooldown = Cooldown;
	}
	if (default.LWR_PHASEWALK_CHARGES > 0)
	{
		Charges = new class 'X2AbilityCharges';
		Charges.InitialCharges = default.LWR_PHASEWALK_CHARGES;
		Template.AbilityCharges = Charges;

		ChargeCost = new class'X2AbilityCost_Charges';
		ChargeCost.NumCharges = 1;
		Template.AbilityCosts.AddItem(ChargeCost);
	}
	Template.TargetingMethod = class'X2TargetingMethod_Teleport';
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityToHitCalc = default.DeadEye;

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToSquadsightRange = default.LWR_PHASEWALK_TARGET_TILE_MUST_BE_REVEALED;
	if (default.LWR_PHASEWALK_CAST_RANGE_TILES > 0) CursorTarget.FixedAbilityRange = default.LWR_PHASEWALK_CAST_RANGE_TILES;	// TILES OMG
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = 0.25; // small amount so it just grabs one tile
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	if (default.LWR_PHASEWALK_CAN_BE_USED_WHILE_BURNING) SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	if (default.LWR_PHASEWALK_CAN_BE_USED_WHILE_DISORIENTED) SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	//// Damage Effect
	Template.AbilityMultiTargetConditions.AddItem(default.LivingTargetUnitOnlyProperty);

	Template.ModifyNewContextFn = class'X2Ability_Cyberus'.static.Teleport_ModifyActivatedAbilityContext;
	Template.BuildNewGameStateFn = class'X2Ability_Cyberus'.static.Teleport_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_Cyberus'.static.Teleport_BuildVisualization;
	Template.CinescriptCameraType = "Cyberus_Teleport";
	Template.bFrameEvenWhenUnitIsHidden = true;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	Template.AdditionalAbilities.AddItem('LWR_PhaseWalk_Anim');

	return Template;
}

static function X2AbilityTemplate Create_AnimSet_Passive(name TemplateName, string AnimSetPath)
{
	local X2AbilityTemplate                 Template;
	local X2Effect_AdditionalAnimSets		AnimSetEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.bDontDisplayInAbilitySummary = true;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	AnimSetEffect = new class'X2Effect_AdditionalAnimSets';
	AnimSetEffect.AddAnimSetWithPath(AnimSetPath);
	AnimSetEffect.BuildPersistentEffect(1, true, false, false);
	Template.AddTargetEffect(AnimSetEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

DefaultProperties
{
	FuseEventName="FuseTriggered"
	FusePostEventName="FusePostTriggered"
	VoidRiftInsanityEventName="VoidRiftInsanityTriggered"
	EndVoidRiftDurationFXEventName="EndVoidRiftDurationFXEvent"
	VoidRiftDurationFXEffectName="VoidRiftDurationFXEffect"
}
