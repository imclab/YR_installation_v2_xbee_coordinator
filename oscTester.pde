import controlP5.*;
import oscP5.*;
import netP5.*;


OscP5 oscP5;
NetAddress myRemoteLocation;
ControlP5 controlP5;

int myColorBackground = color(0,0,0);
//int knobValue = 100;

CheckBox led;
CheckBox device;


int time = 3;
int value = 3;

void setup()
{
  size(400, 400);
  smooth();
  controlP5 = new ControlP5(this);

//  controlP5.addKnob("knob",100,200,128,100,160,40);
//  controlP5.addKnob("knobValue",0,255,128,100,240,40);
  device = controlP5.addCheckBox("device",40,40);
  led = controlP5.addCheckBox("led",40,80);
  device.setItemsPerRow(8);
  device.setSpacingColumn(20);
  led.setItemsPerRow(8);
  led.setSpacingColumn(20);
 
  device.addItem("0", 1);
  device.addItem("1", 2);
  device.addItem("2", 4);
  device.addItem("3", 8);
  device.addItem("4", 16);

  led.addItem("0", 1);
  led.addItem("1", 2);
  led.addItem("2", 4);
  led.addItem("3", 8);
  led.addItem("4", 16);
  led.addItem("5", 32);
  led.addItem("6", 64);
  led.addItem("7", 128);
  led.addItem("8", 256);
  led.addItem("9", 512);
  led.addItem("10", 1024);
  led.addItem("11", 2048);
  led.addItem("12", 4096);
  led.addItem("13", 8192);
  led.addItem("14", 16386);
  led.addItem("15", 32772);
  
  controlP5.addSlider("time",0,65535,128,40,160,10,100);
  controlP5.addSlider("value",0,4095,128,140,160,10,100);

  controlP5.addButton("submit",1,0,300,400,100);
  
  myRemoteLocation = new NetAddress("localhost",15000);
  oscP5 = new OscP5(this,15001);
}

void draw()
{
  background(myColorBackground);
//  fill(knobValue);
//  rect(0,0,width,100);
}


void submit(int buttonValue) {
  int deviceValue = 0;
  for(int i = 0; i < 5; i++)
    deviceValue += (device.arrayValue()[i] != 0 ? 1 : 0) << i;

  int ledValue = 0;
  for(int i = 0; i < 16; i++)
    ledValue += (led.arrayValue()[i] != 0 ? 1 : 0) << i;
  
  println("submit:" + deviceValue + " " + ledValue + " " + value + " " + time);
  
  int target = deviceValue << 16 + ledValue;
  int data = value << 16 + time;

  OscMessage message = new OscMessage("/tlc");
  
  message.add(target); /* add an int to the osc message */
  message.add(data); /* add an int to the osc message */

  /* send the message */
  oscP5.send(message, myRemoteLocation); 

}

