package com.efg.games.spacecheckers
{
	import flash.display.Sprite;
	
	public class LevelSelection extends Sprite
	{
		//levels beatean goes through for loop to see if 
		//player completed the criteria or not
		public function LevelSelection(levelsBeaten:int) 
		{
			//selectionSetup gives all the variables on how the 
			//level selection screen should look like, asset size/etc
			var selectionSetup:screenSetup = new screenSetup();
			//variable to count through the for loop for levels completed
			//levels locked
			var levelSelect:LevelSelectionBase;
			
			//index = i; Loop through the index to see if it is less than total beaten levels
			//If it is less than total levels beaten add a new level
			//if not, don't add a new level. The Boolean will be in the LevelSelectionBase Class
			for (var i:int = 0; i < selectionSetup.totalLevels; i++)
			{
				levelSelect = new LevelSelectionBase(i,i < levelsBeaten);
				
				addChild(levelSelect);
			}
			
			//Home Button asset
			var homeButton:homeButtonBase = new HomeButton();
			addChild(homeButton);
			
		}

	}
	
}
