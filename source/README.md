![alt text](https://github.com/Universal-Rom-Tools/Universal-XML-Scraper/raw/master/Images/Presentation/UI/Main%20UI%20RB.jpg)

Universal XML Scraper V2 is an easy to use and configure scraper.
It works in English, French, German, Spanish, Portugaise (and all other language you can translate it if you want ;) )
It's work only on windows (sorry) but maybe you can try to test it on WINE.
It's open source ( [The Github](https://github.com/Universal-Rom-Tools/Universal-XML-Scraper) )
And based on [Screenscraper](http://www.screenscraper.fr/) Database, I really think it's the best DB you can found right now... It's just 1 year old but better (in quality and content) than any other DB I found... And it's just the begining ;)

What you can do with Universal XML Scraper (UXS for the friend ;) ) :

**Easy configuration :** 
Wizard and configuration menu are easy to handle. 
And the great things is the "Autoconfiguration", select your profil depending on the Systeme you use (Retropie or Recalbox for now... but it's really open) Then choose your "root" directory where all your Roms folder are... Then you just hace to choose the directory you want to scrape all is autoconfigurated.

![alt text](https://github.com/Universal-Rom-Tools/Universal-XML-Scraper/raw/master/Images/Presentation/UI/Wizard-Autoconf%20RB.jpg)

**Evolutive :**
All the configuration are in XML File... So if you are not pleased with the "pre configured" things you can do what you want.
And so it's open to lot's configuration without touching the code.

**Lot's of language :**
I already say that the software can handle lot's of language... But do you know the DB too ?
If you want your synopsis in Spanish, deutsh, French, portugaise, and of course english, it's possible.
Depending on your language selection for UXS, the data you scrape will match.
(And it's possible in menu to change that).
It of course have a fallback function... so if no synopsis in deutsh is found, it will take the English one (for exemple)

**Fast :**
The default configuration use only one thread (roms were scrapped one by one). But if you want to help us to filling the hole in the [Screenscraper](http://www.screenscraper.fr/) Database, you will be granted more thread...
with only one participation, you already have 2 threads... And scrape 2X faster ;)
Don't forget to put your Screenscraper information in the general menu to check how many Threads you can have.

![alt text](https://github.com/Universal-Rom-Tools/Universal-XML-Scraper/raw/master/Images/Presentation/UI/Results.jpg)

**Acurate :**
The scrape is done by 2 way : your romfile hash and if not found your romfile name.
it's not taking the Game name, only the rom name to match a rom in the [Screenscraper](http://www.screenscraper.fr/) Database.
Why ? Because, rom are link to a country. And media and some informations are also link to the rom country.
So when you scrape a Japan rom, you will have the Japan Box and the Japan Name of the game.
If you scrape a US one ;) it's the same, you will have media and information corresponding.
And no mistake can happen with 2 games with "near" the same rom name... Because Hash aren't the same ;)

![alt text](https://github.com/Universal-Rom-Tools/Universal-XML-Scraper/raw/master/Images/Presentation/MIX/Region%20Exemple/Akumajou%20Dracula%20XX%20(Japan)-image.png) 
![alt text](https://github.com/Universal-Rom-Tools/Universal-XML-Scraper/raw/master/Images/Presentation/MIX/Region%20Exemple/Castlevania%20-%20Vampire's%20Kiss%20(Europe)-image.png)

**Nice :**
Emulationstation can handle only one dynamique picture... So you have to choose : Screenshot ? 3D Box ? 2D Box ?....
With the MIX profil, you can "create" very nice picture to make your front end beautiful ...

**Some MIX exemple :**

![alt text](https://github.com/Universal-Rom-Tools/Universal-XML-Scraper/raw/master/Images/Presentation/MIX/Super%20Mario%20All-Stars%20(Europe)-image.png)
![alt text](https://github.com/Universal-Rom-Tools/Universal-XML-Scraper/raw/master/Images/Presentation/MIX/sf2ce-image.png)

With the appropriate theme, you can have full screen dynamique picture :

![alt text](https://github.com/Universal-Rom-Tools/Universal-XML-Scraper/raw/master/Images/Presentation/MIX/Addams%20Family%2C%20The%20(USA%2C%20Europe)-image.png)

Teasing : A new MIX template with Emulationstation theme in preparation :

![alt text](https://github.com/Universal-Rom-Tools/Universal-XML-Scraper/raw/master/Images/Presentation/MIX/screecheffect.jpg)

You can found the last version here : [Github](https://github.com/Universal-Rom-Tools/Universal-XML-Scraper/releases)

don't hesitate to test, and tell me if all is alright ;)

What Change in the V2 :

* Total rewrote of XML functions
* Total rewrote of GDI functions (the one who make the MIX ^^)
* Now all Scraping profil are in XML with tone of options
* Now all MIX profil are in XML with also tone of options
* Multithread, you can have several rom scraped at the same time. For this you need to register on [Screenscraper](http://www.screenscraper.fr) (with a single registration you will have 2 threads, if you participate to the BDD you can have up to 10 threads.)
* Wizard at start to help the first configuration
* Scrape with recursivity (subfolder can now be scraped)
* lot's of configuration menu (but they are easy to understand... And I need to make tooltips :p )
* Autoconfiguration and Fullscrape work
* New function to handle timeout and network problem
* Changing standard things are easy now (2D Box instead of Screenshot, Game Name with region,...)
* Autohide function (Bios are auto hidden, and if you have a cue+bin, the bin will be hide too.. So are the "track" files) and it's configurable in the XML Scrape profil
* ... Lot's of more things I can't remember... 3 month on this ^^

Don't hesitate to ask or tell me there is a bug ;)

This is SPARTA.. oups [V2](https://github.com/Universal-Rom-Tools/Universal-XML-Scraper/releases)

__UDF utilisés__  
[Extended Message Box](https://www.autoitscript.com/forum/topic/109096-extended-message-box-bugfix-version-9-aug-15/) by Melba23  
[Hash](https://www.autoitscript.com/forum/topic/95558-crc32-md4-md5-sha1-for-files/) by trancexx  
[MultiLang](https://www.autoitscript.com/forum/topic/118495-multilangau3/) by BrettF  
[Trim](https://www.autoitscript.com/forum/topic/14173-new-string-trim-functions/) by blitzer99  
[XMLDomWrapper](https://www.autoitscript.com/forum/topic/176895-xmlau3-v-11110-formerly-xmlwrapperexau3-beta-support-topic/) by mLipok, Eltorro, Weaponx, drlava, Lukasz Suleja, oblique, Mike Rerick, Tom Hohmann, guinness, GMK
[zip](https://www.autoitscript.com/forum/topic/73425-zipau3-udf-in-pure-autoit/) by torels
[AutoItErrorTrap](https://www.autoitscript.com/forum/topic/145096-_autoiterrortrapau3-udf-error-detection-in-autoit-scripts/) by João Carlos
[GraphGDIPlus](https://www.autoitscript.com/forum/topic/104399-graphgdiplus-udf-create-gdi-line-graphs/) by andybiochem
[MailSlot](https://www.autoitscript.com/forum/topic/106710-mailslot/) by trancexx

__Images__  
moon.png come from [robospin](http://forum.attractmode.org/index.php?topic=700.0) attract mode template by omegaman
