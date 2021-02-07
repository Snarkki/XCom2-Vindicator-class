class X2Effect_FocusCrit extends X2Effect_Persistent config (LWRAbility);
//Based on cutthroat but uses focus and is not limited from robotics
var int BONUS_CRIT_CHANCE;
var int BONUS_CRIT_DAMAGE;
var int BASE_CRIT_DMG;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local XComGameState_Item	SourceWeapon;
    local ShotModifierInfo		ShotInfo;
	local XComGameState_Effect_TemplarFocus FocusState;

    if(AbilityState.GetMyTemplate().IsMelee())
	{
		if (Target != none)
		{
			SourceWeapon = AbilityState.GetSourceWeapon();
			if (SourceWeapon != none)
			{
				FocusState = Attacker.GetTemplarFocusEffectState();
				if (FocusState != none)
				{	
					ShotInfo.ModType = eHit_Crit;
					ShotInfo.Reason = FriendlyName;
					ShotInfo.Value = BONUS_CRIT_CHANCE * FocusState.FocusLevel;
					ShotModifiers.AddItem(ShotInfo);
				}
			}
		}
	}
}

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local XComGameState_Unit		Target;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;
	local XComGameState_Effect_TemplarFocus FocusState;


	if(AbilityState.GetMyTemplate().IsMelee())
	{
	    if(AppliedData.AbilityResultContext.HitResult == eHit_Crit)
		{
			Target = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AppliedData.TargetStateObjectRef.ObjectID));
			if (Target != none)
			{
				if (CurrentDamage > 0)
				{
					// remove from DOT effects
					WeaponDamageEffect = X2Effect_ApplyWeaponDamage(class'X2Effect'.static.GetX2Effect(AppliedData.EffectRef));
					if (WeaponDamageEffect != none)
					{			
						if (WeaponDamageEffect.bIgnoreBaseDamage)
						{	
							return 0;		
						}
					}
					FocusState = Attacker.GetTemplarFocusEffectState();
						if (FocusState != none)
						{	
							return BASE_CRIT_DMG + BONUS_CRIT_DAMAGE * FocusState.FocusLevel;
						}
				   return 0;
				}
			}
        }
    }
	return 0;
}


defaultproperties
{
    DuplicateResponse=eDupe_Allow
    EffectName="LWR_Vigor"
}