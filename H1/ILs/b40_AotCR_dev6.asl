//AOTCR Leg IL autosplitter 

//leg splits
//bsp load to banshee grab 
//getting into banshee
//1st button press
//2nd button press
//opening hallway start door
//opening hallway end door
//1st tele complete
//2nd tele complete
//end



	
state("halo")  
{
	uint tickcounter1: 0x2F1D8C; //pauses on pause menu, resets on reverts 
	byte bspstate: 0x29E8D8; //tracks which bsp is loaded
	float xpos: 0x2AC5BC; //chief camera x position
	float ypos: 0x2AC5C0; //chief camera y position
	byte chiefstate: 0x2AC5B4; //tracks whether chief in cutscene or vehicle
	byte button1: 0x3FC9213C; //4 when button1 pushed, 0 otherwise
	byte button2: 0x3FC92ADC; //4 when button2 pushed, 0 otherwise
	byte hallwaydoor1: 0x3FC26D36; //128 when start hallway door open, 0 otherwise
	byte hallwaydoor2: 0x3FC26D76; //128 when end hallway door open, 0 otherwise
	string3 levelname: 0x319780;
	byte fireshee: 0x3FC962EC; //0 in banshee, 4 in ghost, 255 in nothing
	byte plasmacount: 0x3FC964EB ; //counts how many plasmas you have
	byte cinematic: 0x3FFFD679; //true when cutscene is playing
	byte cutsceneskip: 0x3FFFD67A; //true when cutscene is skippable
}

startup //settings for which splits you want to use
{
settings.Add("outside", true, "split on loading outdoor bsp");
settings.Add("corner", false, "split rounding corner before ghostflip");
settings.Add("grab", true, "split on entering banshee/ghost");
settings.Add("plasma", false, "split on plasma for fireworks");
settings.Add("fireworks", false, "split on entering fireworks shee");
settings.Add("button1", true, "split on 1st button");
settings.Add("button2", true, "split on 2nd button");
settings.Add("tunnel", false, "split on tunnel");
settings.Add("ledge", false, "split on ledge");
settings.Add("caveend", false, "split on cave end");
settings.Add("hallway1", true, "split on hallway start");
settings.Add("hallway2", true, "split on hallway end");
settings.Add("tele1", true, "split on 1st tele");
settings.Add("tele2", true, "split on 2nd tele");
}

init
{
vars.indexoffset = 0;
}

start 	//starts timer
{
vars.indexoffset = 0;
return (current.cinematic == 0 && old.cinematic == 1 && current.tickcounter1 < 920 && current.levelname == "b40"); //starts timer on specific tick that chief hits the ground
}

split
{
int checkindex = timer.CurrentSplitIndex + vars.indexoffset;
	switch (checkindex)
	{
		case 0: //splits on bsp load right before banshee grab
		if (!(settings["outside"]))
		{
		vars.indexoffset++;
		break;
		}
		return (current.ypos < -19.378);
		break;
		
		case 1: //splits on crossing corner before ghostflip
		if (!(settings["corner"]))
		{
		vars.indexoffset++;
		break;
		}
		return (current.xpos > 118.5);
		break;

		case 2: //splits on entering banshee/ghost
		if (!(settings["grab"]))
		{
		vars.indexoffset++;
		break;
		}
		return (current.chiefstate == 2);
		break;
		
		case 3: //splits on throwing plasma for fireworks
		if (!(settings["plasma"]))
		{
		vars.indexoffset++; 
		break;
		}
		return (current.plasmacount == (old.plasmacount - 1));
		break;
		
		case 4: //splits on entering fireworks banshee
		if (!(settings["fireworks"]))
		{
		vars.indexoffset++;
		break;
		}
		return (current.chiefstate == 2 && current.fireshee == 0);
		break;
		
		case 5: //splits on first button
		if (!(settings["button1"]))
		{
		vars.indexoffset++;
		break;
		}
		return (current.button1 == 4);
		break;
		
		case 6: //splits on second button
		if (!(settings["button2"]))
		{
		vars.indexoffset++;
		break;
		}
		return (current.button2 == 4);
		break;
		
		case 7: //splits on tunnel
		if (!(settings["tunnel"]))
		{
		vars.indexoffset++;
		break;
		}
		return (current.ypos < -326.5);
		break;
		
		case 8: //splits on ledge
		if (!(settings["ledge"]))
		{
		vars.indexoffset++;
		break;
		}
		return (current.ypos < -531);
		break;
		
		case 9: //splits on cave end
		if (!(settings["caveend"]))
		{
		vars.indexoffset++;
		break;
		}
		return (current.xpos > 214);
		break;
		
		case 10: //splits on hallwaydoor start open
		if (!(settings["hallway1"]))
		{
		vars.indexoffset++;
		break;
		}
		return (current.hallwaydoor1 == 128);
		break;
		
		case 11: //splits on hallwaydoor end open
		if (!(settings["hallway2"]))
		{
		vars.indexoffset++;
		break; 
		}
		return (current.hallwaydoor2 == 128);
		break;
		
		case 12: //splits on 1st banshee tele
		if (!(settings["tele1"]))
		{
		vars.indexoffset++;
		break;
		}
		return (current.ypos < -590);
		break;
		 
		case 13: //splits on 2nd banshee tele
		if (!(settings["tele2"]))
		{
		vars.indexoffset++;
		break;
		}
		return(current.xpos > 350);
		break;
		
		
		default:	//splits on level end
		return (current.bspstate == 2 && current.cutsceneskip == 1 && old.cutsceneskip == 0);
		break;
	}
}

reset
{
return (current.tickcounter1 < 900 && current.levelname == "b40");
}