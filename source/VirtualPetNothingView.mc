import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Weather;
import Toybox.Activity;
import Toybox.ActivityMonitor;
import Toybox.Time.Gregorian;

class VirtualPetNothingView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }


    function onLayout(dc as Dc) as Void {
        //setLayout(Rez.Layouts.WatchFace(dc));
    }

 
    function onShow() as Void {
    }

    
    function onUpdate(dc as Dc) as Void {
        var mySettings = System.getDeviceSettings();
       var myStats = System.getSystemStats();
       var info = ActivityMonitor.getInfo();
       var timeFormat = "$1$:$2$";
       var clockTime = System.getClockTime();
       var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
              var hours = clockTime.hour;
               if (!System.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        } else {   
                timeFormat = "$1$:$2$";
                hours = hours.format("%02d");  
        }
        var timeString = Lang.format(timeFormat, [hours, clockTime.min.format("%02d")]);
        var weekdayArray = ["Day", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"] as Array<String>;
        var monthArray = ["Month", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"] as Array<String>;
        var monthArraySQ = ["Month", "Jan", "Feb", "March", "April", "May", "June", "July", "Aug", "Sept", "Oct", "Nov", "Dec"] as Array<String>;
 var userBattery = "-";
   if (myStats.battery != null){userBattery = Lang.format("$1$",[((myStats.battery.toNumber())).format("%2d")]);}else{userBattery="-";} 

   var userSTEPS = 0;
   if (info.steps != null){userSTEPS = info.steps.toNumber();}else{userSTEPS=0;} 

  var userNotify = "-";
   if (mySettings.notificationCount != null){userNotify = Lang.format("$1$",[((mySettings.notificationCount.toNumber())).format("%2d")]);}else{userNotify="-";} 

var userAlarm = "-";
   if (mySettings.alarmCount != null){userAlarm = Lang.format("$1$",[((mySettings.alarmCount.toNumber())).format("%2d")]);}else{userAlarm="-";} 

     var userCAL = 0;
   if (info.calories != null){userCAL = info.calories.toNumber();}else{userCAL=0;}  
   

    var timeStamp= new Time.Moment(Time.today().value());
   var getCC = Toybox.Weather.getCurrentConditions();
    var TEMP = "--";
    var FC = "-";
     if(getCC != null && getCC.temperature!=null){     
        if (System.getDeviceSettings().temperatureUnits == 0){  
    FC = "C";
    TEMP = getCC.temperature.format("%d");
    }else{
    TEMP = (((getCC.temperature*9)/5)+32).format("%d"); 
    FC = "F";   
    }}
     else {TEMP = "--";}
    
    var cond;
    if (getCC != null){ cond = getCC.condition.toNumber();}
    else{cond = 0;}//sun
    
var positions;
        if (Toybox.Weather.getCurrentConditions().observationLocationPosition == null){
        positions=new Position.Location( 
    {
        :latitude => 33.684566,
        :longitude => -117.826508,
        :format => :degrees
    }
    );
    }else{
      positions= Toybox.Weather.getCurrentConditions().observationLocationPosition;
    }
    
  

  var sunrise = Time.Gregorian.info(Toybox.Weather.getSunrise(positions, timeStamp), Time.FORMAT_MEDIUM);
        
	var sunriseHour;
  if (Toybox.Weather.getSunrise(positions, timeStamp) == null){sunriseHour = 6;}
    else {sunriseHour= sunrise.hour;}
         if (!System.getDeviceSettings().is24Hour) {
            if (sunriseHour > 12) {
                sunriseHour = (sunriseHour - 12).abs();
            }
        } else {
           
                timeFormat = "$1$:$2$";
                sunriseHour = sunriseHour.format("%02d");
        }
        
    var sunset;
    var sunsetHour;
    sunset = Time.Gregorian.info(Toybox.Weather.getSunset(positions, timeStamp), Time.FORMAT_MEDIUM);
    if (Toybox.Weather.getSunset(positions, timeStamp) == null){sunsetHour = 6;}
    else {sunsetHour= sunset.hour ;}
        
	
         if (!System.getDeviceSettings().is24Hour) {
            if (sunsetHour > 12) {
                sunsetHour = (sunsetHour - 12).abs();
            }
        } else {
            
                timeFormat = "$1$:$2$";
                sunsetHour = sunsetHour.format("%02d");
        }


   //Get and show Heart Rate Amount

var userHEART = "--";
if (getHeartRate() == null){userHEART = "--";}
else if(getHeartRate() == 255){userHEART = "--";}
else{userHEART = getHeartRate().toString();}

       var centerX = (dc.getWidth()) / 2;
       var centerY = (dc.getHeight()) / 2;


        var bgO = bgobject();
       var dog = dogPhase(today.sec, today.min);
       var object = object(today.day_of_week);//today.day_of_week
       var smallFont =  WatchUi.loadResource( Rez.Fonts.WeatherFont );
       var wordFont =  WatchUi.loadResource( Rez.Fonts.smallFont );
       var LargeFont =  WatchUi.loadResource( Rez.Fonts.largeFont );
       var small =  WatchUi.loadResource( Rez.Fonts.smallFont );
       var xsmall =  WatchUi.loadResource( Rez.Fonts.xsmallFont );
       
      View.onUpdate(dc);
 bgO.draw(dc);
    

  if (System.getDeviceSettings().screenHeight < 301){
    wordFont =  WatchUi.loadResource( Rez.Fonts.xsmallFont );
    dc.setColor(0xEF1EB8, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX,centerY*1.45,xsmall,(weekdayArray[today.day_of_week]+" , "+ monthArray[today.month]+" "+ today.day +" " +today.year), Graphics.TEXT_JUSTIFY_CENTER );
        dc.setColor(0xFFFFFF, Graphics.COLOR_TRANSPARENT);
       dc.drawText(centerX,  centerY*0.87,LargeFont, timeString,  Graphics.TEXT_JUSTIFY_CENTER  );

       dc.setColor(0x2AFA3F, Graphics.COLOR_TRANSPARENT);
if (today.sec%20==0 || today.sec%20==1 || today.sec%20==2 ){ 
  dc.setColor(0x2AFA3F, Graphics.COLOR_TRANSPARENT);
dc.drawText( centerX,  centerY*1.7, small,  (" ! "), Graphics.TEXT_JUSTIFY_RIGHT );
dc.drawText( centerX, centerY*1.7, wordFont,  (""+userBattery), Graphics.TEXT_JUSTIFY_LEFT );}
else if (today.sec%20==3 || today.sec%20==4 || today.sec%20==5 ){
  dc.setColor(0x2AFA3F, Graphics.COLOR_TRANSPARENT);
dc.drawText( centerX,  centerY*1.7, small,  (" ^ "), Graphics.TEXT_JUSTIFY_RIGHT );
dc.drawText( centerX, centerY*1.7, wordFont,  (""+userCAL), Graphics.TEXT_JUSTIFY_LEFT );}
else if (today.sec%20==6 ||today.sec%20==7 || today.sec%20==8  ){  
  dc.setColor(0x2AFA3F, Graphics.COLOR_TRANSPARENT);
dc.drawText(centerX, centerY*1.7, small, " % ",Graphics.TEXT_JUSTIFY_RIGHT);      
dc.drawText(centerX, centerY*1.7, wordFont, userHEART, Graphics.TEXT_JUSTIFY_LEFT ); }
else if (today.sec%20==9 ||today.sec%20==10 || today.sec%20==11 || today.sec%20==12 || today.sec%20==13  ){  
dc.setColor(0x00F7EE, Graphics.COLOR_TRANSPARENT);   
dc.drawText(centerX, centerY*1.7, small, " a ",Graphics.TEXT_JUSTIFY_LEFT); 
dc.drawText(centerX, centerY*1.65, xsmall, "          "+userAlarm+"          ", Graphics.TEXT_JUSTIFY_LEFT );     
dc.setColor(0xFFFF35, Graphics.COLOR_TRANSPARENT);  
dc.drawText(centerX, centerY*1.7, small, " a ",Graphics.TEXT_JUSTIFY_RIGHT); 
dc.drawText(centerX, centerY*1.65, xsmall, "          "+userNotify+"          ", Graphics.TEXT_JUSTIFY_RIGHT );  }
else{
  dc.setColor(0x2AFA3F, Graphics.COLOR_TRANSPARENT);
dc.drawText(centerX, centerY*1.7, small, (" a "), Graphics.TEXT_JUSTIFY_RIGHT );
  dc.drawText(centerX, centerY*1.7, wordFont, (""+userSTEPS), Graphics.TEXT_JUSTIFY_LEFT );}

if (System.getDeviceSettings().screenHeight >= 260){
dc.setColor(0x555555, Graphics.COLOR_TRANSPARENT);
dc.drawText(centerX*1.5, centerY*0.62, smallFont, weather(cond),Graphics.TEXT_JUSTIFY_RIGHT);      
dc.drawText(centerX*1.5, centerY*0.75, wordFont, " "+TEMP+" "+FC, Graphics.TEXT_JUSTIFY_LEFT );}

  }else{
      
      dc.setColor(0xFFFFFF, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX,centerY*1.05,wordFont,(weekdayArray[today.day_of_week]+" , "+ monthArray[today.month]+" "+ today.day +" " +today.year), Graphics.TEXT_JUSTIFY_CENTER );
        dc.setColor(0xFFFFFF, Graphics.COLOR_TRANSPARENT);
       dc.drawText(centerX,  centerY*1.35,LargeFont, timeString,  Graphics.TEXT_JUSTIFY_CENTER  );
       
if (today.sec%20==0 ||today.sec%20==1 || today.sec%20==2){  
dc.setColor(0xFFFF35, Graphics.COLOR_TRANSPARENT);
dc.drawText(centerX, centerY*1.2, smallFont, "b",Graphics.TEXT_JUSTIFY_CENTER);
dc.setColor(0x00F7EE, Graphics.COLOR_TRANSPARENT);
dc.drawText(centerX, centerY*1.25, wordFont, ("  "+sunriseHour + ":" + sunrise.min.format("%02u")+"AM"+"   "), Graphics.TEXT_JUSTIFY_RIGHT );     
dc.drawText(centerX, centerY*1.25, wordFont, ("   "+sunsetHour + ":" + sunset.min.format("%02u")+"PM"+"    "), Graphics.TEXT_JUSTIFY_LEFT ); }
else if (today.sec%20==3 ||today.sec%20==4 || today.sec%20==5){  
  dc.setColor(0x00F7EE, Graphics.COLOR_TRANSPARENT);
dc.drawText(centerX, centerY*1.2, smallFont, weather(cond),Graphics.TEXT_JUSTIFY_RIGHT);      
dc.setColor(0xFFFF35, Graphics.COLOR_TRANSPARENT);
dc.drawText(centerX, centerY*1.25, wordFont, " "+TEMP+" "+FC, Graphics.TEXT_JUSTIFY_LEFT );}  
else{
  
  if (today.sec%2 == 0){
  dc.setColor(0x00F7EE, Graphics.COLOR_TRANSPARENT);
//dc.drawText( centerX,  centerY*1.6, small,  (" ^ "), Graphics.TEXT_JUSTIFY_RIGHT );
dc.drawText( centerX, centerY*1.25, wordFont,  (" ^ "+userCAL), Graphics.TEXT_JUSTIFY_CENTER );
  }else{
  dc.setColor(0xFFFF35, Graphics.COLOR_TRANSPARENT);
//dc.drawText(centerX, centerY*1.6, small, (" $ "), Graphics.TEXT_JUSTIFY_RIGHT );
  dc.drawText(centerX, centerY*1.25, wordFont, (" $ "+userSTEPS), Graphics.TEXT_JUSTIFY_CENTER );
  }

dc.setColor(0x2AFA3F, Graphics.COLOR_TRANSPARENT);
dc.drawText( centerX*0.5,  centerY*1.25, small,  (" ! "), Graphics.TEXT_JUSTIFY_RIGHT );
dc.drawText( centerX*0.5, centerY*1.25, wordFont,  (""+userBattery), Graphics.TEXT_JUSTIFY_LEFT );
dc.setColor(0xEF1EB8, Graphics.COLOR_TRANSPARENT);
dc.drawText(centerX*1.5, centerY*1.25, small, " % ",Graphics.TEXT_JUSTIFY_RIGHT);      
dc.drawText(centerX*1.5, centerY*1.25, wordFont, userHEART, Graphics.TEXT_JUSTIFY_LEFT ); }

dc.setColor(0x00F7EE, Graphics.COLOR_TRANSPARENT);   
dc.drawText(centerX, centerY*1.8, small, " a ",Graphics.TEXT_JUSTIFY_LEFT); 
dc.drawText(centerX, centerY*1.75, xsmall, "          "+userAlarm+"          ", Graphics.TEXT_JUSTIFY_LEFT );     
dc.setColor(0xFFFF35, Graphics.COLOR_TRANSPARENT);  
dc.drawText(centerX, centerY*1.8, small, " a ",Graphics.TEXT_JUSTIFY_RIGHT); 
dc.drawText(centerX, centerY*1.75, xsmall, "          "+userNotify+"          ", Graphics.TEXT_JUSTIFY_RIGHT );  

}



        
        
        
        dog.draw(dc);
        //object.draw(dc); //for testing
       if (userSTEPS > 3000){ object.draw(dc);}else{}
        if (mySettings.screenShape == 1){
          if(System.getDeviceSettings().screenHeight < 301){dc.setPenWidth(22);}
          else{dc.setPenWidth(30);}

//0x555555 for 64 bit color and 16 bit color - only AMOLED can show 0x272727
dc.setColor(0x555555, Graphics.COLOR_TRANSPARENT);
dc.drawCircle(centerX, centerX, centerX);
dc.setColor(0x48FF35, Graphics.COLOR_TRANSPARENT);
dc.drawArc(centerX, centerX, centerX, Graphics.ARC_CLOCKWISE, 180, 177 - (userSTEPS/56));//userSTEPS
}else 
{
  dc.setPenWidth(25);
  //dc.setColor(0x5E704B, Graphics.COLOR_TRANSPARENT);
  //dc.drawRectangle(0, 0, dc.getWidth(), dc.getHeight());
  
  dc.setColor(0x48FF35, Graphics.COLOR_TRANSPARENT);
  dc.drawLine(0, 0, dc.getWidth(), 0);

  dc.setColor(0xFFFF35, Graphics.COLOR_TRANSPARENT);
  dc.drawLine(dc.getWidth(), dc.getHeight(), 0, dc.getHeight());
  
  dc.setColor(0xEF1EB8, Graphics.COLOR_TRANSPARENT);
  dc.drawLine(0, 0, 0, dc.getHeight());
  
  dc.setColor(0x00F7EE, Graphics.COLOR_TRANSPARENT);
  dc.drawLine(dc.getWidth(), 0, dc.getWidth(), dc.getHeight());
  
}


     
        
    }


    function onHide() as Void { }

    
    function onExitSleep() as Void {}

    
    function onEnterSleep() as Void {}

function weather(cond) {
  if (cond == 0 || cond == 40){return "b";}//sun
  else if (cond == 50 || cond == 49 ||cond == 47||cond == 45||cond == 44||cond == 42||cond == 31||cond == 27||cond == 26||cond == 25||cond == 24||cond == 21||cond == 18||cond == 15||cond == 14||cond == 13||cond == 11||cond == 3){return "a";}//rain
  else if (cond == 52||cond == 20||cond == 2||cond == 1){return "e";}//cloud
  else if (cond == 5 || cond == 8|| cond == 9|| cond == 29|| cond == 30|| cond == 33|| cond == 35|| cond == 37|| cond == 38|| cond == 39){return "g";}//wind
  else if (cond == 51 || cond == 48|| cond == 46|| cond == 43|| cond == 10|| cond == 4){return "i";}//snow
  else if (cond == 32 || cond == 37|| cond == 41|| cond == 42){return "f";}//whirlwind 
  else {return "c";}//suncloudrain 
}


private function getHeartRate() {
  // initialize it to null
  var heartRate = null;

  // Get the activity info if possible
  var info = Activity.getActivityInfo();
  if (info != null) {
    heartRate = info.currentHeartRate;
  } else {
    // Fallback to `getHeartRateHistory`
    var latestHeartRateSample = ActivityMonitor.getHeartRateHistory(1, true).next();
    if (latestHeartRateSample != null) {
      heartRate = latestHeartRateSample.heartRate;
    }
  }

  // Could still be null if the device doesn't support it
  return heartRate;
}

function bgobject(){
  var object;
var mySettings = System.getDeviceSettings();
 var venus2X =   mySettings.screenWidth *0.08;
 var venus2Y =   mySettings.screenHeight *0.08;
 if (System.getDeviceSettings().screenHeight == 218){
     object = ( new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.rainbowsm,
            :locX=> mySettings.screenWidth *0.04,
            :locY=>mySettings.screenHeight *0.01
        }));
      }else if (System.getDeviceSettings().screenHeight == 260){
     object = ( new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.rainbowsm,
            :locX=> mySettings.screenWidth *0.12,
            :locY=>mySettings.screenHeight *0.07
        }));
      } else if (System.getDeviceSettings().screenHeight == 390){
        object = ( new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.rainbow,
            :locX=> mySettings.screenWidth *0.02,
            :locY=>mySettings.screenHeight *0.01
        }));
      } else if (System.getDeviceSettings().screenHeight == 416){
        object = ( new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.rainbow,
            :locX=> mySettings.screenWidth *0.02,
            :locY=>mySettings.screenHeight *0.04
        }));
      }else if (System.getDeviceSettings().screenHeight == 454){
        object = ( new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.rainbow,
            :locX=> mySettings.screenWidth *0.065,
            :locY=>mySettings.screenHeight *0.055
        }));
      }else if (mySettings.screenShape != 1){
        object = ( new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.rainbowS,
            :locX=> mySettings.screenWidth*0.04,
            :locY=>mySettings.screenHeight *0.04
        }));
      }else{
         object = ( new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.rainbowbig,
            :locX=> venus2X,
            :locY=>venus2Y
        }));
      }
 

  return object;
}


function object(dayofweek){
  var mySettings = System.getDeviceSettings();
  //0: normal 200 px 1:small 100 px 2:Large 200px 3:square
var growX = 1; //0.75 for grow large 1.25 for shrink small 1 for normal or square
var growY = 1;
var size = 0;
      if (System.getDeviceSettings().screenHeight < 301){
        size =1;
        growX=1;
        growY=1;
      }else if (System.getDeviceSettings().screenHeight >= 390){
        size=2;
        growX=0.7;
        growY=growX*growX;
      }else if (mySettings.screenShape != 1){
        size=0;
        growX=0.75;
        growY=0.47;
      }else{
        size=0;
        growX=0.8;
        growY=1;
      }
  var venus2X =  mySettings.screenWidth *0.27*growX ;
  var venus2Y =  mySettings.screenHeight *0.1*growY ;
var objectARRAY;
if (size ==1){
 objectARRAY=[
        (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.sunsmall,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
      (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.monsmall,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
              (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.tuessmall,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
              (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.wedsmall,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
              (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.thurssmall,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
            (  new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.frismall,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
           ( new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.satsmall,
            :locX=> venus2X,
            :locY=>venus2Y
        }))
     ];
}
else if (size ==2){
 objectARRAY=[
        (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.sunbig,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
      (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.monbig,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
              (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.tuesbig,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
              (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.wedbig,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
              (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.thursbig,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
            (  new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.fribig,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
           ( new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.satbig,
            :locX=> venus2X,
            :locY=>venus2Y
        }))
     ];
}else{
 objectARRAY=[
      (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.sun,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
              (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.mon,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
              (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.tues,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
              (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.wed,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
              (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.thurs,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
            (  new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.fri,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
           ( new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.sat,
            :locX=> venus2X,
            :locY=>venus2Y
        }))
     ];
}
  return objectARRAY[(dayofweek-1)];
}



function dogPhase(seconds, minutes){
  var mySettings = System.getDeviceSettings();
  var size= 0;//0: normal 200 px 1:small 100 px 2:Large 200px 3:square
var growX = 1; //0.75 for grow large 1.25 for shrink small 1 for normal or square
var growY = 1;
      if (System.getDeviceSettings().screenHeight < 301){
        size=1;
        growX=1;
        growY=1;
      }else if (System.getDeviceSettings().screenHeight >= 390){
        size=2;
        growX=0.7;
        growY=growX*growX;
      }else if (mySettings.screenShape != 1){
        size=3;
        growX=0.75;
        growY=0.47;
      }else{
        size=0;
        growX=0.8;
        growY=1;
      }

  var venus2X =  mySettings.screenWidth *0.27*growX ;
  var venus2Y =  mySettings.screenHeight *0.08*growY ;
  var dogARRAY;
if (size == 1){
 dogARRAY = [
(new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.SMALLDog0,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
        (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.SMALLDog1,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
        (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.SMALLDog2,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
        (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.SMALLDog3,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
        (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.SMALLDog4,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
        (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.SMALLDog5,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
          (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.SMALLDog6,
            :locX=> venus2X,
            :locY=>venus2Y
        }))
 ];
}
else if (size == 2){     
   dogARRAY = [
(new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.BIGDog0,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
        (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.BIGDog1,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
        (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.BIGDog2,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
        (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.BIGDog3,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
        (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.BIGDog4,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
        (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.BIGDog5,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
          (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.BIGDog6,
            :locX=> venus2X,
            :locY=>venus2Y
        }))
 ];      
}
else {
   dogARRAY = [
(new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.Dog0,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
        (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.Dog1,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
        (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.Dog2,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
        (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.Dog3,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
        (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.Dog4,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
          (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.Dog5,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
          (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.Dog6,
            :locX=> venus2X,
            :locY=>venus2Y
        }))
 ]; 
}
return dogARRAY[seconds%2+minutes%6];
}
}
