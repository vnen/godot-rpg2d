<?xml version="1.0" encoding="UTF-8"?>
<tileset name="collision" tilewidth="32" tileheight="32" tilecount="15">
 <image source="collision.png" width="96" height="160"/>
 <terraintypes>
  <terrain name="Collision" tile="-1"/>
 </terraintypes>
 <tile id="1" terrain="0,0,0,">
  <objectgroup draworder="index">
   <object id="0" x="0" y="0">
    <polyline points="0,0 32,0 32,16 16,16 16,32 0,32 0,0"/>
   </object>
  </objectgroup>
 </tile>
 <tile id="2" terrain="0,0,,0">
  <objectgroup draworder="index">
   <object id="0" x="0" y="0">
    <polyline points="0,0 32,0 32,32 16,32 16,16 0,16 0,0"/>
   </object>
  </objectgroup>
 </tile>
 <tile id="4" terrain="0,,0,0">
  <objectgroup draworder="index">
   <object id="0" x="0" y="0">
    <polyline points="0,0 16,0 16,16 32,16 32,32 0,32 0,0"/>
   </object>
  </objectgroup>
 </tile>
 <tile id="5" terrain=",0,0,0">
  <objectgroup draworder="index">
   <object id="0" x="0" y="16">
    <polyline points="0,0 16,0 16,-16 32,-16 32,16 0,16 0,0"/>
   </object>
  </objectgroup>
 </tile>
 <tile id="6" terrain=",,,0">
  <objectgroup draworder="index">
   <object id="0" x="16" y="16" width="16" height="16"/>
  </objectgroup>
 </tile>
 <tile id="7" terrain=",,0,0">
  <objectgroup draworder="index">
   <object id="0" x="0" y="16" width="32" height="16"/>
  </objectgroup>
 </tile>
 <tile id="8" terrain=",,0,">
  <objectgroup draworder="index">
   <object id="0" x="0" y="16" width="16" height="16"/>
  </objectgroup>
 </tile>
 <tile id="9" terrain=",0,,0">
  <objectgroup draworder="index">
   <object id="0" x="16" y="0" width="16" height="32"/>
  </objectgroup>
 </tile>
 <tile id="10" terrain="0,0,0,0">
  <objectgroup draworder="index">
   <object id="0" x="0" y="0" width="32" height="32"/>
  </objectgroup>
 </tile>
 <tile id="11" terrain="0,,0,">
  <objectgroup draworder="index">
   <object id="0" x="0" y="0" width="16" height="32"/>
  </objectgroup>
 </tile>
 <tile id="12" terrain=",0,,">
  <objectgroup draworder="index">
   <object id="0" x="16" y="0" width="16" height="16"/>
  </objectgroup>
 </tile>
 <tile id="13" terrain="0,0,,">
  <objectgroup draworder="index">
   <object id="0" x="0" y="0" width="32" height="16"/>
  </objectgroup>
 </tile>
 <tile id="14" terrain="0,,,">
  <objectgroup draworder="index">
   <object id="0" x="0" y="0" width="16" height="16"/>
  </objectgroup>
 </tile>
</tileset>
