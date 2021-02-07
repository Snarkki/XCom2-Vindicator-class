class X2DownloadableContentInfo_ModifyTemplar extends X2DownloadableContentInfo config (LWRAbility);


var config bool AllowMomentumOnVolt;

static event OnPostTemplatesCreated()
{
	Modify_Templar_Momentum();
	Modify_Templar_Volt();
}

static function Modify_Templar_Momentum()
{
	local X2AbilityTemplateManager		AbilityTemplateManager;
	local X2DataTemplate				DataTemplate;
	local array<X2DataTemplate>			DataTemplates;
	local X2AbilityTemplate				AbilityTemplate;
	local X2Condition_UnitEffects UnitEffectsCondition;


	`LOG("Modify templates",,'LWR_Vindicator');

	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	//  Access a specific ability template by name.
	AbilityTemplateManager.FindDataTemplateAllDifficulties('Momentum', DataTemplates);

		foreach DataTemplates(DataTemplate)
		{
			// check it's an ability template
			AbilityTemplate = X2AbilityTemplate(DataTemplate);

			if(AbilityTemplate != None)
			{
				UnitEffectsCondition = new class'X2Condition_UnitEffects';
				UnitEffectsCondition.AddExcludeEffect('Reaper', 'AA_ReaperUsed');
				UnitEffectsCondition.AddExcludeEffect('Battlelord', 'AA_BattlelordUsed');
				AbilityTemplate.AbilityShooterConditions.AddItem(UnitEffectsCondition);
				`LOG("LWR_Momentum",,'LWR_Vindicator');
			}
		}

}

static function Modify_Templar_Volt()
{
	local X2AbilityTemplateManager		AbilityTemplateManager;
	local X2DataTemplate				DataTemplate;
	local array<X2DataTemplate>			DataTemplates;
	local X2AbilityTemplate				AbilityTemplate;

	if(default.AllowMomentumOnVolt == true)
	{
		`LOG("Modify templates:VOLT",,'LWR_Vindicator');

		AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

		//  Access a specific ability template by name.
		AbilityTemplateManager.FindDataTemplateAllDifficulties('Volt', DataTemplates);

			foreach DataTemplates(DataTemplate)
			{
				// check it's an ability template
				AbilityTemplate = X2AbilityTemplate(DataTemplate);

				if(AbilityTemplate != None)
				{
					AbilityTemplate.PostActivationEvents.AddItem('RendActivated');
				}
			}
	}
}