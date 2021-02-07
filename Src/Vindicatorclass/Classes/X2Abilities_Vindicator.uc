class X2Abilities_Vindicator extends X2Ability config (LWRAbility);

var config int STONEFORM_BASE_SHIELDHP_BONUS;
var config int STONEFORM_ADDITIONAL_HP_PER_FOCUS;
var config int STONEFORM_FOCUS_COST;
var config int STONEFORM_COOLDOWN;
var config int STONEFORM_MOBILITY_PENALTY;
var config int STONEFORM_DURATION;
var config int IRONSKIN_FOCUS_DOWNGRADE_CHANCE;
//var config float IronSkin_DAMAGE_REDUCTION;
var config int MINDSHIELD_WILL;
var config int THOUSAND_CUTS_FOCUS_COST;
var config int THOUSAND_CUTS_MOBILITY_PENALTY;
var config float THOUSAND_CUTS_MOBILITY_FLOAT;

var config int PREPARATION_FOCUS_GAIN;
var config int PREPARATION_COOLDOWN;

var config int LWR_JUDGMENT_APPLYCHANCEATTACKVAL;
var config int LWR_JUDGMENT_MINCHANCE;
var config int LWR_JUDGMENT_MAXCHANCE;

var config float BONUS_VIND_REND_DMG_PER_TILE;
var config int MAX_VIND_REND_FLECHE_DAMAGE;

var config int LWR_EXCHANGE_COOLDOWN;
var config int LWR_EXCHANGE_FOCUS_COST;

var config int LWR_ENRAGE_COOLDOWN;
var config float LWR_ENRAGE_DAMAGE_MULTIPLIER;
var config int LWR_ENRAGE_DURATION_TURNS; 
var config int LWR_ENRAGE_FOCUS_COST;
var config int LWR_ENRAGE_DEFENSE_MINUS;

var config float LWR_ArcWaveConeEndDiameterTiles;
var config float LWR_ArcWaveConeLengthTiles;

var config int FOCUS1MOBILITY;
var config int FOCUS1DODGE;
var config int FOCUS1RENDDAMAGE;
var config int FOCUS2MOBILITY;
var config int FOCUS2DODGE;
var config int FOCUS2RENDDAMAGE;
var config int FOCUS3MOBILITY;
var config int FOCUS3DODGE;
var config int FOCUS3RENDDAMAGE;
var config int FOCUS4MOBILITY;
var config int FOCUS4DODGE;
var config int FOCUS4RENDDAMAGE;

var config int VIGOR_CRIT_CHANCE_PER_FOCUS;
var config int VIGOR_CRIT_DAMAGE_PER_FOCUS;
var config int VIGOR_BASE_CRIT_DAMAGE;

var localized string EnrageEffectFriendlyName;
var localized string EnragedEffectDescription;
const ThousandcutsPriority=50;
const StoneformPriority=50;
var name RageTriggeredEffectName;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	Templates.AddItem(AddLWR_VindicatorFocus());
	Templates.AddItem(AddLWR_VindicatorFleche());
	Templates.AddItem(AddLWR_StoneForm());
	Templates.AddItem(AddLWR_IronSkinAbility());
	Templates.AddItem(AddLWR_ThousandCuts());
	Templates.AddItem(AddLWR_ThousandCut_Activated());
	Templates.AddItem(AddLWR_MindShield());
	Templates.AddItem(AddLWR_Preparation());
	Templates.AddItem(LWR_Rend());
	Templates.AddItem(LWR_ArcWave());
	Templates.AddItem(LWR_ArcWavePassive());
	Templates.AddItem(AddLWR_FocusOnHit());
	Templates.AddItem(LWR_Judgement());
	Templates.AddItem(LWR_JudgementTrigger());
	Templates.AddItem(AddLWREnrageAbility());
	Templates.AddItem(PurePassive('LWR_Enrage_Passive',"img:///UILibrary_PerkIcons.UIPerk_beserk",, 'eAbilitySource_Psionic'));
	Templates.AddItem(ADDLWR_Exchange());
	Templates.AddItem(AddLWR_Vigor());
	Templates.AddItem(PurePassive('LWR_CriticalFocus',"img:///UILibrary_PerkIcons.UIPerk_archon_beatdown",, 'eAbilitySource_Psionic'));
	Templates.AddItem(Add_TemplarAnimations());
	return Templates;
}

static function X2AbilityTemplate AddLWR_VindicatorFocus()
{
	local X2AbilityTemplate						Template;
	local X2Effect_Persistent           PersistentEffect;
	local X2Effect_TemplarFocus	FocusEffect;
	local array<StatChange>		StatChanges;
	local StatChange			NewStatChange;


	`CREATE_X2ABILITY_TEMPLATE(Template, 'LWR_VindicatorFocus');

	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_InnerFocus";
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bIsPassive = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);


	//  This is a dummy effect so that an icon shows up in the UI.
	PersistentEffect = new class'X2Effect_Persistent';
	PersistentEffect.BuildPersistentEffect(1, true, false);
	PersistentEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true,, Template.AbilitySourceName);
	Template.AddTargetEffect(PersistentEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	FocusEffect = new class'X2Effect_TemplarFocus';
	FocusEffect.BuildPersistentEffect(1, true, false);
	FocusEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, false, , Template.AbilitySourceName);
	FocusEffect.EffectSyncVisualizationFn = class'X2Ability_TemplarAbilitySet'.static.FocusEffectVisualization;
	FocusEffect.VisualizationFn = class'X2Ability_TemplarAbilitySet'.static.FocusEffectVisualization;


	//	focus 0
	StatChanges.Length = 0;
	FocusEffect.AddNextFocusLevel(StatChanges, 0, 0);
	//	focus 1
	StatChanges.Length = 0;
	NewStatChange.StatType = eStat_Mobility;
	NewStatChange.StatAmount = default.FOCUS1MOBILITY;
	StatChanges.AddItem(NewStatChange);
	NewStatChange.StatType = eStat_Dodge;
	NewStatChange.StatAmount = default.FOCUS1DODGE;
	StatChanges.AddItem(NewStatChange);
	FocusEffect.AddNextFocusLevel(StatChanges, 0, default.FOCUS1RENDDAMAGE);
	//	focus 2
	StatChanges.Length = 0;
	NewStatChange.StatType = eStat_Mobility;
	NewStatChange.StatAmount = default.FOCUS2MOBILITY;
	StatChanges.AddItem(NewStatChange);
	NewStatChange.StatType = eStat_Dodge;
	NewStatChange.StatAmount = default.FOCUS2DODGE;
	StatChanges.AddItem(NewStatChange);
	FocusEffect.AddNextFocusLevel(StatChanges, 0, default.FOCUS2RENDDAMAGE);
	//	focus 3
	StatChanges.Length = 0;
	NewStatChange.StatType = eStat_Mobility;
	NewStatChange.StatAmount = default.FOCUS3MOBILITY;
	StatChanges.AddItem(NewStatChange);
	NewStatChange.StatType = eStat_Dodge;
	NewStatChange.StatAmount = default.FOCUS3DODGE;
	StatChanges.AddItem(NewStatChange);
	FocusEffect.AddNextFocusLevel(StatChanges, 0, default.FOCUS3RENDDAMAGE);
	//	Supreme Focus support
	NewStatChange.StatType = eStat_Mobility;
	NewStatChange.StatAmount = default.FOCUS4MOBILITY;
	StatChanges.AddItem(NewStatChange);
	NewStatChange.StatType = eStat_Dodge;
	NewStatChange.StatAmount = default.FOCUS4DODGE;
	StatChanges.AddItem(NewStatChange);
	FocusEffect.AddNextFocusLevel(StatChanges, 0, default.FOCUS4RENDDAMAGE);



	Template.AddTargetEffect(FocusEffect);


	//  NOTE: No visualization on purpose!

	// This adds the focus abilities and momentum
	Template.AdditionalAbilities.AddItem('TemplarFocus');
	Template.AdditionalAbilities.AddItem('FocusOnHit');
	Template.AdditionalAbilities.AddItem('TemplarAnimations');

	return Template;
}


static function X2AbilityTemplate AddLWR_VindicatorFleche()
{
	local X2AbilityTemplate				Template;
	local X2Effect_VindicatorFlecheDamage	FlecheBonusDamageEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'VindicatorFleche');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityFleche";
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	Template.bHideOnClassUnlock = true;
	Template.bCrossClassEligible = false;
	Template.bDisplayInUITacticalText = false;
    Template.bDontDisplayInAbilitySummary = true;
	FlecheBonusDamageEffect = new class 'X2Effect_VindicatorFlecheDamage';
	FlecheBonusDamageEffect.BonusDmgPerTile = default.BONUS_VIND_REND_DMG_PER_TILE;
	FlecheBonusDamageEffect.MaxBonusDamage = default.MAX_VIND_REND_FLECHE_DAMAGE;
	FlecheBonusDamageEffect.AbilityNames.AddItem('LWR_Rend');
	FlecheBonusDamageEffect.AbilityNames.AddItem('LWR_ThousandCuts');
	FlecheBonusDamageEffect.SetDisplayInfo(0, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	FlecheBonusDamageEffect.BuildPersistentEffect (1, true, false);
	Template.AddTargetEffect (FlecheBonusDamageEffect);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate AddLWR_StoneForm()
{
	local X2AbilityTemplate						Template;
	local X2AbilityCost_ActionPoints			ActionPointCost;
	local X2Condition_UnitEffects				EffectsCondition;
	local X2Effect_Stoneform					FormEffect;
//	local X2Effect_IncrementUnitValue			SFUnitValue;
	local X2AbilityCooldown						Cooldown;
	local array<name>							SkipExclusions;
	local X2AbilityCost_Focus				FocusCost;
	local X2Effect_PersistentStatChange			MobilityEffect;
	local X2Effect_DowngradeHit			HitEffect;
	local	X2Condition_AbilityProperty			AbilityCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LWR_StoneForm');


	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_shieldwall";
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	Template.OverrideAbilityAvailabilityFn = Stoneform_OverrideAbilityAvailability;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
 	Template.AddShooterEffectExclusions(SkipExclusions);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.AllowedTypes.AddItem('Momentum');
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	FocusCost = new class'X2AbilityCost_Focus';
	FocusCost.FocusAmount = default.STONEFORM_FOCUS_COST;
	Template.AbilityCosts.AddItem(FocusCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.STONEFORM_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	// Disable stacking
	EffectsCondition = new class'X2Condition_UnitEffects';
	EffectsCondition.AddExcludeEffect('LWR_StoneForm', 'AA_UnitIsImmune');
	Template.AbilityTargetConditions.AddItem(EffectsCondition);

	FormEffect = new class'X2Effect_StoneForm';
	FormEffect.BaseShieldHPIncrease = default.STONEFORM_BASE_SHIELDHP_BONUS;
	FormEffect.AdditionalHPPerFocus = default.STONEFORM_ADDITIONAL_HP_PER_FOCUS;
//	FormEffect.IronSkinDR = default.IronSkin_DAMAGE_REDUCTION;
	FormEffect.BuildPersistentEffect(default.STONEFORM_DURATION, false, true, false, eGameRule_PlayerTurnBegin);
	FormEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	Template.AddTargetEffect(FormEffect);

	MobilityEffect = new class'X2Effect_PersistentStatChange';
	MobilityEFfect.EffectName = 'Stoneform penalty';
	MobilityEffect.DuplicateResponse = eDupe_Refresh;
	MobilityEffect.AddPersistentStatChange(eStat_Mobility, default.STONEFORM_MOBILITY_PENALTY);
	MobilityEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	MobilityEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	Template.AddShooterEffect(MobilityEffect);

	HitEffect = new class'X2Effect_DowngradeHit';
	HitEffect.FocusDowngradeChance = default.IRONSKIN_FOCUS_DOWNGRADE_CHANCE;
	HitEffect.BuildPersistentEffect(default.STONEFORM_DURATION, false, true, false, eGameRule_PlayerTurnBegin);
	HitEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true,, Template.AbilitySourceName);
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('LWR_IronSkin');
	HitEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddShooterEffect(HitEffect);



    Template.AssociatedPassives.AddItem('LWR_IronSkin');
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.bShowActivation = true;
	Template.CustomFireAnim = 'HL_Stoneform';
	Template.ActivationSpeech = 'NullShield';


	return Template;
}

function Stoneform_OverrideAbilityAvailability(out AvailableAction Action, XComGameState_Ability AbilityState, XComGameState_Unit OwnerState)
{
	if (Action.AvailableCode == 'AA_Success')
	{
		if (OwnerState.ActionPoints.Length >= 1 && OwnerState.ActionPoints[0] == 'Momentum')
			Action.ShotHUDPriority = const.StoneformPriority;
	}
}
static function X2AbilityTemplate AddLWR_IronSkinAbility()
{
	local X2AbilityTemplate                 Template;
	
	Template = PurePassive('LWR_IronSkin', "img:///Vindicator_UI.UI_IronSkin", , 'eAbilitySource_Psionic');
	Template.PrerequisiteAbilities.AddItem('LWR_StoneForm');

	return Template;
}

static function X2AbilityTemplate AddLWR_FocusOnHit()
{
	local X2AbilityTemplate					Template;
	local X2Effect_FocusGain				FocusGainEffect;



	`CREATE_X2ABILITY_TEMPLATE (Template, 'FocusOnHit');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_momentum";
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	
	FocusGainEffect = new class'X2Effect_FocusGain';
//	FocusGainEffect.eventid = 'FocusOnHit';
//	FocusGainEffect.bShowActivation = false;
	FocusGainEffect.BuildPersistentEffect(1,true,false);
	FocusGainEffect.SetDisplayInfo (ePerkBuff_Passive,Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName); 
	Template.AddTargetEffect(FocusGainEffect);

	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.bShowActivation = true;
	Template.bShowPostActivation = false;

	return Template;

}


static function X2AbilityTemplate LWR_Rend(name TemplateName = 'LWR_Rend')
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local array<name>							SkipExclusions;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);


	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.CinescriptCameraType = "Ranger_Reaper";
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_Rend";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.REND_PRIORITY;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.bCrossClassEligible = false;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	Template.AbilityToHitCalc = StandardMelee;

	Template.AbilityTargetStyle = new class'X2AbilityTarget_MovingMelee';
	Template.TargetingMethod = class'X2TargetingMethod_MeleePath';

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_EndOfMove');

	// Target Conditions
	//
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);

	// Shooter Conditions
	//
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Damage Effect
	//
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.DamageTypes.AddItem('Melee');
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.bAllowBonusWeaponEffects = true;
	Template.bSkipMoveStop = true;
	
	// Voice events
	//
	Template.SourceMissSpeech = 'SwordMiss';

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

	Template.PostActivationEvents.AddItem('RendActivated');
	Template.AdditionalAbilities.AddItem('VindicatorFleche');

	return Template;
}

static function X2AbilityTemplate LWR_ArcWave()
{
	local X2AbilityTemplate					Template;
	local X2AbilityMultiTarget_Cone			ConeMultiTarget;
	// Added as different rend used
	Template = LWR_Rend('LWR_ArcWave');
	Template.OverrideAbilities.AddItem('LWR_Rend');
	Template.TargetingMethod = class'X2TargetingMethod_ArcWave';
	Template.ActionFireClass = class'X2Action_Fire_Wave';

	//	These are all handled in the editor if you want to change them!
//BEGIN AUTOGENERATED CODE: Template Overrides 'ArcWave'
	Template.bSkipMoveStop = false;
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.CustomFireAnim = 'FF_ArcWave_MeleeA';
	Template.CustomFireKillAnim = 'FF_ArcWave_MeleeKillA';
	Template.CustomMovingFireAnim = 'MV_ArcWave_MeleeA';
	Template.CustomMovingFireKillAnim = 'MV_ArcWave_MeleeKillA';
	Template.CustomMovingTurnLeftFireAnim = 'MV_ArcWave_RunTurn90LeftMeleeA';
	Template.CustomMovingTurnLeftFireKillAnim = 'MV_ArcWave_RunTurn90LeftMeleeKillA';
	Template.CustomMovingTurnRightFireAnim = 'MV_ArcWave_RunTurn90RightMeleeA';
	Template.CustomMovingTurnRightFireKillAnim = 'MV_ArcWave_RunTurn90RightMeleeKillA';
	Template.ActivationSpeech = 'Rend';
	Template.CinescriptCameraType = "Ranger_Reaper";
	Template.bSkipExitCoverWhenFiring = false;
//END AUTOGENERATED CODE: Template Overrides 'ArcWave'
	//Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	//Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_Arcwave";

	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
	ConeMultiTarget.ConeEndDiameter = default.LWR_ArcWaveConeEndDiameterTiles * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.ConeLength = default.LWR_ArcWaveConeLengthTiles * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.fTargetRadius = Sqrt(Square(ConeMultiTarget.ConeEndDiameter / 2) + Square(ConeMultiTarget.ConeLength)) * class'XComWorldData'.const.WORLD_UNITS_TO_METERS_MULTIPLIER;
	ConeMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	ConeMultiTarget.bLockShooterZ = true;
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

	Template.AbilityMultiTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);

	Template.AddMultiTargetEffect(new class'X2Effect_ArcWaveMultiDamage');
	
	return Template;
}

static function X2AbilityTemplate LWR_ArcWavePassive()
{
	local X2AbilityTemplate						Template;

	Template = PurePassive('LWR_ArcWavePassive', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_Arcwave", , 'eAbilitySource_Psionic');

	Template.AdditionalAbilities.AddItem('LWR_ArcWave');
	Template.PrerequisiteAbilities.AddItem('LWR_Rend');

	return Template;
}

static function X2AbilityTemplate AddLWR_ThousandCuts()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local array<name>                       SkipExclusions;
	local X2AbilityCost_Focus				FocusCost;
	local X2Effect_PersistentStatChange			MobilityEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LWR_ThousandCuts');

	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilitySourceName = 'eAbilitySource_Standard';

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
	Template.Hostility = eHostility_Offensive;
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_Partingsilk";
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.CinescriptCameraType = "Ranger_Reaper";
	Template.bHideOnClassUnlock = false;
	Template.OverrideAbilityAvailabilityFn = ThousandCuts_OverrideAbilityAvailability;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.AllowedTypes.Length = 0;
	ActionPointCost.AllowedTypes.AddItem('Momentum');
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	FocusCost = new class'X2AbilityCost_Focus';
	FocusCost.FocusAmount = default.THOUSAND_CUTS_FOCUS_COST;
	Template.AbilityCosts.AddItem(FocusCost);

	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	StandardMelee.bGuaranteedHit = false;
	Template.AbilityToHitCalc = StandardMelee;

	Template.AbilityTargetStyle = new class'X2AbilityTarget_MovingMelee';
	Template.TargetingMethod = class'X2TargetingMethod_MeleePath';

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_EndOfMove');

	// Target Conditions
	//
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);

	// Shooter Conditions
	//
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Damage Effect
	//local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.DamageTypes.AddItem('Melee');
	Template.AddTargetEffect(WeaponDamageEffect);

	MobilityEffect = new class'X2Effect_PersistentStatChange';
	MobilityEFfect.EffectName = 'TC Mobility penalty';
	MobilityEffect.DuplicateResponse = eDupe_Allow;
	MobilityEffect.AddPersistentStatChange(eStat_Mobility, default.THOUSAND_CUTS_MOBILITY_FLOAT, MODOP_Multiplication);
	MobilityEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	MobilityEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	Template.AddShooterEffect(MobilityEffect);

	// Gives momentum
	Template.AdditionalAbilities.AddItem('LWR_ThousandCut_Activated');
	Template.AdditionalAbilities.AddItem('VindicatorFleche');
	Template.PostActivationEvents.AddItem('RendActivated');

	Template.bAllowBonusWeaponEffects = true;
	Template.bSkipMoveStop = true;

	// Voice events
	//
	Template.SourceMissSpeech = 'SwordMiss';

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'Rend'
	Template.bSkipExitCoverWhenFiring = false;
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.ActivationSpeech = 'Rend';
	Template.CinescriptCameraType = "Ranger_Reaper";
//END AUTOGENERATED CODE: Template Overrides 'Rend'
		
	Template.PrerequisiteAbilities.AddItem('Momentum');

	return Template;
}

static function X2AbilityTemplate AddLWR_ThousandCut_Activated()
{
	local X2AbilityTemplate						Template;
	local X2Effect_ThousandCutDamage			DamageEffect;


	`CREATE_X2ABILITY_TEMPLATE(Template, 'LWR_ThousandCut_Activated');

	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_chryssalid_slash";
    Template.AbilitySourceName = 'eAbilitySource_Psionic';
    Template.Hostility = eHostility_Neutral;
    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
    Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DamageEffect = new class 'X2Effect_ThousandCutDamage';
    DamageEffect.BuildPersistentEffect(1, true, false, false);
    DamageEffect.SetDisplayInfo(0, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,, Template.AbilitySourceName);
	Template.AddTargetEffect(DamageEffect);



	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

function ThousandCuts_OverrideAbilityAvailability(out AvailableAction Action, XComGameState_Ability AbilityState, XComGameState_Unit OwnerState)
{
	if (Action.AvailableCode == 'AA_Success')
	{
		if (OwnerState.ActionPoints.Length >= 1 && OwnerState.ActionPoints[0] == 'Momentum')
			Action.ShotHUDPriority = const.ThousandCutsPriority;
	}
}
static function X2AbilityTemplate AddLWR_Preparation()
{
	local X2AbilityTemplate						Template;
	local X2Effect_ModifyTemplarFocus			FocusEffect;
	local X2AbilityCost_ActionPoints			ActionPointCost;
	local X2AbilityCooldown						Cooldown;
	local array<name>							SkipExclusions;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LWR_Preparation');

	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_psychosis";

	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
 	Template.AddShooterEffectExclusions(SkipExclusions);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.AllowedTypes.AddItem('Momentum');
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.PREPARATION_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	FocusEffect = new class'X2Effect_ModifyTemplarFocus';
	FocusEffect.ModifyFocus = default.PREPARATION_FOCUS_GAIN;
	Template.AddShooterEffect(FocusEffect);

//	Template.AddTargetEffect(new class'X2Effect_Preparation');

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.bShowActivation = false;
	Template.CustomFireAnim = 'HL_SignalHalt';
	Template.ActivationSpeech = 'NullShield';

	return Template;
}



static function X2AbilityTemplate AddLWR_MindShield()
{
	local X2AbilityTemplate						Template;
	local X2Effect_PersistentStatChange         PersistentStatChangeEffect;
	local X2Effect_DamageImmunity               ImmunityEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LWR_MindShield');

	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_mindshield";
	Template.bIsPassive = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.EffectName = 'LWR_MindShieldStats';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Will, default.MINDSHIELD_WILL);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	ImmunityEffect = new class'X2Effect_DamageImmunity';
	ImmunityEffect.EffectName = 'MindShieldImmunity';
	ImmunityEffect.ImmuneTypes.AddItem('Mental');
	ImmunityEffect.ImmuneTypes.AddItem(class'X2Item_DefaultDamageTypes'.default.DisorientDamageType);
	ImmunityEffect.ImmuneTypes.AddItem('stun');
	ImmunityEffect.ImmuneTypes.AddItem('Unconscious');
	ImmunityEffect.BuildPersistentEffect(1, true, false, false);
	ImmunityEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false, , Template.AbilitySourceName);
	Template.AddTargetEffect(ImmunityEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}
static function X2AbilityTemplate LWR_Judgement()
{
	local X2AbilityTemplate						Template;
	local X2Effect_CoveringFire                 CoveringEffect;

	Template = PurePassive('LWR_Judgement', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_Judgment", false, 'eAbilitySource_Psionic', true);
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);

	CoveringEffect = new class'X2Effect_CoveringFire';
	CoveringEffect.BuildPersistentEffect(1, true, false, false);
	CoveringEffect.AbilityToActivate = 'LWR_JudgmentTrigger';
	CoveringEffect.GrantActionPoint = 'Judgment';
	CoveringEffect.bPreEmptiveFire = false;
	CoveringEffect.bDirectAttackOnly = true;
	CoveringEffect.bOnlyDuringEnemyTurn = true;
	CoveringEffect.bUseMultiTargets = false;
	CoveringEffect.EffectName = 'JudgmentWatchEffect';
	Template.AddTargetEffect(CoveringEffect);

	Template.AdditionalAbilities.AddItem('LWR_JudgmentTrigger');

	return Template;
}

static function X2AbilityTemplate LWR_JudgementTrigger()
{
	local X2AbilityTemplate						Template;
	local X2Effect_Panicked						PanicEffect;
	local X2AbilityCost_ReserveActionPoints     ActionPointCost;
	local X2Condition_UnitProperty				TargetCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LWR_JudgementTrigger');
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);

	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_Judgment";
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Offensive;

	ActionPointCost = new class'X2AbilityCost_ReserveActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.AllowedTypes.Length = 0;
	ActionPointCost.AllowedTypes.AddItem('Judgment');
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityToHitCalc = default.DeadEye;                //  the real roll is in the effect apply chance
	Template.AbilityTargetStyle = default.SelfTarget;

	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');

	TargetCondition = new class'X2Condition_UnitProperty';
	TargetCondition.ExcludeAlive = false;
	TargetCondition.ExcludeDead = true;
	TargetCondition.ExcludeFriendlyToSource = true;
	TargetCondition.ExcludeHostileToSource = false;
	TargetCondition.TreatMindControlledSquadmateAsHostile = false;
	TargetCondition.FailOnNonUnits = true;
	TargetCondition.ExcludeRobotic = true;
	Template.AbilityTargetConditions.AddItem(TargetCondition);

	PanicEffect = class'X2StatusEffects'.static.CreatePanickedStatusEffect();
	PanicEffect.ApplyChanceFn = LWR_JudgementApplyChance;
	PanicEffect.VisualizationFn = Judgment_Visualization;
	Template.AddTargetEffect(PanicEffect);

	Template.CustomFireAnim = 'HL_LWR_Judgement';
	Template.bShowActivation = true;
	Template.CinescriptCameraType = "Skirmisher_Judgment";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	//BEGIN AUTOGENERATED CODE: Template Overrides 'JudgmentTrigger'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.ActivationSpeech = 'Judgement';
	Template.CinescriptCameraType = "Skirmisher_Judgment";
	//END AUTOGENERATED CODE: Template Overrides 'JudgmentTrigger'

	return Template;
}

static function name LWR_JudgementApplyChance(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState)
{
	//  this mimics the panic hit roll without actually BEING the panic hit roll
	local XComGameState_Unit TargetUnit, SourceUnit;
	local name ImmuneName;
	local int AttackVal, DefendVal, TargetRoll, RandRoll;

	TargetUnit = XComGameState_Unit(kNewTargetState);
	if( TargetUnit != none )
	{
		foreach class'X2AbilityToHitCalc_PanicCheck'.default.PanicImmunityAbilities(ImmuneName)
		{
			if( TargetUnit.FindAbility(ImmuneName).ObjectID != 0 )
			{
				return 'AA_UnitIsImmune';
			}
		}

		// LWR: Base on Psi offense VS will
		SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
		AttackVal = SourceUnit.GetCurrentStat(eStat_PsiOffense) + default.LWR_JUDGMENT_APPLYCHANCEATTACKVAL / 2;

		DefendVal = TargetUnit.GetCurrentStat(eStat_Will);
		TargetRoll = class'X2AbilityToHitCalc_PanicCheck'.default.BaseValue + AttackVal - DefendVal;
		TargetRoll = Clamp(TargetRoll, default.LWR_JUDGMENT_MINCHANCE, default.LWR_JUDGMENT_MAXCHANCE);
		RandRoll = `SYNC_RAND_STATIC(100);
		if( RandRoll < TargetRoll )
			return 'AA_Success';
	}

	return 'AA_EffectChanceFailed';
}

static function Judgment_Visualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local XComGameState_Unit UnitState;
	local XComGameStateContext_Ability Context;
	local X2AbilityTemplate	AbilityTemplate;

	if( EffectApplyResult != 'AA_Success' )
	{
		// pan to the not panicking unit (but only if it isn't a civilian)
		Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
		UnitState = XComGameState_Unit(ActionMetadata.StateObject_NewState);
		if( (UnitState == none) || (Context == none) )
		{
			return;
		}

		AbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate(Context.InputContext.AbilityTemplateName);

		class'X2StatusEffects'.static.AddEffectCameraPanToAffectedUnitToTrack(ActionMetadata, VisualizeGameState.GetContext());
		class'X2StatusEffects'.static.AddEffectSoundAndFlyOverToTrack(ActionMetadata, VisualizeGameState.GetContext(), AbilityTemplate.LocMissMessage, '', eColor_Good, class'UIUtilities_Image'.const.UnitStatus_Panicked);
	}
}

static function X2AbilityTemplate ADDLWR_Exchange()
{
	local X2AbilityTemplate			Template;
	local X2AbilityCooldown			Cooldown;
	local X2AbilityCost_ActionPoints	ActionPointCost;
	local X2Condition_UnitProperty	UnitCondition;
	local X2AbilityCost_Focus				FocusCost;


	`CREATE_X2ABILITY_TEMPLATE(Template, 'LWR_Exchange');

//BEGIN AUTOGENERATED CODE: Template Overrides 'TemplarInvert'
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.CustomFireAnim = 'HL_ExchangeStart';
	Template.ActivationSpeech = 'Invert';
	Template.CinescriptCameraType = "Templar_Invert";
//END AUTOGENERATED CODE: Template Overrides 'TemplarInvert'
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Offensive;
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_Invert";
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.LWR_EXCHANGE_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	FocusCost = new class'X2AbilityCost_Focus';
	FocusCost.FocusAmount = default.LWR_EXCHANGE_FOCUS_COST;
	Template.AbilityCosts.AddItem(FocusCost);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	UnitCondition = new class'X2Condition_UnitProperty';
	UnitCondition.ExcludeAlive = false;
	UnitCondition.ExcludeDead = true;
	UnitCondition.ExcludeCivilian = true;
	UnitCondition.ExcludeFriendlyToSource = false;
	UnitCondition.ExcludeHostileToSource = false;
	UnitCondition.TreatMindControlledSquadmateAsHostile = false;
	UnitCondition.FailOnNonUnits = true;
	UnitCondition.ExcludeLargeUnits = true;
	UnitCondition.ExcludeTurret = true;
	Template.AbilityTargetConditions.AddItem(UnitCondition);
	Template.AbilityTargetConditions.AddItem(InvertAndExchangeEffectsCondition());

	Template.BuildNewGameStateFn = class'X2Ability_TemplarAbilitySet'.static.InvertAndExchange_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_TemplarAbilitySet'.static.InvertAndExchange_BuildVisualization;
	Template.ModifyNewContextFn = class'X2Ability_TemplarAbilitySet'.static.InvertAndExchange_ModifyActivatedAbilityContext;
	
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;
	
	return Template;
}
static function X2Condition_UnitEffects InvertAndExchangeEffectsCondition()
{
	local X2Condition_UnitEffects ExcludeEffects;

	ExcludeEffects = new class'X2Condition_UnitEffects';
	ExcludeEffects.AddExcludeEffect(class'X2AbilityTemplateManager'.default.BoundName, 'AA_UnitIsBound');
	ExcludeEffects.AddExcludeEffect(class'X2Ability_CarryUnit'.default.CarryUnitEffectName, 'AA_CarryingUnit');
	ExcludeEffects.AddExcludeEffect(class'X2Effect_PersistentVoidConduit'.default.EffectName, 'AA_UnitIsBound');
	ExcludeEffects.AddExcludeEffect(class'X2Ability_ChryssalidCocoon'.default.GestationStage1EffectName, 'AA_UnitHasCocoonOnIt');
	ExcludeEffects.AddExcludeEffect(class'X2Ability_ChryssalidCocoon'.default.GestationStage2EffectName, 'AA_UnitHasCocoonOnIt');
	ExcludeEffects.AddExcludeEffect('IcarusDropGrabbeeEffect_Sustained', 'AA_UnitIsBound');
	ExcludeEffects.AddExcludeEffect('IcarusDropGrabberEffect', 'AA_UnitIsBound');

	return ExcludeEffects;
}



static function X2AbilityTemplate AddLWREnrageAbility()
{
	local X2AbilityTemplate				Template;
	local X2Condition_UnitEffects		RageTriggeredCondition;
	local X2AbilityTrigger_EventListener Trigger;
	local X2AbilityCooldown				Cooldown;
	local array<name>							SkipExclusions;
	local X2AbilityCost_Focus				FocusCost;
	local X2Effect_LWREnrage RageTriggeredPersistentEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LWR_Enrage');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_archon_beserk";
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SERGEANT_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.LWR_ENRAGE_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	FocusCost = new class'X2AbilityCost_Focus';
	FocusCost.FocusAmount = default.LWR_ENRAGE_FOCUS_COST;
	Template.AbilityCosts.AddItem(FocusCost);

	//	Targeting and Triggering
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	//	Not actually a trigger; listener is reducing cooldown when this unit is attacked
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'AbilityActivated';
	Trigger.ListenerData.Filter = eFilter_None;
	Trigger.ListenerData.EventFn = LWR_Enrage_Listener;
	Template.AbilityTriggers.AddItem(Trigger);
	
	//	Shooter Conditions - can be used while burning or disoriented
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
 	Template.AddShooterEffectExclusions(SkipExclusions);

	//	Disallow duplicate activation
	RageTriggeredCondition = new class'X2Condition_UnitEffects';
	RageTriggeredCondition.AddExcludeEffect('LWR_Enrage', 'AA_UnitRageTriggered');
	Template.AbilityShooterConditions.AddItem(RageTriggeredCondition);

	//	Ability Effects
	RageTriggeredPersistentEffect = new class'X2Effect_LWREnrage';
	RageTriggeredPersistentEffect.fDamageMultiplier = default.LWR_ENRAGE_DAMAGE_MULTIPLIER;
	RageTriggeredPersistentEffect.BuildPersistentEffect(default.LWR_ENRAGE_DURATION_TURNS, false, true, false, eGameRule_PlayerTurnEnd);
	RageTriggeredPersistentEffect.SetDisplayInfo(ePerkBuff_Bonus, default.EnrageEffectFriendlyName, default.EnragedEffectDescription, "img:///IRIBrawler.UI.UIPerk_Enrage", true,, 'eAbilitySource_Psionic');
	RageTriggeredPersistentEffect.DuplicateResponse = eDupe_Ignore;
	RageTriggeredPersistentEffect.EffectHierarchyValue = class'X2StatusEffects'.default.RAGE_HIERARCHY_VALUE;
	RageTriggeredPersistentEffect.EffectName = 'LWR_Enrage';
	RageTriggeredPersistentEffect.AddPersistentStatChange(eStat_Defense, default.LWR_ENRAGE_DEFENSE_MINUS);
	RageTriggeredPersistentEffect.VisualizationFn = LWREnrageTriggeredVisualization;
	Template.AddShooterEffect(RageTriggeredPersistentEffect);

	Template.Hostility = eHostility_Neutral;
	Template.CinescriptCameraType = "Archon_Frenzy";
	Template.bShowActivation = false;
	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CustomFireAnim = 'HL_Enrage';
	
	Template.AdditionalAbilities.AddItem('LWR_Enrage_Passive');

	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentNormalLoss;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.NormalLostSpawnIncreasePerUse;

	return Template;
}

static function EventListenerReturn LWR_Enrage_Listener(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState_Unit				AttackingUnit;
	local XComGameState_Ability				EnrageAbilityState, AbilityState;
	local XComGameStateContext_Ability		AbilityContext;
	local XComGameState						NewGameState;
	local XComGameState_Unit						TargetUnit;
	local XComGameState_Effect_TemplarFocus FocusState;

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());

	if (AbilityContext.InterruptionStatus == eInterruptionStatus_Interrupt)
	{	// only after the ability chain resolves, never as an interrupt
		return ELR_NoInterrupt;
	}

	AbilityState = XComGameState_Ability(EventData);
	AttackingUnit = XComGameState_Unit(EventSource);
	EnrageAbilityState = XComGameState_Ability(CallbackData);
	
	if (AbilityState == none || AttackingUnit == none || EnrageAbilityState == none || EnrageAbilityState.iCooldown <= 0)
    {
        return ELR_NoInterrupt;
    }

	//	If the ability was activated against the owner of the Enrage ability or *by* the owner of the enrage ability, it's offensive and input-triggered
	if ((AbilityContext.InputContext.PrimaryTarget == EnrageAbilityState.OwnerStateObject || AbilityContext.InputContext.SourceObject == EnrageAbilityState.OwnerStateObject) && 
		 AbilityState.GetMyTemplate().Hostility == eHostility_Offensive && AbilityState.IsAbilityInputTriggered())
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Reducing Enrage Cooldown");
		TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
		// If targeted by enemy. 
		if (AbilityContext.InputContext.PrimaryTarget == EnrageAbilityState.OwnerStateObject && TargetUnit != none && TargetUnit.bDisabled == false && TargetUnit.StunnedActionPoints == 0)
		{
			FocusState = TargetUnit.GetTemplarFocusEffectState();
			if (FocusState != none)
				{
					FocusState = XComGameState_Effect_TemplarFocus(NewGameState.ModifyStateObject(FocusState.Class, FocusState.ObjectID));
					FocusState.SetFocusLevel(FocusState.FocusLevel + 1, TargetUnit, NewGameState);		
				}
		}
		EnrageAbilityState = XComGameState_Ability(NewGameState.ModifyStateObject(class'XComGameState_Ability', EnrageAbilityState.ObjectID));
		EnrageAbilityState.iCooldown--;
		`GAMERULES.SubmitGameState(NewGameState);

		//	TODO add a Build Viz function here with flyover
	}
	
	return ELR_NoInterrupt;
}
static function LWREnrageTriggeredVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local X2Action_PlaySoundAndFlyOver	SoundAndFlyOver;
	local X2Action_PlayAnimation		PlayAnimation;
	local X2Action_MoveTurn				MoveTurnAction;
	local XComGameState_Unit			SourceUnit, TargetUnit;

	if (EffectApplyResult != 'AA_Success') return;

	SourceUnit = XComGameState_Unit(ActionMetadata.StateObject_NewState);

	if (SourceUnit != none)
	{
		TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(SourceUnit.LastDamagedByUnitID));

		if (TargetUnit != none)
		{
			MoveTurnAction = X2Action_MoveTurn(class'X2Action_MoveTurn'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
			MoveTurnAction.m_vFacePoint = `XWORLD.GetPositionFromTileCoordinates(TargetUnit.TileLocation);
		}
	}
	
	PlayAnimation = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
	PlayAnimation.Params.AnimName = 'FF_Enrage';

	SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
	SoundAndFlyOver.SetSoundAndFlyOverParameters(None, class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate('Rage').LocFlyOverText, '', eColor_Good);
}


static function X2AbilityTemplate AddLWR_Vigor()
{
	local X2AbilityTemplate					Template;
	local X2Effect_FocusCrit				VigorBonus;


	`CREATE_X2ABILITY_TEMPLATE(Template, 'LWR_Vigor');

	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_Amplify";
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	Template.bCrossClassEligible = false;


	VigorBonus = new class 'X2Effect_FocusCrit';
	VigorBonus.BuildPersistentEffect (1, true, false);
	VigorBonus.Bonus_Crit_Chance = default.VIGOR_CRIT_CHANCE_PER_FOCUS;
	VigorBonus.Bonus_Crit_Damage = default.VIGOR_CRIT_DAMAGE_PER_FOCUS;
	VigorBonus.BASE_CRIT_DMG = default.VIGOR_BASE_CRIT_DAMAGE;
	VigorBonus.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect (VigorBonus);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;	
	//no visualization
	return Template;		

}

static function X2AbilityTemplate Add_TemplarAnimations()
{
    local X2AbilityTemplate						Template;
    local X2Effect_AdditionalAnimSets			AnimSets;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'TemplarAnimations');

    Template.AbilitySourceName = 'eAbilitySource_Item';
    Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
    Template.Hostility = eHostility_Neutral;
    Template.bDisplayInUITacticalText = false;
    Template.bDontDisplayInAbilitySummary = true;
	Template.bIsPassive = true;

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
    Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
    AnimSets = new class'X2Effect_AdditionalAnimSets';
    AnimSets.EffectName = 'TemplarAnimSet';
	//AnimSets.AddAnimSetWithPath("Templar_ANIM.Anims.AS_Templar");
	//AnimSets.AddAnimSetWithPath("Templar_ANIM.Anims.AS_Templar_F");
	//AnimSets.AddAnimSetWithPath("HQ_ANIM.Anims.AS_Armory_Unarmed");
	//AnimSets.AddAnimSetWithPath("Soldier_Unarmed_ANIM.Anims.AS_UB_Death");
	//AnimSets.AddAnimSetWithPath("Human_ANIM.Anims.AS_Util");
	//AnimSets.AddAnimSetWithPath("Soldier_Unarmed_ANIM.Anims.AS_UB_Medkit");
	//AnimSets.AddAnimSetWithPath("Soldier_Unarmed_ANIM.Anims.AS_UB_Carry");
	//AnimSets.AddAnimSetWithPath("Soldier_Unarmed_ANIM.Anims.AS_UB_Body");
//
//
	//AnimSets.AddAnimSetWithPath("Templar_ANIM.Anims.AS_UB_Grenade");
	//AnimSets.AddAnimSetWithPath("Templar_ANIM.Anims.AS_UB_Grenade_F");
	//AnimSets.AddAnimSetWithPath("Soldier_Unarmed_ANIM.Anims.AS_UB_SOLDIER");
    //
	//AnimSets.AddAnimSetWithPath("Vindicator_ANIM.Anims.AS_VindicatorArmory");
	//AnimSets.AddAnimSetWithPath("Vindicator_ANIM.Anims.AS_Vindicator_Poses");
	//AnimSets.AddAnimSetWithPath("Vindicator_ANIM.Anims.AS_Vindicator_TLEArmory");
	//spells
	AnimSets.AddAnimSetWithPath("Templar_Reflect_ANIM.Anims.AS_Reflect");
	AnimSets.AddAnimSetWithPath("Templar_Deflect_ANIM.Anims.AS_Deflect");
	AnimSets.AddAnimSetWithPath("Templar_GainingFocus_ANIM.Anims.AS_GainingFocus");
	AnimSets.AddAnimSetWithPath("Templar_Exchange_ANIM.Anims.AS_Exchange");
	AnimSets.AddAnimSetWithPath("Templar_Ghost_ANIM.Anims.AS_Ghost");
	AnimSets.AddAnimSetWithPath("Templar_Pillar_ANIM.Anims.AS_Pillar");
	AnimSets.AddAnimSetWithPath("Templar_VoidConduit_ANIM.Anims.AS_VoidConduit");
	AnimSets.AddAnimSetWithPath("Templar_Stunstrike_ANIM.Anims.AS_Stunstrike");
	//custom spells
	AnimSets.AddAnimSetWithPath("Vindicator_ANIM.Anims.AS_Spells");
    AnimSets.BuildPersistentEffect(1, true, false, false, eGameRule_TacticalGameStart);
    AnimSets.DuplicateResponse = eDupe_Ignore;


    Template.AddTargetEffect(AnimSets);
    
    Template.bSkipFireAction = true;
    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

    return Template;
}


defaultproperties
{
	RageTriggeredEffectName="RageTriggered" 
}